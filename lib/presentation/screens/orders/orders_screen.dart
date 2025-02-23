import 'package:auto_route/annotations.dart';
import 'package:beauty_client/presentation/components/app_overlay.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppOverlay(child: Scaffold(body: Center(child: Text('Orders Screen'))));
  }
}
