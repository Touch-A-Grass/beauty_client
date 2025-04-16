import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/presentation/models/order_status.dart';
import 'package:flutter/material.dart';

class OrderStatusView extends StatelessWidget {
  final OrderStatus orderStatus;

  const OrderStatusView({super.key, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Theme.of(context).colorScheme.shadow),
          ),
          child: Container(
            decoration: BoxDecoration(color: orderStatus.color(), shape: BoxShape.circle),
            height: 8,
            width: 8,
          ),
        ),
        Text(
          orderStatus.statusName(context),
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.tertiary),
        ),
      ],
    );
  }
}
