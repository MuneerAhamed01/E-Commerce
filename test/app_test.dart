import 'package:flutter_test/flutter_test.dart';
import 'package:trends/analytics/analytics.dart';
import 'package:trends/app/view/trends_app.dart';

void main() {
  testWidgets('Trends app renders home page', (tester) async {
    await tester.pumpWidget(
      const TrendsApp(
        analyticsRepository: NoOpAnalyticsRepository(),
      ),
    );

    expect(find.text('Trends'), findsOneWidget);
    expect(find.textContaining('Modern commerce'), findsOneWidget);
  });
}
