import 'package:dio/dio.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class BaseHeadersInterceptor extends QueuedInterceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String timezone = await FlutterTimezone.getLocalTimezone();

    options.headers.addAll({'Content-Type': 'application/json', 'X-Timezone': timezone});
    super.onRequest(options, handler);
  }
}
