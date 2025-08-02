// lib/modules/items/models/spring_bed_item.dart

import 'package:big_ear/modules/items/models/review.dart';

class SpringBedItem {
  final int id;
  final String name;
  final String desc;
  final String imageAsset;
  final double rate; // This will be the *calculated* average rate from backend
  final List<Review> reviews;

  SpringBedItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.imageAsset,
    required this.rate,
    this.reviews = const [],
  });

  // Factory constructor for mock data (keep for backward compatibility during transition)
  factory SpringBedItem.fromJson(Map<String, dynamic> json) {
    return SpringBedItem(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      imageAsset: json['imageAsset'],
      rate: (json['rate'] as num? ?? 0.0).toDouble(),
      reviews: const [],
    );
  }

  // NEW: Factory constructor for backend data
  factory SpringBedItem.fromBackendJson(Map<String, dynamic> json) {
    // Parse reviews from backend
    List<Review> reviewsList = [];
    if (json['reviews'] != null) {
      reviewsList = (json['reviews'] as List)
          .map((reviewJson) => Review.fromBackendJson(reviewJson))
          .toList();
    }

    return SpringBedItem(
      id: json['id'],
      name: json['name'] ?? '',
      desc: json['description'] ?? '', // Note: backend uses 'description', flutter uses 'desc'
      imageAsset: json['imageAsset'] ?? '',
      rate: (json['rate'] as num? ?? 0.0).toDouble(),
      reviews: reviewsList,
    );
  }

  // Convert to JSON for API calls if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': desc, // Use 'description' for backend
      'imageAsset': imageAsset,
      'rate': rate,
    };
  }

  SpringBedItem copyWith({
    int? id,
    String? name,
    String? desc,
    String? imageAsset,
    double? rate,
    List<Review>? reviews,
  }) {
    return SpringBedItem(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      imageAsset: imageAsset ?? this.imageAsset,
      rate: rate ?? this.rate,
      reviews: reviews ?? this.reviews,
    );
  }
}