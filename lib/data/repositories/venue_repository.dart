import 'package:beauty_client/data/api/beauty_client.dart';
import 'package:beauty_client/data/storage/location_storage.dart';
import 'package:beauty_client/domain/models/location.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';

class VenueRepositoryImpl implements VenueRepository {
  final BeautyClient _api;
  final LocationStorage locationStorage;

  VenueRepositoryImpl(this._api, this.locationStorage);

  @override
  Future<List<Venue>> getVenues({Location? location, required int limit, required int offset}) async {
    return [Venue(id: 'abcsgbzxcvbnm', name: 'Тестовый', location: location ?? locationStorage.value)];

    final userLocation = location;

    return _api.venues(
      latitude: userLocation?.latitude,
      longitude: userLocation?.longitude,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<Service>> getServices(String venueId) async {
    return [
      Service(id: 'a', name: 'Ноготочки', description: 'Дёшево, быстро', price: 1000, duration: Duration(minutes: 30)),
      Service(id: 'a', name: 'Ноготочки', description: 'Дёшево, быстро', price: 1000, duration: Duration(minutes: 30)),
      Service(id: 'a', name: 'Ноготочки', description: 'Дёшево, быстро', price: 1000, duration: Duration(minutes: 30)),
      Service(id: 'a', name: 'Ноготочки', description: 'Дёшево, быстро', price: 1000, duration: Duration(minutes: 30)),
      Service(id: 'a', name: 'Ноготочки', description: 'Дёшево, быстро', price: 1000, duration: Duration(minutes: 30)),
      Service(id: 'a', name: 'Ноготочки', description: 'Дёшево, быстро', price: 1000, duration: Duration(minutes: 30)),
      Service(id: 'a', name: 'Ноготочки', description: 'Дёшево, быстро', price: 1000, duration: Duration(minutes: 30)),
    ];
    return _api.venueServices(venueId);
  }

  @override
  Future<Venue> getVenue(String venueId) async {
    return Venue(
      id: 'abcsgbzxcvbnm',
      description: 'Лучший салон в Иркутске на улице Бульвар Гагарина',
      name: 'Итали в цирке',
      location: locationStorage.value,
    );
    return _api.getVenue(venueId);
  }
}
