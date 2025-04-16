import 'package:beauty_client/domain/models/location.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigatorUtil {
  const NavigatorUtil._();

  static void navigateToLocation(Location location) async {
    final yandexUri = Uri.parse(
      'yandexnavi://build_route_on_map?lat_to=${location.latitude}&lon_to=${location.longitude}',
    );
    final googleUri = Uri.parse('google.navigation:q=${location.latitude},${location.longitude}');
    if (!kIsWeb && await canLaunchUrl(yandexUri)) {
      launchUrl(yandexUri);
    } else if (!kIsWeb && await canLaunchUrl(googleUri)) {
      launchUrl(googleUri);
    } else {
      print('pizda');
      print(location);
      print('https://2gis.ru/directions/points/|${location.latitude},${location.longitude}');
      launchUrl(Uri.parse('https://2gis.ru/directions/points/|${location.longitude},${location.latitude}'));
    }
  }
}
