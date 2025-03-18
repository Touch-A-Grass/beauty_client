import 'package:auto_route/annotations.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/presentation/screens/venue_details/bloc/venue_details_bloc.dart';
import 'package:beauty_client/presentation/screens/venue_details/widget/venue_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class VenueDetailsScreen extends StatelessWidget {
  final String venueId;
  final Venue? venue;

  const VenueDetailsScreen({
    super.key,
    @PathParam('venueId') required this.venueId,
    this.venue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          VenueDetailsBloc(context.read(), venueId: venueId, venue: venue)..add(const VenueDetailsEvent.started()),
      child: const VenueDetailsWidget(),
    );
  }
}
