import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/converters.dart';

part 'research_paper.freezed.dart';
part 'research_paper.g.dart';

enum PaperVisibility {
  public,
  private,
  connections;

  String get label {
    switch (this) {
      case PaperVisibility.public:
        return 'Public';
      case PaperVisibility.private:
        return 'Private';
      case PaperVisibility.connections:
        return 'Connections only';
    }
  }
}

enum PaperFormat { pdf, doc, text }

enum PaperStatus {
  draft,
  submitted,
  underReview,
  aiReview,
  revisionsRequested,
  approved,
  published,
  rejected;

  String get label {
    switch (this) {
      case PaperStatus.draft:
        return 'Draft';
      case PaperStatus.submitted:
        return 'Submitted';
      case PaperStatus.underReview:
        return 'Under Review';
      case PaperStatus.aiReview:
        return 'AI Review';
      case PaperStatus.revisionsRequested:
        return 'Revisions Requested';
      case PaperStatus.approved:
        return 'Approved';
      case PaperStatus.published:
        return 'Published';
      case PaperStatus.rejected:
        return 'Rejected';
    }
  }
}

enum ReviewDecision { approve, requestChanges, reject }

@freezed
class HighlightAnnotation with _$HighlightAnnotation {
  const HighlightAnnotation._();

  const factory HighlightAnnotation({
    required String id,
    required String reviewerId,
    required int startOffset,
    required int endOffset,
    required String colorHex,
    String? note,
    @TimestampDateTimeConverter() DateTime? createdAt,
  }) = _HighlightAnnotation;

  factory HighlightAnnotation.fromJson(Map<String, dynamic> json) =>
      _$HighlightAnnotationFromJson(json);
}

@freezed
class ReviewFeedback with _$ReviewFeedback {
  const ReviewFeedback._();

  const factory ReviewFeedback({
    required String id,
    required String reviewerId,
    required ReviewDecision decision,
    required String summary,
    @Default([]) List<String> improvementPoints,
    @Default([]) List<HighlightAnnotation> highlights,
    @TimestampDateTimeConverter() DateTime? createdAt,
  }) = _ReviewFeedback;

  factory ReviewFeedback.fromJson(Map<String, dynamic> json) =>
      _$ReviewFeedbackFromJson(json);
}

@freezed
class AiReviewResult with _$AiReviewResult {
  const AiReviewResult._();

  const factory AiReviewResult({
    required String modelId,
    required double qualityScore,
    required double plagiarismRisk,
    required String summary,
    @Default([]) List<String> strengths,
    @Default([]) List<String> improvements,
    @TimestampDateTimeConverter() DateTime? createdAt,
  }) = _AiReviewResult;

  factory AiReviewResult.fromJson(Map<String, dynamic> json) =>
      _$AiReviewResultFromJson(json);
}

@freezed
class ResearchPaper with _$ResearchPaper {
  const ResearchPaper._();

  const factory ResearchPaper({
    required String id,
    required String title,
    required String ownerId,
    String? primaryReviewerId,
    @Default([]) List<String> reviewerIds,
    required String abstractText,
    String? content,
    String? fileUrl,
    String? storagePath,
    required PaperFormat format,
    required PaperVisibility visibility,
    required PaperStatus status,
    required String departmentId,
    required String subjectId,
    @Default([]) List<String> tags,
    @Default([]) List<String> keywords,
    @Default([]) List<String> references,
    @Default([]) List<String> coAuthors,
    @Default([]) List<ReviewFeedback> reviews,
    AiReviewResult? aiReview,
    @TimestampDateTimeConverter() DateTime? submittedAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
    @TimestampDateTimeConverter() DateTime? publishedAt,
  }) = _ResearchPaper;

  factory ResearchPaper.fromJson(Map<String, dynamic> json) =>
      _$ResearchPaperFromJson(json);

  bool get isPublished => status == PaperStatus.published;
  bool get isAwaitingReview => status == PaperStatus.submitted || status == PaperStatus.underReview;
  bool get canResubmit => status == PaperStatus.revisionsRequested || status == PaperStatus.rejected;
}
