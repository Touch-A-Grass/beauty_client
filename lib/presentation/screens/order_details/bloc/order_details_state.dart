part of 'order_details_bloc.dart';

@freezed
class OrderDetailsState with _$OrderDetailsState {
  const OrderDetailsState._();

  const factory OrderDetailsState({
    Order? order,
    @Default(true) bool isLoadingOrder,
    AppError? loadingOrderError,
    @Default(OrderDiscardingState.initial()) OrderDiscardingState discardingState,
  }) = _OrderDetailsState;

  bool get canDiscardOrder => order?.status == OrderStatus.pending && !isLoadingOrder;
}

@freezed
sealed class OrderDiscardingState with _$OrderDiscardingState {
  const factory OrderDiscardingState.initial() = InitialOrderDiscardingState;

  const factory OrderDiscardingState.loading() = LoadingOrderDiscardingState;

  const factory OrderDiscardingState.error(AppError error) = ErrorOrderDiscardingState;
}
