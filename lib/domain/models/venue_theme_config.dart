import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_theme_config.freezed.dart';
part 'venue_theme_config.g.dart';

@freezed
class VenueThemeConfig with _$VenueThemeConfig {
  const factory VenueThemeConfig({
    required int color,
    required String photo,
  }) = _VenueThemeConfig;

  factory VenueThemeConfig.fromJson(Map<String, dynamic> json) => _$VenueThemeConfigFromJson(json);
}
