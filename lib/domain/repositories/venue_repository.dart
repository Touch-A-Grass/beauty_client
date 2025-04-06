import 'package:beauty_client/domain/models/location.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/staff_time_slot.dart';
import 'package:beauty_client/domain/models/venue.dart';

abstract interface class VenueRepository {
  Future<List<Venue>> getVenues({Location? location, required int limit, required int offset});

  Future<Venue> getVenue(String venueId);

  Future<List<Service>> getServices(String venueId);

  Future<List<Staff>> getStaff(String venueId);

  Future<List<StaffTimeSlot>> getVenueStaffTimeSlots({required String staffId, required String venueId});
}
