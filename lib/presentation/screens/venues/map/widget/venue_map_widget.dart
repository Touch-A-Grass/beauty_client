import 'dart:async';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/data/storage/location_storage.dart';
import 'package:beauty_client/domain/models/location.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/models/venue_map_clusters.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/screens/venues/map/bloc/venue_map_bloc.dart';
import 'package:beauty_client/presentation/screens/venues/widget/venue_list_item.dart';
import 'package:beauty_client/presentation/screens/venues/widget/venues_widget.dart';
import 'package:beauty_client/presentation/util/hex_color.dart';
import 'package:beauty_client/presentation/util/theme_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

class VenueMapWidget extends StatefulWidget {
  const VenueMapWidget({super.key});

  @override
  State<VenueMapWidget> createState() => _VenueMapWidgetState();
}

class _VenueMapWidgetState extends State<VenueMapWidget> with TickerProviderStateMixin {
  final mapLoadingCompleter = Completer();

  final mapController = MapController();

  late final AnimationController mapAnimationController;
  late final Animation<double> mapAnimation;

  late final Ticker ticker;

  final ValueNotifier<LatLng?> userLocation = ValueNotifier(null);

  Venue? selectedVenue;

  late final VenuesSearchController venuesSearchController;

  final pageController = PageController(viewportFraction: 0.9);

  _listenSearch() {
    context.read<VenueMapBloc>().add(VenueMapEvent.searchQueryChanged(venuesSearchController.text));
  }

