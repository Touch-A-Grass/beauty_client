part of 'cart_bloc.dart';

@freezed
class CartState with _$CartState {
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
    @Default(CartTimeSlotsState.empty()) CartTimeSlotsState timeSlotsState,
  }) = _CartState;
}

@freezed
sealed class CartTimeSlotsState with _$CartTimeSlotsState {
  const factory CartTimeSlotsState.empty() = CartTimeSlotsStateEmpty;

  const factory CartTimeSlotsState.loading() = CartTimeSlotsStateLoading;

  const factory CartTimeSlotsState.loaded({required List<StaffTimeSlot> timeSlots}) = CartTimeSlotsStateLoaded;

  const factory CartTimeSlotsState.error({required AppError error}) = CartTimeSlotsStateError;
}
