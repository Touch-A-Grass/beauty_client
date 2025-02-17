import 'package:beauty_client/domain/models/auth.dart';
import 'package:beauty_client/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Auth> login(String phone, String password) {
    throw UnimplementedError('Not implemented yet');
  }

  @override
  Future<Auth> register(String name, String phone, String password) {
    throw UnimplementedError('Not implemented yet');
  }
}
