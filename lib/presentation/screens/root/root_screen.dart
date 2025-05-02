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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = ((constraints.maxWidth - 900) / 2).clamp(0.0, double.infinity);
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      padding: MediaQuery.of(context).padding + EdgeInsets.symmetric(horizontal: horizontalPadding),
                    ),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false,
                        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad},
                      ),
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
