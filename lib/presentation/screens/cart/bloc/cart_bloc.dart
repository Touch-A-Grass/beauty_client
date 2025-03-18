import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_bloc.freezed.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final VenueRepository _venueRepository;

  CartBloc(
    this._venueRepository, {
    required String venueId,
    Venue? venue,
    List<Service> services = const [],
    String? selectedServiceId,
  }) : super(CartState(venue: venue, services: services)) {
    on<_Started>((event, emit) {
      add(CartEvent.updateSelectedServiceRequested());
      add(CartEvent.venueRequested());
      add(CartEvent.servicesRequested());
    });
    on<_ServicesRequested>((event, emit) async {
      try {
        final services = await _venueRepository.getServices(venueId);
        emit(state.copyWith(services: services));
        add(CartEvent.updateSelectedServiceRequested());
      } catch (_) {}
    });
    on<_VenueRequested>((event, emit) async {
      try {
        final venue = await _venueRepository.getVenue(venueId);
        emit(state.copyWith(venue: venue));
      } catch (_) {}
    });
    on<_ServiceSelected>((event, emit) {
      emit(state.copyWith(selectedService: event.service));
    });
    on<_UpdateSelectedServiceRequested>((event, emit) {
      final newService = state.services?.firstWhereOrNull((service) => service.id == selectedServiceId);
      if (newService != null) emit(state.copyWith(selectedService: newService));
    });
  }
}
