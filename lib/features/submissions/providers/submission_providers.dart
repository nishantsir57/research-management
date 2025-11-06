import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/app_user.dart';
import '../../../data/models/paper_comment.dart';
import '../../../data/models/research_paper.dart';
import '../../auth/providers/auth_controller.dart';
import '../domain/submission_repository.dart';

final studentPapersProvider = StreamProvider<List<ResearchPaper>>((ref) {
  final user = ref.watch(currentAppUserProvider);
  final repository = ref.watch(submissionRepositoryProvider);
  if (user == null) return const Stream.empty();
  return repository.watchStudentPapers(user.id);
});

final allPapersProvider = StreamProvider<List<ResearchPaper>>((ref) {
  final repository = ref.watch(submissionRepositoryProvider);
  return repository.watchAllPapers();
});

final publishedPapersProvider = StreamProvider.family<List<ResearchPaper>, PublishedPaperFilter>((ref, filter) {
  final repository = ref.watch(submissionRepositoryProvider);
  return repository.watchPublishedPapers(
    departmentId: filter.departmentId,
    subjectId: filter.subjectId,
    visibility: filter.visibility,
    afterDate: filter.afterDate,
  );
});

final reviewerAssignmentsProvider = StreamProvider<List<ResearchPaper>>((ref) {
  final repository = ref.watch(submissionRepositoryProvider);
  final user = ref.watch(currentAppUserProvider);
  if (user == null) return const Stream.empty();
  return repository.watchReviewerAssignments(user.id);
});

final reviewerHistoryProvider = StreamProvider<List<ResearchPaper>>((ref) {
  final repository = ref.watch(submissionRepositoryProvider);
  final user = ref.watch(currentAppUserProvider);
  if (user == null) return const Stream.empty();
  return repository.watchReviewerHistory(user.id);
});

final paperCommentsProvider = StreamProvider.family<List<PaperComment>, String>((ref, paperId) {
  final repository = ref.watch(submissionRepositoryProvider);
  return repository.watchPaperComments(paperId);
});

final paperProvider = StreamProvider.family<ResearchPaper?, String>((ref, paperId) {
  final repository = ref.watch(submissionRepositoryProvider);
  return repository.watchPaperById(paperId);
});

final submitPaperControllerProvider = StateNotifierProvider.autoDispose<SubmitPaperController, AsyncValue<ResearchPaper?>>((ref) {
  final repository = ref.watch(submissionRepositoryProvider);
  final user = ref.watch(currentAppUserProvider);
  return SubmitPaperController(repository: repository, currentUser: user);
});

class SubmitPaperController extends StateNotifier<AsyncValue<ResearchPaper?>> {
  SubmitPaperController({
    required SubmissionRepository repository,
    required AppUser? currentUser,
  })  : _repository = repository,
        _currentUser = currentUser,
        super(const AsyncValue.data(null));

  final SubmissionRepository _repository;
  final AppUser? _currentUser;

  Future<void> submit({
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
    if (_currentUser == null) {
      state = const AsyncValue.error('Not authenticated', StackTrace.empty);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final paper = await _repository.submitPaper(
        student: _currentUser!,
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
      state = AsyncValue.data(paper);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
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

  @override
  int get hashCode => Object.hash(
        departmentId,
        subjectId,
        visibility,
        afterDate,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PublishedPaperFilter &&
        other.departmentId == departmentId &&
        other.subjectId == subjectId &&
        other.visibility == visibility &&
        other.afterDate == afterDate;
  }
}
