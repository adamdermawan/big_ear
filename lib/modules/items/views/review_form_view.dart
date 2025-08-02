import 'package:big_ear/modules/items/models/spring_bed_item.dart';
import 'package:big_ear/modules/items/services/review_service.dart';
import 'package:big_ear/modules/shared/constants/url_path.dart';
import 'package:big_ear/modules/user/services/auth_service.dart';
import 'package:big_ear/modules/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewFormView extends StatefulWidget {
  final SpringBedItem item;

  const ReviewFormView({super.key, required this.item});

  @override
  State<ReviewFormView> createState() => _ReviewFormViewState();
}

class _ReviewFormViewState extends State<ReviewFormView> {
  final ReviewService _reviewService = ReviewService();
  final AuthService _authService = AuthService();

  double _rating = 0;
  String _reviewText = '';
  bool _isLoading = false;
  bool _isAuthenticated = false;
  bool _isGuest = false;
  String _userType = 'guest';
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _existingReview;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    _loadExistingReview();
  }

  Future<void> _checkAuthentication() async {
    try {
      final isAuth = await _authService.canWriteReviews();
      final isGuestMode = await _authService.isGuestMode();
      final userType = await _authService.getUserType();
      final userData = await _authService.getUserData();

      setState(() {
        _isAuthenticated = isAuth;
        _isGuest = isGuestMode;
        _userType = userType;
        _userData = userData;
      });
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _isGuest = true;
        _userType = 'guest';
      });
    }
  }

  Future<void> _loadExistingReview() async {
    try {
      final review = await _reviewService.getUserReviewForItem(widget.item.id);
      if (review != null) {
        setState(() {
          _existingReview = {
            'id': review.id,
            'rating': review.rating,
            'comment': review.comment,
          };
          _rating = review.rating;
          _reviewText = review.comment;
        });
      }
    } catch (e) {
      // Optional: show error or log it
    }
  }

  Future<void> _submitReview() async {
    await _checkAuthentication();

    if (!_isAuthenticated || _isGuest) {
      _showLoginDialog();
      return;
    }

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    if (_reviewText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a review')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_existingReview != null && _existingReview!['id'] != null) {
        await _reviewService.updateReview(
          _existingReview!['id'],
          _rating,
          _reviewText.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review updated successfully!')),
        );
      } else {
        await _reviewService.createReview(
          itemId: widget.item.id,
          rating: _rating,
          comment: _reviewText.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully!')),
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteReview() async {
    if (_existingReview == null || _existingReview!['id'] == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Review'),
        content: const Text('Apakah Anda yakin ingin menghapus review ini?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
              style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white),
            child: const Text('Batal'), // Set text color to black
        ),

          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await _reviewService.deleteReview(_existingReview!['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review deleted.')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting review: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You need to login to submit a review.'),
            const SizedBox(height: 8),
            if (_isGuest)
              const Text(
                'You are currently browsing as a guest. Guests cannot write reviews.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, '/login');
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isAuthenticated ? Colors.green.shade50 : Colors.orange.shade50,
        border: Border.all(
          color: _isAuthenticated ? Colors.green.shade200 : Colors.orange.shade200,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _isAuthenticated ? Icons.check_circle_outline : Icons.info_outline,
            color: _isAuthenticated ? Colors.green.shade700 : Colors.orange.shade700,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isAuthenticated) ...[
                  const Text(
                    'You can write reviews',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_userData != null)
                    Text(
                      'Logged in as: ${_userData!['name']} ($_userType)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ] else ...[
                  const Text(
                    'Buat Akun Atau Login untuk Menulis Review',
                    style: TextStyle(color: Colors.black87),
                  ),
                  if (_isGuest)
                    const Text(
                      'Masih Sebagai Guest',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beri Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    '${ApiConstants.url}${widget.item.imageAsset}',
                    width: 144,
                    height: 144,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 48),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildAuthStatusCard(),
            const SizedBox(height: 20),

            Center(
              child: RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                allowHalfRating: true,
                itemCount: 5,
                ignoreGestures: !_isAuthenticated,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: _isAuthenticated ? Colors.amber : Colors.grey,
                ),
                onRatingUpdate: (rating) => setState(() => _rating = rating),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              maxLines: 5,
              maxLength: 500,
              enabled: _isAuthenticated,
              decoration: InputDecoration(
                hintText: _isAuthenticated
                    ? 'Masukan Review Anda...'
                    : 'Login required to write a review',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: _isAuthenticated ? null : Colors.grey.shade100,
                filled: !_isAuthenticated,
              ),
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: _reviewText,
                  selection: TextSelection.collapsed(offset: _reviewText.length),
                ),
              ),
              onChanged: (value) => setState(() => _reviewText = value),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAuthenticated ? primaryBlue : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(_existingReview != null ? 'Update Review' : 'Submit Review'),
            ),
            if (_existingReview != null)
  const SizedBox(height: 12),

        if (_existingReview != null)
          ElevatedButton(
            onPressed: _isLoading ? null : _deleteReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Hapus Review'),
          ),


                  ],
        ),
      ),
    );
  }
}
