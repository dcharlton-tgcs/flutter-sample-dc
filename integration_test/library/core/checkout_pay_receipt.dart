import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_flutter_app/pages/basket/components/bottom_sheet/checkout_slider.dart';
import 'package:ui_flutter_app/pages/basket/components/checkout_area.dart';
import 'package:ui_flutter_app/pages/transaction_completed/transaction_completed.dart';

Future<void> checkoutPayReceipt(
    dynamic tester, bool useCoupon, bool wantReceipt) async {
  // Pull up the checkout slider
  await tester.tap(find.byKey(CheckoutAreaWidget.proceedToCheckoutKey));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));

  // Pay by coupon or card
  Key button;
  if (useCoupon) {
    button = CheckoutSliderWidget.couponButtonKey;
  } else {
    button = CheckoutSliderWidget.cardButtonKey;
  }
  expect(find.byKey(button), findsOneWidget);
  await tester.tap(find.byKey(button));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));

  // Print a receipt?
  if (wantReceipt) {
    button = TransactionCompletedPage.yesButtonKey;
  } else {
    button = TransactionCompletedPage.noButtonKey;
  }
  expect(find.byKey(button), findsOneWidget);
  await tester.tap(find.byKey(button));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));

  // Make sure basket is showing empty
  expect(find.text('Items: 0'), findsOneWidget);
}
