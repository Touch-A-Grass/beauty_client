import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required Staff staff,
    required Venue venue,
    required Service service,
    required DateTime startTimestamp,
    required DateTime endTimestamp,
    @Default('') String comment,
    @Default(OrderStatus.pending) OrderStatus status,
  }) = _Record;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@JsonEnum()
enum OrderStatus {
  @JsonValue('Discarded')
  discarded,
  @JsonValue('Pending')
  pending,
  @JsonValue('Approved')
  approved,
  @JsonValue('Completed')
  completed,
}
