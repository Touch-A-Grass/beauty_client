part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.phoneChanged(String phone) = _PhoneChanged;

  const factory LoginEvent.passwordChanged(String password) = _PasswordChanged;

  const factory LoginEvent.loginRequested() = _LoginRequested;
}
