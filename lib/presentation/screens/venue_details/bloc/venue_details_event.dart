part of 'venue_details_bloc.dart';

@freezed
class VenueDetailsEvent with _$VenueDetailsEvent {
  const factory VenueDetailsEvent.started() = _Started;

  const factory VenueDetailsEvent.servicesRequested() = _ServicesRequested;

  const factory VenueDetailsEvent.venuesRequested() = _VenuesRequested;

  const factory VenueDetailsEvent.staffRequested() = _StaffRequested;
}
