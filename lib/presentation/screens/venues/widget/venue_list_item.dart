import 'package:beauty_client/domain/models/venue.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VenueListItem extends StatelessWidget {
  final Venue venue;
  final VoidCallback? onClick;

  const VenueListItem({super.key, required this.venue, this.onClick});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 128,
                    child: CachedNetworkImage(imageUrl: venue.theme.photo, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 10),
                Text(venue.name, style: Theme.of(context).textTheme.headlineSmall),
                if (venue.description.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(venue.description, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
