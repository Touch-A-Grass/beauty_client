import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessageListener extends StatefulWidget {
  final ValueChanged<RemoteMessage> onMessage;
  final Widget child;

  const MessageListener({super.key, required this.child, required this.onMessage});

  @override
  State<MessageListener> createState() => _MessageListenerState();
}

class _MessageListenerState extends State<MessageListener> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    _subscription = FirebaseMessaging.onMessage.listen((message) {
      widget.onMessage(message);
    });
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
