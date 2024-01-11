import 'dart:convert';
import 'package:requests/requests.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class User {
  final String id;
  final String googleId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String createdAt;
  final bool isAdmin;

  const User(this.id, this.googleId, this.email, this.firstName, this.lastName,
      this.createdAt, this.isAdmin);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json['_id'] as String,
        json['googleId'] as String,
        json['email'] as String,
        json['firstName'] as String?,
        json['lastName'] as String?,
        json['createdAt'] as String,
        json.containsKey("isAdmin") ? json['isAdmin'] as bool : false);
  }
}

Future<User?> getUserByID(String id) async {
  final response = await Requests.get("${dotenv.env['API_URL']!}/users/$id");
  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    return null;
  } else {
    throw Exception('Failed to load ticket ${response.body}');
  }
}
