part of 'venue_list_bloc.dart';

@freezed
class VenueListEvent with _$VenueListEvent {
  const factory VenueListEvent.started() = _Started;

  const factory VenueListEvent.requested({@Default(false) bool refresh}) = _Requested;

  const factory VenueListEvent.locationChanged({required Location location}) = _LocationChanged;
}
