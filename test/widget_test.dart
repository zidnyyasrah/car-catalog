import 'package:flutter_test/flutter_test.dart';
import 'package:carcat/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const CarCatApp());
    expect(find.text('CarCat'), findsOneWidget);
  });
}
