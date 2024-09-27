import 'package:dio/dio.dart';

class AuthenticationRepository {
  final Dio dio;

  AuthenticationRepository(this.dio);

  Future<void> login(String username, String password) async {
    try {
      final response = await dio.post('/login', data: {
        'username': username,
        'password': password,
      });
      if (response.statusCode == 200) {
        // Handle login success
      }
    } catch (e) {
      throw Exception('Failed to login');
    }
  }
}
