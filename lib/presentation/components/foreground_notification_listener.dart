import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ForegroundNotificationListener extends StatefulWidget {
  final void Function(RemoteMessage message) onData;
  final Widget child;

  const ForegroundNotificationListener({super.key, required this.onData, required this.child});

  @override
  State<ForegroundNotificationListener> createState() => _ForegroundNotificationListenerState();
}

class _ForegroundNotificationListenerState extends State<ForegroundNotificationListener> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    _subscription = FirebaseMessaging.onMessage.listen(widget.onData);
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
