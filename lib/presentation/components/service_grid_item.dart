import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/image_placeholder.dart';
import 'package:beauty_client/presentation/util/price_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ServiceGridItem extends StatelessWidget {
  final Service service;
  final VoidCallback? onTap;
  final bool grayScaleImage;

  const ServiceGridItem({super.key, required this.service, this.onTap, this.grayScaleImage = false});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    foregroundDecoration:
                        grayScaleImage
                            ? BoxDecoration(color: Colors.grey, backgroundBlendMode: BlendMode.saturation)
                            : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child:
                          service.photo != null
                              ? CachedNetworkImage(imageUrl: service.photo!, fit: BoxFit.cover)
                              : ImagePlaceholder(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, left: 4, right: 4, bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 4,
                    children: [
                      Text(
                        service.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(service.description),
                      Row(
                        spacing: 4,
                        children: [
                          if (service.price != null)
                            Expanded(
                              child: Text(
                                service.price!.toPriceFormat(),
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            )
                          else
                            Expanded(child: SizedBox()),
                          if (service.duration != null)
                            Text(
                              S.of(context).serviceTime(service.duration!.inMinutes),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                        ],
                      ),
                    ],
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
