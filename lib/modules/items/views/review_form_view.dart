import 'package:big_ear/modules/items/models/spring_bed_item.dart'; // Import SpringBedItem
import 'package:big_ear/modules/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewFormView extends StatefulWidget {
  final SpringBedItem item; // Change type to SpringBedItem

  const ReviewFormView({super.key, required this.item});

  @override
  State<ReviewFormView> createState() => _ReviewFormViewState();
}

class _ReviewFormViewState extends State<ReviewFormView> {
  double _rating = 0;
  String _reviewText = '';
  String? _twoStepAnswer; // This part is commented out, keeping it as is.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beri Review')), // Added const
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.item.imageAsset, // Use widget.item.imageAsset
                    width: 144,
                    height: 144,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.item.name, // Use widget.item.name
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

            // Rating
            Center(
              child: RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) => _rating = rating,
              ),
            ),

            const SizedBox(height: 20),

            // Review Text
            TextField(
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Masukan Review Anda...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => _reviewText = value,
            ),

            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                print('Rating: $_rating');
                print('Review: $_reviewText');
                print(
                  '2FA: $_twoStepAnswer',
                ); // Still prints this if uncommented
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
