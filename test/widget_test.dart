// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cabo_karte/features/app/app_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App init test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AppComponent());

    // Verify that our app starts with no games.
    expect(find.text('Neues Spiel'), findsOneWidget);
    expect(find.text('Spiel fortsetzen'), findsNothing);

    // tap on Neues Spiel to create a new game
    await tester.tap(find.bySemanticsLabel('Neues Spiel'));
    await tester.pumpAndSettle();

    expect(find.text('Neue Spieler anlegen'), findsOneWidget);
  });
}
