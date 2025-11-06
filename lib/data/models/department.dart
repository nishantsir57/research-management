import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/converters.dart';

part 'department.freezed.dart';
part 'department.g.dart';

@freezed
class Department with _$Department {
  const Department._();

  const factory Department({
    required String id,
    required String name,
    @Default([]) List<Subject> subjects,
    @Default(true) bool isActive,
    @TimestampDateTimeConverter() DateTime? createdAt,
    @TimestampDateTimeConverter() DateTime? updatedAt,
  }) = _Department;

  factory Department.fromJson(Map<String, dynamic> json) => _$DepartmentFromJson(json);
}

@freezed
class Subject with _$Subject {
  const Subject._();

  const factory Subject({
    required String id,
    required String name,
    String? departmentId,
    @Default(true) bool isActive,
  }) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);
}
