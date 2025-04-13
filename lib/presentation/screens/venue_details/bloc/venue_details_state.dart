part of 'venue_details_bloc.dart';

@freezed
class VenueDetailsState with _$VenueDetailsState {
  const VenueDetailsState._();

  const factory VenueDetailsState({
    Venue? venue,
    @Default([]) List<Service> services,
    @Default([]) List<Staff> staff,
    AppError? servicesLoadingError,
    @Default(false) bool isLoadingServices,
    AppError? venueLoadingError,
    @Default(false) bool isLoadingVenue,
    AppError? staffLoadingError,
    @Default(false) bool isLoadingStaff,
  }) = _VenueDetailsState;

  List<String> get allPhotos => [venue?.theme.photo, ...(venue?.photos ?? <String>[])].nonNulls.toList();
}
