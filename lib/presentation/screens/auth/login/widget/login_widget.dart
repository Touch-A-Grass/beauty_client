import 'package:beauty_client/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverSafeArea(
                bottom: false,
                sliver: SliverPadding(
                  padding: const EdgeInsets.only(top: 120, left: 16, right: 16),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        children: [
                          TextField(
                            enabled: state.canEdit,
                            controller: phoneController,
                            onChanged: (value) => context.read<LoginBloc>().add(LoginEvent.phoneChanged(value)),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: AppLocalizations.of(context).phone,
                              errorText: state.error,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            enabled: state.canEdit,
                            controller: passwordController,
                            onChanged: (value) => context.read<LoginBloc>().add(LoginEvent.passwordChanged(value)),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: AppLocalizations.of(context).password,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 240,
                            child: ElevatedButton(
                              onPressed: state.canRequestLogin
                                  ? () {
                                      context.read<LoginBloc>().add(const LoginEvent.loginRequested());
                                    }
                                  : null,
                              child: Text(AppLocalizations.of(context).loginButton),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 240,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(AppLocalizations.of(context).registerButton),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
