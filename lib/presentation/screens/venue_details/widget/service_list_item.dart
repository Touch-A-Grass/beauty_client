import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/util/price_utils.dart';
import 'package:flutter/material.dart';

class ServiceListItem extends StatelessWidget {
  final Service service;
  final VoidCallback? onTap;
  final bool showBorder;
  final bool isError;

  const ServiceListItem({super.key, required this.service, this.onTap, this.showBorder = true, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainer,
        border:
            showBorder
                ? Border.all(
                  color: isError ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.outline,
                )
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.name, style: Theme.of(context).textTheme.titleMedium),
                          Text(service.description, style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 4,
                      children: [
                        if (service.duration != null)
                          Text(
                            S.of(context).serviceTime(service.duration!.inMinutes),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        if (service.price != null) ...[
                          Text(service.price!.toPriceFormat(), style: Theme.of(context).textTheme.labelLarge),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceListItemPlaceholder extends StatelessWidget {
  final VoidCallback? onTap;

  const ServiceListItemPlaceholder({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border.all(color: Theme.of(context).colorScheme.error),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Text(S.of(context).cartSelectServiceButton, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ),
    );
  }
}
