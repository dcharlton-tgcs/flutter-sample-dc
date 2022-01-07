import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ui_flutter_app/common_widgets/general_button.dart';
import 'package:ui_flutter_app/common_widgets/navigation_bar.dart'
    as ecp_nav_bar;
import 'package:ui_flutter_app/main_integration.dart' as my_app;
import 'package:ui_flutter_app/pages/basket/basket.dart';
import 'package:ui_flutter_app/pages/basket/components/checkout_area.dart';
import 'package:ui_peripheral_agent/ui_peripheral_agent.dart';

import '../../../library/test_library.dart';

void main() {
  group("Void Transaction: ", () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    var uiPeripheralAgent = UiPeripheralAgent();

    tearDown(() {
      disposePeripheralAgent(uiPeripheralAgent);
    });

    testWidgets('Void an order that has one item', (tester) async {
      // Fire off the main app and wait for all frames to render
      my_app.integMain(uiPeripheralAgent);
      await tester.pumpAndSettle();

      // [Step 001]: Login with valid keycloak credentials
      //             basket screen is displayed
      //             item count and total are 0
      //             'Trash' icon is not visible
      //             'Proceed to checkout" is disabled
      await loginAsUserSuccess(tester, LoginUser.username, LoginUser.password);
      expect(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey),
          findsOneWidget);
      expect(find.text('Items: 0'), findsOneWidget);
      expect(find.text('Total: € 0,00'), findsOneWidget);
      expect(find.byKey(BasketPage.cancelCheckoutKey), findsNothing);
      expect(
          tester
              .widget<GeneralButton>(
                  find.byKey(CheckoutAreaWidget.proceedToCheckoutKey))
              .buttonDisabled,
          isTrue);

      // [Step 002]: Tap Keypad and Add '232323'
      //             'Milk' is added on the list
      //             'Trash' icon is visible
      await tester.tap(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      await keypadEntry(tester, '232323');
      await keypadAdd(tester);
      // Get first item details
      Map<String, dynamic>? data = await getItemListData(tester, 0);
      expect(data!['quantity'], '1');
      expect(data['description'], 'Milk');
      expect(find.byKey(BasketPage.cancelCheckoutKey), findsOneWidget);

      // [Step 003]: Tap 'Trash' icon and select 'No'
      //             basket screen is displayed
      //             'Milk' is on the list and item count is 1
      await tester.tap(find.byKey(BasketPage.cancelCheckoutKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(find.text('Items: 1'), findsOneWidget);
      expect(find.text('Milk'), findsOneWidget);

      // [Step 004]: Tap 'Trash' icon and select 'Yes'
      //             basket page resets
      //            'Trash' icon is disabled
      await tester.tap(find.byKey(BasketPage.cancelCheckoutKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(find.text('Items: 0'), findsOneWidget);
      expect(find.text('Total: € 0,00'), findsOneWidget);
      expect(find.byKey(BasketPage.cancelCheckoutKey), findsNothing);
    });
  });
}
