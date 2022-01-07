import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_flutter_app/common_widgets/general_alert_dialog.dart';

import '../helpers/pump_app.dart';

void main() {
  group('Testing alert dialog', () {
    testWidgets('Test GeneralAlertDialog two buttons', (tester) async {
      final primarylog = <int>[];
      final secondarylog = <int>[];

      primaryOnPressed() {
        primarylog.add(0);
      }

      secondaryOnPressed() {
        secondarylog.add(0);
      }

      await tester.pumpApp(
        Builder(
          builder: (BuildContext context) {
            var alert = GeneralAlertDialog(
              label: 'Test two buttons',
              content: 'This alert dialog contains two buttons',
              primaryButtonText: 'primary',
              primaryOnPressed: primaryOnPressed,
              secondaryButtonText: 'secondary',
              secondaryOnPressed: secondaryOnPressed,
            );
            return alert;
          },
        ),
      );
      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey),
          findsOneWidget);

      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      expect(primarylog.length, 1);
      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      expect(primarylog.length, 2);

      await tester.tap(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey));
      await tester.tap(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey));
      expect(secondarylog.length, 2);
      await tester.tap(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey));
      expect(secondarylog.length, 3);
    });

    testWidgets('Test GeneralAlertDialog one button', (tester) async {
      final primarylog = <int>[];

      primaryOnPressed() {
        primarylog.add(0);
      }

      await tester.pumpApp(
        Builder(
          builder: (BuildContext context) {
            var alert = GeneralAlertDialog(
              label: 'Test one button',
              content: 'This alert dialog contains one button',
              primaryButtonText: 'primary',
              primaryOnPressed: primaryOnPressed,
            );
            return alert;
          },
        ),
      );
      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.secondaryAlertButtonKey), findsNothing);

      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      expect(primarylog.length, 1);
      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      expect(primarylog.length, 2);
    });
  });
}
