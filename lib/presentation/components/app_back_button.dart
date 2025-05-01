import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final ButtonStyle? style;

  const AppBackButton({super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      style: style,
      onPressed: () {
        if (!AutoRouter.of(context).canPop()) {
          AutoRouter.of(context).pushAndPopUntil(HomeRoute(), predicate: (route) => false);
        } else {
          context.maybePop();
        }
      },
    );
  }
}
