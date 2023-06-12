import 'package:teslo_shop/features/auth/domain/domain.dart';

class UserMapper {
  static User jsonToUserEntity(Map<String, dynamic> json) => User(
    id: json['id'], 
    fullName: json['fullName'], 
    email: json['email'], 
    roles: List<String>.from(json['roles'].map((role) => role)),
    token: json['token']
  );
}