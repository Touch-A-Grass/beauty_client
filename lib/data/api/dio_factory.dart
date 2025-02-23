import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:dio/dio.dart';

class DioFactory {
  static Dio create(AuthStorage authStorage) {
    final dio = Dio();
    final retryDio = Dio();

    // dio.interceptors.add(AuthInterceptor(authStorage: authStorage, retryDio: retryDio));
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return dio;
  }
}
