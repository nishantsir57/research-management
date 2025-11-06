// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiscussionThreadImpl _$$DiscussionThreadImplFromJson(
  Map<String, dynamic> json,
) => _$DiscussionThreadImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  createdBy: json['createdBy'] as String,
  description: json['description'] as String,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  departmentId: json['departmentId'] as String?,
  subjectId: json['subjectId'] as String?,
  isOpen: json['isOpen'] as bool? ?? true,
  participantCount: (json['participantCount'] as num?)?.toInt() ?? 0,
  createdAt: const TimestampDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampDateTimeConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$$DiscussionThreadImplToJson(
  _$DiscussionThreadImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'createdBy': instance.createdBy,
  'description': instance.description,
  'tags': instance.tags,
  'departmentId': instance.departmentId,
  'subjectId': instance.subjectId,
  'isOpen': instance.isOpen,
  'participantCount': instance.participantCount,
  'createdAt': const TimestampDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampDateTimeConverter().toJson(instance.updatedAt),
};

_$DiscussionCommentImpl _$$DiscussionCommentImplFromJson(
  Map<String, dynamic> json,
) => _$DiscussionCommentImpl(
  id: json['id'] as String,
  threadId: json['threadId'] as String,
  authorId: json['authorId'] as String,
  content: json['content'] as String,
  upvotes:
      (json['upvotes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  replies:
      (json['replies'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: const TimestampDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampDateTimeConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$$DiscussionCommentImplToJson(
  _$DiscussionCommentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'threadId': instance.threadId,
  'authorId': instance.authorId,
  'content': instance.content,
  'upvotes': instance.upvotes,
  'replies': instance.replies,
  'createdAt': const TimestampDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampDateTimeConverter().toJson(instance.updatedAt),
};
