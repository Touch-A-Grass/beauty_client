import 'package:beauty_client/data/api/beauty_client.dart';
import 'package:beauty_client/domain/models/location.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';

class VenueRepositoryImpl implements VenueRepository {
  final BeautyClient _api;

  VenueRepositoryImpl(this._api);

  @override
  Future<List<Venue>> getVenues({required Location location, required int limit, required int offset}) {
    return _api.venues(
      latitude: location.latitude,
      longitude: location.longitude,
      limit: limit,
      offset: offset,
    );
  }
}
