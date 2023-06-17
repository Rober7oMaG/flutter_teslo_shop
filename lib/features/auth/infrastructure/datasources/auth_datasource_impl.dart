import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/auth.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl
    )
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status', 
        options: Options(
          headers: {
            'Authorization': 'Bearer $token'
          }
        )
      );

      final user = UserMapper.fromJson(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Invalid token');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Check your internet connection');
      }

      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password
      });

      final user = UserMapper.fromJson(response.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Incorrect credentials');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Check your internet connection');
      }

      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String fullName, String email, String password) async {
    try {
      final response = await dio.post('/auth/register', data: {
        'fullName': fullName,
        'email': email,
        'password': password
      });

      final user = UserMapper.fromJson(response.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError('This email is already registered');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Check your internet connection');
      }

      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

}