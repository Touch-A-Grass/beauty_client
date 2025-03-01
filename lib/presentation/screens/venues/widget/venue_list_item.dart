import 'package:beauty_client/domain/models/venue.dart';
import 'package:flutter/material.dart';

class VenueListItem extends StatelessWidget {
  final Venue venue;

  const VenueListItem({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 128,
              child: Image.network(venue.theme.photo, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Text(venue.name, style: Theme.of(context).textTheme.headlineSmall),
            if (venue.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(venue.description, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ],
        ),
      ),
    );
  }
}
