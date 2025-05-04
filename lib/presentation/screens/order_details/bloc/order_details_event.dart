part of 'order_details_bloc.dart';

@freezed
class OrderDetailsEvent with _$OrderDetailsEvent {
  const factory OrderDetailsEvent.started() = _Started;

  const factory OrderDetailsEvent.orderRequested() = _OrderRequested;

  const factory OrderDetailsEvent.rateOrderRequested(OrderReview review) = _RateOrderRequested;

  const factory OrderDetailsEvent.discardRequested() = _DiscardRequested;

  const factory OrderDetailsEvent.unreadCountChanged(int count) = _UnreadCountChanged;
}
