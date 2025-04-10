import 'dart:ui';

import 'package:beauty_client/presentation/components/app_overlay.dart';
import 'package:beauty_client/presentation/components/push_handler.dart';
import 'package:beauty_client/presentation/components/shimmer.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatelessWidget {
  final Widget child;

  const RootScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PushHandler(
      child: AppOverlay(
        child: Scaffold(
          body: Shimmer(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.loose(const Size(600, double.infinity)),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad},
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
