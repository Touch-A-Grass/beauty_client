import 'package:beauty_client/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(const LoginState()) {
    on<_LoginRequested>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final auth = await authRepository.login(state.phone, state.password);
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
      emit(state.copyWith(isLoading: false));
    });

    on<_PhoneChanged>((event, emit) {
      emit(state.copyWith(phone: event.phone, error: null));
    });

    on<_PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password, error: null));
    });
  }
}
