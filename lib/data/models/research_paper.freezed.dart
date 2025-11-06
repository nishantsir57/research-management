// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'research_paper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HighlightAnnotation _$HighlightAnnotationFromJson(Map<String, dynamic> json) {
  return _HighlightAnnotation.fromJson(json);
}

/// @nodoc
mixin _$HighlightAnnotation {
  String get id => throw _privateConstructorUsedError;
  String get reviewerId => throw _privateConstructorUsedError;
  int get startOffset => throw _privateConstructorUsedError;
  int get endOffset => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this HighlightAnnotation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HighlightAnnotation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HighlightAnnotationCopyWith<HighlightAnnotation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HighlightAnnotationCopyWith<$Res> {
  factory $HighlightAnnotationCopyWith(
    HighlightAnnotation value,
    $Res Function(HighlightAnnotation) then,
  ) = _$HighlightAnnotationCopyWithImpl<$Res, HighlightAnnotation>;
  @useResult
  $Res call({
    String id,
    String reviewerId,
    int startOffset,
    int endOffset,
    String colorHex,
    String? note,
    @TimestampDateTimeConverter() DateTime? createdAt,
  });
}

/// @nodoc
class _$HighlightAnnotationCopyWithImpl<$Res, $Val extends HighlightAnnotation>
    implements $HighlightAnnotationCopyWith<$Res> {
  _$HighlightAnnotationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HighlightAnnotation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewerId = null,
    Object? startOffset = null,
    Object? endOffset = null,
    Object? colorHex = null,
    Object? note = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reviewerId: null == reviewerId
                ? _value.reviewerId
                : reviewerId // ignore: cast_nullable_to_non_nullable
                      as String,
            startOffset: null == startOffset
                ? _value.startOffset
                : startOffset // ignore: cast_nullable_to_non_nullable
                      as int,
            endOffset: null == endOffset
                ? _value.endOffset
                : endOffset // ignore: cast_nullable_to_non_nullable
                      as int,
            colorHex: null == colorHex
                ? _value.colorHex
                : colorHex // ignore: cast_nullable_to_non_nullable
                      as String,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HighlightAnnotationImplCopyWith<$Res>
    implements $HighlightAnnotationCopyWith<$Res> {
  factory _$$HighlightAnnotationImplCopyWith(
    _$HighlightAnnotationImpl value,
    $Res Function(_$HighlightAnnotationImpl) then,
  ) = __$$HighlightAnnotationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reviewerId,
    int startOffset,
    int endOffset,
    String colorHex,
    String? note,
    @TimestampDateTimeConverter() DateTime? createdAt,
  });
}

