import 'package:ecp_openapi/model/pos_order.dart';
import 'package:flutter/material.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/pages/basket/components/bottom_sheet/checkout_slider.dart';
import 'package:ui_flutter_app/theme/theme.dart';

class CheckoutAreaWidget extends StatelessWidget {
  const CheckoutAreaWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  static const proceedToCheckoutKey = Key('proceed_to_checkout');
  final PosOrder order;

  void _showCheckout(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    showModalBottomSheet(
        backgroundColor: UiuxColours.bottomSheetBackground,
        elevation: 20.0,
        barrierColor: Colors.black.withAlpha(30),
        context: context,
        builder: (context) {
          return CheckoutSliderWidget(order: order);
        });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 17),
          GeneralButton(
            key: proceedToCheckoutKey,
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0.0),
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.white;
                  }
                  return Colors.white;
                },
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return UiuxColours.disabledButtonColour;
                  }
                  return UiuxColours.primaryColour;
                },
              ),
              textStyle: MaterialStateProperty.all(const TextStyle(
                fontWeight: FontWeight.normal,
              )),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
            onPressed: () => _showCheckout(context),
            buttonWidth: 328,
            buttonHeight: 48,
            buttonDisabled: order.totals.totalItemQuantity > 0 ? false : true,
            child: Text(l10n.basketCheckoutButtonText),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
