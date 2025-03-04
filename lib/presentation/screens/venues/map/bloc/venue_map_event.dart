part of 'venue_map_bloc.dart';

@freezed
class VenueMapEvent with _$VenueMapEvent {
  const factory VenueMapEvent.started() = _Started;

  const factory VenueMapEvent.locationChanged(Location location) = _LocationChanged;
}
