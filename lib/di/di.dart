import 'package:beauty_client/core/config.dart';
import 'package:beauty_client/data/api/beauty_client.dart';
import 'package:beauty_client/data/api/dio_factory.dart';
import 'package:beauty_client/data/api/interceptors/base_headers_interceptor.dart';
import 'package:beauty_client/data/event/order_changed_event_bus.dart';
import 'package:beauty_client/data/event/order_chat_unread_count_changed_event_bus.dart';
import 'package:beauty_client/data/event/order_created_event_bus.dart';
import 'package:beauty_client/data/repositories/auth_repository.dart';
import 'package:beauty_client/data/repositories/order_repository.dart';
import 'package:beauty_client/data/repositories/venue_repository.dart';
import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:beauty_client/data/storage/location_storage.dart';
import 'package:beauty_client/data/storage/user_storage.dart';
import 'package:beauty_client/data/websocket_api/websocket_api.dart';
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
  final UserStorage userStorage;
  final Widget child;

  const Di({super.key, required this.child, required this.authStorage, required this.userStorage});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        //   Storages
        RepositoryProvider.value(value: authStorage),
        RepositoryProvider.value(value: userStorage),
        RepositoryProvider(create: (context) => LocationStorage()),
        RepositoryProvider(create: (context) => BaseHeadersInterceptor()),
        RepositoryProvider(create: (context) => DioFactory.create(context.read(), context.read())),
        RepositoryProvider(create: (context) => BeautyClient(context.read(), baseUrl: Config.apiBaseUrl)),
        RepositoryProvider(create: (context) => WebsocketApi(context.read(), baseUrl: Config.websocketBaseUrl)),
        RepositoryProvider(create: (context) => OrderCreatedEventBus()),
        RepositoryProvider(create: (context) => OrderChangedEventBus()),
        RepositoryProvider(create: (context) => OrderChatUnreadCountChangedEventBus()),
        //   Repositories
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(context.read(), context.read(), context.read()),
        ),
        RepositoryProvider<VenueRepository>(create: (context) => VenueRepositoryImpl(context.read(), context.read())),
        RepositoryProvider<OrderRepository>(
          create:
              (context) =>
                  OrderRepositoryImpl(context.read(), context.read(), context.read(), context.read(), context.read()),
        ),
        //   Logic
        RepositoryProvider(create: (context) => LogoutUseCase(context.read())),
        ChangeNotifierProvider(create: (context) => NavigationStateUpdater(context.read())),
      ],
      child: child,
    );
  }
}
