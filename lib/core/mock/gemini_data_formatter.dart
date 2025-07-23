import 'package:big_ear/core/mock/mock_data_service.dart';
import 'package:big_ear/modules/items/models/spring_bed_item.dart';

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