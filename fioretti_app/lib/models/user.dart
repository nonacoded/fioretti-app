class User {
  final String id;
  final String googleId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String createdAt;

  const User(this.id, this.googleId, this.email, this.firstName, this.lastName,
      this.createdAt);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json['_id'] as String,
        json['googleId'] as String,
        json['email'] as String,
        json['firstName'] as String,
        json['lastName'] as String,
        json['createdAt'] as String);
  }
}
