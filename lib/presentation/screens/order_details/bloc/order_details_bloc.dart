import 'package:beauty_client/domain/models/app_error.dart';
import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/order_review.dart';
import 'package:beauty_client/domain/repositories/order_repository.dart';
import 'package:beauty_client/presentation/util/subscription_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_details_bloc.freezed.dart';
part 'order_details_event.dart';
part 'order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> with SubscriptionBloc {
  final OrderRepository _orderRepository;

  OrderDetailsBloc(this._orderRepository, {required String orderId}) : super(const OrderDetailsState()) {
    on<_Started>((event, emit) {
      add(OrderDetailsEvent.orderRequested());
    });
    on<_OrderRequested>((event, emit) async {
      emit(state.copyWith(isLoadingOrder: true));
      try {
        final order = await _orderRepository.getOrder(orderId);
        emit(state.copyWith(isLoadingOrder: false, order: order));
      } catch (e) {
        emit(state.copyWith(isLoadingOrder: false, loadingOrderError: AppError.fromObject(e)));
      }
    });
    on<_RateOrderRequested>((event, emit) async {
      emit(state.copyWith(ratingState: const OrderRatingState.loading()));
      try {
        await _orderRepository.rateOrder(orderId, event.review);
        add(OrderDetailsEvent.orderRequested());
      } catch (e) {
        emit(state.copyWith(ratingState: OrderRatingState.error(AppError.fromObject(e))));
      }
    });
    on<_DiscardRequested>((event, emit) async {
      emit(state.copyWith(discardingState: const OrderDiscardingState.loading()));
      try {
        await _orderRepository.discardOrder(orderId);
        add(OrderDetailsEvent.orderRequested());
      } catch (e) {
        emit(state.copyWith(discardingState: OrderDiscardingState.error(AppError.fromObject(e))));
      }
    });
    on<_UnreadCountChanged>((event, emit) {
      emit(state.copyWith(order: state.order?.copyWith(unreadMessageCount: event.count)));
    });

    subscribe(
      _orderRepository.watchOrderChatUnreadCount(orderId),
      (count) => add(OrderDetailsEvent.unreadCountChanged(count)),
    );
  }
}
