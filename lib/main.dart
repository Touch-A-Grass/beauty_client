import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:beauty_client/di/di.dart';
import 'package:beauty_client/presentation/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  const secureStorage = FlutterSecureStorage(aOptions: androidOptions);

  final authStorage = AuthStorage(secureStorage: secureStorage);

  runApp(App(authStorage: authStorage));
}

class App extends StatefulWidget {
  final AuthStorage authStorage;

  const App({
    super.key,
    required this.authStorage,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return Di(
      authStorage: widget.authStorage,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: appRouter.config(),
      ),
    );
  }
}
