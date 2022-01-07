import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/common_widgets/navigation_bar.dart'
    as ecp_nav_bar;
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/pages/basket/basket_view.dart';
import 'package:ui_flutter_app/pages/basket/components/basket_list.dart';
import 'package:ui_flutter_app/pages/logoff/logoff.dart';
import 'package:ui_flutter_app/theme/theme.dart';

class BasketPage extends StatelessWidget {
  const BasketPage({Key? key}) : super(key: key);

  static const cancelCheckoutKey = Key('cancel_checkout_button_key');
  static const resetToReadyStateKey = Key('resetToReadyState');
  static const basketPageAppBarKey = Key('basket_page_app_bar_key');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          for (var element in ItemsListWidget.slidableControllers) {
            element.close();
          }
        },
        child: Scaffold(
          appBar: GenericAppBar(
            title: BlocBuilder<PosCubit, PosState>(
              builder: (context, state) {
                if (state is PosCheckoutOrderCompleted ||
                    state is PosCheckoutAddPayment ||
                    state is PosCheckoutPaymentAdded) {
                  return Text(l10n.paymentPageHeaderPlaceholder);
                }
                return Text(l10n.basketPageHeaderPlaceholder);
              },
            ),
            titleTextStyle: ECPTextStyles.loginTextStyleLabels,
            actions: [
              BlocBuilder<PosCubit, PosState>(
                builder: (context, state) {
                  if (state is PosCheckoutReady) {
                    if (state.checkout.posOrder.items.isNotEmpty) {
                      return _cancelCheckoutAction(context, state);
                    }
                  }
                  return Container();
                },
              ),
            ],
          ),
          body: const BasketView(),
          key: basketPageAppBarKey,
          drawer: const LogoffPage(),
          bottomNavigationBar: BlocBuilder<PosCubit, PosState>(
            builder: (context, state) {
              if (state is PosCheckoutReady) {
                return Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                    ),
                    child: const ecp_nav_bar.NavigationBar());
              }
              return const SizedBox(height: 0.0);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _cancelCheckout(
    BuildContext context,
    PosState state,
  ) async {
    if (state is PosCheckoutReady) {
      await BlocProvider.of<PosCubit>(context).cancelCheckout(
        state.checkout,
        false,
      );
    }
  }

  Widget _cancelCheckoutAction(BuildContext context, PosState state) {
    final l10n = context.l10n;
    return IconButton(
      key: cancelCheckoutKey,
      icon: const Icon(
        ECPIcons.cancelCheckout,
        size: 22.0,
      ),
      onPressed: () {
        for (var element in ItemsListWidget.slidableControllers) {
          element.close();
        }
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return GeneralAlertDialog(
                label: l10n.voidTransactionText,
                content: l10n.voidTransactionConfirmationText,
                primaryButtonText: l10n.yesButtonText,
                primaryOnPressed: () async {
                  await _cancelCheckout(
                    context,
                    state,
                  );
                  Navigator.of(context).pop();
                },
                secondaryButtonText: l10n.noButtonText,
                secondaryOnPressed: () async {
                  Navigator.pop(context);
                },
              );
            });
      },
    );
  }
}
