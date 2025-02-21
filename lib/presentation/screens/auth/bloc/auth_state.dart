part of 'auth_bloc.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.phone() = AuthPhoneState;

  const factory AuthState.code(String phone) = AuthCodeState;

  const factory AuthState.telegram(String phone) = AuthTelegramState;
}
