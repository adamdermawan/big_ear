// import 'springbed_data.dart';
// import 'user_data.dart';
// import 'review_data.dart';
// import 'package:big_ear/modules/items/models/review.dart';
// import 'package:big_ear/modules/items/models/spring_bed_item.dart';


// // Helper function to process SpringBed data with reviews and calculate average rating
// List<SpringBedItem> getSpringBedItemsWithReviews() {
//   final List<SpringBedItem> items = springBed
//       .map((json) => SpringBedItem.fromJson(json))
//       .toList();
//   final List<Review> reviews = mockReviews
//       .map((json) => Review.fromJson(json))
//       .toList();

//   return items.map((item) {
//     final itemReviews = reviews.where((r) => r.itemId == item.id).toList();
//     final double avgRating = itemReviews.isEmpty
//         ? 0.0
//         : itemReviews.map((r) => r.rating).reduce((a, b) => a + b) /
//               itemReviews.length;

//     // Attach user name to each review here before storing them
//     final reviewsWithUsers = itemReviews.map((review) {
//       final user = mockUsers.firstWhere(
//         (u) => u['email'] == review.userEmail,
//         orElse: () => {'name': 'Unknown User'}, // Fallback for unmatched email
//       );
//       // Use the copyWith method on Review to add the userName
//       return review.copyWith(userName: user['name'] as String);
//     }).toList();

//     // Use copyWith on SpringBedItem to add the calculated average rate and the reviews list
//     return item.copyWith(reviews: reviewsWithUsers, rate: avgRating);
//   }).toList();
// }