import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/presentation/models/order_status.dart';
import 'package:beauty_client/presentation/util/price_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderListItem extends StatefulWidget {
  final Order order;
  final VoidCallback? onTap;

  const OrderListItem({super.key, required this.order, this.onTap});

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
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 8,
                  decoration: BoxDecoration(
                    color: widget.order.status.color(),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.order.service.name,
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (widget.order.service.price != null)
                              Center(
                                child: Text(
                                  widget.order.service.price!.toPriceFormat(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.person_rounded, size: 16),
                            Expanded(
                              child: Text(widget.order.staff.name, style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            Icon(Icons.location_pin, size: 16),
                            Expanded(
                              child: Text(widget.order.venue.name, style: Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            Expanded(
                              child: Text(
                                widget.order.status.statusName(context),
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                            Text(
                              dateFormatter.format(widget.order.startTimestamp.toLocal()),
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
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
    );
  }
}
