import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../data/models/app_user.dart';
import '../../../data/models/paper_comment.dart';
import '../../../data/models/research_paper.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/domain/auth_role.dart';
import '../domain/submission_repository.dart';

class SubmissionController extends GetxController {
  SubmissionController({SubmissionRepository? repository})
      : _repository = repository ?? SubmissionRepository();

  final SubmissionRepository _repository;
  final AuthController _authController = Get.find<AuthController>();

  final RxList<ResearchPaper> studentPapers = <ResearchPaper>[].obs;
  final RxList<ResearchPaper> publishedPapers = <ResearchPaper>[].obs;
  final RxList<ResearchPaper> reviewerAssignments = <ResearchPaper>[].obs;
  final RxList<ResearchPaper> reviewerHistory = <ResearchPaper>[].obs;

  final Rx<PublishedPaperFilter> publishedFilter = PublishedPaperFilter().obs;

  StreamSubscription<List<ResearchPaper>>? _studentSub;
  StreamSubscription<List<ResearchPaper>>? _publishedSub;
  StreamSubscription<List<ResearchPaper>>? _reviewerAssignedSub;
  StreamSubscription<List<ResearchPaper>>? _reviewerHistorySub;

  @override
  void onInit() {
    super.onInit();
    ever<AppUser?>(_authController.currentUser, (_) => _restartStreams());
    _restartStreams();
  }

  Future<ResearchPaper> submitPaper({
    required String title,
    required String abstractText,
    required PaperFormat format,
    required PaperVisibility visibility,
    required String departmentId,
    required String subjectId,
    String? content,
    File? file,
    Uint8List? fileBytes,
    String? fileName,
    List<String>? tags,
    List<String>? keywords,
  }) async {
    final user = _authController.currentUser.value;
    if (user == null) {
      throw StateError('Not authenticated');
    }
    return _repository.submitPaper(
      student: user,
      title: title,
      abstractText: abstractText,
      content: content,
      file: file,
      fileBytes: fileBytes,
      fileName: fileName,
      format: format,
      visibility: visibility,
      departmentId: departmentId,
      subjectId: subjectId,
      tags: tags,
      keywords: keywords,
    );
  }

  Future<ResearchPaper> resubmitPaper({
    required ResearchPaper paper,
    String? updatedContent,
    File? newFile,
    Uint8List? newFileBytes,
    String? newFileName,
  }) async {
    return _repository.resubmitPaper(
      paper: paper,
      updatedContent: updatedContent,
      newFile: newFile,
      newFileBytes: newFileBytes,
      newFileName: newFileName,
    );
  }

  Future<void> updatePaperVisibility({
    required String paperId,
    required PaperVisibility visibility,
  }) =>
      _repository.updatePaperVisibility(paperId: paperId, visibility: visibility);

  Future<void> addComment({
    required String paperId,
    required String content,
    bool reviewerOnly = false,
  }) async {
    final user = _authController.currentUser.value;
    if (user == null) throw StateError('Not authenticated');
    await _repository.addPaperComment(
      paperId: paperId,
      authorId: user.id,
      content: content,
      reviewerOnly: reviewerOnly,
    );
  }

  Future<void> toggleCommentLike({
    required String paperId,
    required String commentId,
    required bool like,
  }) async {
    final user = _authController.currentUser.value;
    if (user == null) throw StateError('Not authenticated');
    await _repository.toggleCommentLike(
      paperId: paperId,
      commentId: commentId,
      userId: user.id,
      like: like,
    );
  }

  Future<void> recordReviewDecision({
    required ResearchPaper paper,
    required ReviewDecision decision,
    required String summary,
    List<String>? improvementPoints,
    List<HighlightAnnotation>? highlights,
  }) async {
    final user = _authController.currentUser.value;
    if (user == null) throw StateError('Not authenticated');
    await _repository.recordReviewDecision(
      paper: paper,
      reviewerId: user.id,
      decision: decision,
      summary: summary,
      improvementPoints: improvementPoints,
      highlights: highlights,
    );
  }

  void updatePublishedFilter(PublishedPaperFilter filter) {
    publishedFilter.value = filter;
    _startPublishedStream();
  }

  Stream<List<PaperComment>> commentsStream(String paperId) =>
      _repository.watchPaperComments(paperId);

  Stream<ResearchPaper?> paperStream(String paperId) =>
      _repository.watchPaperById(paperId);

  void _restartStreams() {
    _studentSub?.cancel();
    _publishedSub?.cancel();
    _reviewerAssignedSub?.cancel();
    _reviewerHistorySub?.cancel();

    studentPapers.clear();
    reviewerAssignments.clear();
    reviewerHistory.clear();

    final user = _authController.currentUser.value;
    if (user == null) {
      publishedPapers.clear();
      return;
    }

    if (user.role == AuthRole.student) {
      _studentSub = _repository.watchStudentPapers(user.id).listen(studentPapers.assignAll);
      _startPublishedStream();
      unawaited(_repository.ensureStudentPipeline(user.id));
    } else if (user.role == AuthRole.reviewer) {
      _reviewerAssignedSub = _repository
          .watchReviewerAssignments(user.id)
          .listen(reviewerAssignments.assignAll);
      _reviewerHistorySub =
          _repository.watchReviewerHistory(user.id).listen(reviewerHistory.assignAll);
      _startPublishedStream();
    } else if (user.role == AuthRole.admin) {
      _studentSub = _repository.watchAllPapers().listen(allPapersListener);
      _startPublishedStream();
    }
  }

  void _startPublishedStream() {
    final filter = publishedFilter.value;
    _publishedSub?.cancel();
    _publishedSub = _repository
        .watchPublishedPapers(
          departmentId: filter.departmentId,
          subjectId: filter.subjectId,
          visibility: filter.visibility,
          afterDate: filter.afterDate,
        )
        .listen(publishedPapers.assignAll);
  }

  void allPapersListener(List<ResearchPaper> papers) {
    // For admin dashboards; overrides student list intentionally.
    studentPapers.assignAll(papers);
  }

  @override
  void onClose() {
    _studentSub?.cancel();
    _publishedSub?.cancel();
    _reviewerAssignedSub?.cancel();
    _reviewerHistorySub?.cancel();
    super.onClose();
  }
}

class PublishedPaperFilter {
  PublishedPaperFilter({
    this.departmentId,
    this.subjectId,
    this.visibility,
    this.afterDate,
  });

  final String? departmentId;
  final String? subjectId;
  final PaperVisibility? visibility;
  final DateTime? afterDate;

  PublishedPaperFilter copyWith({
    String? departmentId,
    String? subjectId,
    PaperVisibility? visibility,
    DateTime? afterDate,
  }) {
    return PublishedPaperFilter(
      departmentId: departmentId ?? this.departmentId,
      subjectId: subjectId ?? this.subjectId,
      visibility: visibility ?? this.visibility,
      afterDate: afterDate ?? this.afterDate,
    );
  }
}
