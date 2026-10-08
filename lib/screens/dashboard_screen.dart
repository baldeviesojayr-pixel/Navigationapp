import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/student.dart';
import 'attendance_tracker_screen.dart';
import 'marks_tracker_screen.dart';
import 'notice_board_screen.dart';
import 'overview_screen.dart';
import 'student_profiles_screen.dart';

enum AttendanceStatus { present, absent, late }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.userName,
    required this.onSignOut,
  });

  final String userName;
  final VoidCallback onSignOut;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final List<Student> _students = List<Student>.of(mockStudents);
  final Map<String, AttendanceStatus> _attendance = {
    's1': AttendanceStatus.present,
    's2': AttendanceStatus.present,
    's3': AttendanceStatus.late,
    's4': AttendanceStatus.present,
    's5': AttendanceStatus.absent,
    's6': AttendanceStatus.present,
    's7': AttendanceStatus.present,
    's8': AttendanceStatus.present,
  };
  final Map<String, List<double>> _marks = {
    's1': [92, 88, 95],
    's2': [84, 79, 87],
    's3': [96, 91, 89],
    's4': [78, 85, 81],
    's5': [89, 93, 86],
    's6': [91, 87, 94],
    's7': [73, 80, 77],
    's8': [86, 90, 82],
  };

  static const _pages = [
    'Overview',
    'Student Profiles',
    'Attendance Tracker',
    'Marks Tracker',
    'Notice Board',
  ];

  static const _icons = [
    Icons.space_dashboard_outlined,
    Icons.people_alt_outlined,
    Icons.fact_check_outlined,
    Icons.bar_chart_rounded,
    Icons.campaign_outlined,
  ];

  double get _attendanceRate {
    if (_students.isEmpty) return 0;
    final attended = _students.where((student) {
      final status = _attendance[student.id];
      return status == AttendanceStatus.present || status == AttendanceStatus.late;
    }).length;
    return attended / _students.length * 100;
  }

  void _setAttendance(String studentId, AttendanceStatus status) {
    setState(() => _attendance[studentId] = status);
  }

  void _saveMarks(String studentId, List<double> values) {
    setState(() => _marks[studentId] = values);
  }

  void _addStudent(Student student) {
    setState(() {
      _students.add(student);
      _attendance[student.id] = AttendanceStatus.present;
      _marks[student.id] = [0, 0, 0];
    });
  }

  void _updateStudent(Student updatedStudent) {
    setState(() {
      final index = _students.indexWhere((student) => student.id == updatedStudent.id);
      if (index != -1) _students[index] = updatedStudent;
    });
  }

  void _deleteStudent(Student student) {
    setState(() {
      _students.removeWhere((item) => item.id == student.id);
      _attendance.remove(student.id);
      _marks.remove(student.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageViews = [
      OverviewScreen(
        students: _students,
        attendanceRate: _attendanceRate,
        onOpenPage: (index) => setState(() => _selectedIndex = index),
      ),
      StudentProfilesScreen(
        students: _students,
        onAdd: _addStudent,
        onUpdate: _updateStudent,
        onDelete: _deleteStudent,
      ),
      AttendanceTrackerScreen(
        students: _students,
        attendance: _attendance,
        onChanged: _setAttendance,
      ),
      MarksTrackerScreen(students: _students, marks: _marks, onSave: _saveMarks),
      const NoticeBoardScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedIndex]),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => setState(() => _selectedIndex = 4),
            icon: const Badge(
              smallSize: 8,
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 20, 24),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Campusly',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        Text(
                          'STUDENT PORTAL',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    letterSpacing: 1.1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 16, 8),
                child: Text(
                  'MENU',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 1,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
              for (var index = 0; index < _pages.length; index++)
                ListTile(
                  leading: Icon(_icons[index]),
                  title: Text(_pages[index]),
                  selected: _selectedIndex == index,
                  selectedTileColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() => _selectedIndex = index);
                  },
                ),
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      child: Text(_initials(widget.userName)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Administrator',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Sign out',
                      onPressed: widget.onSignOut,
                      icon: const Icon(Icons.logout_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: pageViews),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'A';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
