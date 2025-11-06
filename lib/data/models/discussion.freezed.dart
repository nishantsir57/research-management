// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discussion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiscussionThread _$DiscussionThreadFromJson(Map<String, dynamic> json) {
  return _DiscussionThread.fromJson(json);
}

/// @nodoc
mixin _$DiscussionThread {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get departmentId => throw _privateConstructorUsedError;
  String? get subjectId => throw _privateConstructorUsedError;
  bool get isOpen => throw _privateConstructorUsedError;
  int get participantCount => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DiscussionThread to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscussionThread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscussionThreadCopyWith<DiscussionThread> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscussionThreadCopyWith<$Res> {
  factory $DiscussionThreadCopyWith(
    DiscussionThread value,
    $Res Function(DiscussionThread) then,
  ) = _$DiscussionThreadCopyWithImpl<$Res, DiscussionThread>;
  @useResult
  $Res call({
    String id,
    String title,
    String createdBy,
    String description,
    List<String> tags,
    String? departmentId,
    String? subjectId,
    bool isOpen,
    int participantCount,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class _$DiscussionThreadCopyWithImpl<$Res, $Val extends DiscussionThread>
    implements $DiscussionThreadCopyWith<$Res> {
  _$DiscussionThreadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscussionThread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? createdBy = null,
    Object? description = null,
    Object? tags = null,
    Object? departmentId = freezed,
    Object? subjectId = freezed,
    Object? isOpen = null,
    Object? participantCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            departmentId: freezed == departmentId
                ? _value.departmentId
                : departmentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            subjectId: freezed == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOpen: null == isOpen
                ? _value.isOpen
                : isOpen // ignore: cast_nullable_to_non_nullable
                      as bool,
            participantCount: null == participantCount
                ? _value.participantCount
                : participantCount // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$DiscussionThreadImplCopyWith<$Res>
    implements $DiscussionThreadCopyWith<$Res> {
  factory _$$DiscussionThreadImplCopyWith(
    _$DiscussionThreadImpl value,
    $Res Function(_$DiscussionThreadImpl) then,
  ) = __$$DiscussionThreadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String createdBy,
    String description,
    List<String> tags,
    String? departmentId,
    String? subjectId,
    bool isOpen,
    int participantCount,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class __$$DiscussionThreadImplCopyWithImpl<$Res>
    extends _$DiscussionThreadCopyWithImpl<$Res, _$DiscussionThreadImpl>
    implements _$$DiscussionThreadImplCopyWith<$Res> {
  __$$DiscussionThreadImplCopyWithImpl(
    _$DiscussionThreadImpl _value,
    $Res Function(_$DiscussionThreadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscussionThread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? createdBy = null,
    Object? description = null,
    Object? tags = null,
    Object? departmentId = freezed,
    Object? subjectId = freezed,
    Object? isOpen = null,
    Object? participantCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$DiscussionThreadImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        departmentId: freezed == departmentId
            ? _value.departmentId
            : departmentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        subjectId: freezed == subjectId
            ? _value.subjectId
            : subjectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOpen: null == isOpen
            ? _value.isOpen
            : isOpen // ignore: cast_nullable_to_non_nullable
                  as bool,
        participantCount: null == participantCount
            ? _value.participantCount
            : participantCount // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$DiscussionThreadImpl extends _DiscussionThread {
  const _$DiscussionThreadImpl({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.description,
    final List<String> tags = const [],
    this.departmentId,
    this.subjectId,
    this.isOpen = true,
    this.participantCount = 0,
    @TimestampDateTimeConverter() this.createdAt,
    @TimestampDateTimeConverter() this.updatedAt,
  }) : _tags = tags,
       super._();

  factory _$DiscussionThreadImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscussionThreadImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String createdBy;
  @override
  final String description;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? departmentId;
  @override
  final String? subjectId;
  @override
  @JsonKey()
  final bool isOpen;
  @override
  @JsonKey()
  final int participantCount;
  @override
  @TimestampDateTimeConverter()
  final DateTime? createdAt;
  @override
  @TimestampDateTimeConverter()
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'DiscussionThread(id: $id, title: $title, createdBy: $createdBy, description: $description, tags: $tags, departmentId: $departmentId, subjectId: $subjectId, isOpen: $isOpen, participantCount: $participantCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscussionThreadImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.participantCount, participantCount) ||
                other.participantCount == participantCount) &&
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
    title,
    createdBy,
    description,
    const DeepCollectionEquality().hash(_tags),
    departmentId,
    subjectId,
    isOpen,
    participantCount,
    createdAt,
    updatedAt,
  );

  /// Create a copy of DiscussionThread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscussionThreadImplCopyWith<_$DiscussionThreadImpl> get copyWith =>
      __$$DiscussionThreadImplCopyWithImpl<_$DiscussionThreadImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscussionThreadImplToJson(this);
  }
}

abstract class _DiscussionThread extends DiscussionThread {
  const factory _DiscussionThread({
    required final String id,
    required final String title,
    required final String createdBy,
    required final String description,
    final List<String> tags,
    final String? departmentId,
    final String? subjectId,
    final bool isOpen,
    final int participantCount,
    @TimestampDateTimeConverter() final DateTime? createdAt,
    @TimestampDateTimeConverter() final DateTime? updatedAt,
  }) = _$DiscussionThreadImpl;
  const _DiscussionThread._() : super._();

  factory _DiscussionThread.fromJson(Map<String, dynamic> json) =
      _$DiscussionThreadImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get createdBy;
  @override
  String get description;
  @override
  List<String> get tags;
  @override
  String? get departmentId;
  @override
  String? get subjectId;
  @override
  bool get isOpen;
  @override
  int get participantCount;
  @override
  @TimestampDateTimeConverter()
  DateTime? get createdAt;
  @override
  @TimestampDateTimeConverter()
  DateTime? get updatedAt;

  /// Create a copy of DiscussionThread
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscussionThreadImplCopyWith<_$DiscussionThreadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DiscussionComment _$DiscussionCommentFromJson(Map<String, dynamic> json) {
  return _DiscussionComment.fromJson(json);
}

/// @nodoc
mixin _$DiscussionComment {
  String get id => throw _privateConstructorUsedError;
  String get threadId => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get upvotes => throw _privateConstructorUsedError;
  List<String> get replies => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DiscussionComment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscussionComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscussionCommentCopyWith<DiscussionComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscussionCommentCopyWith<$Res> {
  factory $DiscussionCommentCopyWith(
    DiscussionComment value,
    $Res Function(DiscussionComment) then,
  ) = _$DiscussionCommentCopyWithImpl<$Res, DiscussionComment>;
  @useResult
  $Res call({
    String id,
    String threadId,
    String authorId,
    String content,
    List<String> upvotes,
    List<String> replies,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class _$DiscussionCommentCopyWithImpl<$Res, $Val extends DiscussionComment>
    implements $DiscussionCommentCopyWith<$Res> {
  _$DiscussionCommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscussionComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? threadId = null,
    Object? authorId = null,
    Object? content = null,
    Object? upvotes = null,
    Object? replies = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            threadId: null == threadId
                ? _value.threadId
                : threadId // ignore: cast_nullable_to_non_nullable
                      as String,
            authorId: null == authorId
                ? _value.authorId
                : authorId // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            upvotes: null == upvotes
                ? _value.upvotes
                : upvotes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            replies: null == replies
                ? _value.replies
                : replies // ignore: cast_nullable_to_non_nullable
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
abstract class _$$DiscussionCommentImplCopyWith<$Res>
    implements $DiscussionCommentCopyWith<$Res> {
  factory _$$DiscussionCommentImplCopyWith(
    _$DiscussionCommentImpl value,
    $Res Function(_$DiscussionCommentImpl) then,
  ) = __$$DiscussionCommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String threadId,
    String authorId,
    String content,
    List<String> upvotes,
    List<String> replies,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class __$$DiscussionCommentImplCopyWithImpl<$Res>
    extends _$DiscussionCommentCopyWithImpl<$Res, _$DiscussionCommentImpl>
    implements _$$DiscussionCommentImplCopyWith<$Res> {
  __$$DiscussionCommentImplCopyWithImpl(
    _$DiscussionCommentImpl _value,
    $Res Function(_$DiscussionCommentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscussionComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? threadId = null,
    Object? authorId = null,
    Object? content = null,
    Object? upvotes = null,
    Object? replies = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$DiscussionCommentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        threadId: null == threadId
            ? _value.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
                  as String,
        authorId: null == authorId
            ? _value.authorId
            : authorId // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        upvotes: null == upvotes
            ? _value._upvotes
            : upvotes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        replies: null == replies
            ? _value._replies
            : replies // ignore: cast_nullable_to_non_nullable
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
class _$DiscussionCommentImpl extends _DiscussionComment {
  const _$DiscussionCommentImpl({
    required this.id,
    required this.threadId,
    required this.authorId,
    required this.content,
    final List<String> upvotes = const [],
    final List<String> replies = const [],
    @TimestampDateTimeConverter() this.createdAt,
    @TimestampDateTimeConverter() this.updatedAt,
  }) : _upvotes = upvotes,
       _replies = replies,
       super._();

  factory _$DiscussionCommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscussionCommentImplFromJson(json);

  @override
  final String id;
  @override
  final String threadId;
  @override
  final String authorId;
  @override
  final String content;
  final List<String> _upvotes;
  @override
  @JsonKey()
  List<String> get upvotes {
    if (_upvotes is EqualUnmodifiableListView) return _upvotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upvotes);
  }

  final List<String> _replies;
  @override
  @JsonKey()
  List<String> get replies {
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replies);
  }

  @override
  @TimestampDateTimeConverter()
  final DateTime? createdAt;
  @override
  @TimestampDateTimeConverter()
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'DiscussionComment(id: $id, threadId: $threadId, authorId: $authorId, content: $content, upvotes: $upvotes, replies: $replies, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscussionCommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._upvotes, _upvotes) &&
            const DeepCollectionEquality().equals(other._replies, _replies) &&
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
    threadId,
    authorId,
    content,
    const DeepCollectionEquality().hash(_upvotes),
    const DeepCollectionEquality().hash(_replies),
    createdAt,
    updatedAt,
  );

  /// Create a copy of DiscussionComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscussionCommentImplCopyWith<_$DiscussionCommentImpl> get copyWith =>
      __$$DiscussionCommentImplCopyWithImpl<_$DiscussionCommentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscussionCommentImplToJson(this);
  }
}

abstract class _DiscussionComment extends DiscussionComment {
  const factory _DiscussionComment({
    required final String id,
    required final String threadId,
    required final String authorId,
    required final String content,
    final List<String> upvotes,
    final List<String> replies,
    @TimestampDateTimeConverter() final DateTime? createdAt,
    @TimestampDateTimeConverter() final DateTime? updatedAt,
  }) = _$DiscussionCommentImpl;
  const _DiscussionComment._() : super._();

  factory _DiscussionComment.fromJson(Map<String, dynamic> json) =
      _$DiscussionCommentImpl.fromJson;

  @override
  String get id;
  @override
  String get threadId;
  @override
  String get authorId;
  @override
  String get content;
  @override
  List<String> get upvotes;
  @override
  List<String> get replies;
  @override
  @TimestampDateTimeConverter()
  DateTime? get createdAt;
  @override
  @TimestampDateTimeConverter()
  DateTime? get updatedAt;

  /// Create a copy of DiscussionComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscussionCommentImplCopyWith<_$DiscussionCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
