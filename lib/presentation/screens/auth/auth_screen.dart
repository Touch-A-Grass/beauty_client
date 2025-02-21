import 'package:auto_route/annotations.dart';
import 'package:beauty_client/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:beauty_client/presentation/screens/auth/widget/auth_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const AuthWidget(),
    );
  }
}
