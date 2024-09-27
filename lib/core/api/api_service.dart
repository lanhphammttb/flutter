import 'package:dio/dio.dart';
import 'package:nttcs/data/dtos/get_user_success_dto.dart';
import 'package:nttcs/data/dtos/login_dto.dart';
import 'package:nttcs/data/dtos/login_success_dto.dart';
import 'package:nttcs/data/dtos/register_dto.dart';
import 'package:nttcs/data/models/BaseResponse.dart';
import 'package:nttcs/data/result_type.dart';

import 'dio_client.dart';

class AuthApiClient {
  AuthApiClient(this.dio);

  final DioClient dio;

  Future<LoginSuccessDto> login(LoginDto loginDto) async {
    try {
      // Gửi yêu cầu đăng nhập
      final response = await dio.post(
        '/Auth/KToken',
        data: loginDto.toJson(),
      );

      // Phân tích kết quả đăng nhập
      final result = BaseResponse.fromJson(response.data);

      // Kiểm tra xem đăng nhập có thành công không
      if (result.status) {
        // Nếu thành công, lấy thông tin người dùng
        final userData = await getUser(result.app, result.token);

        // Trả về kết quả đăng nhập kèm thông tin người dùng
        return LoginSuccessDto.withUserData(result, userData);
      }

      // Nếu không thành công, trả về kết quả đăng nhập mà không có thông tin người dùng
      return result;
    } on DioException catch (e) {
      // Xử lý lỗi DioException
      if (e.response != null) {
        print('DioException response data: ${e.response!.data}');
        throw Exception(e.response!.data['message']);
      } else {
        print('DioException message: ${e.message}');
        throw Exception(e.message);
      }
    } catch (e) {
      // Xử lý các lỗi chung khác
      print('General exception: $e');
      throw Exception('An error occurred: $e');
    }
  }


  Future<GetUserSuccessDto> getUser(String id, String token) async {
    try {
      final response = await dio.get(
        'site',
        token: token,
      );

      return GetUserSuccessDto.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        print('DioException response data: ${e.response!.data}');
        throw Exception(e.response!.data['message']);
      } else {
        print('DioException message: ${e.message}');
        throw Exception(e.message);
      }
    } catch (e) {
      print('General exception: $e');
      throw Exception('An error occurred: $e');
    }
  }
}
