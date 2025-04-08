part of 'dashboard_bloc.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(LoadingState.progress()) LoadingState<User> userState,
    @Default(LoadingState.progress()) LoadingState<List<Venue>> venuesState,
    @Default(LoadingState.progress()) LoadingState<Order?> ordersState,
    Location? location,
  }) = _DashboardState;
}
