import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_response.g.dart';

@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class PageResponse<T> {
  final List<T> data;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;

  factory PageResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PageResponseFromJson(json, fromJsonT);

  PageResponse({
    required this.data,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
  });
}
