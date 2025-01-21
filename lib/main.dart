import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:beauty_client/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  const secureStorage = FlutterSecureStorage(aOptions: androidOptions);

  final authStorage = AuthStorage(secureStorage: secureStorage);

  runApp(MyApp(authStorage: authStorage));
}

class MyApp extends StatelessWidget {
  final AuthStorage authStorage;

  const MyApp({
    super.key,
    required this.authStorage,
  });

  @override
  Widget build(BuildContext context) {
    return Di(
      authStorage: authStorage,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SizedBox(),
      ),
    );
  }
}
