import 'dart:convert';

import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:beauty_client/data/storage/user_storage.dart';
import 'package:beauty_client/di/di.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/location_listener.dart';
import 'package:beauty_client/presentation/navigation/app_router.dart';
import 'package:beauty_client/presentation/navigation/guards/auth_guard.dart';
import 'package:beauty_client/presentation/navigation/navigation_state_updater.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_theme/json_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  const secureStorage = FlutterSecureStorage(aOptions: androidOptions);

  final authStorage = AuthStorage(secureStorage: secureStorage);
  await authStorage.init();

  final userStorage = UserStorage(secureStorage: secureStorage);
  await userStorage.init();

  runApp(
    Di(
      userStorage: userStorage,
      authStorage: authStorage,
      child: App(
        lightTheme: await decodeTheme('assets/appainter_theme.json'),
        darkTheme: await decodeTheme('assets/appainter_theme_dark.json'),
      ),
    ),
  );
}

Future<ThemeData?> decodeTheme(String assetPath) async {
  final themeStr = await rootBundle.loadString(assetPath);
  final themeJson = jsonDecode(themeStr);
  return ThemeDecoder.decodeThemeData(themeJson);
}

class App extends StatefulWidget {
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  const App({super.key, required this.lightTheme, required this.darkTheme});

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
        theme: applyTheme(widget.lightTheme),
        darkTheme: applyTheme(widget.darkTheme),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [S.delegate, ...GlobalMaterialLocalizations.delegates],
        supportedLocales: S.delegate.supportedLocales,
        routerConfig: appRouter.config(reevaluateListenable: context.read<NavigationStateUpdater>()),
      ),
    );
  }

  ThemeData? applyTheme(ThemeData? theme) {
    return theme?.copyWith(
      timePickerTheme: theme.timePickerTheme.copyWith(hourMinuteTextStyle: theme.textTheme.displaySmall),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: theme.textTheme.titleMedium,
        backgroundColor: theme.colorScheme.surfaceContainer,
        scrolledUnderElevation: 1,
        elevation: 1,
      ),
    );
  }
}
