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
  Future<List<Venue>> getVenues({Location? location, required int limit, required int offset}) {
    final userLocation = location ?? locationStorage.value;

    return _api.venues(
      latitude: userLocation.latitude,
      longitude: userLocation.longitude,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<Service>> getServices(String venueId) async {
    return _api.venueServices('78f46b6d-0c74-4424-b42c-2fd2b2d4f658');
    return _api.venueServices(venueId);
  }
}
