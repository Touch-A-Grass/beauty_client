import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/util/hex_color.dart';
import 'package:beauty_client/presentation/util/navigator_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VenueListItem extends StatelessWidget {
  final Venue venue;
  final VoidCallback? onClick;
  final bool shrinkDescription;
  final bool showLocationButton;

  const VenueListItem({
    super.key,
    required this.venue,
    this.onClick,
    this.shrinkDescription = false,
    this.showLocationButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          borderRadius: BorderRadius.circular(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: shrinkDescription ? 128 : 0),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(borderRadius: BorderRadius.circular(16), child: VenuePhotoFade(venue: venue)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              venue.name,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onInverseSurface),
                            ),
                            if (venue.description.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                venue.description,
                                maxLines: shrinkDescription ? 3 : null,
                                overflow: shrinkDescription ? TextOverflow.ellipsis : null,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onInverseSurface,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
                if (showLocationButton)
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: IconButton(
                      onPressed: () => NavigatorUtil.navigateToLocation(venue.location),
                      icon: const Icon(Icons.location_pin),
                      iconSize: 24,
                      padding: EdgeInsets.all(4),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onSurface),
                      ),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VenuePhotoFade extends StatelessWidget {
  final Venue venue;

  const VenuePhotoFade({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: SizedBox()),
            Expanded(child: CachedNetworkImage(imageUrl: venue.theme.photo, fit: BoxFit.cover)),
          ],
        ),
        Positioned.fill(
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback:
                (rect) => LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [venue.theme.color.toMaterial().shade800, Colors.transparent],
                  stops: [0.5, 1],
                ).createShader(rect),
            child: DecoratedBox(decoration: BoxDecoration(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}

class VenuePreview extends StatelessWidget {
  final Venue venue;
  final VoidCallback? onClick;

  const VenuePreview({super.key, required this.venue, this.onClick});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              onClick ??
              () {
                context.pushRoute(VenueDetailsRoute(venueId: venue.id));
              },
          borderRadius: BorderRadius.circular(8),
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
              const SizedBox(height: 8),
              Text(venue.name, style: Theme.of(context).textTheme.titleLarge),
              if (venue.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(venue.description, style: Theme.of(context).textTheme.labelMedium),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
