import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_order_request.freezed.dart';
part 'create_order_request.g.dart';

@freezed
class CreateOrderRequest with _$CreateOrderRequest {
  const factory CreateOrderRequest({
    required String serviceId,
    required String staffId,
    required DateTime startTimestamp,
  }) = _CreateOrderRequest;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) => _$CreateOrderRequestFromJson(json);
}
