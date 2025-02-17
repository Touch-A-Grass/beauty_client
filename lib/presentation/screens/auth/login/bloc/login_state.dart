part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const LoginState._();

  const factory LoginState({
    @Default(false) bool isLoading,
    @Default('') String password,
    @Default('') String phone,
    String? error,
  }) = _LoginState;

  bool get canEdit => !isLoading;

  bool get canRequestLogin => canEdit && phone.isNotEmpty && password.isNotEmpty;
}
