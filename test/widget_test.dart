// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:asufor_bornes/main.dart';

void main() {
  testWidgets('ASUFOR app starts on borne list', (WidgetTester tester) async {
    await tester.pumpWidget(const AsuforApp());
    await tester.pump();

    expect(find.text('ASUFOR'), findsOneWidget);
    expect(find.text('Liste des bornes'), findsOneWidget);
  });
}
