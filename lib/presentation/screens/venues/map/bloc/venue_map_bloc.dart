import 'package:beauty_client/data/storage/location_storage.dart';
import 'package:beauty_client/domain/models/location.dart';
import 'package:beauty_client/domain/models/paging.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/models/venue_map_clusters.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';
import 'package:beauty_client/presentation/util/subscription_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'venue_map_bloc.freezed.dart';
part 'venue_map_event.dart';
part 'venue_map_state.dart';

class VenueMapBloc extends Bloc<VenueMapEvent, VenueMapState> with SubscriptionBloc {
  final VenueRepository venueRepository;
  final LocationStorage locationStorage;

  VenueMapBloc(this.venueRepository, this.locationStorage) : super(const VenueMapState()) {
    on<_Started>((event, emit) {});

    on<_LocationChanged>((event, emit) async {
      final oldLocation = state.location;
      emit(state.copyWith(location: event.location));
      if (!(oldLocation?.isReal ?? false)) {
        add(const VenueMapEvent.started());
      }
    });

    on<_VenuesSearchRequested>((event, emit) async {
      try {
        final venues = await venueRepository.getVenues(
          location: state.location,
          offset: state.searchVenues.offset(event.refresh),
          limit: 10,
          searchQuery: state.searchQuery,
        );
        emit(state.copyWith(searchVenues: state.searchVenues.next(venues, refresh: event.refresh)));
      } catch (_) {}
    }, transformer: (events, mapper) => events.debounceTime(Duration(milliseconds: 250)).asyncExpand(mapper));

    on<_VenuesRequested>((event, emit) async {
      if (state.isSearching) return;
      final mapInfo = state.mapInfo;
      if (mapInfo == null) return;
      final venueClusters = await venueRepository.getClusters(
        minLatitude: mapInfo.minLatitude,
        maxLatitude: mapInfo.maxLatitude,
        minLongitude: mapInfo.minLongitude,
        maxLongitude: mapInfo.maxLongitude,
        zoom: mapInfo.zoom,
      );
      emit(state.copyWith(venues: venueClusters.venues, cluster: venueClusters.clusters, prevClusters: state.cluster));
    }, transformer: (events, mapper) => events.debounceTime(Duration(milliseconds: 100)).asyncExpand(mapper));

    on<_MapLocationChanged>((event, emit) async {
      emit(
        state.copyWith(
          mapInfo: MapInfo(
            minLatitude: event.minLatitude,
            maxLatitude: event.maxLatitude,
            minLongitude: event.minLongitude,
            maxLongitude: event.maxLongitude,
            zoom: event.zoom,
          ),
        ),
      );
      add(VenueMapEvent.venuesRequested());
    });

    on<_SearchQueryChanged>((event, emit) {
      emit(state.copyWith(searchQuery: event.searchQuery));
      if (!state.isSearching) {
        add(VenueMapEvent.venuesRequested());
      } else {
        add(VenueMapEvent.venuesSearchRequested(refresh: true));
      }
    });

    subscribe(locationStorage.stream, (data) {
      add(VenueMapEvent.locationChanged(data));
    });
  }
}
