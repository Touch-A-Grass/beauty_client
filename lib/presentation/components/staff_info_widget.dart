import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/presentation/util/image_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StaffInfoWidget extends StatelessWidget {
  final Staff staff;
  final VoidCallback? onTap;

  const StaffInfoWidget({super.key, required this.staff, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox.square(
          dimension: 96,
          child: CircleAvatar(
            foregroundImage: staff.photo != null ? CachedNetworkImageProvider(ImageUtil.parse256(staff.photo!)) : null,
            child: Text(staff.initials),
          ),
        ),
        Expanded(child: Text(staff.name, style: Theme.of(context).textTheme.titleMedium)),
        if (onTap != null) IconButton(onPressed: onTap, icon: const Icon(Icons.edit)),
      ],
    );
  }
}
