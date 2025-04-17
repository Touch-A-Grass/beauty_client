import 'dart:typed_data';

import 'package:beauty_client/domain/models/user.dart';
import 'package:beauty_client/domain/repositories/auth_repository.dart';
import 'package:beauty_client/domain/use_cases/logout_use_case.dart';
import 'package:beauty_client/presentation/util/subscription_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> with SubscriptionBloc {
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;

  ProfileBloc(this._logoutUseCase, this._authRepository) : super(const ProfileState()) {
    on<_Started>((event, emit) {
      add(ProfileEvent.userRequested());
    });

    on<_UserRequested>((event, emit) async {
      try {
        await _authRepository.getUser();
      } catch (_) {}
    });

    on<_UpdateUserRequested>((event, emit) async {
      emit(state.copyWith(isUpdatingUser: true));
      try {
        await _authRepository.updateUser(name: event.name);
        add(ProfileEvent.userRequested());
      } catch (_) {
      } finally {
        emit(state.copyWith(isUpdatingUser: false));
      }
    });

    on<_LogoutRequested>((event, emit) {
      _logoutUseCase.execute();
    });

    on<_UserChanged>((event, emit) {
      emit(state.copyWith(user: event.user));
    });

    on<_UpdatePromoNotificationsRequested>((event, emit) async {
      final settings = state.user?.settings?.copyWith(receivePromoNotifications: event.value);

      if (settings == null) return;

      emit(state.copyWith(user: state.user?.copyWith(settings: settings)));
      add(ProfileEvent.updateUserSettingsRequested(settings));
    });

    on<_UpdateOrderNotificationsRequested>((event, emit) async {
      final settings = state.user?.settings?.copyWith(receiveOrderNotifications: event.value);

      if (settings == null) return;

      emit(state.copyWith(user: state.user?.copyWith(settings: settings)));
      add(ProfileEvent.updateUserSettingsRequested(settings));
    });

    on<_UpdateUserSettingsRequested>((event, emit) async {
      try {
        await _authRepository.updateSettings(event.settings);
      } catch (_) {}
    }, transformer: (events, mapper) => events.debounceTime(Duration(milliseconds: 500)).asyncExpand(mapper));

    on<_UpdatePhotoRequested>((event, emit) async {
      emit(state.copyWith(isUpdatingUser: true));
      try {
        await _authRepository.updatePhoto(event.photo);
      } catch (_) {}
      emit(state.copyWith(isUpdatingUser: false));
    });

    subscribe(_authRepository.watchUser(), (user) {
      add(ProfileEvent.userChanged(user));
    });
  }
}
