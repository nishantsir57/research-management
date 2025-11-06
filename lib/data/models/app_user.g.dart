// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      role: $enumDecode(_$AuthRoleEnumMap, json['role']),
      departmentId: json['departmentId'] as String?,
      subjectIds: (json['subjectIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      connections:
          (json['connections'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isBlocked: json['isBlocked'] as bool? ?? false,
      isReviewerApproved: json['isReviewerApproved'] as bool? ?? false,
      createdAt: const TimestampDateTimeConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampDateTimeConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$AppUserImplToJson(
  _$AppUserImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'displayName': instance.displayName,
  'role': _$AuthRoleEnumMap[instance.role]!,
  'departmentId': instance.departmentId,
  'subjectIds': instance.subjectIds,
  'photoUrl': instance.photoUrl,
  'bio': instance.bio,
  'connections': instance.connections,
  'isBlocked': instance.isBlocked,
  'isReviewerApproved': instance.isReviewerApproved,
  'createdAt': const TimestampDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampDateTimeConverter().toJson(instance.updatedAt),
};

const _$AuthRoleEnumMap = {
  AuthRole.student: 'student',
  AuthRole.reviewer: 'reviewer',
  AuthRole.admin: 'admin',
};
