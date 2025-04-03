import 'package:beauty_client/data/storage/base/persistent_stream_storage.dart';
import 'package:beauty_client/domain/models/user.dart';

class UserStorage extends PersistentStreamStorage<User?> {
  UserStorage({required super.secureStorage})
    : super(initialValue: null, fromJson: User.fromJson, toJson: (value) => value?.toJson() ?? {}, key: 'user');
}
