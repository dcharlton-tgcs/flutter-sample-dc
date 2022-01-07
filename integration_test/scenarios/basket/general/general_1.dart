import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ui_flutter_app/common_widgets/general_alert_dialog.dart';
import 'package:ui_flutter_app/main_integration.dart' as my_app;
import 'package:ui_peripheral_agent/ui_peripheral_agent.dart';
import 'package:ui_flutter_app/common_widgets/navigation_bar.dart' as ecp_nav_bar;

import '../../../library/test_library.dart';

void main() {
  group("General: ", () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Item not found is not added to basket list', (tester) async {
      // Fire off the main app and wait for all frames to render
      my_app.integMain(UiPeripheralAgent());
      await tester.pumpAndSettle();

      // [Step 001]: Login with valid keycloak user and password
      await loginAsUserSuccess(tester, LoginUser.username, LoginUser.password);

      // Locate and press the keypad button
      expect(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey), findsOneWidget);
      await tester.tap(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      // [Step 002]: Keypad ->Type '999999' ->Tap Add
      await keypadEntry(tester, '999999');
      await keypadAdd(tester);

      // [Step 003]: Check that unknown item '999999' appears on alert dialog
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Unknown item - 999999'), findsOneWidget);

      // press the 'close' button
      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      // [Step 004]: Confirm no items added to basket
      Map<String, dynamic>? data = await getItemListData(tester, 0);
      expect(data, isNull);
      expect(find.text('Items: 0'), findsOneWidget);
    }, timeout: const Timeout.factor(1.0));
  });
}
