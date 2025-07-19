class Review {
  final int itemId;
  final String userPhone;
  final double rating;
  final String comment;

  Review({
    required this.itemId,
    required this.userPhone,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      itemId: json['itemId'],
      userPhone: json['userPhone'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'userPhone': userPhone,
      'rating': rating,
      'comment': comment,
    };
  }
}
