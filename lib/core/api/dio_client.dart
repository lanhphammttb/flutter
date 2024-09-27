import 'package:dio/dio.dart';
import 'package:nttcs/utils/constants.dart';

import 'interceptors.dart';

class DioClient {
  static DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: BASE_URL,
    ));

    dio.interceptors.add(AppInterceptors());
  }

  static DioClient get instance => _instance;

  static set instance(DioClient value) {
    _instance = value;
  }

  Future<Response> get(String path, {String? token, Map<String, dynamic>? queryParameters}) async {
    return dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(headers: token != null ? {"Authorization": token} : {}),
    );
  }

  Future<Response> post(String path, {String? token, dynamic data}) async {
    return dio.post(
      path,
      data: data,
      options: Options(headers: token != null ? {"Authorization": token} : {}),
    );
  }
}

