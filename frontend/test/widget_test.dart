import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/app.dart';

void main() {
  testWidgets('HELPHA app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const HelphaApp());

    expect(find.text('HELPHA'), findsOneWidget);
  });
}