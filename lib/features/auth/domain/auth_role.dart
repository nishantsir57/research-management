enum AuthRole {
  student,
  reviewer,
  admin;

  String get label {
    switch (this) {
      case AuthRole.student:
        return 'Student';
      case AuthRole.reviewer:
        return 'Reviewer';
      case AuthRole.admin:
        return 'Admin';
    }
  }

  static AuthRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'student':
        return AuthRole.student;
      case 'reviewer':
        return AuthRole.reviewer;
      case 'admin':
        return AuthRole.admin;
      default:
        return AuthRole.student;
    }
  }

  String get firestoreValue => name;
}
