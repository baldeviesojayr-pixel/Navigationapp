import 'package:flutter/material.dart';

import '../models/student.dart';

class MarksTrackerScreen extends StatelessWidget {
  const MarksTrackerScreen({
    super.key,
    required this.students,
    required this.marks,
    required this.onSave,
  });

  static const subjects = ['Mathematics', 'Science', 'English'];

  final List<Student> students;
  final Map<String, List<double>> marks;
  final void Function(String studentId, List<double> values) onSave;

  double get _classAverage {
    if (students.isEmpty) return 0;
    final allScores = students
        .expand((student) => marks[student.id] ?? const <double>[])
        .toList();
    if (allScores.isEmpty) return 0;
    return allScores.reduce((a, b) => a + b) / allScores.length;
  }

  Future<void> _editMarks(BuildContext context, Student student) async {
    final currentMarks = marks[student.id] ?? const [0.0, 0.0, 0.0];
    final result = await showDialog<List<double>>(
      context: context,
      builder: (_) => _MarksDialog(student: student, initialMarks: currentMarks),
    );
    if (result != null) onSave(student.id, result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        Text(
          'Marks & performance',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Review subject scores, averages, and estimated GPA.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.auto_graph_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Class average', style: theme.textTheme.bodyMedium),
                      Text(
                        '${_classAverage.toStringAsFixed(1)}%',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '3 subjects',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (students.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No student marks to display.')),
            ),
          )
        else
          for (final student in students)
            _StudentMarksCard(
              student: student,
              scores: marks[student.id] ?? const [0.0, 0.0, 0.0],
              onEdit: () => _editMarks(context, student),
            ),
      ],
    );
  }

  static double gpaForAverage(double average) {
    if (average >= 90) return 4.0;
    if (average >= 80) return 3.0 + (average - 80) / 10;
    if (average >= 70) return 2.0 + (average - 70) / 10;
    if (average >= 60) return 1.0 + (average - 60) / 10;
    return average / 60;
  }
}

class _StudentMarksCard extends StatelessWidget {
  const _StudentMarksCard({
    required this.student,
    required this.scores,
    required this.onEdit,
  });

  final Student student;
  final List<double> scores;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final average =
        scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
    final gpa = MarksTrackerScreen.gpaForAverage(average);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
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
                      Text(
                        '${student.rollNumber} · ${student.grade}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${average.toStringAsFixed(1)}%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'GPA ${gpa.toStringAsFixed(2)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  tooltip: 'Edit marks',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: List.generate(MarksTrackerScreen.subjects.length, (index) {
                final score = index < scores.length ? scores[index] : 0.0;
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        MarksTrackerScreen.subjects[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${score.toStringAsFixed(0)} / 100',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarksDialog extends StatefulWidget {
  const _MarksDialog({required this.student, required this.initialMarks});

  final Student student;
  final List<double> initialMarks;

  @override
  State<_MarksDialog> createState() => _MarksDialogState();
}

class _MarksDialogState extends State<_MarksDialog> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      MarksTrackerScreen.subjects.length,
      (index) => TextEditingController(
        text: (index < widget.initialMarks.length
                ? widget.initialMarks[index]
                : 0)
            .toStringAsFixed(0),
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _validateScore(String? value) {
    final score = double.tryParse(value ?? '');
    if (score == null || score < 0 || score > 100) {
      return 'Enter a score from 0 to 100';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _controllers.map((controller) => double.parse(controller.text)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit marks · ${widget.student.name}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            MarksTrackerScreen.subjects.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextFormField(
                controller: _controllers[index],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: MarksTrackerScreen.subjects[index],
                  suffixText: '/ 100',
                ),
                validator: _validateScore,
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save marks')),
      ],
    );
  }
}
