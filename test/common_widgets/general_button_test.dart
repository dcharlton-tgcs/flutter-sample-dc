import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_flutter_app/common_widgets/general_button.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';

import '../helpers/pump_app.dart';

void main() {
  group('Testing buttons', () {
    testWidgets('Test GeneralButton', (tester) async {
      final log = <int>[];
      onPressed() {
        log.add(0);
      }

      await tester.pumpApp(
        Builder(
          builder: (BuildContext context) {
            var l10n = context.l10n;
            var button = GeneralButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 0, 31, 73),
              ),
              onPressed: onPressed,
              buttonHeight: 48,
              buttonWidth: 296,
              child: Text(l10n.basketCheckoutButtonText),
            );
            return button;
          },
        ),
      );
      var generalButton = find.byType(GeneralButton);
      await tester.tap(generalButton);
      expect(log.length, 1);
      await tester.tap(generalButton);
      await tester.tap(generalButton);
      expect(log.length, 3);
    });

    testWidgets('Test disabled GeneralButton', (tester) async {
      final log = <int>[];
      onPressed() {
        log.add(0);
      }

      await tester.pumpApp(
        Builder(
          builder: (BuildContext context) {
            var l10n = context.l10n;
            var button = GeneralButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 0, 31, 73),
              ),
              onPressed: onPressed,
              buttonHeight: 48,
              buttonWidth: 328,
              buttonDisabled: true,
              child: Text(l10n.basketCheckoutButtonText),
            );
            return button;
          },
        ),
      );
      var generalButton = find.byType(GeneralButton);
      await tester.tap(generalButton);
      expect(log.length, 0);
    });
  });
}
