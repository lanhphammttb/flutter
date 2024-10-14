import 'dart:developer';

import 'package:nttcs/core/api/api_service.dart';
import 'package:nttcs/core/constants/constants.dart';
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

  Future<Result<void>> login({required String username, required String password, required String otp}) async {
    try {
      // Gửi yêu cầu đăng nhập
      final result = await authApiClient.login(
        LoginDto(username: username, password: password, otp: ""),
      );

      return Success(result);
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
      final [token] = await authLocalDataSource.getValue([Constants.token]);
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
      // await authLocalDataSource.deleteToken();
      return Success(null);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<void>> getDevice(int siteMapId, int page) async {
    try {
      final result = await authApiClient.getDevice(siteMapId, page);
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> getDevice2(int page, int reload) async {
    try {
      final result = await authApiClient.getDevice2(page, reload);
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> getOverview() async {
    try {
      final result = await authApiClient.getOverview();
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> getLocations() async {
    try {
      final result = await authApiClient.getLocations();
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> getSchedules(int page, int reload) async {
    try {
      final result = await authApiClient.getSchedules(page, reload);
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> createSchedule(int locationSelected, String name, List<ScheduleDate> scheduleDates, List<Device> devices, int id) async {
    try {
      final result = await authApiClient.createSchedule(locationSelected, name, scheduleDates, devices, id);
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> getNews() async {
    try {
      final result = authApiClient.getNews();
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> getInformation() async {
    try {
      final result = authApiClient.getInformation();
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> controlDevice(int maLenh, int thamSo, List<String> devicesArray) async {
    try {
      final result = await authApiClient.controlDevice(maLenh, thamSo, devicesArray);
      return Success(result);
    } catch (e) {
      return Failure('$e');
    }
  }

  void saveSelectCode(String selectCode) {
    authLocalDataSource.saveString(Constants.selectCode, selectCode);
  }
}
