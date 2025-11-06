// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConnectionRequest _$ConnectionRequestFromJson(Map<String, dynamic> json) {
  return _ConnectionRequest.fromJson(json);
}

/// @nodoc
mixin _$ConnectionRequest {
  String get id => throw _privateConstructorUsedError;
  String get requesterId => throw _privateConstructorUsedError;
  String get recipientId => throw _privateConstructorUsedError;
  ConnectionStatus get status => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get respondedAt => throw _privateConstructorUsedError;

  /// Serializes this ConnectionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConnectionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectionRequestCopyWith<ConnectionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectionRequestCopyWith<$Res> {
  factory $ConnectionRequestCopyWith(
    ConnectionRequest value,
    $Res Function(ConnectionRequest) then,
  ) = _$ConnectionRequestCopyWithImpl<$Res, ConnectionRequest>;
  @useResult
  $Res call({
    String id,
    String requesterId,
    String recipientId,
    ConnectionStatus status,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? respondedAt,
  });
}

/// @nodoc
class _$ConnectionRequestCopyWithImpl<$Res, $Val extends ConnectionRequest>
    implements $ConnectionRequestCopyWith<$Res> {
  _$ConnectionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? recipientId = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? respondedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            requesterId: null == requesterId
                ? _value.requesterId
                : requesterId // ignore: cast_nullable_to_non_nullable
                      as String,
            recipientId: null == recipientId
                ? _value.recipientId
                : recipientId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ConnectionStatus,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            respondedAt: freezed == respondedAt
                ? _value.respondedAt
                : respondedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConnectionRequestImplCopyWith<$Res>
    implements $ConnectionRequestCopyWith<$Res> {
  factory _$$ConnectionRequestImplCopyWith(
    _$ConnectionRequestImpl value,
    $Res Function(_$ConnectionRequestImpl) then,
  ) = __$$ConnectionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String requesterId,
    String recipientId,
    ConnectionStatus status,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? respondedAt,
  });
}

/// @nodoc
class __$$ConnectionRequestImplCopyWithImpl<$Res>
    extends _$ConnectionRequestCopyWithImpl<$Res, _$ConnectionRequestImpl>
    implements _$$ConnectionRequestImplCopyWith<$Res> {
  __$$ConnectionRequestImplCopyWithImpl(
    _$ConnectionRequestImpl _value,
    $Res Function(_$ConnectionRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConnectionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? recipientId = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? respondedAt = freezed,
  }) {
    return _then(
      _$ConnectionRequestImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        requesterId: null == requesterId
            ? _value.requesterId
            : requesterId // ignore: cast_nullable_to_non_nullable
                  as String,
        recipientId: null == recipientId
            ? _value.recipientId
            : recipientId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ConnectionStatus,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        respondedAt: freezed == respondedAt
            ? _value.respondedAt
            : respondedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectionRequestImpl extends _ConnectionRequest {
  const _$ConnectionRequestImpl({
    required this.id,
    required this.requesterId,
    required this.recipientId,
    required this.status,
    @TimestampDateTimeConverter() this.createdAt,
    @TimestampDateTimeConverter() this.respondedAt,
  }) : super._();

  factory _$ConnectionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectionRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String requesterId;
  @override
  final String recipientId;
  @override
  final ConnectionStatus status;
  @override
  @TimestampDateTimeConverter()
  final DateTime? createdAt;
  @override
  @TimestampDateTimeConverter()
  final DateTime? respondedAt;

  @override
  String toString() {
    return 'ConnectionRequest(id: $id, requesterId: $requesterId, recipientId: $recipientId, status: $status, createdAt: $createdAt, respondedAt: $respondedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    requesterId,
    recipientId,
    status,
    createdAt,
    respondedAt,
  );

  /// Create a copy of ConnectionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionRequestImplCopyWith<_$ConnectionRequestImpl> get copyWith =>
      __$$ConnectionRequestImplCopyWithImpl<_$ConnectionRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectionRequestImplToJson(this);
  }
}

abstract class _ConnectionRequest extends ConnectionRequest {
  const factory _ConnectionRequest({
    required final String id,
    required final String requesterId,
    required final String recipientId,
    required final ConnectionStatus status,
    @TimestampDateTimeConverter() final DateTime? createdAt,
    @TimestampDateTimeConverter() final DateTime? respondedAt,
  }) = _$ConnectionRequestImpl;
  const _ConnectionRequest._() : super._();

  factory _ConnectionRequest.fromJson(Map<String, dynamic> json) =
      _$ConnectionRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get requesterId;
  @override
  String get recipientId;
  @override
  ConnectionStatus get status;
  @override
  @TimestampDateTimeConverter()
  DateTime? get createdAt;
  @override
  @TimestampDateTimeConverter()
  DateTime? get respondedAt;

  /// Create a copy of ConnectionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectionRequestImplCopyWith<_$ConnectionRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
