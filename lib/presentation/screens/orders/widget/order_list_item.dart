import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/models/order_status.dart';
import 'package:beauty_client/presentation/util/price_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderListItem extends StatefulWidget {
  final Order order;

  const OrderListItem({super.key, required this.order});

  @override
  State<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends State<OrderListItem> {
  final dateFormatter = DateFormat('dd MMMM HH:mm');

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
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Text(
                        widget.order.service.name,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (widget.order.service.price != null)
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Text(
                            widget.order.service.price!.toPriceFormat(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  widget.order.service.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                Text(S.of(context).orderMaster(widget.order.staff.name), style: Theme.of(context).textTheme.bodyMedium),
                Text(S.of(context).orderVenue(widget.order.venue.name), style: Theme.of(context).textTheme.bodyMedium),
                if (widget.order.comment.isNotEmpty) Text(S.of(context).orderComment(widget.order.comment)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.order.status.statusName(context),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: widget.order.status.color()),
                    ),
                    Text(
                      dateFormatter.format(widget.order.startTimestamp),
                      style: Theme.of(context).textTheme.labelLarge,
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
