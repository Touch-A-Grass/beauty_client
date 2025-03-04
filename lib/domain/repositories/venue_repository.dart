import 'package:beauty_client/domain/models/location.dart';
import 'package:beauty_client/domain/models/venue.dart';

abstract interface class VenueRepository {
  Future<List<Venue>> getVenues({Location? location, required int limit, required int offset});
}
