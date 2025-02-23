import 'package:beauty_client/domain/use_cases/logout_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final LogoutUseCase _logoutUseCase;

  ProfileBloc(this._logoutUseCase) : super(const ProfileState()) {
    on<_LogoutRequested>((event, emit) {
      _logoutUseCase.execute();
    });
  }
}
