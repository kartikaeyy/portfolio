import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/portfolio_app.dart';

void main() {
  testWidgets('Portfolio app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    expect(find.text('Hey'), findsOneWidget);
  });
}
