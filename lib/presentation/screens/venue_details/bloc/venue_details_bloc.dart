import 'dart:math';

import 'package:beauty_client/domain/models/app_error.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_details_bloc.freezed.dart';
part 'venue_details_event.dart';
part 'venue_details_state.dart';

class VenueDetailsBloc extends Bloc<VenueDetailsEvent, VenueDetailsState> {
  final VenueRepository venueRepository;

  VenueDetailsBloc(
    this.venueRepository, {
    required String venueId,
    Venue? venue,
  }) : super(VenueDetailsState(venue: venue)) {
    on<_Started>((event, emit) async {
      add(const VenueDetailsEvent.servicesRequested());
      add(const VenueDetailsEvent.venuesRequested());
      add(const VenueDetailsEvent.staffRequested());
    });

    on<_StaffRequested>((event, emit) async {
      emit(state.copyWith(isLoadingStaff: true));
      try {
        final staff = await venueRepository.getStaff(venueId);
        emit(state.copyWith(staff: staff, isLoadingStaff: false));
      } catch (e) {
        emit(state.copyWith(
          staffLoadingError: AppError(message: e.toString()),
          isLoadingStaff: false,
        ));
      }
    });

    on<_ServicesRequested>((event, emit) async {
      emit(state.copyWith(isLoadingServices: true));
      try {
        final services = await venueRepository.getServices(venueId);
        emit(state.copyWith(services: services, isLoadingServices: false));
      } catch (e) {
        emit(state.copyWith(
          servicesLoadingError: AppError(message: e.toString()),
          isLoadingServices: false,
        ));
      }
    });

    on<_VenuesRequested>((event, emit) async {
      emit(state.copyWith(isLoadingVenue: true));
      try {
        final venue = await venueRepository.getVenue(venueId);
        emit(
          state.copyWith(
            venue: venue,
            isLoadingVenue: false,
          ),
        );
      } catch (e) {
        emit(state.copyWith(
          venueLoadingError: AppError(message: e.toString()),
          isLoadingVenue: false,
        ));
      }
    });
  }
}
