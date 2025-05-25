part of 'cart_bloc.dart';

@freezed
class CartState with _$CartState {
  const CartState._();

  const factory CartState({
    Venue? venue,
    List<Service>? services,
    List<Staff>? staffs,
    Service? selectedService,
    Staff? selectedStaff,
    @Default('') String comment,
    DateTime? date,
    @Default(false) bool isCreatingOrder,
    @Default(false) bool isOrderCreated,
    AppError? orderCreatingError,
    Coupon? coupon,
    @Default(CartTimeSlotsState.empty()) CartTimeSlotsState timeSlotsState,
  }) = _CartState;

  int? get totalPrice {
    if (selectedService?.price == null) {
      return null;
    }

    var price = selectedService!.price!;

    price = switch (coupon?.discountType) {
      DiscountType.percentage => price - (price * (coupon!.discountValue / 100)),
      DiscountType.fixed => price - coupon!.discountValue,
      null => price,
    };

    return price.toInt();
  }
}

@freezed
sealed class CartTimeSlotsState with _$CartTimeSlotsState {
  const factory CartTimeSlotsState.empty() = CartTimeSlotsStateEmpty;

  const factory CartTimeSlotsState.loading() = CartTimeSlotsStateLoading;

  const factory CartTimeSlotsState.loaded({required List<StaffTimeSlot> timeSlots}) = CartTimeSlotsStateLoaded;

  const factory CartTimeSlotsState.error({required AppError error}) = CartTimeSlotsStateError;
}
