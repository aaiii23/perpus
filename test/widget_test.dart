import 'package:flutter_test/flutter_test.dart';
import 'package:perpus_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const PerpusApp());
    expect(find.byType(PerpusApp), findsOneWidget);
  });
}
