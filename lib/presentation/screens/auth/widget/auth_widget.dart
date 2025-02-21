import 'package:beauty_client/presentation/components/app_overlay.dart';
import 'package:beauty_client/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:beauty_client/presentation/screens/auth/screens/code/code_screen.dart';
import 'package:beauty_client/presentation/screens/auth/screens/phone/phone_screen.dart';
import 'package:beauty_client/presentation/screens/auth/screens/telegram/telegram_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: (context, state) {
        FocusScope.of(context).unfocus();

        pageController.animateToPage(
          switch (state) {
            AuthPhoneState() => 0,
            AuthCodeState() => 2,
            AuthTelegramState() => 1,
          },
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      },
      child: AppOverlay(
        child: Scaffold(
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              PhoneScreen(
                onPhoneEntered: (phone) =>
                    context.read<AuthBloc>().add(AuthEvent.phoneEntered(phone)),
              ),
              TelegramScreen(
                onConfirmed: () => context
                    .read<AuthBloc>()
                    .add(const AuthEvent.telegramConfirmed()),
              ),
              CodeScreen(
                backToPhonePressed: () => context
                    .read<AuthBloc>()
                    .add(const AuthEvent.changePhoneRequested()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
