import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cabo_karte/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify that our app starts with no games.
      expect(find.text('Neues Spiel'), findsOneWidget);
      expect(find.text('Spiel fortsetzen'), findsNothing);

      // Finds the floating action button to tap on.
      final Finder fab = find.bySemanticsLabel('Neues Spiel');

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();

      expect(find.text('Neue Spieler anlegen'), findsOneWidget);
    });
  });
}
