part of 'venue_details_bloc.dart';

@freezed
class VenueDetailsEvent with _$VenueDetailsEvent {
  const factory VenueDetailsEvent.started() = _Started;
}