/// @nodoc
class __$$HighlightAnnotationImplCopyWithImpl<$Res>
    extends _$HighlightAnnotationCopyWithImpl<$Res, _$HighlightAnnotationImpl>
    implements _$$HighlightAnnotationImplCopyWith<$Res> {
  __$$HighlightAnnotationImplCopyWithImpl(
    _$HighlightAnnotationImpl _value,
    $Res Function(_$HighlightAnnotationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HighlightAnnotation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewerId = null,
    Object? startOffset = null,
    Object? endOffset = null,
    Object? colorHex = null,
    Object? note = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$HighlightAnnotationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewerId: null == reviewerId
            ? _value.reviewerId
            : reviewerId // ignore: cast_nullable_to_non_nullable
                  as String,
        startOffset: null == startOffset
            ? _value.startOffset
            : startOffset // ignore: cast_nullable_to_non_nullable
                  as int,
        endOffset: null == endOffset
            ? _value.endOffset
            : endOffset // ignore: cast_nullable_to_non_nullable
                  as int,
        colorHex: null == colorHex
            ? _value.colorHex
            : colorHex // ignore: cast_nullable_to_non_nullable
                  as String,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HighlightAnnotationImpl extends _HighlightAnnotation {
  const _$HighlightAnnotationImpl({
    required this.id,
    required this.reviewerId,
    required this.startOffset,
    required this.endOffset,
    required this.colorHex,
    this.note,
    @TimestampDateTimeConverter() this.createdAt,
  }) : super._();

  factory _$HighlightAnnotationImpl.fromJson(Map<String, dynamic> json) =>
      _$$HighlightAnnotationImplFromJson(json);

  @override
  final String id;
  @override
  final String reviewerId;
  @override
  final int startOffset;
  @override
  final int endOffset;
  @override
  final String colorHex;
  @override
  final String? note;
  @override
  @TimestampDateTimeConverter()
  final DateTime? createdAt;

  @override
  String toString() {
    return 'HighlightAnnotation(id: $id, reviewerId: $reviewerId, startOffset: $startOffset, endOffset: $endOffset, colorHex: $colorHex, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HighlightAnnotationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.startOffset, startOffset) ||
                other.startOffset == startOffset) &&
            (identical(other.endOffset, endOffset) ||
                other.endOffset == endOffset) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reviewerId,
    startOffset,
    endOffset,
    colorHex,
    note,
    createdAt,
  );

  /// Create a copy of HighlightAnnotation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HighlightAnnotationImplCopyWith<_$HighlightAnnotationImpl> get copyWith =>
      __$$HighlightAnnotationImplCopyWithImpl<_$HighlightAnnotationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HighlightAnnotationImplToJson(this);
  }
}

abstract class _HighlightAnnotation extends HighlightAnnotation {
  const factory _HighlightAnnotation({
    required final String id,
    required final String reviewerId,
    required final int startOffset,
    required final int endOffset,
    required final String colorHex,
    final String? note,
    @TimestampDateTimeConverter() final DateTime? createdAt,
  }) = _$HighlightAnnotationImpl;
  const _HighlightAnnotation._() : super._();

  factory _HighlightAnnotation.fromJson(Map<String, dynamic> json) =
      _$HighlightAnnotationImpl.fromJson;

  @override
  String get id;
  @override
  String get reviewerId;
  @override
  int get startOffset;
  @override
  int get endOffset;
  @override
  String get colorHex;
  @override
  String? get note;
  @override
  @TimestampDateTimeConverter()
  DateTime? get createdAt;

  /// Create a copy of HighlightAnnotation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HighlightAnnotationImplCopyWith<_$HighlightAnnotationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewFeedback _$ReviewFeedbackFromJson(Map<String, dynamic> json) {
  return _ReviewFeedback.fromJson(json);
}

/// @nodoc
mixin _$ReviewFeedback {
  String get id => throw _privateConstructorUsedError;
  String get reviewerId => throw _privateConstructorUsedError;
  ReviewDecision get decision => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  List<String> get improvementPoints => throw _privateConstructorUsedError;
  List<HighlightAnnotation> get highlights =>
      throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ReviewFeedback to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewFeedback
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewFeedbackCopyWith<ReviewFeedback> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewFeedbackCopyWith<$Res> {
  factory $ReviewFeedbackCopyWith(
    ReviewFeedback value,
    $Res Function(ReviewFeedback) then,
  ) = _$ReviewFeedbackCopyWithImpl<$Res, ReviewFeedback>;
  @useResult
  $Res call({
    String id,
    String reviewerId,
    ReviewDecision decision,
    String summary,
    List<String> improvementPoints,
    List<HighlightAnnotation> highlights,
    @TimestampDateTimeConverter() DateTime? createdAt,
  });
}

/// @nodoc
class _$ReviewFeedbackCopyWithImpl<$Res, $Val extends ReviewFeedback>
    implements $ReviewFeedbackCopyWith<$Res> {
  _$ReviewFeedbackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewFeedback
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewerId = null,
    Object? decision = null,
    Object? summary = null,
    Object? improvementPoints = null,
    Object? highlights = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reviewerId: null == reviewerId
                ? _value.reviewerId
                : reviewerId // ignore: cast_nullable_to_non_nullable
                      as String,
            decision: null == decision
                ? _value.decision
                : decision // ignore: cast_nullable_to_non_nullable
                      as ReviewDecision,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
            improvementPoints: null == improvementPoints
                ? _value.improvementPoints
                : improvementPoints // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            highlights: null == highlights
                ? _value.highlights
                : highlights // ignore: cast_nullable_to_non_nullable
                      as List<HighlightAnnotation>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewFeedbackImplCopyWith<$Res>
    implements $ReviewFeedbackCopyWith<$Res> {
  factory _$$ReviewFeedbackImplCopyWith(
    _$ReviewFeedbackImpl value,
    $Res Function(_$ReviewFeedbackImpl) then,
  ) = __$$ReviewFeedbackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reviewerId,
    ReviewDecision decision,
    String summary,
    List<String> improvementPoints,
    List<HighlightAnnotation> highlights,
    @TimestampDateTimeConverter() DateTime? createdAt,
  });
}

/// @nodoc
class __$$ReviewFeedbackImplCopyWithImpl<$Res>
    extends _$ReviewFeedbackCopyWithImpl<$Res, _$ReviewFeedbackImpl>
    implements _$$ReviewFeedbackImplCopyWith<$Res> {
  __$$ReviewFeedbackImplCopyWithImpl(
    _$ReviewFeedbackImpl _value,
    $Res Function(_$ReviewFeedbackImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewFeedback
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewerId = null,
    Object? decision = null,
    Object? summary = null,
    Object? improvementPoints = null,
    Object? highlights = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ReviewFeedbackImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewerId: null == reviewerId
            ? _value.reviewerId
            : reviewerId // ignore: cast_nullable_to_non_nullable
                  as String,
        decision: null == decision
            ? _value.decision
            : decision // ignore: cast_nullable_to_non_nullable
                  as ReviewDecision,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        improvementPoints: null == improvementPoints
            ? _value._improvementPoints
            : improvementPoints // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        highlights: null == highlights
            ? _value._highlights
            : highlights // ignore: cast_nullable_to_non_nullable
                  as List<HighlightAnnotation>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewFeedbackImpl extends _ReviewFeedback {
  const _$ReviewFeedbackImpl({
    required this.id,
    required this.reviewerId,
    required this.decision,
    required this.summary,
    final List<String> improvementPoints = const [],
    final List<HighlightAnnotation> highlights = const [],
    @TimestampDateTimeConverter() this.createdAt,
  }) : _improvementPoints = improvementPoints,
       _highlights = highlights,
       super._();

  factory _$ReviewFeedbackImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewFeedbackImplFromJson(json);

  @override
  final String id;
  @override
  final String reviewerId;
  @override
  final ReviewDecision decision;
  @override
  final String summary;
  final List<String> _improvementPoints;
  @override
  @JsonKey()
  List<String> get improvementPoints {
    if (_improvementPoints is EqualUnmodifiableListView)
      return _improvementPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_improvementPoints);
  }

  final List<HighlightAnnotation> _highlights;
  @override
  @JsonKey()
  List<HighlightAnnotation> get highlights {
    if (_highlights is EqualUnmodifiableListView) return _highlights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highlights);
  }

  @override
  @TimestampDateTimeConverter()
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ReviewFeedback(id: $id, reviewerId: $reviewerId, decision: $decision, summary: $summary, improvementPoints: $improvementPoints, highlights: $highlights, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewFeedbackImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.decision, decision) ||
                other.decision == decision) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(
              other._improvementPoints,
              _improvementPoints,
            ) &&
            const DeepCollectionEquality().equals(
              other._highlights,
              _highlights,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reviewerId,
    decision,
    summary,
    const DeepCollectionEquality().hash(_improvementPoints),
    const DeepCollectionEquality().hash(_highlights),
    createdAt,
  );

  /// Create a copy of ReviewFeedback
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewFeedbackImplCopyWith<_$ReviewFeedbackImpl> get copyWith =>
      __$$ReviewFeedbackImplCopyWithImpl<_$ReviewFeedbackImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewFeedbackImplToJson(this);
  }
}

