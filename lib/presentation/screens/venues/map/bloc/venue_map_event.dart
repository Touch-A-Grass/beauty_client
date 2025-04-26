part of 'venue_map_bloc.dart';

@freezed
class VenueMapEvent with _$VenueMapEvent {
  const factory VenueMapEvent.started() = _Started;

  const factory VenueMapEvent.locationChanged(Location location) = _LocationChanged;

  const factory VenueMapEvent.venuesRequested() = _VenuesRequested;

  const factory VenueMapEvent.venuesSearchRequested({@Default(false) bool refresh}) = _VenuesSearchRequested;

  const factory VenueMapEvent.mapLocationChanged({
    required double minLatitude,
    required double maxLatitude,
    required double minLongitude,
    required double maxLongitude,
    required int zoom,
  }) = _MapLocationChanged;

  const factory VenueMapEvent.searchQueryChanged(String searchQuery) = _SearchQueryChanged;
}
