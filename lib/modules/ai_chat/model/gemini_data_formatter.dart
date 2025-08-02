import 'package:big_ear/modules/items/services/springbed_item_service.dart';
import 'package:big_ear/modules/items/models/spring_bed_item.dart';

// NEW: Updated to use real API data instead of mock data
Future<String> formatDataForGemini() async {
  try {
    final SpringBedItemService itemService = SpringBedItemService();
    final List<SpringBedItem> items = await itemService.getAllItemsWithReviews();
    
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
          // Use review.userName directly from the backend
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
  } catch (e) {
    print('❌ Error formatting data for Gemini: $e');
    // Return a fallback message if API fails
    return "Sorry, I'm having trouble accessing the product data right now. Please try again later.";
  }
}

// DEPRECATED: Keep this for backward compatibility during transition, but it's no longer used
String formatDataForGeminiOld() {
  // This function is deprecated and should not be used
  return "This function is deprecated. Use the async version instead.";
}