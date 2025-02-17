import 'package:beauty_client/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_bloc.freezed.dart';
part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthRepository authRepository;

  RegistrationBloc(this.authRepository) : super(const RegistrationState()) {
    on<_RegisterRequested>((event, emit) async {
      emit(state.copyWith(error: null, isLoading: true));
      try {
        await authRepository.register(state.name, state.phone, state.password);
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
      emit(state.copyWith(isLoading: false));
    });
    on<_NameChanged>((event, emit) {
      emit(state.copyWith(name: event.name, error: null));
    });
    on<_PhoneChanged>((event, emit) {
      emit(state.copyWith(phone: event.phone, error: null));
    });
    on<_PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password, error: null));
    });
  }
}
