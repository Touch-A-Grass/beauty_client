part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = _Started;

  const factory ProfileEvent.userRequested() = _UserRequested;

  const factory ProfileEvent.updateUserRequested({required String name}) = _UpdateUserRequested;

  const factory ProfileEvent.logoutRequested() = _LogoutRequested;

  const factory ProfileEvent.userChanged(User? user) = _UserChanged;
}
