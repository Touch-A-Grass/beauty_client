part of 'registration_bloc.dart';

@freezed
class RegistrationEvent with _$RegistrationEvent {
  const factory RegistrationEvent.nameChanged(String name) = _NameChanged;

  const factory RegistrationEvent.phoneChanged(String phone) = _PhoneChanged;

  const factory RegistrationEvent.passwordChanged(String password) = _PasswordChanged;

  const factory RegistrationEvent.registerRequested() = _RegisterRequested;
}

