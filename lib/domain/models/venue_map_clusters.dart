import 'package:beauty_client/domain/models/venue.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_map_clusters.freezed.dart';
part 'venue_map_clusters.g.dart';

@freezed
class VenueCluster with _$VenueCluster {
  const factory VenueCluster({
    required double latitude,
    required double longitude,
    required int count,
    required List<String> venueIds,
  }) = _VenueCluster;

  factory VenueCluster.fromJson(Map<String, dynamic> json) => _$VenueClusterFromJson(json);
}

@freezed
class VenueMapClusters with _$VenueMapClusters {
  const factory VenueMapClusters({required List<VenueCluster> clusters, required List<Venue> venues}) =
      _VenueMapClusters;

  factory VenueMapClusters.fromJson(Map<String, dynamic> json) => _$VenueMapClustersFromJson(json);
}
