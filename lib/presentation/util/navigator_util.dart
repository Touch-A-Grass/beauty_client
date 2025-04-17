import 'package:beauty_client/domain/models/location.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigatorUtil {
  const NavigatorUtil._();

  static void navigateToLocation(Location location) async {
    final yandexUri = Uri.parse(
      'yandexnavi://build_route_on_map?lat_to=${location.latitude}&lon_to=${location.longitude}',
    );
    final yandexMapsUri = Uri.parse('https://yandex.ru/maps/?pt=${location.longitude},${location.latitude}');
    if (!kIsWeb && await canLaunchUrl(yandexUri)) {
      launchUrl(yandexUri);
    } else {
      launchUrl(yandexMapsUri);
    }
  }
}
