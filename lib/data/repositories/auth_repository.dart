import 'package:beauty_client/data/api/beauty_client.dart';
import 'package:beauty_client/data/models/requests/send_code_request.dart';
import 'package:beauty_client/data/models/requests/send_phone_request.dart';
import 'package:beauty_client/data/models/requests/update_user_request.dart';
import 'package:beauty_client/data/storage/auth_storage.dart';
import 'package:beauty_client/data/storage/user_storage.dart';
import 'package:beauty_client/domain/models/auth.dart';
import 'package:beauty_client/domain/models/user.dart';
import 'package:beauty_client/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BeautyClient _api;
  final AuthStorage _authStorage;
  final UserStorage _userStorage;

  AuthRepositoryImpl(this._api, this._authStorage, this._userStorage);

  @override
  Future<Auth> sendCode(String phone, String code) async {
    final auth = await _api.sendCode(SendCodeRequest(phoneNumber: phone, code: code));
    _authStorage.update(auth);
    return auth;
  }

  @override
  Future<void> sendPhone(String phone) async {
    return _api.sendPhone(SendPhoneRequest(phoneNumber: phone));
  }

  @override
  Stream<Auth?> watchAuth() => _authStorage.stream;

  @override
  Auth? getAuth() => _authStorage.value;

  @override
  Future<void> logout() async {
    _authStorage.update(null);
  }

  @override
  Future<User> getUser() async {
    final user = await _api.getUser();
    _userStorage.update(user);
    return user;
  }

  @override
  Future<void> updateUser({required String name}) async {
    await _api.updateUser(UpdateUserRequest(name: name));
    getUser();
  }

  @override
  Stream<User?> watchUser() => _userStorage.stream;
}
