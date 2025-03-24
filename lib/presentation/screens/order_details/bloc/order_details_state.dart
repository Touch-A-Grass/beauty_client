part of 'order_details_bloc.dart';

@freezed
class OrderDetailsState with _$OrderDetailsState {
  const factory OrderDetailsState.initial({
    Order? order,
    @Default(true) bool isLoadingOrder,
    AppError? loadingOrderError,
  }) = _Initial;
}
