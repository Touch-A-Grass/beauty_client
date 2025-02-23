import 'package:beauty_client/data/api/beauty_client.dart';
import 'package:beauty_client/data/models/requests/send_code_request.dart';
import 'package:beauty_client/data/models/requests/send_phone_request.dart';
import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:beauty_client/domain/models/auth.dart';
import 'package:beauty_client/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BeautyClient _api;
  final AuthStorage authStorage;

  AuthRepositoryImpl(this._api, this.authStorage);

  @override
  Future<Auth> sendCode(String phone, String code) async {
    final auth = await _api.sendCode(SendCodeRequest(phoneNumber: phone, code: code));
    authStorage.update(auth);
    return auth;
  }

  @override
  Future<void> sendPhone(String phone) async {
    return _api.sendPhone(SendPhoneRequest(phoneNumber: phone));
  }

  @override
  Stream<Auth?> watchAuth() => authStorage.stream;

  @override
  Auth? getAuth() => authStorage.value;

  @override
  Future<void> logout() async {
    authStorage.update(null);
  }
}
