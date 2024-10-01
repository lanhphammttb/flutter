import 'package:dio/dio.dart';
import 'package:nttcs/data/dtos/login_dto.dart';
import 'package:nttcs/data/dtos/login_success_dto.dart';
import 'package:nttcs/data/dtos/register_dto.dart';
import 'package:nttcs/data/models/device2.dart';
import 'package:nttcs/data/models/location.dart';
import 'package:nttcs/data/models/res_overview.dart';
import 'package:nttcs/data/models/specific_response.dart';
import 'package:nttcs/data/models/user.dart';
import 'package:nttcs/data/result_type.dart';

import 'dio_client.dart';

class AuthApiClient {
  AuthApiClient(this.dio);

  final DioClient dio;

  Future<Map<String, dynamic>?> login(LoginDto loginDto) async {
    try {
      // Gửi yêu cầu đăng nhập
      final response = await dio.post(
        '/Auth/KToken',
        data: loginDto.toJson(),
      );

      final result = LoginSuccessDto.fromJson(response.data);

      if (result.code == 1) {
        final userData = await getUser(result.token);

        return {
          'Token': result.token,
          'Code': userData.items.isNotEmpty ? userData.items[0].code : null,
          'Name': userData.items.isNotEmpty ? userData.items[0].name : null,
          'Id': userData.items.isNotEmpty ? userData.items[0].id : null,
          'IsGoogleAuth': result.isGoogleAuth,
          'Status': userData.status,
        };
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> register(RegisterDto registerDto) async {
    try {
      await dio.post(
        '/auth/register',
        data: registerDto.toJson(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificResponse<User>> getUser(String token) async {
    try {
      final response = await dio.get(
        'site',
        token: token,
      );

      return SpecificResponse<User>.fromJson(
        response.data,
        (item) => User.fromJson(item as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificResponse<Device2>> getDevice2(String token) async {
    try {
      final response = await dio.post(
        'Device/list',
        token: token,
        data: {
          'Type': "IPRADIO",
          'Code': "H39",
          'Province': "H39",
          'Page': 1,
          'Size': 1000,
        },
      );

      return SpecificResponse<Device2>.fromJson(
        response.data,
        (item) => Device2.fromJson(item as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificResponse<ResOverview>> getOverview(String token) async {
    try {
      final response = await dio.get(
        'SourceData/code',
        token: token,
        queryParameters: {
          'Code': 'H39',
          'Province': 'H39',
        },
      );

      return SpecificResponse<ResOverview>.fromJson(
        response.data,
        (item) => ResOverview.fromJson(item as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<SpecificResponse<Location>> getLocations(String token) async {
    try {
      final response = await dio.get(
        'SourceData/code',
        token: token,
        queryParameters: {
          'Code': 'H39',
          'Province': 'H39',
        },
      );

      return SpecificResponse<Location>.fromJson(
        response.data,
            (item) => Location.fromJson(item as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
