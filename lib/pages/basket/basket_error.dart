part of 'basket_view.dart';

class BasketError {
  static showBasketDialog(BuildContext context, PosState state) {
    if (state is PosCheckoutError) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            final l10n = context.l10n;
            if (state.code == PosCheckoutErrorCode.itemNotFound) {
              return GeneralAlertDialog(
                label: l10n.unknownItemLabelText +
                    ' - ' +
                    state.ecpError.message.placeholderValues['itemId'],
                content: EcpErrorHandler.getPopulatedMessage(state.ecpError),
                primaryButtonText: l10n.closeButtonText,
                primaryOnPressed: () async {
                  BlocProvider.of<PosCubit>(context)
                      .setPosCheckoutReadyState(state.checkout!);
                  Navigator.of(context).pop();
                },
              );
            } else if (state.code ==
                PosCheckoutErrorCode.orderAddItemBlockedForSale) {
              return GeneralAlertDialog(
                label: l10n.blockedItemLabelText +
                    ' - ' +
                    state.ecpError.message.placeholderValues['itemDescription']
                        ['default']['text'],
                content: EcpErrorHandler.getPopulatedMessage(state.ecpError),
                primaryButtonText: l10n.closeButtonText,
                primaryOnPressed: () async {
                  BlocProvider.of<PosCubit>(context)
                      .setPosCheckoutReadyState(state.checkout!);
                  Navigator.of(context).pop();
                },
              );
            } else if (state.code ==
                PosCheckoutErrorCode.checkoutAlreadyExists) {
              return GeneralAlertDialog(
                label: l10n.checkoutAlreadyExistLabelText,
                content: EcpErrorHandler.getPopulatedMessage(state.ecpError),
                primaryButtonText: l10n.closeButtonText,
                primaryOnPressed: () async {
                  BlocProvider.of<PosCubit>(context)
                      .setPosCheckoutInitialState();
                  Navigator.of(context).pop();
                },
              );
            } else if (state.code ==
                PosCheckoutErrorCode.orderChangeItemQuantityLessThanZero) {
              return GeneralAlertDialog(
                label: l10n.quantityCannotbeZeroLabelText,
                content: EcpErrorHandler.getPopulatedMessage(state.ecpError),
                primaryButtonText: l10n.closeButtonText,
                primaryOnPressed: () async {
                  BlocProvider.of<PosCubit>(context)
                      .setPosCheckoutReadyState(state.checkout!);
                  Navigator.of(context).pop();
                },
              );
            } else {
              return GeneralAlertDialog(
                label: state.ecpError.type.toString() +
                    ' - ' +
                    state.ecpError.message.key.code,
                content: 'Group: ' +
                    state.ecpError.message.key.group +
                    '\n' +
                    EcpErrorHandler.getPopulatedMessage(state.ecpError),
                primaryButtonText: l10n.closeButtonText,
                primaryOnPressed: () async {
                  BlocProvider.of<PosCubit>(context)
                      .setPosCheckoutReadyState(state.checkout!);

                  Navigator.of(context).pop();
                },
              );
            }
          });
    }
  }
}
