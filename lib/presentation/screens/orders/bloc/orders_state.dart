part of 'orders_bloc.dart';

@freezed
class OrdersState with _$OrdersState {
  const factory OrdersState({
    @Default(Paging()) Paging<Order> orders,
    @Default(true) bool isLoading,
    AppError? loadingError,
  }) = _OrdersState;
}
