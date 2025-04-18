import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:beauty_client/data/storage/user_storage.dart';
import 'package:beauty_client/di/di.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/location_listener.dart';
import 'package:beauty_client/presentation/navigation/app_router.dart';
import 'package:beauty_client/presentation/navigation/guards/auth_guard.dart';
import 'package:beauty_client/presentation/navigation/navigation_state_updater.dart';
import 'package:beauty_client/presentation/screens/root/root_screen.dart';
import 'package:beauty_client/presentation/theme/colors.dart';
import 'package:beauty_client/presentation/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  const secureStorage = FlutterSecureStorage(aOptions: androidOptions);

  final authStorage = AuthStorage(secureStorage: secureStorage);
  await authStorage.init();

  final userStorage = UserStorage(secureStorage: secureStorage);
  await userStorage.init();

  runApp(Di(userStorage: userStorage, authStorage: authStorage, child: const App()));
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
    return LocationListener(
      child: MaterialApp.router(
        theme: AppTheme.theme(AppColorScheme.light()),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [S.delegate, ...GlobalMaterialLocalizations.delegates],
        supportedLocales: S.delegate.supportedLocales,
        routerConfig: appRouter.config(reevaluateListenable: context.read<NavigationStateUpdater>()),
        builder: (context, child) => RootScreen(child: child ?? SizedBox.shrink()),
      ),
    );
  }
}
