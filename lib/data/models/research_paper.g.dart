// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'research_paper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HighlightAnnotationImpl _$$HighlightAnnotationImplFromJson(
  Map<String, dynamic> json,
) => _$HighlightAnnotationImpl(
  id: json['id'] as String,
  reviewerId: json['reviewerId'] as String,
  startOffset: (json['startOffset'] as num).toInt(),
  endOffset: (json['endOffset'] as num).toInt(),
  colorHex: json['colorHex'] as String,
  note: json['note'] as String?,
  createdAt: const TimestampDateTimeConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$$HighlightAnnotationImplToJson(
  _$HighlightAnnotationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'reviewerId': instance.reviewerId,
  'startOffset': instance.startOffset,
  'endOffset': instance.endOffset,
  'colorHex': instance.colorHex,
  'note': instance.note,
  'createdAt': const TimestampDateTimeConverter().toJson(instance.createdAt),
};

_$ReviewFeedbackImpl _$$ReviewFeedbackImplFromJson(Map<String, dynamic> json) =>
    _$ReviewFeedbackImpl(
      id: json['id'] as String,
      reviewerId: json['reviewerId'] as String,
      decision: $enumDecode(_$ReviewDecisionEnumMap, json['decision']),
      summary: json['summary'] as String,
      improvementPoints:
          (json['improvementPoints'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      highlights:
          (json['highlights'] as List<dynamic>?)
              ?.map(
                (e) => HighlightAnnotation.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      createdAt: const TimestampDateTimeConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$ReviewFeedbackImplToJson(
  _$ReviewFeedbackImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'reviewerId': instance.reviewerId,
  'decision': _$ReviewDecisionEnumMap[instance.decision]!,
  'summary': instance.summary,
  'improvementPoints': instance.improvementPoints,
  'highlights': instance.highlights,
  'createdAt': const TimestampDateTimeConverter().toJson(instance.createdAt),
};

const _$ReviewDecisionEnumMap = {
  ReviewDecision.approve: 'approve',
  ReviewDecision.requestChanges: 'requestChanges',
  ReviewDecision.reject: 'reject',
};

_$AiReviewResultImpl _$$AiReviewResultImplFromJson(Map<String, dynamic> json) =>
    _$AiReviewResultImpl(
      modelId: json['modelId'] as String,
      qualityScore: (json['qualityScore'] as num).toDouble(),
      plagiarismRisk: (json['plagiarismRisk'] as num).toDouble(),
      summary: json['summary'] as String,
      strengths:
          (json['strengths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      improvements:
          (json['improvements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: const TimestampDateTimeConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$AiReviewResultImplToJson(
  _$AiReviewResultImpl instance,
) => <String, dynamic>{
  'modelId': instance.modelId,
  'qualityScore': instance.qualityScore,
  'plagiarismRisk': instance.plagiarismRisk,
  'summary': instance.summary,
  'strengths': instance.strengths,
  'improvements': instance.improvements,
  'createdAt': const TimestampDateTimeConverter().toJson(instance.createdAt),
};

_$ResearchPaperImpl _$$ResearchPaperImplFromJson(
  Map<String, dynamic> json,
) => _$ResearchPaperImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  ownerId: json['ownerId'] as String,
  primaryReviewerId: json['primaryReviewerId'] as String?,
  reviewerIds:
      (json['reviewerIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  abstractText: json['abstractText'] as String,
  content: json['content'] as String?,
  fileUrl: json['fileUrl'] as String?,
  storagePath: json['storagePath'] as String?,
  format: $enumDecode(_$PaperFormatEnumMap, json['format']),
  visibility: $enumDecode(_$PaperVisibilityEnumMap, json['visibility']),
  status: $enumDecode(_$PaperStatusEnumMap, json['status']),
  departmentId: json['departmentId'] as String,
  subjectId: json['subjectId'] as String,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  keywords:
      (json['keywords'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  references:
      (json['references'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  coAuthors:
      (json['coAuthors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  reviews:
      (json['reviews'] as List<dynamic>?)
          ?.map((e) => ReviewFeedback.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  aiReview: json['aiReview'] == null
      ? null
      : AiReviewResult.fromJson(json['aiReview'] as Map<String, dynamic>),
  submittedAt: const TimestampDateTimeConverter().fromJson(json['submittedAt']),
  updatedAt: const TimestampDateTimeConverter().fromJson(json['updatedAt']),
  publishedAt: const TimestampDateTimeConverter().fromJson(json['publishedAt']),
);

Map<String, dynamic> _$$ResearchPaperImplToJson(
  _$ResearchPaperImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'ownerId': instance.ownerId,
  'primaryReviewerId': instance.primaryReviewerId,
  'reviewerIds': instance.reviewerIds,
  'abstractText': instance.abstractText,
  'content': instance.content,
  'fileUrl': instance.fileUrl,
  'storagePath': instance.storagePath,
  'format': _$PaperFormatEnumMap[instance.format]!,
  'visibility': _$PaperVisibilityEnumMap[instance.visibility]!,
  'status': _$PaperStatusEnumMap[instance.status]!,
  'departmentId': instance.departmentId,
  'subjectId': instance.subjectId,
  'tags': instance.tags,
  'keywords': instance.keywords,
  'references': instance.references,
  'coAuthors': instance.coAuthors,
  'reviews': instance.reviews,
  'aiReview': instance.aiReview,
  'submittedAt': const TimestampDateTimeConverter().toJson(
    instance.submittedAt,
  ),
  'updatedAt': const TimestampDateTimeConverter().toJson(instance.updatedAt),
  'publishedAt': const TimestampDateTimeConverter().toJson(
    instance.publishedAt,
  ),
};

const _$PaperFormatEnumMap = {
  PaperFormat.pdf: 'pdf',
  PaperFormat.doc: 'doc',
  PaperFormat.text: 'text',
};

const _$PaperVisibilityEnumMap = {
  PaperVisibility.public: 'public',
  PaperVisibility.private: 'private',
  PaperVisibility.connections: 'connections',
};

const _$PaperStatusEnumMap = {
  PaperStatus.draft: 'draft',
  PaperStatus.submitted: 'submitted',
  PaperStatus.underReview: 'underReview',
  PaperStatus.aiReview: 'aiReview',
  PaperStatus.revisionsRequested: 'revisionsRequested',
  PaperStatus.approved: 'approved',
  PaperStatus.published: 'published',
  PaperStatus.rejected: 'rejected',
};
