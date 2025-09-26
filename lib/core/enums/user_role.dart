enum UserRole {
  student,
  teacher,
}

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.student:
        return "Student";
      case UserRole.teacher:
        return "Teacher";
    }
  }
}
