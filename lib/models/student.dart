class Student {
  const Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.grade,
    required this.contact,
  });

  final String id;
  final String name;
  final String rollNumber;
  final String grade;
  final String contact;

  Student copyWith({
    String? name,
    String? rollNumber,
    String? grade,
    String? contact,
  }) {
    return Student(
      id: id,
      name: name ?? this.name,
      rollNumber: rollNumber ?? this.rollNumber,
      grade: grade ?? this.grade,
      contact: contact ?? this.contact,
    );
  }
}
