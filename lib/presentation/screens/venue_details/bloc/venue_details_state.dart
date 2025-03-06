part of 'venue_details_bloc.dart';

@freezed
class VenueDetailsState with _$VenueDetailsState {
  const factory VenueDetailsState({
    Venue? venue,
    @Default([]) List<Service> services,
    AppError? servicesLoadingError,
    @Default(false) bool isLoadingServices,
  }) = _VenueDetailsState;
}
