// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$AppSettingsImpl(
  id: json['id'] as String,
  aiPreReviewEnabled: json['aiPreReviewEnabled'] as bool? ?? true,
  allowStudentRegistration: json['allowStudentRegistration'] as bool? ?? true,
  allowReviewerRegistration: json['allowReviewerRegistration'] as bool? ?? true,
  allowPublicVisibility: json['allowPublicVisibility'] as bool? ?? true,
  updatedAt: const TimestampDateTimeConverter().fromJson(json['updatedAt']),
  updatedBy: json['updatedBy'] as String?,
);

Map<String, dynamic> _$$AppSettingsImplToJson(
  _$AppSettingsImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'aiPreReviewEnabled': instance.aiPreReviewEnabled,
  'allowStudentRegistration': instance.allowStudentRegistration,
  'allowReviewerRegistration': instance.allowReviewerRegistration,
  'allowPublicVisibility': instance.allowPublicVisibility,
  'updatedAt': const TimestampDateTimeConverter().toJson(instance.updatedAt),
  'updatedBy': instance.updatedBy,
};
