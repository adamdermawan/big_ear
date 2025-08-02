class Review {
  final int? id;
  final int itemId;
  final int? userId;
  final String userEmail;
  final String? userName;
  final double rating;
  final String comment;
  final DateTime? createdAt;

  Review({
    this.id,
    required this.itemId,
    this.userId,
    required this.userEmail,
    this.userName,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  // For mock data (existing)
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      itemId: json['itemId'],
      userEmail: json['userEmail'],
      userName: json['userName'] as String?,
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt']) // Use safe parsing
        : null,
    );
  }

  // For backend data (new)
  factory Review.fromBackendJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      itemId: json['itemId'],
      userId: json['userId'],
      userEmail: json['userEmail'] ?? '', // You might need to adjust based on your backend response
      userName: json['userName'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  Review copyWith({
    int? id,
    int? itemId,
    int? userId,
    String? userEmail,
    String? userName,
    double? rating,
    String? comment,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}