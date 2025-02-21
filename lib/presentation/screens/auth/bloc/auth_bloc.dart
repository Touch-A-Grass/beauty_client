import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.phone()) {
    on<_PhoneEntered>((event, emit) => emit(AuthState.telegram(event.phone)));

    on<_TelegramConfirmed>((event, emit) {
      switch (state) {
        case AuthTelegramState state:
          emit(AuthState.code(state.phone));
        default:
          emit(const AuthState.phone());
      }
    });

    on<_CodeEntered>((event, emit) {});

    on<_ChangePhoneRequested>((event, emit) {
      emit(const AuthState.phone());
    });
  }
}
