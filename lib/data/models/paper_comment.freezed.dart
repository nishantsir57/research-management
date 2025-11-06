// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paper_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaperComment _$PaperCommentFromJson(Map<String, dynamic> json) {
  return _PaperComment.fromJson(json);
}

/// @nodoc
mixin _$PaperComment {
  String get id => throw _privateConstructorUsedError;
  String get paperId => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  bool get isReviewerOnly => throw _privateConstructorUsedError;
  List<String> get likedBy => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PaperComment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaperComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaperCommentCopyWith<PaperComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaperCommentCopyWith<$Res> {
  factory $PaperCommentCopyWith(
    PaperComment value,
    $Res Function(PaperComment) then,
  ) = _$PaperCommentCopyWithImpl<$Res, PaperComment>;
  @useResult
  $Res call({
    String id,
    String paperId,
    String authorId,
    String content,
    bool isReviewerOnly,
    List<String> likedBy,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class _$PaperCommentCopyWithImpl<$Res, $Val extends PaperComment>
    implements $PaperCommentCopyWith<$Res> {
  _$PaperCommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaperComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paperId = null,
    Object? authorId = null,
    Object? content = null,
    Object? isReviewerOnly = null,
    Object? likedBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            paperId: null == paperId
                ? _value.paperId
                : paperId // ignore: cast_nullable_to_non_nullable
                      as String,
            authorId: null == authorId
                ? _value.authorId
                : authorId // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            isReviewerOnly: null == isReviewerOnly
                ? _value.isReviewerOnly
                : isReviewerOnly // ignore: cast_nullable_to_non_nullable
                      as bool,
            likedBy: null == likedBy
                ? _value.likedBy
                : likedBy // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaperCommentImplCopyWith<$Res>
    implements $PaperCommentCopyWith<$Res> {
  factory _$$PaperCommentImplCopyWith(
    _$PaperCommentImpl value,
    $Res Function(_$PaperCommentImpl) then,
  ) = __$$PaperCommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String paperId,
    String authorId,
    String content,
    bool isReviewerOnly,
    List<String> likedBy,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class __$$PaperCommentImplCopyWithImpl<$Res>
    extends _$PaperCommentCopyWithImpl<$Res, _$PaperCommentImpl>
    implements _$$PaperCommentImplCopyWith<$Res> {
  __$$PaperCommentImplCopyWithImpl(
    _$PaperCommentImpl _value,
    $Res Function(_$PaperCommentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaperComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paperId = null,
    Object? authorId = null,
    Object? content = null,
    Object? isReviewerOnly = null,
    Object? likedBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PaperCommentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        paperId: null == paperId
            ? _value.paperId
            : paperId // ignore: cast_nullable_to_non_nullable
                  as String,
        authorId: null == authorId
            ? _value.authorId
            : authorId // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        isReviewerOnly: null == isReviewerOnly
            ? _value.isReviewerOnly
            : isReviewerOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
        likedBy: null == likedBy
            ? _value._likedBy
            : likedBy // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaperCommentImpl extends _PaperComment {
  const _$PaperCommentImpl({
    required this.id,
    required this.paperId,
    required this.authorId,
    required this.content,
    this.isReviewerOnly = false,
    final List<String> likedBy = const [],
    @TimestampDateTimeConverter() this.createdAt,
    @TimestampDateTimeConverter() this.updatedAt,
  }) : _likedBy = likedBy,
       super._();

  factory _$PaperCommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaperCommentImplFromJson(json);

  @override
  final String id;
  @override
  final String paperId;
  @override
  final String authorId;
  @override
  final String content;
  @override
  @JsonKey()
  final bool isReviewerOnly;
  final List<String> _likedBy;
  @override
  @JsonKey()
  List<String> get likedBy {
    if (_likedBy is EqualUnmodifiableListView) return _likedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likedBy);
  }

  @override
  @TimestampDateTimeConverter()
  final DateTime? createdAt;
  @override
  @TimestampDateTimeConverter()
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PaperComment(id: $id, paperId: $paperId, authorId: $authorId, content: $content, isReviewerOnly: $isReviewerOnly, likedBy: $likedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaperCommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.paperId, paperId) || other.paperId == paperId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isReviewerOnly, isReviewerOnly) ||
                other.isReviewerOnly == isReviewerOnly) &&
            const DeepCollectionEquality().equals(other._likedBy, _likedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    paperId,
    authorId,
    content,
    isReviewerOnly,
    const DeepCollectionEquality().hash(_likedBy),
    createdAt,
    updatedAt,
  );

  /// Create a copy of PaperComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaperCommentImplCopyWith<_$PaperCommentImpl> get copyWith =>
      __$$PaperCommentImplCopyWithImpl<_$PaperCommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaperCommentImplToJson(this);
  }
}

abstract class _PaperComment extends PaperComment {
  const factory _PaperComment({
    required final String id,
    required final String paperId,
    required final String authorId,
    required final String content,
    final bool isReviewerOnly,
    final List<String> likedBy,
    @TimestampDateTimeConverter() final DateTime? createdAt,
    @TimestampDateTimeConverter() final DateTime? updatedAt,
  }) = _$PaperCommentImpl;
  const _PaperComment._() : super._();

  factory _PaperComment.fromJson(Map<String, dynamic> json) =
      _$PaperCommentImpl.fromJson;

  @override
  String get id;
  @override
  String get paperId;
  @override
  String get authorId;
  @override
  String get content;
  @override
  bool get isReviewerOnly;
  @override
  List<String> get likedBy;
  @override
  @TimestampDateTimeConverter()
  DateTime? get createdAt;
  @override
  @TimestampDateTimeConverter()
  DateTime? get updatedAt;

  /// Create a copy of PaperComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaperCommentImplCopyWith<_$PaperCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
