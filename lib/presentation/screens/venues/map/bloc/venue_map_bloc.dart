import 'package:beauty_client/data/storage/location_storage.dart';
import 'package:beauty_client/domain/models/location.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';
import 'package:beauty_client/presentation/util/subscription_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_map_bloc.freezed.dart';
part 'venue_map_event.dart';
part 'venue_map_state.dart';

class VenueMapBloc extends Bloc<VenueMapEvent, VenueMapState> with SubscriptionBloc {
  final VenueRepository venueRepository;
  final LocationStorage locationStorage;

  VenueMapBloc(this.venueRepository, this.locationStorage) : super(const VenueMapState()) {
    on<_Started>((event, emit) async {
      try {
        final venues = await venueRepository.getVenues(
          location: state.location,
          limit: 50,
          offset: 0,
        );

        emit(state.copyWith(venues: venues));
      } catch (_) {}
    });

    on<_LocationChanged>((event, emit) async {
      final oldLocation = state.location;
      emit(state.copyWith(location: event.location));
      if (!(oldLocation?.isReal ?? false)) {
        add(const VenueMapEvent.started());
      }
    });

    subscribe(locationStorage.stream, (data) {
      add(VenueMapEvent.locationChanged(data));
    });
  }
}
