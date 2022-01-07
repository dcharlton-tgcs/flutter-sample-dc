import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ui_flutter_app/common_widgets/navigation_bar.dart'
    as ecp_nav_bar;
import 'package:ui_flutter_app/main_integration.dart' as my_app;
import 'package:ui_peripheral_agent/ui_peripheral_agent.dart';

import '../../../library/test_library.dart';

void main() {
  group("Linked Item:", () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    var uiPeripheralAgent = UiPeripheralAgent();

    tearDown(() {
      disposePeripheralAgent(uiPeripheralAgent);
    });

    testWidgets('Sell item with linked item and item with deposit linked item',
        (tester) async {
      // Fire off the main app and wait for all frames to render
      my_app.integMain(uiPeripheralAgent);
      await tester.pumpAndSettle();

      // [Step 001]: Login with valid keycloak user and password
      await loginAsUserSuccess(tester, LoginUser.username, LoginUser.password);

      // [Step 002]: Tap Keypad ->add 89852323 ->item count is 1,
      //             item quantity is 1,
      //             basket list display item "Coke Cherry EAN 8

      // Locate and press the keypad button
      expect(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey),
          findsOneWidget);
      await tester.tap(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      await keypadEntry(tester, '89852323');
      await keypadAdd(tester);

      // Get first item details
      Map<String, dynamic>? data = await getItemListData(tester, 0);

      // Validate against expectations for this step
      expect(data!['quantity'], '1');
      expect(data['description'], 'Coke Cherry EAN 8');
      expect(find.text('Items: 1'), findsOneWidget);

      // [Step 003]: Tap Keypad ->add 89852316 ->item count is 3,
      //             item quantity is 1,
      //             basket list display item "Diet Coke EAN 8

      // Locate and press the keypad button
      expect(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey),
          findsOneWidget);
      await tester.tap(find.byKey(ecp_nav_bar.NavigationBar.keypadButtonKey));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      await keypadEntry(tester, '89852316');
      await keypadAdd(tester);

      // Get second item details
      data = await getItemListData(tester, 1);

      // Validate against expectations for this step
      expect(data!['quantity'], '1');
      expect(data['description'], 'Diet Coke EAN 8');
      expect(find.text('Items: 3'), findsOneWidget);

      // [Step 004]: Pay with card and take receipt
      await checkoutPayReceipt(tester, false, true);

      // Make sure basket is empty to confirm transaction complete
      expect(find.text('Items: 0'), findsOneWidget);
    }, timeout: const Timeout.factor(3.0));
  });
}
