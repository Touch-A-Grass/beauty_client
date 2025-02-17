import 'package:auto_route/annotations.dart';
import 'package:beauty_client/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:beauty_client/presentation/screens/auth/login/widget/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(context.read()),
      child: const LoginWidget(),
    );
  }
}
