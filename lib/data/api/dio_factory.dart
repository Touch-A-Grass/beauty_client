import 'package:dio/dio.dart';

class DioFactory {
  static Dio create() {
    final dio = Dio();

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) => handler.next(options)));

    return dio;
  }
}
