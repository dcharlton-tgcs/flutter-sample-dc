import 'package:auth_service/auth_service.dart';
import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/entry_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/app/app_routing.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/pages/basket/components/basket_list.dart';
import 'package:ui_flutter_app/pages/basket/components/checkout_area.dart';
import 'package:ui_flutter_app/pages/basket/components/totals_area.dart';
import 'package:ui_flutter_app/pages/processing/processing_view.dart';
import 'package:ui_flutter_app/pages/transaction_completed/transaction_completed_view.dart';
import 'package:ui_flutter_app/theme/theme.dart';
import 'package:ui_peripheral_agent/cubit/peripheral_agent_cubits.dart';

part 'basket_error.dart';

class BasketView extends StatelessWidget {
  const BasketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.65,
            0.8,
          ],
          colors: [
            UiuxColours.whiteBackground,
            UiuxColours.basketBackgroundColour,
          ],
        ),
      ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<PosCubit, PosState>(
            listener: (posContext, posState) {
              if (posState is PosCheckoutPaymentAdded) {
                _paymentAdded(posContext, posState);
              }
              if (posState is PosCheckoutFinished) {
                _finishedConfirmation(posContext, posState);
              }
              if (posState is PosCheckoutError) {
                if (posState is PosCheckoutAddPaymentError) {
                  _paymentError(posContext, posState);
                } else {
                  BasketError.showBasketDialog(posContext, posState);
                }
              }
              if (posState is PosCheckoutLogout) {
                BlocProvider.of<AuthCubit>(context).logout();
                Navigator.pushNamedAndRemoveUntil(context, AppRouting.welcome,
                    (Route<dynamic> route) => false);
              }
            },
          ),
          BlocListener<ScannerCubit, PeripheralState>(
            listener: (scannerContext, scannerState) {
              if (scannerState is ScannerData) {
                var _posState = BlocProvider.of<PosCubit>(context).state;
                if (_posState is PosCheckoutReady) {
                  BlocProvider.of<PosCubit>(context).addItem(
                    _posState.checkout,
                    scannerState.barcode,
                    scannerState.symbology,
                    1,
                    EntryMethod.SCANNED.value,
                  );
                }
              }
            },
          ),
        ],
        child: BlocBuilder<PosCubit, PosState>(
          builder: (context, state) {
            if (state is PosCheckoutInitial) {
              BlocProvider.of<PosCubit>(context).startNewCheckout();
            }
            if (state is PosCheckoutCancelled) {
              BlocProvider.of<PosCubit>(context).startNewCheckout();
            }
            if (state is PosCheckoutItemQuantityChanged) {
              Navigator.maybePop(
                context,
              );
              BlocProvider.of<PosCubit>(context)
                  .setPosCheckoutReadyState(state.checkout);
            }
            if (state is PosCheckoutReady) {
              return _basket(
                context,
                state,
              );
            }
            if (state is PosCheckoutOrderCompleted) {
              return TransactionCompletedView(
                checkout: state.checkout,
              );
            }
            if (state is PosCheckoutError) {
              if (state.view == PosCheckoutErrorView.basket) {
                return _basket(
                  context,
                  state,
                );
              }
              return const ProcessingView();
            }
            return const ProcessingView();
          },
        ),
      ),
    );
  }

  Column _basket(BuildContext context, dynamic state) {
    return Column(
      children: [
        ItemsListWidget(checkout: state.checkout),
        TotalsAreaWidget(order: state.checkout.posOrder),
        CheckoutAreaWidget(order: state.checkout.posOrder),
      ],
    );
  }

  void _paymentAdded(BuildContext context, PosCheckoutPaymentAdded state) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            content: Text(
              context.l10n.checkoutPaymentConfirmation,
            ),
          ),
        )
        .closed
        .then((reason) {
      BlocProvider.of<PosCubit>(context)
          .setPosCheckoutOrderCompletedState(state.checkout);
    });
  }

  void _finishedConfirmation(BuildContext context, PosCheckoutFinished state) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            content: Text(
              context.l10n.orderCompletedConfirmation,
            ),
          ),
        )
        .closed
        .then((reason) {
      BlocProvider.of<PosCubit>(context).setPosCheckoutInitialState();
    });
  }

  Future<void> _paymentError(
      BuildContext context, PosCheckoutAddPaymentError state) async {
    await ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: UiuxColours.backgroundErrorColour,
            behavior: SnackBarBehavior.floating,
            content: Text(context.l10n.checkoutPaymentFailed),
          ),
        )
        .closed
        .then((reason) {
      BlocProvider.of<PosCubit>(context)
          .setPosCheckoutReadyState(state.checkout!);
    });
  }
}
