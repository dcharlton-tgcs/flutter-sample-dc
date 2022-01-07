import 'package:ecp_openapi/model/pos_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/theme/theme.dart';

class CheckoutSliderWidget extends StatelessWidget {
  const CheckoutSliderWidget({Key? key, required this.order}) : super(key: key);

  final PosOrder order;

  static const couponButtonKey = Key('checkout_coupon_button');
  static const cardButtonKey = Key('checkout_card_button');

  Future<void> _addPayment(
    BuildContext context,
    PosState state,
    String tenderId,
  ) async {
    if (state is PosCheckoutReady) {
      await BlocProvider.of<PosCubit>(context).addPayment(
        state.checkout,
        tenderId,
        order.totals.amount.toDouble(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSlider(
      width: 300.00,
      height: 176.00,
      body: _checkoutBody(context),
    );
  }

  Flexible _checkoutBody(BuildContext context) {
    final l10n = context.l10n;
    return Flexible(
      child: BlocBuilder<PosCubit, PosState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.tenderSliderHeaderLabel,
                    style: ECPTextStyles.tenderHeadingLabels,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GeneralButton(
                    key: couponButtonKey,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0.0),
                      elevation: 0.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      primary: Colors.white,
                    ),
                    onPressed: () async {},
                    buttonWidth: 160,
                    buttonHeight: 80,
                    child: Image.asset(ECPImages.tenderPaymentPayPal),
                  ),
                  const SizedBox(width: 8),
                  GeneralButton(
                    key: cardButtonKey,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0.0),
                      elevation: 0.0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      primary: Colors.white,
                    ),
                    onPressed: () async {
                      await _addPayment(
                        context,
                        state,
                        '1', //assumed 1 is card
                      );
                      Navigator.of(context).pop();
                    },
                    buttonWidth: 160,
                    buttonHeight: 80,
                    child: Image.asset(ECPImages.tenderPaymentCard),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
