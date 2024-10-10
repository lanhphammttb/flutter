import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Kiểm tra và thêm token nếu có trong headers
    if (options.headers.containsKey("Authorization")) {
      final token = options.headers["Authorization"];
      options.headers["Authorization"] = "Bearer $token";
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}

class CacheInterceptor extends Interceptor {
  final _cache = <Uri, Response>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_cache.containsKey(options.uri)) {
      return handler.resolve(_cache[options.uri]!); // Trả về response từ cache
    }
    super.onRequest(options, handler); // Tiếp tục request nếu không có trong cache
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cache[response.requestOptions.uri] = response; // Lưu response vào cache
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}