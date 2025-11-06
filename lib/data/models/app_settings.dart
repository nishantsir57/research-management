import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/converters.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const AppSettings._();

  const factory AppSettings({
    required String id,
    @Default(true) bool aiPreReviewEnabled,
    @Default(true) bool allowStudentRegistration,
    @Default(true) bool allowReviewerRegistration,
    @Default(true) bool allowPublicVisibility,
    @TimestampDateTimeConverter() DateTime? updatedAt,
    String? updatedBy,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
}
