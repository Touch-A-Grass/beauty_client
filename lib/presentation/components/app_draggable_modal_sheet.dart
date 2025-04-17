import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AppDraggableModalSheet extends StatefulWidget {
  static const double closeExtent = 0.25;

  final ScrollableWidgetBuilder builder;
  final DraggableScrollableController? controller;
  final double size;

  const AppDraggableModalSheet({super.key, required this.builder, this.controller, this.size = 1});

  @override
  State<AppDraggableModalSheet> createState() => _AppDraggableModalSheetState();
}

class _AppDraggableModalSheetState extends State<AppDraggableModalSheet> {
  bool isClosed = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (!isClosed && notification.extent <= AppDraggableModalSheet.closeExtent) {
          isClosed = true;
          context.maybePop();
        }
        return false;
      },
      child: DraggableScrollableSheet(
        controller: widget.controller,
        snap: true,
        initialChildSize: widget.size,
        minChildSize: 0,
        shouldCloseOnMinExtent: false,
        maxChildSize: widget.size,
        snapSizes: [widget.size],
        builder: widget.builder,
      ),
    );
  }
}
