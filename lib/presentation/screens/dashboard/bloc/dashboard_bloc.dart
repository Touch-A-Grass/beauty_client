import 'package:beauty_client/data/storage/location_storage.dart';
import 'package:beauty_client/domain/models/app_error.dart';
import 'package:beauty_client/domain/models/location.dart';
import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/user.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/auth_repository.dart';
import 'package:beauty_client/domain/repositories/order_repository.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';
import 'package:beauty_client/presentation/models/loading_state.dart';
import 'package:beauty_client/presentation/util/subscription_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_bloc.freezed.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> with SubscriptionBloc {
  final AuthRepository _authRepository;
  final OrderRepository _orderRepository;
  final VenueRepository _venueRepository;
  final LocationStorage _locationStorage;

  DashboardBloc(this._authRepository, this._orderRepository, this._venueRepository, this._locationStorage)
    : super(DashboardState()) {
    on<_Started>((event, emit) {
      add(const DashboardEvent.userRequested());
      add(const DashboardEvent.ordersRequested());
      add(const DashboardEvent.venuesRequested());
    });

    on<_UserChanged>((event, emit) {
      emit(state.copyWith(userState: LoadingState.success(event.user)));
    });

    on<_UserRequested>((event, emit) async {
      try {
        await _authRepository.getUser();
      } catch (_) {}
    });

    on<_OrdersRequested>((event, emit) async {
      try {
        final order = (await _orderRepository.getOrders(limit: 1, offset: 0)).firstOrNull;
        emit(state.copyWith(ordersState: LoadingState.success(order)));
      } catch (e) {
        emit(state.copyWith(ordersState: LoadingState.error(AppError.fromObject(e))));
      }
    });

    on<_VenuesRequested>((event, emit) async {
      try {
        final venues = await _venueRepository.getVenues(limit: 3, offset: 0, location: state.location);
        emit(state.copyWith(venuesState: LoadingState.success(venues)));
      } catch (e) {
        emit(state.copyWith(venuesState: LoadingState.error(AppError.fromObject(e))));
      }
    });

    subscribe(_authRepository.watchUser(), (user) {
      if (user != null) {
        add(DashboardEvent.userChanged(user));
      }
    });

    on<_LocationChanged>((event, emit) {
      final prevLocation = state.location;
      emit(state.copyWith(location: event.location));
      if (!(prevLocation?.isReal ?? false)) {
        add(const DashboardEvent.venuesRequested());
      }
    });

    subscribe(_orderRepository.watchOrderCreated(), (order) {
      add(DashboardEvent.ordersRequested());
    });

    subscribe(_orderRepository.watchOrderChanged(), (order) {
      add(DashboardEvent.ordersRequested());
    });

    subscribe(_locationStorage.stream, (data) {
      add(DashboardEvent.locationChanged(location: data));
    });
  }
}
