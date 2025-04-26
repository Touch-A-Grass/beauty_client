import 'package:beauty_client/data/api/beauty_client.dart';
import 'package:beauty_client/data/models/mappers/staff_time_slot_mapper.dart';
import 'package:beauty_client/data/storage/location_storage.dart';
import 'package:beauty_client/data/util/string_util.dart';
import 'package:beauty_client/domain/models/location.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/staff_time_slot.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/models/venue_map_clusters.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';

class VenueRepositoryImpl implements VenueRepository {
  final BeautyClient _api;
  final LocationStorage locationStorage;

  VenueRepositoryImpl(this._api, this.locationStorage);

  @override
  Future<List<Venue>> getVenues({
    Location? location,
    required int limit,
    required int offset,
    String? searchQuery,
  }) async {
    final userLocation = location;

    return _api.venues(
      latitude: userLocation?.latitude,
      longitude: userLocation?.longitude,
      limit: limit,
      offset: offset,
      searchQuery: searchQuery?.trimOrNull,
    );
  }

  @override
  Future<List<Service>> getServices(String venueId) async {
    return _api.venueServices(venueId);
  }

  @override
  Future<List<Staff>> getStaff(String venueId) async {
    return _api.getStaff(venueId);
  }

  @override
  Future<List<StaffTimeSlot>> getVenueStaffTimeSlots({required String staffId, required String venueId}) async {
    final dto = await _api.getVenueStaffTimeSlots(staffId: staffId, venueId: venueId);
    return dto.map((e) => StaffTimeSlotMapper.fromDto(e)).toList();
  }

  @override
  Future<Venue> getVenue(String venueId) async {
    return _api.getVenue(venueId);
  }

  @override
  Future<VenueMapClusters> getClusters({
    required double minLatitude,
    required double maxLatitude,
    required double minLongitude,
    required double maxLongitude,
    required int zoom,
    String? searchQuery,
  }) => _api.getVenueMapClusters(
    minLatitude: minLatitude,
    maxLatitude: maxLatitude,
    minLongitude: minLongitude,
    maxLongitude: maxLongitude,
    zoom: zoom,
  );
}
