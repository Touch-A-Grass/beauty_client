import 'package:beauty_client/domain/models/app_error.dart';
import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/paging.dart';
import 'package:beauty_client/domain/repositories/order_repository.dart';
import 'package:beauty_client/presentation/util/subscription_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'orders_bloc.freezed.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> with SubscriptionBloc {
  final OrderRepository _orderRepository;

  OrdersBloc(this._orderRepository) : super(const OrdersState()) {
    on<_Started>((event, emit) {
      add(OrdersEvent.ordersRequested());
    });
    on<_OrdersRequested>((event, emit) async {
      try {
        final orders = await _orderRepository.getOrders(limit: 10, offset: state.orders.offset(event.refresh));
        emit(state.copyWith(orders: state.orders.next(orders, refresh: event.refresh), isLoading: false));
      } catch (e) {
        emit(state.copyWith(loadingError: AppError.fromObject(e), isLoading: false));
      }
    });
    subscribe(_orderRepository.watchCreatedOrderEvent(), (_) {
      add(OrdersEvent.ordersRequested(refresh: true));
    });
  }
}
