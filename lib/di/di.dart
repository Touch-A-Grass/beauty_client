import 'package:beauty_client/data/api/beauty_client.dart';
import 'package:beauty_client/data/api/dio_factory.dart';
import 'package:beauty_client/data/repositories/auth_repository.dart';
import 'package:beauty_client/data/repositories/order_repository.dart';
import 'package:beauty_client/data/repositories/venue_repository.dart';
import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:beauty_client/data/storage/location_storage.dart';
import 'package:beauty_client/domain/repositories/auth_repository.dart';
import 'package:beauty_client/domain/repositories/order_repository.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';
import 'package:beauty_client/domain/use_cases/logout_use_case.dart';
import 'package:beauty_client/presentation/navigation/navigation_state_updater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Di extends StatelessWidget {
  final AuthStorage authStorage;
  final Widget child;

  const Di({super.key, required this.child, required this.authStorage});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        //   Storages
        RepositoryProvider.value(value: authStorage),
        RepositoryProvider(create: (context) => LocationStorage()),
        RepositoryProvider(create: (context) => DioFactory.create(context.read())),
        RepositoryProvider(create: (context) => BeautyClient(context.read(), baseUrl: 'http://213.183.53.46:8228/api')),
        //   Repositories
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepositoryImpl(context.read(), context.read())),
        RepositoryProvider<VenueRepository>(create: (context) => VenueRepositoryImpl(context.read(), context.read())),
        RepositoryProvider<OrderRepository>(create: (context) => OrderRepositoryImpl(context.read())),
        //   Logic
        RepositoryProvider(create: (context) => LogoutUseCase(context.read())),
        ChangeNotifierProvider(create: (context) => NavigationStateUpdater(context.read())),
      ],
      child: child,
    );
  }
}
