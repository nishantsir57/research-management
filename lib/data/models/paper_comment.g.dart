// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paper_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaperCommentImpl _$$PaperCommentImplFromJson(Map<String, dynamic> json) =>
    _$PaperCommentImpl(
      id: json['id'] as String,
      paperId: json['paperId'] as String,
      authorId: json['authorId'] as String,
      content: json['content'] as String,
      isReviewerOnly: json['isReviewerOnly'] as bool? ?? false,
      likedBy:
          (json['likedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: const TimestampDateTimeConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampDateTimeConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$PaperCommentImplToJson(
  _$PaperCommentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'paperId': instance.paperId,
  'authorId': instance.authorId,
  'content': instance.content,
  'isReviewerOnly': instance.isReviewerOnly,
  'likedBy': instance.likedBy,
  'createdAt': const TimestampDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampDateTimeConverter().toJson(instance.updatedAt),
};
