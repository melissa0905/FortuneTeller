// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:fortune_teller/main.dart';

void main() {
  testWidgets('Fortune Teller app loads and shows reading options', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FortuneTellerApp());

    // Verify that the app title appears
    expect(find.text('Fortune Teller'), findsOneWidget);
    expect(find.text('Tarot Reading'), findsOneWidget);

    // Verify that all three reading options are shown
    expect(find.text('Tek Kart'), findsOneWidget);
    expect(find.text('Üçlü Çekiş'), findsOneWidget);
    expect(find.text('Yedili Çekiş'), findsOneWidget);

    // Verify that the numbers are displayed
    expect(find.text('1'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
  });
}
