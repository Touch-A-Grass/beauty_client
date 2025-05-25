import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon.freezed.dart';
part 'coupon.g.dart';

@freezed
class Coupon with _$Coupon {
  const factory Coupon({
    required String id,
    required String name,
    required String description,
    required String code,
    required DiscountType discountType,
    required double discountValue,
    required bool isPublic,
    required int usageLimit,
    required DateTime startDate,
    required DateTime endDate,
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
}

@JsonEnum(alwaysCreate: true)
enum DiscountType {
  @JsonValue('Fixed')
  fixed,
  @JsonValue('Percentage')
  percentage,
}
