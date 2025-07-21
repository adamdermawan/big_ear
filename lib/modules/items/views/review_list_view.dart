import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import 'package:big_ear/core/network/mock_up_api.dart';
import '../models/review.dart';
import '../../user/models/user.dart';

class ReviewListView extends StatelessWidget {
  final int itemId;

  const ReviewListView({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    // Convert review JSON to model
    final reviews = mockReviews
        .map((r) => Review.fromJson(r))
        .where((r) => r.itemId == itemId)
        .toList();

    final users = mockUsers.map((u) => User.fromJson(u)).toList();

    final ratings = reviews.map((r) => r.rating).toList();
    final avgRating = ratings.isEmpty
        ? 0.0
        : (ratings.reduce((a, b) => a + b) / ratings.length).toDouble();

    // Rating distribution
    final ratingCounts = List.generate(5, (i) {
      return reviews.where((r) => r.rating.floor() == 5 - i).length;
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Ratings and Reviews')),
      body: Padding(
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
                    Text('${reviews.length} ratings'),
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
              final percent = reviews.isEmpty ? 0.0 : count / reviews.length;
              return Row(
                children: [
                  Text('$label'),
                  const Icon(Icons.star, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: percent,
                      color: Colors.blue,
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
            Expanded(
              child: ListView.separated(
                itemCount: reviews.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  final user = users.firstWhere(
                    (u) => u.email == review.userEmail,
                    orElse: () => User(email: review.userEmail, name: 'User'),
                  );

                  final formattedDate = DateFormat.yMMMd().format(
                    DateTime.now(),
                  ); // mock

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0] : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(user.name),
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
    );
  }
}
