import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size(600, double.infinity)),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
            child: AutoRouter(),
          ),
        ),
      ),
    );
  }
}
