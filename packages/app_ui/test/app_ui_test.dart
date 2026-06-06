import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ComponentShowcasePage renders key sections', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const ComponentShowcasePage(),
      ),
    );

    expect(find.text('Design System'), findsOneWidget);
    expect(find.text('Color palette'), findsOneWidget);
    expect(find.text('Typography'), findsOneWidget);
  });
}
