import 'package:beauty_client/domain/models/auth.dart';
import 'package:beauty_client/domain/models/user.dart';

abstract interface class AuthRepository {
  Future<void> sendPhone(String phone);

  Future<Auth> sendCode(String phone, String code);

  Stream<Auth?> watchAuth();

  Auth? getAuth();

  Future<void> logout();

  Future<User> getUser();

  Future<void> updateUser({required String name});

  Stream<User?> watchUser();

  Future<void> sendFirebaseToken(String token);
}
