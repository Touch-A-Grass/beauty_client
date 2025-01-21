import 'package:beauty_client/domain/models/auth.dart';

abstract interface class AuthRepository {
  Future<Auth> login(String phone, String password);

  Future<Auth> register(String name, String phone, String password);
}
