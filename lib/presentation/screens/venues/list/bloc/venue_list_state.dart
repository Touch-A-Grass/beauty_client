part of 'venue_list_bloc.dart';

@freezed
class VenueListState with _$VenueListState {
  const factory VenueListState({
    @Default(Paging()) Paging<Venue> venues,
    AppError? loadingError,
    @Default(false) bool isLoadingVenues,
    Location? location,
  }) = _VenueListState;
}
