import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_role.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    required this.department,
    required this.subjects,
    required this.approvedReviewer,
    required this.approvedAdmin,
    required this.blocked,
    required this.createdAt,
    required this.fcmTokens,
  });

  final String uid;
  final String fullName;
  final String email;
  final UserRole role;
  final String? department;
  final List<String> subjects;
  final bool approvedReviewer;
  final bool approvedAdmin;
  final bool blocked;
  final DateTime createdAt;
  final List<String> fcmTokens;

  bool get isReviewerPending => role.isReviewer && !approvedReviewer;
  bool get isAdminPending => role.isAdmin && !approvedAdmin;

  AppUser copyWith({
    String? fullName,
    String? email,
    UserRole? role,
    String? department,
    List<String>? subjects,
    bool? approvedReviewer,
    bool? approvedAdmin,
    bool? blocked,
    DateTime? createdAt,
    List<String>? fcmTokens,
  }) {
    return AppUser(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      department: department ?? this.department,
      subjects: subjects ?? this.subjects,
      approvedReviewer: approvedReviewer ?? this.approvedReviewer,
      approvedAdmin: approvedAdmin ?? this.approvedAdmin,
      blocked: blocked ?? this.blocked,
      createdAt: createdAt ?? this.createdAt,
      fcmTokens: fcmTokens ?? this.fcmTokens,
    );
  }

  factory AppUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AppUser(
      uid: doc.id,
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: UserRoleX.fromName(data['role'] as String?),
      department: data['department'] as String?,
      subjects: (data['subjects'] as List<dynamic>?)
              ?.map((subject) => subject as String)
              .toList() ??
          const [],
      approvedReviewer: data['approvedReviewer'] as bool? ?? false,
      approvedAdmin: data['approvedAdmin'] as bool? ?? false,
      blocked: data['blocked'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      fcmTokens: (data['fcmTokens'] as List<dynamic>?)
              ?.map((token) => token as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'role': role.name,
      'department': department,
      'subjects': subjects,
      'approvedReviewer': approvedReviewer,
      'approvedAdmin': approvedAdmin,
      'blocked': blocked,
      'createdAt': Timestamp.fromDate(createdAt),
      'fcmTokens': fcmTokens,
    };
  }
}
