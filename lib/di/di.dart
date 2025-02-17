import 'package:beauty_client/data/api/dio_factory.dart';
import 'package:beauty_client/data/repositories/auth_repository.dart';
import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:beauty_client/domain/repositories/auth_repository.dart';
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
        //   Storages
        RepositoryProvider.value(value: authStorage),
        RepositoryProvider(create: (context) => DioFactory.create(context.read())),
        //   Repositories
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepositoryImpl()),
      ],
      child: child,
    );
  }
}
