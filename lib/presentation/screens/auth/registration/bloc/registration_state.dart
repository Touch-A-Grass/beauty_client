part of 'registration_bloc.dart';

@freezed
class RegistrationState with _$RegistrationState {
  const RegistrationState._();

  const factory RegistrationState({
    @Default(false) bool isLoading,
    @Default('') String password,
    @Default('') String phone,
    @Default('') String name,
    String? error,
}) = _RegistrationState;

  bool get canEdit => !isLoading;

  bool get canRequestRegistration => canEdit && phone.isNotEmpty && password.isNotEmpty && name.isNotEmpty;
}
