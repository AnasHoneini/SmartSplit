class User {
  final String firstName;
  final String lastName;
  final String email;
  DateTime? deletedAt;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}
