class User {
  final String phoneNumber;
  final String name;

  User({required this.phoneNumber, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(phoneNumber: json['phoneNumber'], name: json['name'] ?? 'User');
  }

  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber, 'name': name};
  }
}
