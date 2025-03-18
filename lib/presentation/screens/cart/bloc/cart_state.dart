part of 'cart_bloc.dart';

@freezed
class CartState with _$CartState {
  const factory CartState({Venue? venue, List<Service>? services, Service? selectedService}) = _CartState;
}
