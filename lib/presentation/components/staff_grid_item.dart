import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/presentation/components/rating_card_view.dart';
import 'package:beauty_client/presentation/util/image_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StaffGridItem extends StatelessWidget {
  final Staff staff;
  final VoidCallback? onTap;
  final bool grayScaleImage;

  const StaffGridItem({super.key, required this.staff, this.onTap, this.grayScaleImage = false});

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
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        foregroundDecoration:
                            grayScaleImage
                                ? BoxDecoration(color: Colors.grey, backgroundBlendMode: BlendMode.saturation)
                                : null,
                        child: CircleAvatar(
                          foregroundImage:
                              staff.photo != null ? CachedNetworkImageProvider(ImageUtil.parse256(staff.photo!)) : null,
                          child: Text(
                            staff.initials,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(staff.name, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                if (staff.rating > 0) Align(alignment: Alignment.center, child: RatingStarView(rating: staff.rating)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
