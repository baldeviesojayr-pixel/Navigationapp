import 'package:flutter/material.dart';

import '../models/student.dart';

class StudentProfilesScreen extends StatelessWidget {
  const StudentProfilesScreen({
    super.key,
    required this.students,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  final List<Student> students;
  final ValueChanged<Student> onAdd;
  final ValueChanged<Student> onUpdate;
  final ValueChanged<Student> onDelete;

  Future<void> _openForm(BuildContext context, {Student? student}) async {
    final result = await showDialog<Student>(
      context: context,
      builder: (_) => _StudentFormDialog(student: student),
    );
    if (result == null) return;
    if (student == null) {
      onAdd(result);
    } else {
      onUpdate(result);
    }
  }

  Future<void> _confirmDelete(BuildContext context, Student student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove student?'),
        content: Text('This will remove ${student.name} from the student list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) onDelete(student);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student directory',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${students.length} students · Manage student records',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => _openForm(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add student'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (students.isEmpty)
          const _EmptyStudents()
        else
          for (final student in students) ...[
            _StudentCard(
              student: student,
              onEdit: () => _openForm(context, student: student),
              onDelete: () => _confirmDelete(context, student),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _StudentCard extends StatelessWidget {
  const _StudentCard({
    required this.student,
    required this.onEdit,
    required this.onDelete,
  });

  final Student student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = student.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.secondaryContainer,
              child: Text(
                initials,
                style: TextStyle(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${student.rollNumber}  ·  ${student.grade}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    student.contact,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Student actions',
              onSelected: (action) {
                if (action == 'edit') onEdit();
                if (action == 'delete') onDelete();
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStudents extends StatelessWidget {
  const _EmptyStudents();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.people_outline_rounded, size: 40),
            const SizedBox(height: 10),
            Text('No students yet', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            const Text('Add a student to get started.'),
          ],
        ),
      ),
    );
  }
}

class _StudentFormDialog extends StatefulWidget {
  const _StudentFormDialog({this.student});

  final Student? student;

  @override
  State<_StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<_StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _rollController;
  late final TextEditingController _gradeController;
  late final TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    final student = widget.student;
    _nameController = TextEditingController(text: student?.name);
    _rollController = TextEditingController(text: student?.rollNumber);
    _gradeController = TextEditingController(text: student?.grade);
    _contactController = TextEditingController(text: student?.contact);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    _gradeController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final existing = widget.student;
    Navigator.of(context).pop(
      Student(
        id: existing?.id ?? 'student-${DateTime.now().microsecondsSinceEpoch}',
        name: _nameController.text.trim(),
        rollNumber: _rollController.text.trim(),
        grade: _gradeController.text.trim(),
        contact: _contactController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.student == null ? 'Add student' : 'Edit student'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _rollController,
                decoration: const InputDecoration(labelText: 'Roll number'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _gradeController,
                decoration: const InputDecoration(labelText: 'Grade'),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Contact / email'),
                validator: _required,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
