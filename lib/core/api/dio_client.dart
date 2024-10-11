import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'interceptors.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
      connectTimeout: const Duration(minutes: 30),
      receiveTimeout: const Duration(minutes: 30),
      headers: {
        'Connection': 'keep-alive',
      },
    ));

    dio.interceptors.add(AppInterceptors());
    // dio.interceptors.add(CacheInterceptor());
    dio.interceptors.add(RetryInterceptor(dio));
  }

  static DioClient get instance => _instance;


  Future<Response> get(String path,
      {String? token, Map<String, dynamic>? queryParameters}) async {
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
