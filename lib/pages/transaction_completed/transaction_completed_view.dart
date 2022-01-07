import 'package:ecp_openapi/model/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/common_widgets/general_button.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/pages/processing/processing_view.dart';
import 'package:ui_flutter_app/pages/transaction_completed/transaction_completed.dart';
import 'package:ui_flutter_app/temporary/receipt_builder.dart';
import 'package:ui_flutter_app/theme/theme.dart';
import 'package:ui_peripheral_agent/cubit/peripheral_agent_cubits.dart';

class TransactionCompletedView extends StatelessWidget {
  const TransactionCompletedView({
    Key? key,
    required this.checkout,
  }) : super(key: key);

  final dynamic checkout;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrinterCubit, PeripheralState>(
      listener: (printContext, printState) {
        if (printState is PrintNormalComplete) {
          return _printReceiptConfirmation(printContext, checkout);
        }
        // TODO: Can't complete until PA supports this
        // if (printState is PrintError) {
        //   return _printReceiptFailed(context);
        // }
      },
      builder: (printContext, printState) {
        if (printState is PeripheralClaimed) {
          return _printReceiptScaffold(printContext, checkout);
        }
        // TODO: Can't complete until PA supports this
        // if (printState is PrintRetry) {
        //   return _retryPrintScaffold(printContext, checkout);
        // }
        return const ProcessingView();
      },
    );
  }

  Scaffold _printReceiptScaffold(BuildContext context, Checkout checkout) {
    final l10n = context.l10n;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 136,
                    ),
                    Text(
                      l10n.transactionCompletedHeadingText,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      l10n.transactionCompletedPrintReceiptText,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GeneralButton(
                          key: TransactionCompletedPage.noButtonKey,
                          onPressed: () async {
                            await _finishOrder(context, checkout);
                          },
                          buttonWidth: 160,
                          buttonHeight: 48,
                          style: ECPButtonStyles.secondaryButtonStyle,
                          child: Text(l10n.noButtonText,
                              style: Theme.of(context)
                                  .textTheme
                                  .secondaryButtonText),
                        ),
                        const SizedBox(width: 8),
                        GeneralButton(
                          key: TransactionCompletedPage.yesButtonKey,
                          onPressed: () async {
                            await _printReceipt(context, checkout);
                          },
                          buttonWidth: 160,
                          buttonHeight: 48,
                          style: ECPButtonStyles.primaryButtonStyle,
                          child: Text(l10n.yesButtonText,
                              style: Theme.of(context)
                                  .textTheme
                                  .primaryButtonText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // TODO: Can't complete until PA supports this
  // Scaffold _retryPrintScaffold(BuildContext context, Checkout checkout) {
  //   final l10n = context.l10n;
  //   return Scaffold(
  //     body: Stack(
  //       fit: StackFit.expand,
  //       children: [
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   const SizedBox(
  //                     height: 136,
  //                   ),
  //                   Text(
  //                     l10n.transactionCompletedHeadingText,
  //                     style: Theme.of(context).textTheme.subtitle1,
  //                   ),
  //                   const SizedBox(
  //                     height: 16,
  //                   ),
  //                   Text(
  //                     l10n.retryPrintReceiptText,
  //                   ),
  //                   const SizedBox(
  //                     height: 24,
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       GeneralButton(
  //                         key: TransactionCompletedPage.noButtonKey,
  //                         onPressed: () async {
  //                           await _finishOrder(context, checkout);
  //                         },
  //                         buttonWidth: 160,
  //                         buttonHeight: 48,
  //                         style: ECPButtonStyles.secondaryButtonStyle,
  //                         child: Text(l10n.noButtonText,
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .secondaryButtonText),
  //                       ),
  //                       const SizedBox(width: 8),
  //                       GeneralButton(
  //                         key: TransactionCompletedPage.yesButtonKey,
  //                         onPressed: () async {
  //                           await _printReceipt(context, checkout);
  //                         },
  //                         buttonWidth: 160,
  //                         buttonHeight: 48,
  //                         style: ECPButtonStyles.primaryButtonStyle,
  //                         child: Text(l10n.retryButtonText,
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .primaryButtonText),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  Future<void> _finishOrder(BuildContext context, Checkout checkout) async {
    await BlocProvider.of<PosCubit>(context).finishCheckout(
      checkout,
    );
  }

  Future<void> _printReceipt(BuildContext context, Checkout checkout) async {
    BlocProvider.of<PrinterCubit>(context).enablePeripheral();
    BlocProvider.of<PrinterCubit>(context)
        .printNormal(ReceiptBuilder.buildReceipt(checkout));
  }

  void _printReceiptConfirmation(BuildContext context, Checkout checkout) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            content: Text(
              context.l10n.printReceiptConfirmation,
            ),
          ),
        )
        .closed
        .then((reason) async {
      _finishOrder(context, checkout);
      BlocProvider.of<PrinterCubit>(context).disablePeripheral();
    });
  }

  // TODO: Can't complete until PA supports this
  // void _printReceiptFailed(BuildContext context) {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(
  //         SnackBar(
  //           duration: const Duration(seconds: 1),
  //           backgroundColor: UiuxColours.backgroundErrorColour,
  //           behavior: SnackBarBehavior.floating,
  //           content: Text(
  //             context.l10n.printReceiptFailed,
  //           ),
  //         ),
  //       )
  //       .closed
  //       .then((reason) {
  //     BlocProvider.of<PrintCubit>(context).setPrintRetryState();
  //   });
  // }
}
