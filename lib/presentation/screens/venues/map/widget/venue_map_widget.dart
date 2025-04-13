import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/data/storage/location_storage.dart';
import 'package:beauty_client/domain/models/location.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/screens/venues/map/bloc/venue_map_bloc.dart';
import 'package:beauty_client/presentation/screens/venues/widget/venue_list_item.dart';
import 'package:beauty_client/presentation/util/hex_color.dart';
import 'package:beauty_client/presentation/util/theme_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class VenueMapWidget extends StatefulWidget {
  const VenueMapWidget({super.key});

  @override
  State<VenueMapWidget> createState() => _VenueMapWidgetState();
}

class _VenueMapWidgetState extends State<VenueMapWidget> with TickerProviderStateMixin {
  final mapLoadingCompleter = Completer();

  final mapController = MapController();

  Venue? selectedVenue;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VenueMapBloc, VenueMapState>(
          listenWhen: (prev, curr) => prev.venues != curr.venues && curr.venues.isNotEmpty,
          listener: (context, state) async {
            await mapLoadingCompleter.future;
          },
        ),
        BlocListener<VenueMapBloc, VenueMapState>(
          listenWhen: (prev, curr) => !(prev.location?.isReal ?? false) && curr.location?.isReal == true,
          listener: (context, state) async {
            await mapLoadingCompleter.future;
            mapController.move(fromLocation(state.location!), 16);
          },
        ),
      ],
      child: BlocBuilder<VenueMapBloc, VenueMapState>(
        builder:
            (context, state) => Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: fromLocation(context.read<LocationStorage>().value),
                    onMapReady: () {
                      mapLoadingCompleter.complete();
                    },
                  ),
                  mapController: mapController,
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.flutter_map_example',
                      tileBuilder: context.isDark ? _darkModeTileBuilder : null,
                    ),
                    MarkerLayer(markers: buildMarkers(state.venues)),
                  ],
                ),
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
                ),
              ],
            ),
      ),
    );
  }

  List<Marker> buildMarkers(List<Venue> venues) =>
      venues
          .map(
            (venue) => Marker(
              point: fromLocation(venue.location),
              width: 64,
              height: 64,
              rotate: false,
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