abstract class _ReviewFeedback extends ReviewFeedback {
  const factory _ReviewFeedback({
    required final String id,
    required final String reviewerId,
    required final ReviewDecision decision,
    required final String summary,
    final List<String> improvementPoints,
    final List<HighlightAnnotation> highlights,
    @TimestampDateTimeConverter() final DateTime? createdAt,
  }) = _$ReviewFeedbackImpl;
  const _ReviewFeedback._() : super._();

  factory _ReviewFeedback.fromJson(Map<String, dynamic> json) =
      _$ReviewFeedbackImpl.fromJson;

  @override
  String get id;
  @override
  String get reviewerId;
  @override
  ReviewDecision get decision;
  @override
  String get summary;
  @override
  List<String> get improvementPoints;
  @override
  List<HighlightAnnotation> get highlights;
  @override
  @TimestampDateTimeConverter()
  DateTime? get createdAt;

  /// Create a copy of ReviewFeedback
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewFeedbackImplCopyWith<_$ReviewFeedbackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiReviewResult _$AiReviewResultFromJson(Map<String, dynamic> json) {
  return _AiReviewResult.fromJson(json);
}

/// @nodoc
mixin _$AiReviewResult {
  String get modelId => throw _privateConstructorUsedError;
  double get qualityScore => throw _privateConstructorUsedError;
  double get plagiarismRisk => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  List<String> get strengths => throw _privateConstructorUsedError;
  List<String> get improvements => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AiReviewResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiReviewResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiReviewResultCopyWith<AiReviewResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiReviewResultCopyWith<$Res> {
  factory $AiReviewResultCopyWith(
    AiReviewResult value,
    $Res Function(AiReviewResult) then,
  ) = _$AiReviewResultCopyWithImpl<$Res, AiReviewResult>;
  @useResult
  $Res call({
    String modelId,
    double qualityScore,
    double plagiarismRisk,
    String summary,
    List<String> strengths,
    List<String> improvements,
    @TimestampDateTimeConverter() DateTime? createdAt,
  });
}

/// @nodoc
class _$AiReviewResultCopyWithImpl<$Res, $Val extends AiReviewResult>
    implements $AiReviewResultCopyWith<$Res> {
  _$AiReviewResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiReviewResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modelId = null,
    Object? qualityScore = null,
    Object? plagiarismRisk = null,
    Object? summary = null,
    Object? strengths = null,
    Object? improvements = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            modelId: null == modelId
                ? _value.modelId
                : modelId // ignore: cast_nullable_to_non_nullable
                      as String,
            qualityScore: null == qualityScore
                ? _value.qualityScore
                : qualityScore // ignore: cast_nullable_to_non_nullable
                      as double,
            plagiarismRisk: null == plagiarismRisk
                ? _value.plagiarismRisk
                : plagiarismRisk // ignore: cast_nullable_to_non_nullable
                      as double,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
            strengths: null == strengths
                ? _value.strengths
                : strengths // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            improvements: null == improvements
                ? _value.improvements
                : improvements // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AiReviewResultImplCopyWith<$Res>
    implements $AiReviewResultCopyWith<$Res> {
  factory _$$AiReviewResultImplCopyWith(
    _$AiReviewResultImpl value,
    $Res Function(_$AiReviewResultImpl) then,
  ) = __$$AiReviewResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String modelId,
    double qualityScore,
    double plagiarismRisk,
    String summary,
    List<String> strengths,
    List<String> improvements,
    @TimestampDateTimeConverter() DateTime? createdAt,
  });
}

/// @nodoc
class __$$AiReviewResultImplCopyWithImpl<$Res>
    extends _$AiReviewResultCopyWithImpl<$Res, _$AiReviewResultImpl>
    implements _$$AiReviewResultImplCopyWith<$Res> {
  __$$AiReviewResultImplCopyWithImpl(
    _$AiReviewResultImpl _value,
    $Res Function(_$AiReviewResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AiReviewResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modelId = null,
    Object? qualityScore = null,
    Object? plagiarismRisk = null,
    Object? summary = null,
    Object? strengths = null,
    Object? improvements = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$AiReviewResultImpl(
        modelId: null == modelId
            ? _value.modelId
            : modelId // ignore: cast_nullable_to_non_nullable
                  as String,
        qualityScore: null == qualityScore
            ? _value.qualityScore
            : qualityScore // ignore: cast_nullable_to_non_nullable
                  as double,
        plagiarismRisk: null == plagiarismRisk
            ? _value.plagiarismRisk
            : plagiarismRisk // ignore: cast_nullable_to_non_nullable
                  as double,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        strengths: null == strengths
            ? _value._strengths
            : strengths // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        improvements: null == improvements
            ? _value._improvements
            : improvements // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AiReviewResultImpl extends _AiReviewResult {
  const _$AiReviewResultImpl({
    required this.modelId,
    required this.qualityScore,
    required this.plagiarismRisk,
    required this.summary,
    final List<String> strengths = const [],
    final List<String> improvements = const [],
    @TimestampDateTimeConverter() this.createdAt,
  }) : _strengths = strengths,
       _improvements = improvements,
       super._();

  factory _$AiReviewResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiReviewResultImplFromJson(json);

  @override
  final String modelId;
  @override
  final double qualityScore;
  @override
  final double plagiarismRisk;
  @override
  final String summary;
  final List<String> _strengths;
  @override
  @JsonKey()
  List<String> get strengths {
    if (_strengths is EqualUnmodifiableListView) return _strengths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_strengths);
  }

  final List<String> _improvements;
  @override
  @JsonKey()
  List<String> get improvements {
    if (_improvements is EqualUnmodifiableListView) return _improvements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_improvements);
  }

  @override
  @TimestampDateTimeConverter()
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AiReviewResult(modelId: $modelId, qualityScore: $qualityScore, plagiarismRisk: $plagiarismRisk, summary: $summary, strengths: $strengths, improvements: $improvements, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiReviewResultImpl &&
            (identical(other.modelId, modelId) || other.modelId == modelId) &&
            (identical(other.qualityScore, qualityScore) ||
                other.qualityScore == qualityScore) &&
            (identical(other.plagiarismRisk, plagiarismRisk) ||
                other.plagiarismRisk == plagiarismRisk) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(
              other._strengths,
              _strengths,
            ) &&
            const DeepCollectionEquality().equals(
              other._improvements,
              _improvements,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    modelId,
    qualityScore,
    plagiarismRisk,
    summary,
    const DeepCollectionEquality().hash(_strengths),
    const DeepCollectionEquality().hash(_improvements),
    createdAt,
  );

  /// Create a copy of AiReviewResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiReviewResultImplCopyWith<_$AiReviewResultImpl> get copyWith =>
      __$$AiReviewResultImplCopyWithImpl<_$AiReviewResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AiReviewResultImplToJson(this);
  }
}

abstract class _AiReviewResult extends AiReviewResult {
  const factory _AiReviewResult({
    required final String modelId,
    required final double qualityScore,
    required final double plagiarismRisk,
    required final String summary,
    final List<String> strengths,
    final List<String> improvements,
    @TimestampDateTimeConverter() final DateTime? createdAt,
  }) = _$AiReviewResultImpl;
  const _AiReviewResult._() : super._();

  factory _AiReviewResult.fromJson(Map<String, dynamic> json) =
      _$AiReviewResultImpl.fromJson;

  @override
  String get modelId;
  @override
  double get qualityScore;
  @override
  double get plagiarismRisk;
  @override
  String get summary;
  @override
  List<String> get strengths;
  @override
  List<String> get improvements;
  @override
  @TimestampDateTimeConverter()
  DateTime? get createdAt;

  /// Create a copy of AiReviewResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiReviewResultImplCopyWith<_$AiReviewResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResearchPaper _$ResearchPaperFromJson(Map<String, dynamic> json) {
  return _ResearchPaper.fromJson(json);
}

/// @nodoc
mixin _$ResearchPaper {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String? get primaryReviewerId => throw _privateConstructorUsedError;
  List<String> get reviewerIds => throw _privateConstructorUsedError;
  String get abstractText => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get fileUrl => throw _privateConstructorUsedError;
  String? get storagePath => throw _privateConstructorUsedError;
  PaperFormat get format => throw _privateConstructorUsedError;
  PaperVisibility get visibility => throw _privateConstructorUsedError;
  PaperStatus get status => throw _privateConstructorUsedError;
  String get departmentId => throw _privateConstructorUsedError;
  String get subjectId => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<String> get keywords => throw _privateConstructorUsedError;
  List<String> get references => throw _privateConstructorUsedError;
  List<String> get coAuthors => throw _privateConstructorUsedError;
  List<ReviewFeedback> get reviews => throw _privateConstructorUsedError;
  AiReviewResult? get aiReview => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @TimestampDateTimeConverter()
  DateTime? get publishedAt => throw _privateConstructorUsedError;

  /// Serializes this ResearchPaper to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResearchPaper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResearchPaperCopyWith<ResearchPaper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResearchPaperCopyWith<$Res> {
  factory $ResearchPaperCopyWith(
    ResearchPaper value,
    $Res Function(ResearchPaper) then,
  ) = _$ResearchPaperCopyWithImpl<$Res, ResearchPaper>;
  @useResult
  $Res call({
    String id,
    String title,
    String ownerId,
    String? primaryReviewerId,
    List<String> reviewerIds,
    String abstractText,
    String? content,
    String? fileUrl,
    String? storagePath,
    PaperFormat format,
    PaperVisibility visibility,
    PaperStatus status,
    String departmentId,
    String subjectId,
    List<String> tags,
    List<String> keywords,
    List<String> references,
    List<String> coAuthors,
    List<ReviewFeedback> reviews,
    AiReviewResult? aiReview,
    @TimestampDateTimeConverter() DateTime? submittedAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
    @TimestampDateTimeConverter() DateTime? publishedAt,
  });

  $AiReviewResultCopyWith<$Res>? get aiReview;
}

/// @nodoc
class _$ResearchPaperCopyWithImpl<$Res, $Val extends ResearchPaper>
    implements $ResearchPaperCopyWith<$Res> {
  _$ResearchPaperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResearchPaper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? ownerId = null,
    Object? primaryReviewerId = freezed,
    Object? reviewerIds = null,
    Object? abstractText = null,
    Object? content = freezed,
    Object? fileUrl = freezed,
    Object? storagePath = freezed,
    Object? format = null,
    Object? visibility = null,
    Object? status = null,
    Object? departmentId = null,
    Object? subjectId = null,
    Object? tags = null,
    Object? keywords = null,
    Object? references = null,
    Object? coAuthors = null,
    Object? reviews = null,
    Object? aiReview = freezed,
    Object? submittedAt = freezed,
    Object? updatedAt = freezed,
    Object? publishedAt = freezed,
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
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            primaryReviewerId: freezed == primaryReviewerId
                ? _value.primaryReviewerId
                : primaryReviewerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            reviewerIds: null == reviewerIds
                ? _value.reviewerIds
                : reviewerIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            abstractText: null == abstractText
                ? _value.abstractText
                : abstractText // ignore: cast_nullable_to_non_nullable
                      as String,
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileUrl: freezed == fileUrl
                ? _value.fileUrl
                : fileUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            storagePath: freezed == storagePath
                ? _value.storagePath
                : storagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            format: null == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                      as PaperFormat,
            visibility: null == visibility
                ? _value.visibility
                : visibility // ignore: cast_nullable_to_non_nullable
                      as PaperVisibility,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PaperStatus,
            departmentId: null == departmentId
                ? _value.departmentId
                : departmentId // ignore: cast_nullable_to_non_nullable
                      as String,
            subjectId: null == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            keywords: null == keywords
                ? _value.keywords
                : keywords // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            references: null == references
                ? _value.references
                : references // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            coAuthors: null == coAuthors
                ? _value.coAuthors
                : coAuthors // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            reviews: null == reviews
                ? _value.reviews
                : reviews // ignore: cast_nullable_to_non_nullable
                      as List<ReviewFeedback>,
            aiReview: freezed == aiReview
                ? _value.aiReview
                : aiReview // ignore: cast_nullable_to_non_nullable
                      as AiReviewResult?,
            submittedAt: freezed == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            publishedAt: freezed == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of ResearchPaper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AiReviewResultCopyWith<$Res>? get aiReview {
    if (_value.aiReview == null) {
      return null;
    }

    return $AiReviewResultCopyWith<$Res>(_value.aiReview!, (value) {
      return _then(_value.copyWith(aiReview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResearchPaperImplCopyWith<$Res>
    implements $ResearchPaperCopyWith<$Res> {
  factory _$$ResearchPaperImplCopyWith(
    _$ResearchPaperImpl value,
    $Res Function(_$ResearchPaperImpl) then,
  ) = __$$ResearchPaperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String ownerId,
    String? primaryReviewerId,
    List<String> reviewerIds,
    String abstractText,
    String? content,
    String? fileUrl,
    String? storagePath,
    PaperFormat format,
    PaperVisibility visibility,
    PaperStatus status,
    String departmentId,
    String subjectId,
    List<String> tags,
    List<String> keywords,
    List<String> references,
    List<String> coAuthors,
    List<ReviewFeedback> reviews,
    AiReviewResult? aiReview,
    @TimestampDateTimeConverter() DateTime? submittedAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
    @TimestampDateTimeConverter() DateTime? publishedAt,
  });

  @override
  $AiReviewResultCopyWith<$Res>? get aiReview;
}

/// @nodoc
class __$$ResearchPaperImplCopyWithImpl<$Res>
    extends _$ResearchPaperCopyWithImpl<$Res, _$ResearchPaperImpl>
    implements _$$ResearchPaperImplCopyWith<$Res> {
  __$$ResearchPaperImplCopyWithImpl(
    _$ResearchPaperImpl _value,
    $Res Function(_$ResearchPaperImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResearchPaper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? ownerId = null,
    Object? primaryReviewerId = freezed,
    Object? reviewerIds = null,
    Object? abstractText = null,
    Object? content = freezed,
    Object? fileUrl = freezed,
    Object? storagePath = freezed,
    Object? format = null,
    Object? visibility = null,
    Object? status = null,
    Object? departmentId = null,
    Object? subjectId = null,
    Object? tags = null,
    Object? keywords = null,
    Object? references = null,
    Object? coAuthors = null,
    Object? reviews = null,
    Object? aiReview = freezed,
    Object? submittedAt = freezed,
    Object? updatedAt = freezed,
    Object? publishedAt = freezed,
  }) {
    return _then(
      _$ResearchPaperImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        primaryReviewerId: freezed == primaryReviewerId
            ? _value.primaryReviewerId
            : primaryReviewerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reviewerIds: null == reviewerIds
            ? _value._reviewerIds
            : reviewerIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        abstractText: null == abstractText
            ? _value.abstractText
            : abstractText // ignore: cast_nullable_to_non_nullable
                  as String,
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileUrl: freezed == fileUrl
            ? _value.fileUrl
            : fileUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        storagePath: freezed == storagePath
            ? _value.storagePath
            : storagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        format: null == format
            ? _value.format
            : format // ignore: cast_nullable_to_non_nullable
                  as PaperFormat,
        visibility: null == visibility
            ? _value.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as PaperVisibility,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PaperStatus,
        departmentId: null == departmentId
            ? _value.departmentId
            : departmentId // ignore: cast_nullable_to_non_nullable
                  as String,
        subjectId: null == subjectId
            ? _value.subjectId
            : subjectId // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        keywords: null == keywords
            ? _value._keywords
            : keywords // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        references: null == references
            ? _value._references
            : references // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        coAuthors: null == coAuthors
            ? _value._coAuthors
            : coAuthors // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        reviews: null == reviews
            ? _value._reviews
            : reviews // ignore: cast_nullable_to_non_nullable
                  as List<ReviewFeedback>,
        aiReview: freezed == aiReview
            ? _value.aiReview
            : aiReview // ignore: cast_nullable_to_non_nullable
                  as AiReviewResult?,
        submittedAt: freezed == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        publishedAt: freezed == publishedAt
            ? _value.publishedAt
            : publishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ResearchPaperImpl extends _ResearchPaper {
  const _$ResearchPaperImpl({
    required this.id,
    required this.title,
    required this.ownerId,
    this.primaryReviewerId,
    final List<String> reviewerIds = const [],
    required this.abstractText,
    this.content,
    this.fileUrl,
    this.storagePath,
    required this.format,
    required this.visibility,
    required this.status,
    required this.departmentId,
    required this.subjectId,
    final List<String> tags = const [],
    final List<String> keywords = const [],
    final List<String> references = const [],
    final List<String> coAuthors = const [],
    final List<ReviewFeedback> reviews = const [],
    this.aiReview,
    @TimestampDateTimeConverter() this.submittedAt,
    @TimestampDateTimeConverter() this.updatedAt,
    @TimestampDateTimeConverter() this.publishedAt,
  }) : _reviewerIds = reviewerIds,
       _tags = tags,
       _keywords = keywords,
       _references = references,
       _coAuthors = coAuthors,
       _reviews = reviews,
       super._();

  factory _$ResearchPaperImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResearchPaperImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String ownerId;
  @override
  final String? primaryReviewerId;
  final List<String> _reviewerIds;
  @override
  @JsonKey()
  List<String> get reviewerIds {
    if (_reviewerIds is EqualUnmodifiableListView) return _reviewerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviewerIds);
  }

  @override
  final String abstractText;
  @override
  final String? content;
  @override
  final String? fileUrl;
  @override
  final String? storagePath;
  @override
  final PaperFormat format;
  @override
  final PaperVisibility visibility;
  @override
  final PaperStatus status;
  @override
  final String departmentId;
  @override
  final String subjectId;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _keywords;
  @override
  @JsonKey()
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  final List<String> _references;
  @override
  @JsonKey()
  List<String> get references {
    if (_references is EqualUnmodifiableListView) return _references;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_references);
  }

  final List<String> _coAuthors;
  @override
  @JsonKey()
  List<String> get coAuthors {
    if (_coAuthors is EqualUnmodifiableListView) return _coAuthors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coAuthors);
  }

  final List<ReviewFeedback> _reviews;
  @override
  @JsonKey()
  List<ReviewFeedback> get reviews {
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviews);
  }

  @override
  final AiReviewResult? aiReview;
  @override
  @TimestampDateTimeConverter()
  final DateTime? submittedAt;
  @override
  @TimestampDateTimeConverter()
  final DateTime? updatedAt;
  @override
  @TimestampDateTimeConverter()
  final DateTime? publishedAt;

  @override
  String toString() {
    return 'ResearchPaper(id: $id, title: $title, ownerId: $ownerId, primaryReviewerId: $primaryReviewerId, reviewerIds: $reviewerIds, abstractText: $abstractText, content: $content, fileUrl: $fileUrl, storagePath: $storagePath, format: $format, visibility: $visibility, status: $status, departmentId: $departmentId, subjectId: $subjectId, tags: $tags, keywords: $keywords, references: $references, coAuthors: $coAuthors, reviews: $reviews, aiReview: $aiReview, submittedAt: $submittedAt, updatedAt: $updatedAt, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResearchPaperImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.primaryReviewerId, primaryReviewerId) ||
                other.primaryReviewerId == primaryReviewerId) &&
            const DeepCollectionEquality().equals(
              other._reviewerIds,
              _reviewerIds,
            ) &&
            (identical(other.abstractText, abstractText) ||
                other.abstractText == abstractText) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.storagePath, storagePath) ||
                other.storagePath == storagePath) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            const DeepCollectionEquality().equals(
              other._references,
              _references,
            ) &&
            const DeepCollectionEquality().equals(
              other._coAuthors,
              _coAuthors,
            ) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
            (identical(other.aiReview, aiReview) ||
                other.aiReview == aiReview) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    ownerId,
    primaryReviewerId,
    const DeepCollectionEquality().hash(_reviewerIds),
    abstractText,
    content,
    fileUrl,
    storagePath,
    format,
    visibility,
    status,
    departmentId,
    subjectId,
    const DeepCollectionEquality().hash(_tags),
    const DeepCollectionEquality().hash(_keywords),
    const DeepCollectionEquality().hash(_references),
    const DeepCollectionEquality().hash(_coAuthors),
    const DeepCollectionEquality().hash(_reviews),
    aiReview,
    submittedAt,
    updatedAt,
    publishedAt,
  ]);

  /// Create a copy of ResearchPaper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResearchPaperImplCopyWith<_$ResearchPaperImpl> get copyWith =>
      __$$ResearchPaperImplCopyWithImpl<_$ResearchPaperImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResearchPaperImplToJson(this);
  }
}

