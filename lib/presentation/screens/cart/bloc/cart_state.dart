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
  }) = _CartState;
}
