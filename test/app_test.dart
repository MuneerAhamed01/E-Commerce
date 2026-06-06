import 'package:flutter_test/flutter_test.dart';
import 'package:trends/analytics/analytics.dart';
import 'package:trends/app/view/trends_app.dart';

void main() {
  testWidgets('Trends app renders design system showcase', (tester) async {
    await tester.pumpWidget(
      const TrendsApp(
        analyticsRepository: NoOpAnalyticsRepository(),
      ),
    );

    expect(find.text('Design System'), findsOneWidget);
    expect(find.textContaining('Aura Couture'), findsOneWidget);
    expect(find.text('Color palette'), findsOneWidget);
  });
}
