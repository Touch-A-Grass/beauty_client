import 'package:beauty_client/data/api/interceptors/auth_interceptor.dart';
import 'package:beauty_client/data/api/interceptors/base_headers_interceptor.dart';
import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:dio/dio.dart';

class DioFactory {
  static Dio create(AuthStorage authStorage, BaseHeadersInterceptor baseHeadersInterceptor) {
    final dio = Dio(
      BaseOptions(connectTimeout: const Duration(seconds: 30), receiveTimeout: const Duration(minutes: 5)),
    );
    final retryDio = Dio();

    dio.interceptors.addAll([
      baseHeadersInterceptor,
      AuthInterceptor(authStorage: authStorage, retryDio: retryDio),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);

    return dio;
  }
}
