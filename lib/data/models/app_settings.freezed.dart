// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  String get id => throw _privateConstructorUsedError;
  bool get aiPreReviewEnabled => throw _privateConstructorUsedError;
  bool get allowStudentRegistration => throw _privateConstructorUsedError;
  bool get allowReviewerRegistration => throw _privateConstructorUsedError;
  bool get allowPublicVisibility => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    String id,
    bool aiPreReviewEnabled,
    bool allowStudentRegistration,
    bool allowReviewerRegistration,
    bool allowPublicVisibility,
    @TimestampDateTimeConverter() DateTime? updatedAt,
    String? updatedBy,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? aiPreReviewEnabled = null,
    Object? allowStudentRegistration = null,
    Object? allowReviewerRegistration = null,
    Object? allowPublicVisibility = null,
    Object? updatedAt = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            aiPreReviewEnabled: null == aiPreReviewEnabled
                ? _value.aiPreReviewEnabled
                : aiPreReviewEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowStudentRegistration: null == allowStudentRegistration
                ? _value.allowStudentRegistration
                : allowStudentRegistration // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowReviewerRegistration: null == allowReviewerRegistration
                ? _value.allowReviewerRegistration
                : allowReviewerRegistration // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowPublicVisibility: null == allowPublicVisibility
                ? _value.allowPublicVisibility
                : allowPublicVisibility // ignore: cast_nullable_to_non_nullable
                      as bool,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedBy: freezed == updatedBy
                ? _value.updatedBy
                : updatedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    bool aiPreReviewEnabled,
    bool allowStudentRegistration,
    bool allowReviewerRegistration,
    bool allowPublicVisibility,
    @TimestampDateTimeConverter() DateTime? updatedAt,
    String? updatedBy,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? aiPreReviewEnabled = null,
    Object? allowStudentRegistration = null,
    Object? allowReviewerRegistration = null,
    Object? allowPublicVisibility = null,
    Object? updatedAt = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(
      _$AppSettingsImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        aiPreReviewEnabled: null == aiPreReviewEnabled
            ? _value.aiPreReviewEnabled
            : aiPreReviewEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowStudentRegistration: null == allowStudentRegistration
            ? _value.allowStudentRegistration
            : allowStudentRegistration // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowReviewerRegistration: null == allowReviewerRegistration
            ? _value.allowReviewerRegistration
            : allowReviewerRegistration // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowPublicVisibility: null == allowPublicVisibility
            ? _value.allowPublicVisibility
            : allowPublicVisibility // ignore: cast_nullable_to_non_nullable
                  as bool,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedBy: freezed == updatedBy
            ? _value.updatedBy
            : updatedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl extends _AppSettings {
  const _$AppSettingsImpl({
    required this.id,
    this.aiPreReviewEnabled = true,
    this.allowStudentRegistration = true,
    this.allowReviewerRegistration = true,
    this.allowPublicVisibility = true,
    @TimestampDateTimeConverter() this.updatedAt,
    this.updatedBy,
  }) : super._();

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final bool aiPreReviewEnabled;
  @override
  @JsonKey()
  final bool allowStudentRegistration;
  @override
  @JsonKey()
  final bool allowReviewerRegistration;
  @override
  @JsonKey()
  final bool allowPublicVisibility;
  @override
  @TimestampDateTimeConverter()
  final DateTime? updatedAt;
  @override
  final String? updatedBy;

  @override
  String toString() {
    return 'AppSettings(id: $id, aiPreReviewEnabled: $aiPreReviewEnabled, allowStudentRegistration: $allowStudentRegistration, allowReviewerRegistration: $allowReviewerRegistration, allowPublicVisibility: $allowPublicVisibility, updatedAt: $updatedAt, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.aiPreReviewEnabled, aiPreReviewEnabled) ||
                other.aiPreReviewEnabled == aiPreReviewEnabled) &&
            (identical(
                  other.allowStudentRegistration,
                  allowStudentRegistration,
                ) ||
                other.allowStudentRegistration == allowStudentRegistration) &&
            (identical(
                  other.allowReviewerRegistration,
                  allowReviewerRegistration,
                ) ||
                other.allowReviewerRegistration == allowReviewerRegistration) &&
            (identical(other.allowPublicVisibility, allowPublicVisibility) ||
                other.allowPublicVisibility == allowPublicVisibility) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    aiPreReviewEnabled,
    allowStudentRegistration,
    allowReviewerRegistration,
    allowPublicVisibility,
    updatedAt,
    updatedBy,
  );

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(this);
  }
}

abstract class _AppSettings extends AppSettings {
  const factory _AppSettings({
    required final String id,
    final bool aiPreReviewEnabled,
    final bool allowStudentRegistration,
    final bool allowReviewerRegistration,
    final bool allowPublicVisibility,
    @TimestampDateTimeConverter() final DateTime? updatedAt,
    final String? updatedBy,
  }) = _$AppSettingsImpl;
  const _AppSettings._() : super._();

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  String get id;
  @override
  bool get aiPreReviewEnabled;
  @override
  bool get allowStudentRegistration;
  @override
  bool get allowReviewerRegistration;
  @override
  bool get allowPublicVisibility;
  @override
  @TimestampDateTimeConverter()
  DateTime? get updatedAt;
  @override
  String? get updatedBy;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
