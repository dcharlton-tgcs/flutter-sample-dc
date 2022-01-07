import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/main_integration.dart' as my_app;
import 'package:ui_flutter_app/pages/basket/components/bottom_sheet/quantity_keypad.dart';
import 'package:ui_flutter_app/pages/basket/components/checkout_area.dart';
import 'package:ui_peripheral_agent/ui_peripheral_agent.dart';

import '../../../library/test_library.dart';

void main() {
  group("Linked Item: ", () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    var uiPeripheralAgent = UiPeripheralAgent();

    tearDown(() {
      disposePeripheralAgent(uiPeripheralAgent);
    });

    testWidgets('Voided item with linked item remains voided', (tester) async {
      // Fire off the main app and wait for all frames to render
      my_app.integMain(uiPeripheralAgent);
      await tester.pumpAndSettle();

      // [Step 001]: Login with valid keycloak user and password
      await loginAsUserSuccess(tester, LoginUser.username, LoginUser.password);

      // [Step 002]: Tap Single add -> tap SCAN -> scan 89852323

      // Setup and scan
      scanBarcode(uiPeripheralAgent, 'EAN8', '89852323');
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      // [Step 003]: Swipe left and tap Delete -> item is on the basket list,
      //             item count is 0, total is 0,
      //             'Proceed to checkout' is disabled
      await voidItem(tester, 0);
      expect(find.text('Items: 0'), findsOneWidget);
      expect(find.text('Total: € 0,00'), findsOneWidget);

      expect(
          tester
              .widget<GeneralButton>(
                  find.byKey(CheckoutAreaWidget.proceedToCheckoutKey))
              .buttonDisabled,
          isTrue);

      // [Step 004]: Tap Single add -> tap SCAN -> scan 89852316
      scanBarcode(uiPeripheralAgent, 'EAN8', '89852316');
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      // [Step 005]: Swipe left and tap Delete -> item is on the basket list,
      //             item count is 0, total is 0,
      //             'Proceed to checkout' is disabled
      await voidItem(tester, 1);
      expect(find.text('Items: 0'), findsOneWidget);
      expect(find.text('Total: € 0,00'), findsOneWidget);

      expect(
          tester
              .widget<GeneralButton>(
                  find.byKey(CheckoutAreaWidget.proceedToCheckoutKey))
              .buttonDisabled,
          isTrue);

      // [Step 006]: Tap first item quantity button -> nothing happens
      await tester.tap(find.byKey(const Key(
        'quantityPadKey0',
      )));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(find.byType(QuantityKeypadSlider), findsNothing);

      // [Step 007]: Swipe left on second item-> nothing happens
      await tester.drag(
          find.byKey(const Key('slidableKey1')), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(find.byType(SlidableAction), findsNothing);

      // cancel checkout to finish
      await cancelCheckout(tester);
    }, timeout: const Timeout.factor(1.0));
  });
}
