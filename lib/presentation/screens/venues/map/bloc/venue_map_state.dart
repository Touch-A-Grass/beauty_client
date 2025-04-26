part of 'venue_map_bloc.dart';

@freezed
class VenueMapState with _$VenueMapState {
  const VenueMapState._();

  const factory VenueMapState({
    @Default([]) List<Venue> venues,
    @Default([]) List<VenueCluster> cluster,
    @Default([]) List<VenueCluster> prevClusters,
    Location? location,
    MapInfo? mapInfo,
    @Default('') String searchQuery,
    @Default(Paging()) Paging<Venue> searchVenues,
  }) = _VenueMapState;

  bool get isSearching => searchQuery.isNotEmpty;
}

@freezed
class MapInfo with _$MapInfo {
  const factory MapInfo({
    required double minLatitude,
    required double maxLatitude,
    required double minLongitude,
    required double maxLongitude,
    required int zoom,
  }) = _MapInfo;
}
