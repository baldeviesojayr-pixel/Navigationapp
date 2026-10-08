import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:studm/main.dart';

void main() {
  testWidgets('sign in opens the dashboard and drawer navigation works', (
    tester,
  ) async {
    await tester.pumpWidget(const StudentManagementApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'admin');
    await tester.enterText(find.byType(TextFormField).at(1), 'demo');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Total students'), findsOneWidget);
    expect(find.text('Good morning 👋'), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Attendance Tracker'));
    await tester.pumpAndSettle();

    expect(find.text('Today’s attendance'), findsOneWidget);
    expect(find.text('Present'), findsWidgets);
  });
  }
