// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConnectionRequestImpl _$$ConnectionRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ConnectionRequestImpl(
  id: json['id'] as String,
  requesterId: json['requesterId'] as String,
  recipientId: json['recipientId'] as String,
  status: $enumDecode(_$ConnectionStatusEnumMap, json['status']),
  createdAt: const TimestampDateTimeConverter().fromJson(json['createdAt']),
  respondedAt: const TimestampDateTimeConverter().fromJson(json['respondedAt']),
);

Map<String, dynamic> _$$ConnectionRequestImplToJson(
  _$ConnectionRequestImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'requesterId': instance.requesterId,
  'recipientId': instance.recipientId,
  'status': _$ConnectionStatusEnumMap[instance.status]!,
  'createdAt': const TimestampDateTimeConverter().toJson(instance.createdAt),
  'respondedAt': const TimestampDateTimeConverter().toJson(
    instance.respondedAt,
  ),
};

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.pending: 'pending',
  ConnectionStatus.accepted: 'accepted',
  ConnectionStatus.rejected: 'rejected',
  ConnectionStatus.blocked: 'blocked',
};
