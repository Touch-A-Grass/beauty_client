import 'dart:async';

import 'package:flutter/material.dart';

class AppRefreshIndicator extends StatefulWidget {
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final Widget child;

  const AppRefreshIndicator({super.key, required this.isRefreshing, required this.onRefresh, required this.child});

  @override
  State<AppRefreshIndicator> createState() => _AppRefreshIndicatorState();
}

class _AppRefreshIndicatorState extends State<AppRefreshIndicator> {
  var _completer = Completer();

  @override
  void didUpdateWidget(covariant AppRefreshIndicator oldWidget) {
    if (!_completer.isCompleted && !oldWidget.isRefreshing) {
      _completer.complete();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        widget.onRefresh();
        _completer = Completer();
        await _completer.future;
      },
      child: widget.child,
    );
  }
}
