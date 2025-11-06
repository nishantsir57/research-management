import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/converters.dart';

part 'connection.freezed.dart';
part 'connection.g.dart';

enum ConnectionStatus { pending, accepted, rejected, blocked }

@freezed
class ConnectionRequest with _$ConnectionRequest {
  const ConnectionRequest._();

  const factory ConnectionRequest({
    required String id,
    required String requesterId,
    required String recipientId,
    required ConnectionStatus status,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? respondedAt,
  }) = _ConnectionRequest;

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) =>
      _$ConnectionRequestFromJson(json);
}