  @override
  void initState() {
    venuesSearchController = context.read<VenuesSearchController>();
    _listenSearch();
    venuesSearchController.addListener(_listenSearch);
    mapAnimationController = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    mapAnimation = CurvedAnimation(parent: mapAnimationController, curve: Curves.decelerate);
    final bloc = context.read<VenueMapBloc>();
    double prevTick = 0;
    ticker = Ticker((elapsed) {
      if (bloc.state.location == null) return;
      final t = ((elapsed.inMilliseconds.toDouble() - prevTick) / 250.0).clamp(0.0, 1.0);
      prevTick = elapsed.inMilliseconds.toDouble();
      if (userLocation.value == null) {
        userLocation.value = fromLocation(bloc.state.location!);
      } else {
        userLocation.value = LatLng(
          lerpDouble(userLocation.value!.latitude, bloc.state.location!.latitude, t)!,
          lerpDouble(userLocation.value!.longitude, bloc.state.location!.longitude, t)!,
        );
      }
    });
    ticker.start();

    mapController.mapEventStream.listen((data) {
      final context = this.context;
      if (context.mounted && data is MapEventWithMove) {
        final bounds = data.camera.visibleBounds;
        context.read<VenueMapBloc>().add(
          VenueMapEvent.mapLocationChanged(
            minLongitude: bounds.west,
            maxLongitude: bounds.east,
            minLatitude: bounds.south,
            maxLatitude: bounds.north,
            zoom: data.camera.zoom.round(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    ticker.dispose();
    venuesSearchController.removeListener(_listenSearch);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VenueMapBloc, VenueMapState>(
          listenWhen: (prev, curr) => prev.cluster != curr.cluster,
          listener: (context, state) async {
            mapAnimationController.forward(from: 0);
          },
        ),
        BlocListener<VenueMapBloc, VenueMapState>(
          listenWhen: (prev, curr) => !(prev.location?.isReal ?? false) && curr.location?.isReal == true,
          listener: (context, state) async {
            await mapLoadingCompleter.future;
            mapController.move(fromLocation(state.location!), 14);
          },
        ),
        BlocListener<VenueMapBloc, VenueMapState>(
          listenWhen:
              (prev, curr) =>
                  curr.searchVenues.data.isNotEmpty &&
                  curr.searchVenues.data.first != prev.searchVenues.data.firstOrNull,
          listener: (context, state) async {
            await mapLoadingCompleter.future;
            _animatedMapMove(fromLocation(state.searchVenues.data.first.location), 14);
          },
        ),
      ],
      child: BlocBuilder<VenueMapBloc, VenueMapState>(
        builder:
            (context, state) => Stack(
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge([userLocation, mapAnimation]),
                  builder:
                      (context, _) => FlutterMap(
                        options: MapOptions(
                          minZoom: 0,
                          initialCenter: fromLocation(context.read<LocationStorage>().value),
                          onMapReady: () {
                            if (!mapLoadingCompleter.isCompleted) {
                              mapLoadingCompleter.complete();
                            }
                          },
                        ),
                        mapController: mapController,
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.flutter_map_example',
                            tileProvider: CancellableNetworkTileProvider(),
                            tileBuilder: context.isDark ? _darkModeTileBuilder : null,
                          ),
                          if (userLocation.value != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  rotate: true,
                                  point: userLocation.value!,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).colorScheme.primary,
                                      border: Border.all(color: Theme.of(context).colorScheme.onPrimary, width: 4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (!state.isSearching) MarkerLayer(markers: buildClusterMarkers(state.cluster)),
                          if (!state.isSearching)
                            MarkerLayer(
                              markers: buildMarkers(state.venues, {
                                for (var venue in state.venues)
                                  venue.id: state.prevClusters.firstWhereOrNull((e) => e.venueIds.contains(venue.id)),
                              }),
                            )
                          else
                            MarkerLayer(markers: buildMarkers(state.searchVenues.data, {})),
                        ],
                      ),
                ),
                if (state.location != null)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () => _animatedMapMove(fromLocation(state.location!), 14),
                      icon: const Icon(Icons.my_location, size: 28),
                    ),
                  ),
                if (!state.isSearching)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    left: 16,
                    child: Padding(
                      padding: MediaQuery.of(context).padding,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child:
                            selectedVenue == null
                                ? const SizedBox.shrink()
                                : VenueListItem(
                                  venue: selectedVenue!,
                                  onClick: () {
                                    final venue = selectedVenue!;
                                    context.pushRoute(VenueDetailsRoute(venueId: venue.id, venue: venue));
                                  },
                                ),
                      ),
                    ),
                  )
                else if (state.searchVenues.data.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: MediaQuery.of(context).padding,
                      child: SizedBox(
                        height: 200,
                        child: PageView.builder(
                          controller: pageController,
                          onPageChanged: (index) {
                            _animatedMapMove(fromLocation(state.searchVenues.data[index].location), 14);
                          },
                          padEnds: false,
                          pageSnapping: true,
                          itemBuilder:
                              (context, index) => Padding(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: VenueListItem(venue: state.searchVenues.data[index]),
                              ),
                          itemCount: state.searchVenues.data.length,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      ),
    );
  }

  List<Marker> buildClusterMarkers(List<VenueCluster> clusters) =>
      clusters
          .map(
            (cluster) => Marker(
              point: fromLocation(Location(latitude: cluster.latitude, longitude: cluster.longitude)),
              width: 64,
              height: 64,
              rotate: true,
              child: GestureDetector(
                onTap: () {
                  _animatedMapMove(
                    fromLocation(Location(latitude: cluster.latitude, longitude: cluster.longitude)),
                    14,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Center(
                    child: Text(
                      cluster.count.toString(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList();

  List<Marker> buildMarkers(List<Venue> venues, Map<String, VenueCluster?> clustersMap) =>
      venues
          .map(
            (venue) => Marker(
              point:
                  clustersMap[venue.id] == null
                      ? fromLocation(venue.location)
                      : LatLng(
                        lerpDouble(clustersMap[venue.id]!.latitude, venue.location.latitude, mapAnimation.value)!,
                        lerpDouble(clustersMap[venue.id]!.longitude, venue.location.longitude, mapAnimation.value)!,
                      ),
              width: 64,
              height: 64,
              rotate: true,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedVenue == venue ? venue.theme.color.toMaterial().shade300 : venue.theme.color,
                    width: 4,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    if (selectedVenue == venue) {
                      setState(() {
                        selectedVenue = null;
                      });
                      return;
                    }
                    _animatedMapMove(fromLocation(venue.location), mapController.camera.zoom);
                    setState(() {
                      selectedVenue = venue;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(64),
                    child: CachedNetworkImage(imageUrl: venue.theme.photo, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          )
          .toList();

  Widget _darkModeTileBuilder(BuildContext context, Widget tileWidget, TileImage tile) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        -0.2126, -0.7152, -0.0722, 0, 255, // Red channel
        -0.2126, -0.7152, -0.0722, 0, 255, // Green channel
        -0.2126, -0.7152, -0.0722, 0, 255, // Blue channel
        0, 0, 0, 1, 0, // Alpha channel
      ]),
      child: tileWidget,
    );
  }

  LatLng fromLocation(Location location) => LatLng(location.latitude, location.longitude);

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(begin: mapController.camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(begin: mapController.camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.camera.zoom, end: destZoom);
    final controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
