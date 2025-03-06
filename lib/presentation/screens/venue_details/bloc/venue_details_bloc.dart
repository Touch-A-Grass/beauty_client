import 'package:beauty_client/domain/models/app_error.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_details_bloc.freezed.dart';
part 'venue_details_event.dart';
part 'venue_details_state.dart';

class VenueDetailsBloc extends Bloc<VenueDetailsEvent, VenueDetailsState> {
  final VenueRepository venueRepository;

  VenueDetailsBloc(this.venueRepository, {required String venueId}) : super(const VenueDetailsState()) {
    on<_Started>((event, emit) async {
      emit(state.copyWith(isLoadingServices: true));
      try {
        final services = await venueRepository.getServices(venueId);
        emit(
          state.copyWith(
            services: services,
            isLoadingServices: false,
          ),
        );
      } catch (e) {
        emit(state.copyWith(
          servicesLoadingError: AppError(message: e.toString()),
          isLoadingServices: false,
        ));
      }
    });
  }
}
