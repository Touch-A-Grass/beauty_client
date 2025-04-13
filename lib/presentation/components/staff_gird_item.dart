import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/presentation/components/image_placeholder.dart';
import 'package:beauty_client/presentation/util/image_util.dart';
import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:flutter/material.dart';

class StaffGirdItem extends StatelessWidget {
  final Staff staff;
  final VoidCallback? onTap;

  const StaffGirdItem({super.key, required this.staff, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipOval(
                    child:
                        staff.photo != null
                            ? CachedNetworkImage(imageUrl: ImageUtil.parse256(staff.photo!), fit: BoxFit.cover)
                            : ImagePlaceholder(),
                  ),
                ),
              ),
            ),
            Text(staff.name, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
