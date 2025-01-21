import 'package:beauty_client/data/storage/base/secure_storage_wrapper.dart';
import 'package:beauty_client/data/storage/base/stream_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class PersistentStreamStorage<T> extends StreamStorage<T> {
  final SecureStorageWrapper<T> persistentStorage;

  PersistentStreamStorage({
    required super.initialValue,
    required FlutterSecureStorage secureStorage,
    required String key,
    required Map<String, dynamic> Function(T) toJson,
    required T Function(Map<String, dynamic>) fromJson,
  }) : persistentStorage = SecureStorageWrapper<T>(
          toJson: toJson,
          fromJson: fromJson,
          storage: secureStorage,
          key: key,
        );

  Future<void> init() async {
    final value = await persistentStorage.get();
    if (value != null) {
      update(value);
    }
  }

  @override
  void update(T value) {
    super.update(value);
    if (value != null) {
      persistentStorage.set(value);
    } else {
      persistentStorage.delete();
    }
  }
}
