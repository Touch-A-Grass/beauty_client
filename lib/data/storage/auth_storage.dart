import 'package:beauty_client/data/storage/base/persistent_stream_storage.dart';
import 'package:beauty_client/domain/models/auth.dart';

class AuthStorage extends PersistentStreamStorage<Auth?> {
  AuthStorage({
    required super.secureStorage,
  }) : super(
          initialValue: null,
          fromJson: Auth.fromJson,
          toJson: (value) => value?.toJson() ?? {},
          key: 'auth',
        );
}
