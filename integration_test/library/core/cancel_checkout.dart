import 'package:flutter_test/flutter_test.dart';
import 'package:ui_flutter_app/common_widgets/general_alert_dialog.dart';
import 'package:ui_flutter_app/pages/basket/basket.dart';

Future<void> cancelCheckout(dynamic tester) async {
  // press the cancel button
  await tester.tap(find.byKey(BasketPage.cancelCheckoutKey));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));

  // press the 'ok' button
  await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
}
