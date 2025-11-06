import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/converters.dart';

part 'discussion.freezed.dart';
part 'discussion.g.dart';

@freezed
class DiscussionThread with _$DiscussionThread {
  const DiscussionThread._();

  const factory DiscussionThread({
    required String id,
    required String title,
    required String createdBy,
    required String description,
    @Default([]) List<String> tags,
    String? departmentId,
    String? subjectId,
    @Default(true) bool isOpen,
    @Default(0) int participantCount,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
  }) = _DiscussionThread;

  factory DiscussionThread.fromJson(Map<String, dynamic> json) =>
      _$DiscussionThreadFromJson(json);
}

@freezed
class DiscussionComment with _$DiscussionComment {
  const DiscussionComment._();

  const factory DiscussionComment({
    required String id,
    required String threadId,
    required String authorId,
    required String content,
    @Default([]) List<String> upvotes,
    @Default([]) List<String> replies,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
  }) = _DiscussionComment;

  factory DiscussionComment.fromJson(Map<String, dynamic> json) =>
      _$DiscussionCommentFromJson(json);
}
