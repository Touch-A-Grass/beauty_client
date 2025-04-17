part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = _Started;

  const factory ProfileEvent.userRequested() = _UserRequested;

  const factory ProfileEvent.updateUserRequested(String name) = _UpdateUserRequested;

  const factory ProfileEvent.updatePhotoRequested(Uint8List photo) = _UpdatePhotoRequested;

  const factory ProfileEvent.updateOrderNotificationsRequested(bool value) = _UpdateOrderNotificationsRequested;

  const factory ProfileEvent.updatePromoNotificationsRequested(bool value) = _UpdatePromoNotificationsRequested;

  const factory ProfileEvent.updateUserSettingsRequested(UserSettings settings) = _UpdateUserSettingsRequested;

  const factory ProfileEvent.logoutRequested() = _LogoutRequested;

  const factory ProfileEvent.userChanged(User? user) = _UserChanged;
}
