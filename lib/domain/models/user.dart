import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String name,
    required String phoneNumber,
    String? photo,
    UserSettings? settings,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String get initials {
    final names = name.split(' ');
    return names.map((e) => e.substring(0, 1)).join('');
  }
}

@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    @Default(false) bool receiveOrderNotifications,
    @Default(false) bool receivePromoNotifications,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);
}
