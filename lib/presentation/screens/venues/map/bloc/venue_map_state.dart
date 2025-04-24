part of 'venue_map_bloc.dart';

@freezed
class VenueMapState with _$VenueMapState {
  const factory VenueMapState({
    @Default([]) List<Venue> venues,
    @Default([]) List<VenueCluster> cluster,
    @Default([]) List<VenueCluster> prevClusters,
    Location? location,
    MapInfo? mapInfo,
  }) = _VenueMapState;
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
