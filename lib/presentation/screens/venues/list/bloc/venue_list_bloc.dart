import 'package:beauty_client/data/storage/location_storage.dart';
import 'package:beauty_client/domain/models/app_error.dart';
import 'package:beauty_client/domain/models/location.dart';
import 'package:beauty_client/domain/models/paging.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';
import 'package:beauty_client/presentation/util/subscription_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_list_bloc.freezed.dart';
part 'venue_list_event.dart';
part 'venue_list_state.dart';

class VenueListBloc extends Bloc<VenueListEvent, VenueListState> with SubscriptionBloc {
  final VenueRepository _venueRepository;
  final LocationStorage _locationStorage;

  VenueListBloc(this._venueRepository, this._locationStorage) : super(const VenueListState()) {
    on<_Started>((event, emit) async {
      add(const VenueListEvent.requested());
    });

    on<_Requested>((event, emit) async {
      emit(state.copyWith(isLoadingVenues: true));
      try {
        final venues = await _venueRepository.getVenues(
          location: state.location,
          offset: state.venues.offset(event.refresh),
          limit: 10,
        );
        emit(state.copyWith(venues: state.venues.next(venues, refresh: event.refresh), isLoadingVenues: false));
      } catch (e) {
        emit(state.copyWith(loadingError: AppError.fromObject(e), isLoadingVenues: false));
      }
    });

    on<_LocationChanged>((event, emit) {
      final prevLocation = state.location;
      emit(state.copyWith(location: event.location));
      if (!(prevLocation?.isReal ?? false)) {
        add(const VenueListEvent.requested(refresh: true));
      }
    });

    subscribe(_locationStorage.stream, (data) {
      add(VenueListEvent.locationChanged(location: data));
    });
  }
}
