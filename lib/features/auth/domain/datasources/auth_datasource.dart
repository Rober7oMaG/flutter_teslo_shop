import 'package:teslo_shop/features/auth/auth.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password);
  Future<User> register(String fullName, String email, String password);

  Future<User> checkAuthStatus(String token);
}