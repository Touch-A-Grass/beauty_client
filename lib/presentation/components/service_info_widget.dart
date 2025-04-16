import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/presentation/components/avatar.dart';
import 'package:beauty_client/presentation/util/image_util.dart';
import 'package:beauty_client/presentation/util/price_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ServiceInfoWidget extends StatelessWidget {
  final Service service;
  final VoidCallback? onTap;

  const ServiceInfoWidget({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoundedAvatar(
            image: service.photo != null ? CachedNetworkImageProvider(ImageUtil.parse256(service.photo!)) : null,
          ),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(service.name, style: Theme.of(context).textTheme.titleMedium),
                Text(service.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                const Spacer(),
                Row(
                  children: [
                    if (service.price != null)
                      Expanded(
                        child: Text(
                          service.price!.toPriceFormat(),
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      Expanded(child: SizedBox()),
                    if (service.duration != null)
                      Text('~${service.duration?.inMinutes} мин.', style: Theme.of(context).textTheme.labelLarge),
                  ],
                ),
              ],
            ),
          ),
          if (onTap != null) IconButton(onPressed: onTap, icon: const Icon(Icons.edit)),
        ],
      ),
    );
  }
}
