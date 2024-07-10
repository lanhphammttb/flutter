import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('Request to ${options.uri}');
    // Kiểm tra và thêm token nếu có trong headers
    if (options.headers.containsKey("Authorization")) {
      final token = options.headers["Authorization"];
      options.headers["Authorization"] = "Bearer $token";
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('Response from ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('Error: $err');
    super.onError(err, handler);
  }
}
