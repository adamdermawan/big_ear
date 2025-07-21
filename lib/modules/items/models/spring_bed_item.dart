import 'package:big_ear/modules/items/models/review.dart'; // Import the Review model

class SpringBedItem {
  final int id;
  final String name;
  final String desc;
  final String imageAsset;
  final double rate; // This will be the *calculated* average rate
  final List<Review> reviews; // Add this line

  SpringBedItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.imageAsset,
    required this.rate,
    this.reviews = const [], // Initialize with an empty list
  });

  factory SpringBedItem.fromJson(Map<String, dynamic> json) {
    return SpringBedItem(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      imageAsset: json['imageAsset'],
      rate: (json['rate'] ?? 0)
          .toDouble(), // This 'rate' will be replaced by the calculated average
      reviews: [], // Reviews will be loaded separately
    );
  }

  // Add a method to create a new SpringBedItem with updated reviews and rate
  SpringBedItem copyWith({List<Review>? reviews, double? rate}) {
    return SpringBedItem(
      id: id,
      name: name,
      desc: desc,
      imageAsset: imageAsset,
      rate: rate ?? this.rate,
      reviews: reviews ?? this.reviews,
    );
  }
}
