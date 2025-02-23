import 'package:beauty_client/domain/models/auth.dart';

abstract interface class AuthRepository {
  Future<void> sendPhone(String phone);

  Future<Auth> sendCode(String phone, String code);

  Stream<Auth?> watchAuth();

  Auth? getAuth();

  Future<void> logout();
}
