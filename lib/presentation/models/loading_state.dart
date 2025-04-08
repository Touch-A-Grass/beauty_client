import 'package:beauty_client/domain/models/app_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'loading_state.freezed.dart';

@freezed
sealed class LoadingState<T> with _$LoadingState {
  const factory LoadingState.progress() = ProgressLoadingState;

  const factory LoadingState.success(T data) = SuccessLoadingState;

  const factory LoadingState.error(AppError error) = ErrorLoadingState;
}
