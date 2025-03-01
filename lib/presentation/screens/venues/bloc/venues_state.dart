part of 'venues_bloc.dart';

@freezed
class VenuesState with _$VenuesState {
  const factory VenuesState({
    @Default(Paging()) Paging<Venue> venues,
  }) = _VenuesState;
}
