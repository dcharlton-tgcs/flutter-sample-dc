import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ui_flutter_app/common_widgets/general_button.dart';
import 'package:ui_flutter_app/common_widgets/keypad.dart';
import 'package:ui_flutter_app/common_widgets/keypad_label_field.dart';
import 'package:ui_flutter_app/main_integration.dart' as my_app;
import 'package:ui_flutter_app/pages/basket/basket.dart';
import 'package:ui_flutter_app/pages/basket/basket_view.dart';
import 'package:ui_flutter_app/pages/basket/components/bottom_sheet/quantity_keypad.dart';
import 'package:ui_flutter_app/common_widgets/navigation_bar.dart' as ecp_nav_bar;
import 'package:ui_peripheral_agent/ui_peripheral_agent.dart';

import '../../../library/test_library.dart';

void main() {
  const keypadAddButtonKey = Key('keypad_add_button');

  group("Void Item: ", () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    var uiPeripheralAgent = UiPeripheralAgent();

    tearDown(() {
      disposePeripheralAgent(uiPeripheralAgent);
    });

    testWidgets('Change qty, void and sell normal items', (tester) async {
      // Fire off the main app and wait for all frames to render
      my_app.integMain(uiPeripheralAgent);
      await tester.pumpAndSettle();

      // [Step 001]: Login with valid keycloak user and password
      await loginAsUserSuccess(tester, LoginUser.username, LoginUser.password);
      expect(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey), findsOneWidget);
      expect(find.byKey(BasketPage.cancelCheckoutKey), findsNothing);

      // [Step 002]: Tap Keypad and Add '40123455' ->
      //             Keypad is displayed
      //             'Burger' with 1 pcs, price 10 is added on basket
      await tester.tap(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      await keypadEntry(tester, '40123455');
      await keypadAdd(tester);

      // Get first item details
      Map<String, dynamic>? data = await getItemListData(tester, 0);
      expect(data!['quantity'], '1');
      expect(data['description'], 'Burger');

      expect(find.text('Items: 1'), findsOneWidget);
      expect(find.text('Total: € 10,00'), findsOneWidget);

      // [Step 003]: Change the qty at 0 for Burger and press Close ->
      //             Failure message is displayed
      //             Basket list is displayed
      await tester.tap(find.byKey(const Key(
        'quantityPadKey0',
      )));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(find.byType(QuantityKeypadSlider), findsOneWidget);
      await keypadEntry(tester, '0');
      await keypadAdd(tester);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Quantity cannot be zero'), findsOneWidget);
      // press the 'Close' button
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(
          tester
              .widget<GeneralButton>(find.byKey(keypadAddButtonKey))
              .buttonDisabled,
          isTrue);
      //close quantity slider by tapping outside slider
      await tester.tap(
          find.byKey(const Key(
            'quantityPadKey0',
          )),
          warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(find.byType(QuantityKeypadSlider), findsNothing);
      expect(find.byType(BasketView), findsOneWidget);

      //[Step 004]:Tap Single Add and SCAN item 3600542267724 ->
      //           'Garnier EAN 13' with 1 pcs, price 10 is added on basket

      // Setup and scan
      await scanBarcode(uiPeripheralAgent, 'EAN13', '3600542267724');
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      // Get second item details
      Map<String, dynamic>? data2 = await getItemListData(tester, 1);
      expect(data2!['quantity'], '1');
      expect(data2['description'], 'Garnier EAN 13');

      expect(find.text('Items: 2'), findsOneWidget);
      expect(find.text('Total: € 20,00'), findsOneWidget);

      //[Step 005]:Change the quantity at 3 for 'Burger'
      await tester.tap(find.byKey(const Key(
        'quantityPadKey0',
      )));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(find.byType(QuantityKeypadSlider), findsOneWidget);

      // Expect quantity slider desc label be 'burger'
      expect(
          (tester.firstWidget(find.byType(KeypadLabelField))
                  as KeypadLabelField)
              .descText,
          'Burger');

      // Expect quantity to be 1
      expect(
          (tester.firstWidget(find.byType(KeypadLabelField))
                  as KeypadLabelField)
              .fieldText,
          '1');

      // Change quantity to 3
      expect(find.byType(Keypad), findsOneWidget);
      await keypadEntry(tester, '3');
      await keypadAdd(tester);
      expect(find.text('Items: 4'), findsOneWidget);
      expect(find.text('Total: € 40,00'), findsOneWidget);

      //[Step 006]: Delete 'Garnier EAN 13'
      await voidItem(
        tester,
        1, // Garnier is second item thus index 1
      );
      expect(find.text('Items: 3'), findsOneWidget);
      expect(find.text('Total: € 30,00'), findsOneWidget);

      //[Step 007]: Pay with card and take receipt
      await checkoutPayReceipt(tester, false, true);

      //Make sure basket is empty to confirm transaction complete
      expect(find.text('Items: 0'), findsOneWidget);
    });
  });
}
