part of 'venue_map_bloc.dart';

@freezed
class VenueMapState with _$VenueMapState {
  const factory VenueMapState({
    @Default([]) List<Venue> venues,
    Location? location,
  }) = _VenueMapState;
}
