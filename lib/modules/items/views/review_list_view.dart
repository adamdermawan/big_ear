// lib/modules/items/views/review_list_view.dart
import 'package:big_ear/modules/items/services/review_service.dart';
import 'package:big_ear/modules/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../models/review.dart';

class ReviewListView extends StatefulWidget {
  final int itemId;

  const ReviewListView({super.key, required this.itemId});

  @override
  State<ReviewListView> createState() => _ReviewListViewState();
}

class _ReviewListViewState extends State<ReviewListView> {
  final ReviewService _reviewService = ReviewService();
  List<Review> _reviews = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final reviews = await _reviewService.getReviewsByItemId(widget.itemId);
      
      setState(() {
        _reviews = reviews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Color getRandomAvatarColor() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[DateTime.now().millisecond % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ratings and Reviews')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ratings and Reviews')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadReviews,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Calculate statistics
    final ratings = _reviews.map((r) => r.rating).toList();
    final avgRating = ratings.isEmpty
        ? 0.0
        : (ratings.reduce((a, b) => a + b) / ratings.length).toDouble();

    // Rating distribution
    final ratingCounts = List.generate(5, (i) {
      return _reviews.where((r) => r.rating.floor() == 5 - i).length;
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Ratings and Reviews')),
      body: RefreshIndicator(
        onRefresh: _loadReviews,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: average rating + bars
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    avgRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBarIndicator(
                        rating: avgRating,
                        itemBuilder: (_, __) =>
                            const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 24,
                      ),
                      Text('${_reviews.length} ratings'),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              // Distribution bars
              ...List.generate(5, (index) {
                final label = 5 - index;
                final count = ratingCounts[index];
                final percent = _reviews.isEmpty ? 0.0 : count / _reviews.length;
                return Row(
                  children: [
                    Text('$label'),
                    const Icon(Icons.star, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percent,
                        color: primaryBlue,
                        backgroundColor: Colors.grey[300],
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$count'),
                  ],
                );
              }),

              const Divider(height: 32),

              // Review List
              if (_reviews.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Belum ada review', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('Jadilah yang pertama untuk review produk ini!'),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: _reviews.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final review = _reviews[index];

                      final formattedDate = review.createdAt != null 
                          ? DateFormat.yMMMd().format(review.createdAt!)
                          : 'Recently';

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: getRandomAvatarColor(),
                          child: Text(
                            review.userName != null && review.userName!.isNotEmpty 
                                ? review.userName![0].toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(review.userName ?? 'Anonymous User'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingBarIndicator(
                              rating: review.rating,
                              itemBuilder: (_, __) =>
                                  const Icon(Icons.star, color: Colors.amber),
                              itemCount: 5,
                              itemSize: 20,
                            ),
                            Text(formattedDate),
                            const SizedBox(height: 4),
                            Text(review.comment),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}