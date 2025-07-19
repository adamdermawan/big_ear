class Review {
  final int itemId;
  final String userEmail;
  final double rating;
  final String comment;

  Review({
    required this.itemId,
    required this.userEmail,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      itemId: json['itemId'],
      userEmail: json['userEmail'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'userEmail': userEmail,
      'rating': rating,
      'comment': comment,
    };
  }
}
