import 'dart:developer';

import 'package:nttcs/core/api/api_service.dart';
import 'package:nttcs/core/constants/constants.dart';
import 'package:nttcs/data/dtos/login_success_dto.dart';
import 'package:nttcs/data/models/device.dart';
import 'package:nttcs/data/models/schedule_date.dart';
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

  Future<Result<void>> login(
      {required String username,
      required String password,
      required String otp}) async {
    try {
      // Gửi yêu cầu đăng nhập
      final result = await authApiClient.login(
        LoginDto(username: username, password: password, otp: ""),
      );

      // Lưu token vào local data source
      await authLocalDataSource.saveString(
          AuthDataConstants.token, result?['Token'] as String);
      await authLocalDataSource.saveString(
          AuthDataConstants.code, result?['Code'] as String);
      await authLocalDataSource.saveString(
          AuthDataConstants.name, result?['Name'] as String);
      await authLocalDataSource.saveInt(
          AuthDataConstants.id, result?['Id'] as int);

      // Trả về kết quả thành công
      return Success(result?['Status']);
    } catch (e) {
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

  Future<String> getName() async {
    try {
      final name = await authLocalDataSource.getName();
      return name ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<Result<void>> logout() async {
    try {
      // await authLocalDataSource.deleteToken();
      return Success(null);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<void>> getDevice2() async {
    try {
      String token = await authLocalDataSource.getToken() as String;
      final result = await authApiClient.getDevice2(token);
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> getOverview() async {
    try {
      String token = await authLocalDataSource.getToken() as String;
      final result = await authApiClient.getOverview(token);
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> getLocations() async {
    try {
      String token = await authLocalDataSource.getToken() as String;
      final result = await authApiClient.getLocations(token);
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> getSchedules() async {
    try {
      String token = await authLocalDataSource.getToken() as String;
      final result = await authApiClient.getSchedules(token);
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> createSchedule(int locationSelected, String name,
      List<ScheduleDate> scheduleDates, List<Device> devices, int id) async {
    try {
      String token = await authLocalDataSource.getToken() as String;
      final result =
          await authApiClient.createSchedule(token, locationSelected, name, scheduleDates, devices, id);
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }
}
