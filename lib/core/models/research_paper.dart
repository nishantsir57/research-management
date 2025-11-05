import 'package:cloud_firestore/cloud_firestore.dart';

import 'ai_review_feedback.dart';
import 'paper_revision.dart';
import 'reviewer_highlight.dart';

enum PaperVisibility { public, private, connections }

extension PaperVisibilityX on PaperVisibility {
  String get name {
    switch (this) {
      case PaperVisibility.public:
        return 'public';
      case PaperVisibility.private:
        return 'private';
      case PaperVisibility.connections:
        return 'connections';
    }
  }

  static PaperVisibility fromName(String? value) {
    switch (value) {
      case 'private':
        return PaperVisibility.private;
      case 'connections':
        return PaperVisibility.connections;
      case 'public':
      default:
        return PaperVisibility.public;
    }
  }
}

enum PaperStatus {
  submitted,
  aiReview,
  underReview,
  reverted,
  approved,
  published,
}

extension PaperStatusX on PaperStatus {
  String get name {
    switch (this) {
      case PaperStatus.submitted:
        return 'submitted';
      case PaperStatus.aiReview:
        return 'ai_review';
      case PaperStatus.underReview:
        return 'under_review';
      case PaperStatus.reverted:
        return 'reverted';
      case PaperStatus.approved:
        return 'approved';
      case PaperStatus.published:
        return 'published';
    }
  }

  static PaperStatus fromName(String? value) {
    switch (value) {
      case 'ai_review':
        return PaperStatus.aiReview;
      case 'under_review':
        return PaperStatus.underReview;
      case 'reverted':
        return PaperStatus.reverted;
      case 'approved':
        return PaperStatus.approved;
      case 'published':
        return PaperStatus.published;
      case 'submitted':
      default:
        return PaperStatus.submitted;
    }
  }
}

class ResearchPaper {
  ResearchPaper({
    required this.id,
    required this.title,
    required this.authorId,
    required this.department,
    required this.subject,
    required this.visibility,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.assignedReviewerId,
    this.contentText,
    this.fileUrl,
    this.reviewerComments,
    this.reviewerHighlights = const [],
    this.studentResubmissions = const [],
    this.aiFeedback,
  });

  final String id;
  final String title;
  final String authorId;
  final String? assignedReviewerId;
  final String department;
  final String subject;
  final PaperVisibility visibility;
  final PaperStatus status;
  final String? contentText;
  final String? fileUrl;
  final String? reviewerComments;
  final List<ReviewerHighlight> reviewerHighlights;
  final List<PaperRevision> studentResubmissions;
  final AIReviewFeedback? aiFeedback;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasFile => fileUrl != null && fileUrl!.isNotEmpty;

  ResearchPaper copyWith({
    String? title,
    String? assignedReviewerId,
    String? department,
    String? subject,
    PaperVisibility? visibility,
    PaperStatus? status,
    String? contentText,
    String? fileUrl,
    String? reviewerComments,
    List<ReviewerHighlight>? reviewerHighlights,
    List<PaperRevision>? studentResubmissions,
    AIReviewFeedback? aiFeedback,
    DateTime? updatedAt,
  }) {
    return ResearchPaper(
      id: id,
      title: title ?? this.title,
      authorId: authorId,
      assignedReviewerId: assignedReviewerId ?? this.assignedReviewerId,
      department: department ?? this.department,
      subject: subject ?? this.subject,
      visibility: visibility ?? this.visibility,
      status: status ?? this.status,
      contentText: contentText ?? this.contentText,
      fileUrl: fileUrl ?? this.fileUrl,
      reviewerComments: reviewerComments ?? this.reviewerComments,
      reviewerHighlights: reviewerHighlights ?? this.reviewerHighlights,
      studentResubmissions: studentResubmissions ?? this.studentResubmissions,
      aiFeedback: aiFeedback ?? this.aiFeedback,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ResearchPaper.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ResearchPaper(
      id: doc.id,
      title: data['title'] as String? ?? '',
      authorId: data['authorId'] as String? ?? '',
      assignedReviewerId: data['assignedReviewerId'] as String?,
      department: data['department'] as String? ?? '',
      subject: data['subject'] as String? ?? '',
      visibility: PaperVisibilityX.fromName(data['visibility'] as String?),
      status: PaperStatusX.fromName(data['status'] as String?),
      contentText: data['contentText'] as String?,
      fileUrl: data['fileUrl'] as String?,
      reviewerComments: data['reviewerComments'] as String?,
      reviewerHighlights: (data['reviewerHighlights'] as List<dynamic>?)
              ?.map((item) => ReviewerHighlight.fromMap(item as Map<String, dynamic>))
              .toList() ??
          const [],
      studentResubmissions: (data['studentResubmissions'] as List<dynamic>?)
              ?.map((item) => PaperRevision.fromMap(item as Map<String, dynamic>))
              .toList() ??
          const [],
      aiFeedback: data['aiFeedback'] == null
          ? null
          : AIReviewFeedback.fromMap(data['aiFeedback'] as Map<String, dynamic>),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'authorId': authorId,
      'assignedReviewerId': assignedReviewerId,
      'department': department,
      'subject': subject,
      'visibility': visibility.name,
      'status': status.name,
      'contentText': contentText,
      'fileUrl': fileUrl,
      'reviewerComments': reviewerComments,
      'reviewerHighlights': reviewerHighlights.map((e) => e.toMap()).toList(),
      'studentResubmissions': studentResubmissions.map((e) => e.toMap()).toList(),
      if (aiFeedback != null) 'aiFeedback': aiFeedback!.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
