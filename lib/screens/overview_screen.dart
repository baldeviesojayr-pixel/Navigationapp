import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/student.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({
    super.key,
    required this.students,
    required this.attendanceRate,
    required this.onOpenPage,
  });

  final List<Student> students;
  final double attendanceRate;
  final ValueChanged<int> onOpenPage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      children: [
        Text(
          'Good morning 👋',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Here’s what’s happening at your school today.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 760
                ? 3
                : constraints.maxWidth > 480
                    ? 2
                    : 1;
            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: columns == 1 ? 1.8 : 1.65,
              children: [
                _MetricCard(
                  title: 'Total students',
                  value: '${students.length}',
                  detail: 'Enrolled this year',
                  icon: Icons.people_alt_outlined,
                  tint: const Color(0xFFE7F3EF),
                  iconColor: const Color(0xFF176B61),
                ),
                _MetricCard(
                  title: 'Attendance rate',
                  value: '${attendanceRate.toStringAsFixed(0)}%',
                  detail: 'Present or late today',
                  icon: Icons.fact_check_outlined,
                  tint: const Color(0xFFEAF0FB),
                  iconColor: const Color(0xFF496BB2),
                ),
                _MetricCard(
                  title: 'Recent notices',
                  value: '${mockNotices.length}',
                  detail: 'Updates for your school',
                  icon: Icons.campaign_outlined,
                  tint: const Color(0xFFFFF2DE),
                  iconColor: const Color(0xFFB87616),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        _SectionHeader(
          title: 'Recent notices',
          actionLabel: 'View all',
          onPressed: () => onOpenPage(4),
        ),
        const SizedBox(height: 12),
        for (final notice in mockNotices.take(3)) ...[
          _NoticePreview(
            title: notice.title,
            subtitle: notice.description,
            date: notice.date,
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 20),
        _SectionHeader(
          title: 'Quick actions',
          actionLabel: 'Students',
          onPressed: () => onOpenPage(1),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _QuickAction(
              label: 'Mark attendance',
              icon: Icons.fact_check_outlined,
              onPressed: () => onOpenPage(2),
            ),
            _QuickAction(
              label: 'Enter marks',
              icon: Icons.edit_note_rounded,
              onPressed: () => onOpenPage(3),
            ),
            _QuickAction(
              label: 'View students',
              icon: Icons.people_alt_outlined,
              onPressed: () => onOpenPage(1),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    required this.tint,
    required this.iconColor,
  });

  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final Color tint;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: tint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 21),
                ),
                const Spacer(),
                Icon(
                  Icons.more_horiz_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  detail,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        TextButton(onPressed: onPressed, child: Text(actionLabel)),
      ],
    );
  }
}

class _NoticePreview extends StatelessWidget {
  const _NoticePreview({
    required this.title,
    required this.subtitle,
    required this.date,
  });

  final String title;
  final String subtitle;
  final String date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.notifications_active_outlined,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(date, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 19),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
