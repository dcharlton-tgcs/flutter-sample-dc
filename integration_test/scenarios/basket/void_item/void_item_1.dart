import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ui_flutter_app/common_widgets/navigation_bar.dart' as ecp_nav_bar;
import 'package:ui_flutter_app/main_integration.dart' as my_app;
import 'package:ui_flutter_app/pages/basket/components/bottom_sheet/quantity_keypad.dart';
import 'package:ui_peripheral_agent/ui_peripheral_agent.dart';

import '../../../library/test_library.dart';

void main() {
  group('Void Item:', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    var uiPeripheralAgent = UiPeripheralAgent();

    tearDown(() {
      disposePeripheralAgent(uiPeripheralAgent);
    });

    testWidgets("Can't change quantity for a voided item", (tester) async {
      // Fire off the main app and wait for all frames to render
      my_app.integMain(uiPeripheralAgent);
      await tester.pumpAndSettle();

      // [Step 001]: Login with valid keycloak user and password
      await loginAsUserSuccess(tester, LoginUser.username, LoginUser.password);

      // [Step 002]: add Burger
      expect(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey), findsOneWidget);
      await tester.tap(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      await keypadEntry(tester, '40123455');
      await keypadAdd(tester);

      // Ensure one item in basket
      expect(find.text('Burger'), findsOneWidget);
      expect(find.text('Items: 1'), findsOneWidget);

      // [Step 003]: add Milk
      expect(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey), findsOneWidget);
      await tester.tap(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      await keypadEntry(tester, '232323');
      await keypadAdd(tester);

      // Ensure two items in basket
      expect(find.text('Milk'), findsOneWidget);
      expect(find.text('Items: 2'), findsOneWidget);

      // [Step 004]: Swipe left on Milk and press Delete -> items will change to 1
      await voidItem(
        tester,
        1, // milk second item thus index 1, burger index 0
      );
      expect(find.text('Items: 1'), findsOneWidget);

      // [Step 005]: Tap on quantity on Milk -> nothing should happen
      await tester.tap(find.byKey(const Key(
        'quantityPadKey1', // milk second item thus 'quantityPadKey' + index '1'
      )));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(find.byType(QuantityKeypadSlider), findsNothing);

      // cancel checkout to finish
      await cancelCheckout(tester);
    });
  });
}
