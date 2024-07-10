import 'dart:developer';

import 'package:nttcs/core/api/api_service.dart';
import 'package:nttcs/data/dtos/login_success_dto.dart';
import 'package:nttcs/data/result_type.dart';

import '../auth_local_data_source.dart';
import '../dtos/login_dto.dart';
import '../dtos/register_dto.dart';

class AuthRepository {
  final AuthApiClient authApiClient;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepository({
    required this.authApiClient,
    required this.authLocalDataSource,
  });

  Future<Result<void>> login({
    required String username,
    required String password,
  }) async {
    try {
      // Gửi yêu cầu đăng nhập
      LoginSuccessDto loginSuccessDto = await authApiClient.login(
        LoginDto(username: username, password: password),
      );

      // Lưu token vào local data source
      await authLocalDataSource.saveToken(loginSuccessDto.token);

      // Trả về kết quả thành công
      return Success(loginSuccessDto);
    } catch (e) {
      // Ghi lại lỗi
      log('$e');

      // Trả về kết quả thất bại
      return Failure('$e');
    }
  }

  Future<Result<void>> register({
    required String username,
    required String password,
  }) async {
    try {
      await authApiClient.register(
        RegisterDto(username: username, password: password),
      );
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
    return Success(null);
  }

  Future<Result<String?>> getToken() async {
    try {
      final token = await authLocalDataSource.getToken();
      if (token == null) {
        return Success(null);
      }
      return Success(token);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<void>> logout() async {
    try {
      await authLocalDataSource.deleteToken();
      return Success(null);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }
}
