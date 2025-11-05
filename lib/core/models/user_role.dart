enum UserRole { student, reviewer, admin }

extension UserRoleX on UserRole {
  String get name {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.reviewer:
        return 'reviewer';
      case UserRole.admin:
        return 'admin';
    }
  }

  bool get isStudent => this == UserRole.student;
  bool get isReviewer => this == UserRole.reviewer;
  bool get isAdmin => this == UserRole.admin;

  static UserRole fromName(String? value) {
    switch (value) {
      case 'student':
        return UserRole.student;
      case 'reviewer':
        return UserRole.reviewer;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.student;
    }
  }
}
