import 'package:beauty_client/domain/models/order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_record_request.freezed.dart';
part 'update_record_request.g.dart';

@freezed
class UpdateRecordRequest with _$UpdateRecordRequest {
  const factory UpdateRecordRequest({required String recordId, OrderStatus? status, RecordReviewDto? review}) =
      _UpdateRecordRequest;

  factory UpdateRecordRequest.fromJson(Map<String, dynamic> json) => _$UpdateRecordRequestFromJson(json);
}

@freezed
class RecordReviewDto with _$RecordReviewDto {
  const factory RecordReviewDto({String? comment, required int rating}) = _RecordReviewDto;

  factory RecordReviewDto.fromJson(Map<String, dynamic> json) => _$RecordReviewDtoFromJson(json);
}
