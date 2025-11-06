import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/converters.dart';
import '../../features/auth/domain/auth_role.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String id,
    required String email,
    required String displayName,
    required AuthRole role,
    String? departmentId,
    List<String>? subjectIds,
    String? photoUrl,
    String? bio,
    @Default([]) List<String> connections,
    @Default(false) bool isBlocked,
    @Default(false) bool isReviewerApproved,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  bool get isAdmin => role == AuthRole.admin;
  bool get isReviewer => role == AuthRole.reviewer;
  bool get isStudent => role == AuthRole.student;
}
