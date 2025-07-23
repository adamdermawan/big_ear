class Review {
  final int itemId;
  final String userEmail;
  final String? userName;
  final double rating;
  final String comment;

  Review({
    required this.itemId,
    required this.userEmail,
    this.userName,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      itemId: json['itemId'],
      userEmail: json['userEmail'],
      userName: json['userName'] as String?,
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'userEmail': userEmail,
      'userName': userName,
      'rating': rating,
      'comment': comment,
    };
  }

  Review copyWith({
    int? itemId,
    String? userEmail,
    String? userName,
    double? rating,
    String? comment,
  }) {
    return Review(
      itemId: itemId ?? this.itemId,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }
}
