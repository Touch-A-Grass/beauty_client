part of 'cart_bloc.dart';

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.started() = _Started;

  const factory CartEvent.venueRequested() = _VenueRequested;

  const factory CartEvent.servicesRequested() = _ServicesRequested;

  const factory CartEvent.staffsRequested() = _StaffsRequested;

  const factory CartEvent.updateSelectedServiceRequested() = _UpdateSelectedServiceRequested;

  const factory CartEvent.staffTimeSlotsRequested() = _StaffTimeSlotsRequested;

  const factory CartEvent.updateSelectedStaffRequested() = _UpdateSelectedStaffRequested;

  const factory CartEvent.serviceSelected(Service service) = _ServiceSelected;

  const factory CartEvent.staffSelected(Staff staff) = _StaffSelected;

  const factory CartEvent.commentChanged(String comment) = _CommentChanged;

  const factory CartEvent.createRequested() = _CreateRequested;

  const factory CartEvent.dateChanged(DateTime? date) = _DateChanged;
}
