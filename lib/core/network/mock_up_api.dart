import 'package:big_ear/modules/items/models/review.dart';
import 'package:big_ear/modules/items/models/spring_bed_item.dart';

const List<Map<String, dynamic>> springBed = [
  {
    "id": 1,
    "name": "Divan & Sandaran Bristol Elephant",
    "desc":
        "Divan Elephant ini memiliki kerapatan antar kayu yg cukup rapat dan dilapisi oleh Hard Padding Solid sehingga dapat menahan beban kasur secara merata. Orang yg berdiri diatasnya pun akan aman / tidak amblas. Elephant Ini memiliki berat divan diatas rata2 untuk memastika tidur Anda nyaman.",
    "imageAsset": "assets/testing/bed1.png",
    "rate": 4.5, // This initial rate will be overridden by calculated average
  },
  {
    "id": 2,
    "name": "Elephant Hampers Box Sajadah Icy Cool Premium",
    "desc":
        "Rasakan pengalaman ibadah yang lebih nyaman dengan Sajadah Icy Cool, sajadah pertama di Indonesia yang menghadirkan sensasi dingin saat disentuh. Dibalut dengan Knitting Bamboo yang diinfus dengan Silk Cool Tech, sajadah ini memberikan kesejukan yang menenangkan, mengurangi rasa panas, dan membuat ibadah lebih khusyuk.",
    "imageAsset": "assets/testing/bed2.png",
    "rate": 3.5, // This initial rate will be overridden by calculated average
  },
];

const List<Map<String, dynamic>> mockUsers = [
  {"email": "blepetan@yahoo.com", "name": "Anita Pangestuti"},
  {"email": "jarangmandi@gmail.com", "name": "Zeyd Rizki Abadi"},
  {"email": "yipiyeye@rocketmail.com", "name": "Marsha Aulia"},
];

const List<Map<String, dynamic>> mockReviews = [
  {
    "itemId": 1,
    "userEmail": "blepetan@yahoo.com",
    "rating": 5.0,
    "comment": "Kasurnya enak, empuk, dan membuat tidur saya nyenyak",
  },
  {
    "itemId": 1,
    "userEmail": "jarangmandi@gmail.com",
    "rating": 4.5,
    "comment":
        "kasur ini bagus banget untuk seseorang yang sedang atau pernah merasakan sakit punggung dan panuan...",
  },
  {
    "itemId": 1,
    "userEmail": "yipiyeye@rocketmail.com",
    "rating": 5.0,
    "comment": "tidur saya jadi meaningful. makasih :)",
  },
  {
    "itemId": 2,
    "userEmail": "jarangmandi@gmail.com",
    "rating": 1.5,
    "comment": "saya tetap ingin murtad walau dengan sajadah ini",
  },
  {
    "itemId": 2,
    "userEmail": "yipiyeye@rocketmail.com",
    "rating": 2.0,
    "comment": "kurang dingin",
  },
];

// Helper function to process SpringBed data with reviews and calculate average rating
List<SpringBedItem> getSpringBedItemsWithReviews() {
  final List<SpringBedItem> items = springBed
      .map((json) => SpringBedItem.fromJson(json))
      .toList();
  final List<Review> reviews = mockReviews
      .map((json) => Review.fromJson(json))
      .toList();

  return items.map((item) {
    final itemReviews = reviews.where((r) => r.itemId == item.id).toList();
    final double avgRating = itemReviews.isEmpty
        ? 0.0
        : itemReviews.map((r) => r.rating).reduce((a, b) => a + b) /
              itemReviews.length;

    // Attach user name to each review here before storing them
    final reviewsWithUsers = itemReviews.map((review) {
      final user = mockUsers.firstWhere(
        (u) => u['email'] == review.userEmail,
        orElse: () => {'name': 'Unknown User'}, // Fallback for unmatched email
      );
      // Use the copyWith method on Review to add the userName
      return review.copyWith(userName: user['name'] as String);
    }).toList();

    // Use copyWith on SpringBedItem to add the calculated average rate and the reviews list
    return item.copyWith(reviews: reviewsWithUsers, rate: avgRating);
  }).toList();
}

// Ensure formatDataForGemini now uses item.reviews[i].userName
String formatDataForGemini() {
  final List<SpringBedItem> items = getSpringBedItemsWithReviews();
  StringBuffer buffer = StringBuffer();

  buffer.writeln(
    "Here is a list of product data, including items and their reviews:",
  );
  buffer.writeln("");

  for (var item in items) {
    buffer.writeln("---");
    buffer.writeln("Product Name: ${item.name}");
    buffer.writeln("Description: ${item.desc}");
    buffer.writeln(
      "Average Rating: ${item.rate.toStringAsFixed(1)} out of 5.0",
    );

    if (item.reviews.isNotEmpty) {
      buffer.writeln("Reviews:");
      for (var review in item.reviews) {
        // Use review.userName directly
        buffer.writeln(
          "- User: ${review.userName ?? 'Unknown'} (Rating: ${review.rating.toStringAsFixed(1)}): ${review.comment}",
        );
      }
    } else {
      buffer.writeln("No reviews available for this product.");
    }
    buffer.writeln("---");
    buffer.writeln("");
  }
  return buffer.toString();
}
