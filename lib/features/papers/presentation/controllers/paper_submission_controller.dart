import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/app_user.dart';
import '../../../../core/models/research_paper.dart';
import '../../../../core/providers/ai_providers.dart';
import '../../../../core/providers/document_parser_provider.dart';
import '../../../../core/services/ai_review_service.dart';
import '../../../admin/domain/settings_providers.dart';
import '../../data/research_paper_repository.dart';
import '../../domain/paper_assignment_provider.dart';
import '../../domain/paper_providers.dart';
import '../../../shared/data/storage_repository.dart';
import '../../../shared/domain/storage_providers.dart';

final paperSubmissionControllerProvider =
    AutoDisposeAsyncNotifierProvider<PaperSubmissionController, void>(
  PaperSubmissionController.new,
);

class PaperSubmissionController extends AutoDisposeAsyncNotifier<void> {
  late final ResearchPaperRepository _paperRepository;
  late final StorageRepository _storageRepository;
  late final AIReviewService? _aiReviewService;

  @override
  FutureOr<void> build() {
    _paperRepository = ref.read(researchPaperRepositoryProvider);
    _storageRepository = ref.read(storageRepositoryProvider);
    _aiReviewService = ref.read(aiReviewServiceProvider);
  }

  Future<void> submitPaper({
    required AppUser author,
    required String title,
    required String department,
    required String subject,
    required PaperVisibility visibility,
    String? plainText,
    File? file,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    state = const AsyncLoading();
    try {
      final settings = await ref.read(settingsRepositoryProvider).fetchSettings();
      String? uploadedUrl;
      String? contentText = plainText;

      final hasAttachment = file != null || fileBytes != null;
      if (hasAttachment) {
        var resolvedFileName = fileName ??
            (file != null
                ? file.uri.pathSegments.last
                : 'research-${DateTime.now().millisecondsSinceEpoch}');

        uploadedUrl = await _storageRepository.uploadResearchFile(
          userId: author.uid,
          fileName: resolvedFileName,
          file: file,
          bytes: fileBytes,
        );

        if (settings.aiReviewEnabled && _aiReviewService != null) {
          final parser = ref.read(documentParserProvider);
          try {
            if (file != null) {
              contentText = await parser.extractText(file);
            } else if (fileBytes != null) {
              contentText = await parser.extractTextFromBytes(
                fileBytes,
                fileName: resolvedFileName,
                fallbackReader: () async => String.fromCharCodes(fileBytes),
              );
            }
          } on UnsupportedError {
            // Ignore extraction failure for unsupported file types; fall back to plain text if any.
          }
        }
      }

      final paper = ResearchPaper(
        id: '',
        title: title,
        authorId: author.uid,
        assignedReviewerId: null,
        department: department,
        subject: subject,
        visibility: visibility,
        status: settings.aiReviewEnabled ? PaperStatus.aiReview : PaperStatus.submitted,
        contentText: contentText,
        fileUrl: uploadedUrl,
        reviewerComments: null,
        reviewerHighlights: const [],
        studentResubmissions: const [],
        aiFeedback: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final paperId = await _paperRepository.submitPaper(paper);

      if (settings.aiReviewEnabled && contentText != null && contentText.isNotEmpty) {
        final feedback = await _aiReviewService?.reviewPaper(content: contentText);
        if (feedback != null) {
          await _paperRepository.setAIReviewFeedback(
            paperId: paperId,
            feedback: feedback.toMap(),
          );
        }
      }

      final savedPaper = await _paperRepository.fetchPaper(paperId);
      if (savedPaper != null) {
        await ref.read(paperAssignmentServiceProvider).assignReviewer(savedPaper);
      }

      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> resubmitPaper({
    required AppUser author,
    required ResearchPaper paper,
    String? plainText,
    File? file,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    state = const AsyncLoading();
    try {
      final settings = await ref.read(settingsRepositoryProvider).fetchSettings();
      String? uploadedUrl = paper.fileUrl;
      String? contentText = plainText ?? paper.contentText;

      final hasAttachment = file != null || fileBytes != null;
      if (hasAttachment) {
        final resolvedFileName = fileName ??
            (file != null
                ? file.uri.pathSegments.last
                : 'revision-${DateTime.now().millisecondsSinceEpoch}');
        uploadedUrl = await _storageRepository.uploadResearchFile(
          userId: author.uid,
          fileName: resolvedFileName,
          file: file,
          bytes: fileBytes,
        );

        if (settings.aiReviewEnabled && _aiReviewService != null) {
          final parser = ref.read(documentParserProvider);
          try {
            if (file != null) {
              contentText = await parser.extractText(file);
            } else if (fileBytes != null) {
              contentText = await parser.extractTextFromBytes(
                fileBytes,
                fileName: resolvedFileName,
                fallbackReader: () async => String.fromCharCodes(fileBytes),
              );
            }
          } on UnsupportedError {
            // Ignore extraction failure; keep existing content if available.
          }
        }
      } else if (plainText != null) {
        contentText = plainText;
      }

      final revisionCount = paper.studentResubmissions.length + 1;
      final revisionEntry = {
        'version': revisionCount,
        'note': 'Resubmitted on ${DateTime.now().toIso8601String()}',
        'submittedAt': FieldValue.serverTimestamp(),
      };

      await _paperRepository.resubmitPaper(
        paperId: paper.id,
        contentText: contentText,
        fileUrl: uploadedUrl,
        revisionEntry: revisionEntry,
      );

      if (settings.aiReviewEnabled && contentText != null && contentText.isNotEmpty) {
        final feedback = await _aiReviewService?.reviewPaper(content: contentText);
        if (feedback != null) {
          await _paperRepository.setAIReviewFeedback(
            paperId: paper.id,
            feedback: feedback.toMap(),
          );
        }
      }

      final updatedPaper = await _paperRepository.fetchPaper(paper.id);
      if (updatedPaper != null) {
        await ref.read(paperAssignmentServiceProvider).assignReviewer(updatedPaper);
      }

      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
