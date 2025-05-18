import 'package:beauty_client/data/storage/base/stream_storage.dart';
import 'package:beauty_client/domain/models/venue_theme_config.dart';

class VenueThemeStorage extends StreamStorage<Map<String, VenueThemeConfig>> {
  VenueThemeStorage() : super(initialValue: {});

  void setTheme(String id, VenueThemeConfig theme) {
    update({...value, id: theme});
  }
}
