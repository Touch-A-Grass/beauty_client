part of 'venue_list_bloc.dart';

@freezed
class VenueListState with _$VenueListState {
  const factory VenueListState({
    @Default(Paging()) Paging<Venue> venues,
    AppError? loadingError,
    @Default(true) bool isLoadingVenues,
    Location? location,
  }) = _VenueListState;
}
