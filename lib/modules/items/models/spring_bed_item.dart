// lib/modules/items/models/spring_bed_item.dart

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
      // Ensure 'rate' is always a double, even if null or int from JSON
      rate: (json['rate'] as num? ?? 0.0).toDouble(),
      // Reviews are intended to be loaded and attached separately, so keep this empty
      reviews: const [],
    );
  }

  // Add a method to create a new SpringBedItem with updated values
  SpringBedItem copyWith({
    int? id, // Add other fields for full copyWith flexibility
    String? name,
    String? desc,
    String? imageAsset,
    double? rate,
    List<Review>? reviews,
  }) {
    return SpringBedItem(
      id: id ?? this.id, // Use null-aware operator for all fields
      name: name ?? this.name,
      desc: desc ?? this.desc,
      imageAsset: imageAsset ?? this.imageAsset,
      rate: rate ?? this.rate,
      reviews: reviews ?? this.reviews,
    );
  }
}
