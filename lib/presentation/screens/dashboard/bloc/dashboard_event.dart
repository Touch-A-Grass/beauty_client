part of 'dashboard_bloc.dart';

@freezed
class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.started() = _Started;

  const factory DashboardEvent.userRequested() = _UserRequested;

  const factory DashboardEvent.ordersRequested() = _OrdersRequested;

  const factory DashboardEvent.venuesRequested() = _VenuesRequested;

  const factory DashboardEvent.userChanged(User user) = _UserChanged;


  const factory DashboardEvent.locationChanged({required Location location}) = _LocationChanged;
}
