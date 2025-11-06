import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/converters.dart';

part 'paper_comment.freezed.dart';
part 'paper_comment.g.dart';

@freezed
class PaperComment with _$PaperComment {
  const PaperComment._();

  const factory PaperComment({
    required String id,
    required String paperId,
    required String authorId,
    required String content,
    @Default(false) bool isReviewerOnly,
    @Default([]) List<String> likedBy,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
  }) = _PaperComment;

  factory PaperComment.fromJson(Map<String, dynamic> json) => _$PaperCommentFromJson(json);
}
