import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:flutter/material.dart';

extension OrderStatusUi on OrderStatus {
  String statusName(BuildContext context) => switch (this) {
    OrderStatus.discarded => S.of(context).orderStatusDiscarded,
    OrderStatus.pending => S.of(context).orderStatusPending,
    OrderStatus.approved => S.of(context).orderStatusApproved,
    OrderStatus.completed => S.of(context).orderStatusCompleted,
  };

  Color color() => switch (this) {
    OrderStatus.discarded => Colors.red,
    OrderStatus.pending => Colors.orange,
    OrderStatus.approved => Colors.green,
    OrderStatus.completed => Colors.blue,
  };
}
