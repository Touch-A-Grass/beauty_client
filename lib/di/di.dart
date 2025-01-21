import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Di extends StatelessWidget {
  final AuthStorage authStorage;
  final Widget child;

  const Di({
    super.key,
    required this.child,
    required this.authStorage,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authStorage),
      ],
      child: child,
    );
  }
}
