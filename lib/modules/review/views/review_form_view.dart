import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewFormView extends StatefulWidget {
  final Map<String, dynamic> item;

  const ReviewFormView({super.key, required this.item});

  @override
  State<ReviewFormView> createState() => _ReviewFormViewState();
}

class _ReviewFormViewState extends State<ReviewFormView> {
  double _rating = 0;
  String _reviewText = '';
  String? _twoStepAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beri Ulasan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    16,
                  ), // Adjust radius as needed
                  child: Image.asset(
                    widget.item['imageAsset'],
                    width: 144, // Same as 72 * 2
                    height: 144,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.item['name'],
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

            // 2FA Question
            // Text('Does this app have 2-step verification?'),
            // Wrap(
            //   spacing: 10,
            //   children: ['Yes', 'No', 'Not Sure'].map((answer) {
            //     return ChoiceChip(
            //       label: Text(answer),
            //       selected: _twoStepAnswer == answer,
            //       onSelected: (_) {
            //         setState(() => _twoStepAnswer = answer);
            //       },
            //     );
            //   }).toList(),
            // ),
            const SizedBox(height: 30),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                print('Rating: $_rating');
                print('Review: $_reviewText');
                print('2FA: $_twoStepAnswer');
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue, // Button background color
                foregroundColor: Colors.white, // Text (and icon) color
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
