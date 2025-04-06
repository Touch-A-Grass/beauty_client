import 'package:beauty_client/domain/models/app_error.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/staff_time_slot.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/order_repository.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_bloc.freezed.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final VenueRepository _venueRepository;
  final OrderRepository _orderRepository;

  CartBloc(
    this._venueRepository,
    this._orderRepository, {
    required String venueId,
    Venue? venue,
    List<Service>? services,
    String? selectedServiceId,
    String? selectedStaffId,
    List<Staff>? staffs,
  }) : super(CartState(venue: venue, services: services, staffs: staffs)) {
    on<_Started>((event, emit) {
      add(CartEvent.updateSelectedServiceRequested());
      add(CartEvent.venueRequested());
      add(CartEvent.servicesRequested());
      add(CartEvent.staffsRequested());
    });
    on<_ServicesRequested>((event, emit) async {
      try {
        final services = await _venueRepository.getServices(venueId);
        emit(state.copyWith(services: services));
        add(CartEvent.updateSelectedServiceRequested());
      } catch (_) {}
    });
    on<_StaffsRequested>((event, emit) async {
      try {
        final staffs = await _venueRepository.getStaff(venueId);
        emit(state.copyWith(staffs: staffs));
        add(CartEvent.updateSelectedStaffRequested());
      } catch (_) {}
    });
    on<_VenueRequested>((event, emit) async {
      try {
        final venue = await _venueRepository.getVenue(venueId);
        emit(state.copyWith(venue: venue));
      } catch (_) {}
    });
    on<_ServiceSelected>((event, emit) {
      final staff = (state.selectedStaff?.services.contains(event.service.id) ?? false) ? state.selectedStaff : null;

      if (staff?.id != state.selectedStaff?.id || event.service.id != state.selectedService?.id) {
        add(const CartEvent.staffTimeSlotsRequested());
      }

      emit(state.copyWith(selectedService: event.service, selectedStaff: staff));
    });
    on<_StaffSelected>((event, emit) async {
      final service = event.staff.services.contains(state.selectedService?.id) ? state.selectedService : null;

      if (event.staff.id != state.selectedStaff?.id || service?.id != state.selectedService?.id) {
        add(const CartEvent.staffTimeSlotsRequested());
      }

      emit(state.copyWith(selectedStaff: event.staff, selectedService: service));
    });
    on<_StaffTimeSlotsRequested>((event, emit) async {
      final staff = state.selectedStaff;

      if (staff == null || state.selectedService == null) {
        emit(state.copyWith(timeSlotsState: const CartTimeSlotsState.empty(), date: null));
        return;
      }

      emit(state.copyWith(timeSlotsState: const CartTimeSlotsState.loading(), date: null));
      try {
        final timeSlots = await _venueRepository.getVenueStaffTimeSlots(staffId: staff.id, venueId: venueId);
        emit(state.copyWith(timeSlotsState: CartTimeSlotsState.loaded(timeSlots: timeSlots)));
      } catch (e) {
        emit(state.copyWith(timeSlotsState: CartTimeSlotsState.error(error: AppError(message: e.toString()))));
      }
    });
    on<_UpdateSelectedStaffRequested>((event, emit) {
      final newStaff = state.staffs?.firstWhereOrNull((staff) => staff.id == selectedStaffId);
      if (newStaff != null) {
        emit(state.copyWith(selectedStaff: newStaff));
        add(const CartEvent.staffTimeSlotsRequested());
      }
    });
    on<_UpdateSelectedServiceRequested>((event, emit) {
      final newService = state.services?.firstWhereOrNull((service) => service.id == selectedServiceId);
      if (newService != null) emit(state.copyWith(selectedService: newService));
    });
    on<_CommentChanged>((event, emit) {
      emit(state.copyWith(comment: event.comment));
    });
    on<_DateChanged>((event, emit) {
      emit(state.copyWith(date: event.date));
    });
    on<_CreateRequested>((event, emit) async {
      emit(state.copyWith(isCreatingOrder: true));
      try {
        await _orderRepository.createOrder(
          venue: state.venue!,
          service: state.selectedService!,
          staff: state.selectedStaff!,
          startDate: state.date!,
          comment: state.comment.trim(),
        );
        emit(state.copyWith(isCreatingOrder: false, isOrderCreated: true));
      } catch (e) {
        emit(state.copyWith(isCreatingOrder: false, orderCreatingError: AppError.fromObject(e)));
      }
    });
  }
}
