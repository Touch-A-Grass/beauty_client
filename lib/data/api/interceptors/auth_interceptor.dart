import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:beauty_client/domain/models/auth.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends QueuedInterceptor {
  final AuthStorage authStorage;
  final Dio retryDio;

  AuthInterceptor({required this.authStorage, required this.retryDio});

  bool refreshing = false;
  final failedRequests = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = authStorage.value?.token;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode != 401) {
      handler.next(err);
    }

    if (refreshing) {
      handler.next(err);
      return;
    }
  }

  Future<void> refreshToken() async {
    final refreshToken = authStorage.value?.refreshToken;
    final response = await retryDio.post('/user/refresh-token', data: {'refresh_token': refreshToken});

    if (response.statusCode == 200) {
      authStorage.update(Auth.fromJson(response.data));
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return retryDio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
