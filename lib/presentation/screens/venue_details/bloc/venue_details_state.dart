part of 'venue_details_bloc.dart';

@freezed
class VenueDetailsState with _$VenueDetailsState {
  const VenueDetailsState._();

  const factory VenueDetailsState({
    required String venueId,
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

  int? get minPrice =>
      services.map((e) => e.price).nonNulls.fold<double?>(null, (a, b) => a == null ? b : min(a, b))?.toInt();

  int? get maxPrice =>
      services.map((e) => e.price).nonNulls.fold<double?>(null, (a, b) => a == null ? b : max(a, b))?.toInt();

  Duration? get minDuration =>
      services.map((e) => e.duration).nonNulls.fold<Duration?>(null, (a, b) => a == null || a > b ? b : a);

  Duration? get maxDuration =>
      services.map((e) => e.duration).nonNulls.fold<Duration?>(null, (a, b) => a == null || a < b ? b : a);
}
