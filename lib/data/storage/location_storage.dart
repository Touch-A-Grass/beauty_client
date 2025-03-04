import 'package:beauty_client/data/storage/base/stream_storage.dart';
import 'package:beauty_client/domain/models/location.dart';

class LocationStorage extends StreamStorage<Location> {
  LocationStorage() : super(initialValue: const Location(latitude: 52.2978, longitude: 104.2964, isReal: false));
}