abstract class _ResearchPaper extends ResearchPaper {
  const factory _ResearchPaper({
    required final String id,
    required final String title,
    required final String ownerId,
    final String? primaryReviewerId,
    final List<String> reviewerIds,
    required final String abstractText,
    final String? content,
    final String? fileUrl,
    final String? storagePath,
    required final PaperFormat format,
    required final PaperVisibility visibility,
    required final PaperStatus status,
    required final String departmentId,
    required final String subjectId,
    final List<String> tags,
    final List<String> keywords,
    final List<String> references,
    final List<String> coAuthors,
    final List<ReviewFeedback> reviews,
    final AiReviewResult? aiReview,
    @TimestampDateTimeConverter() final DateTime? submittedAt,
    @TimestampDateTimeConverter() final DateTime? updatedAt,
    @TimestampDateTimeConverter() final DateTime? publishedAt,
  }) = _$ResearchPaperImpl;
  const _ResearchPaper._() : super._();

  factory _ResearchPaper.fromJson(Map<String, dynamic> json) =
      _$ResearchPaperImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get ownerId;
  @override
  String? get primaryReviewerId;
  @override
  List<String> get reviewerIds;
  @override
  String get abstractText;
  @override
  String? get content;
  @override
  String? get fileUrl;
  @override
  String? get storagePath;
  @override
  PaperFormat get format;
  @override
  PaperVisibility get visibility;
  @override
  PaperStatus get status;
  @override
  String get departmentId;
  @override
  String get subjectId;
  @override
  List<String> get tags;
  @override
  List<String> get keywords;
  @override
  List<String> get references;
  @override
  List<String> get coAuthors;
  @override
  List<ReviewFeedback> get reviews;
  @override
  AiReviewResult? get aiReview;
  @override
  @TimestampDateTimeConverter()
  DateTime? get submittedAt;
  @override
  @TimestampDateTimeConverter()
  DateTime? get updatedAt;
  @override
  @TimestampDateTimeConverter()
  DateTime? get publishedAt;

  /// Create a copy of ResearchPaper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResearchPaperImplCopyWith<_$ResearchPaperImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
