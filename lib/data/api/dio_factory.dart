import 'package:beauty_client/data/api/interceptors/auth_interceptor.dart';
import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:dio/dio.dart';

class DioFactory {
  static Dio create(AuthStorage authStorage) {
    final dio = Dio();
    final retryDio = Dio();

    dio.interceptors.add(AuthInterceptor(authStorage: authStorage, retryDio: retryDio));

    return dio;
  }
}
