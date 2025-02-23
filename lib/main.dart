import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:beauty_client/di/di.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/navigation/app_router.dart';
import 'package:beauty_client/presentation/navigation/guards/auth_guard.dart';
import 'package:beauty_client/presentation/navigation/navigation_state_updater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  const secureStorage = FlutterSecureStorage(aOptions: androidOptions);

  final authStorage = AuthStorage(secureStorage: secureStorage);
  await authStorage.init();

  runApp(Di(authStorage: authStorage, child: const App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter appRouter;

  @override
  void initState() {
    appRouter = AppRouter(authGuard: AuthGuard(context.read<NavigationStateUpdater>()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      routerConfig: appRouter.config(
        reevaluateListenable: context.read<NavigationStateUpdater>(),
      ),
    );
  }
}
