import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_overlay.dart';
import 'package:beauty_client/presentation/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppOverlay(
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context).profile)),
        body: Center(
          child: OutlinedButton(
            onPressed: () => context.read<ProfileBloc>().add(const ProfileEvent.logoutRequested()),
            child: Text(S.of(context).logoutButton),
          ),
        ),
      ),
    );
  }
}
