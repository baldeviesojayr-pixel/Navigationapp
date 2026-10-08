import 'package:flutter/material.dart';

import '../models/student.dart';
import 'dashboard_screen.dart';

class AttendanceTrackerScreen extends StatelessWidget {
  const AttendanceTrackerScreen({
    super.key,
    required this.students,
    required this.attendance,
    required this.onChanged,
  });

  final List<Student> students;
  final Map<String, AttendanceStatus> attendance;
  final void Function(String studentId, AttendanceStatus status) onChanged;

  @override
  Widget build(BuildContext context) {
    final present =
        attendance.values.where((status) => status == AttendanceStatus.present).length;
    final absent =
        attendance.values.where((status) => status == AttendanceStatus.absent).length;
    final late =
        attendance.values.where((status) => status == AttendanceStatus.late).length;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        Text(
          'Today’s attendance',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Monday, October 7, 2024 · Tap a status to update it',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _CountChip(label: 'Present', count: present, color: const Color(0xFF267A55)),
            _CountChip(label: 'Absent', count: absent, color: const Color(0xFFB74848)),
            _CountChip(label: 'Late', count: late, color: const Color(0xFFB87616)),
          ],
        ),
        const SizedBox(height: 18),
        if (students.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No students to take attendance for.')),
            ),
          )
        else
          for (final student in students) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      child: Text(
                        student.name.isEmpty
                            ? '?'
                            : student.name.trim()[0].toUpperCase(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: theme.textTheme.titleSmall?.copyWith(
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
                    const SizedBox(width: 8),
                    DropdownButton<AttendanceStatus>(
                      value: attendance[student.id] ?? AttendanceStatus.absent,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(12),
                      onChanged: (status) {
                        if (status != null) onChanged(student.id, status);
                      },
                      items: AttendanceStatus.values
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(
                                _label(status),
                                style: TextStyle(
                                  color: _color(status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 9),
          ],
      ],
    );
  }

  static String _label(AttendanceStatus status) => switch (status) {
        AttendanceStatus.present => 'Present',
        AttendanceStatus.absent => 'Absent',
        AttendanceStatus.late => 'Late',
      };

  static Color _color(AttendanceStatus status) => switch (status) {
        AttendanceStatus.present => const Color(0xFF267A55),
        AttendanceStatus.absent => const Color(0xFFB74848),
        AttendanceStatus.late => const Color(0xFFB87616),
      };
}

class _CountChip extends StatelessWidget {
  const _CountChip({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(
        radius: 12,
        backgroundColor: color.withValues(alpha: 0.12),
        child: Text(
          '$count',
          style: TextStyle(color: color, fontSize: 12),
        ),
      ),
      label: Text(label),
      side: BorderSide(color: color.withValues(alpha: 0.2)),
      backgroundColor: color.withValues(alpha: 0.04),
    );
  }
}
