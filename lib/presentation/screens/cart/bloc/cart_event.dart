part of 'cart_bloc.dart';

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.started() = _Started;

  const factory CartEvent.venueRequested() = _VenueRequested;

  const factory CartEvent.servicesRequested() = _ServicesRequested;

  const factory CartEvent.updateSelectedServiceRequested() = _UpdateSelectedServiceRequested;

  const factory CartEvent.serviceSelected(Service service) = _ServiceSelected;
}
