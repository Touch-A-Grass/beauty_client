import 'dart:async';

import 'package:beauty_client/data/storage/location_storage.dart';
import 'package:beauty_client/domain/models/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class LocationListener extends StatefulWidget {
  final Widget child;

  const LocationListener({super.key, required this.child});

  @override
  State<LocationListener> createState() => _LocationListenerState();
}

class _LocationListenerState extends State<LocationListener> {
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    start(context);
  }

  Future<void> start(BuildContext context) async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      subscription = Geolocator.getPositionStream().listen((position) {
        if (context.mounted) {
          context.read<LocationStorage>().update(
            Location(
              latitude: position.latitude,
              longitude: position.longitude,
              altitude: position.altitude,
              heading: position.heading,
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
