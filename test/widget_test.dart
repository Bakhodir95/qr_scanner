import 'package:flutter_test/flutter_test.dart';
import 'package:qr_scanner/main.dart';

void main() {
  testWidgets("My App Test", (tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text("'Scanerlash"), findsOneWidget);
  });
}
