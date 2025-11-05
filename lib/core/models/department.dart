class Department {
  Department({
    required this.id,
    required this.name,
    required this.subjects,
  });

  final String id;
  final String name;
  final List<String> subjects;

  factory Department.fromMap(String id, Map<String, dynamic>? data) {
    final snapshot = data ?? {};
    return Department(
      id: id,
      name: snapshot['name'] as String? ?? '',
      subjects: (snapshot['subjects'] as List<dynamic>?)
              ?.map((subject) => subject as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subjects': subjects,
    };
  }
}
