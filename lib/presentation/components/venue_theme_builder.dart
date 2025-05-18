import 'package:beauty_client/data/storage/venue_theme_storage.dart';
import 'package:beauty_client/presentation/util/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VenueThemeBuilder extends StatelessWidget {
  final String? venueId;
  final WidgetBuilder builder;

  const VenueThemeBuilder({super.key, required this.venueId, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<VenueThemeStorage>().stream.map((value) => value[venueId]),
      builder: (context, snapshot) {
        final config = snapshot.data;
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: config?.color,
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: config?.color.toMaterial().shade700,
              primaryContainer: config?.color.toMaterial().shade600,
            ),
          ),
          child: builder(context),
        );
      },
    );
  }
}
