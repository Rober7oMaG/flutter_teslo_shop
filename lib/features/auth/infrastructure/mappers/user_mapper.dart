import 'package:teslo_shop/features/auth/auth.dart';

class UserMapper {
  static User fromJson(Map<String, dynamic> json) => User(
    id: json['id'], 
    fullName: json['fullName'], 
    email: json['email'], 
    roles: List<String>.from(json['roles'].map((role) => role)),
    token: json['token'] ?? ''
  );
}