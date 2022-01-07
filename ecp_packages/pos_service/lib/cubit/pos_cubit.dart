part of '../pos_service.dart';

class PosCubit extends Cubit<PosState> {
  PosCubit(this._posService) : super(PosCheckoutInitial());

  final PosService _posService;

  Future<void> addItem(
    Checkout checkout,
    String barcode,
    String symbology,
    int quantity,
    String entryMethod,
  ) async {
    try {
      emit(PosCheckoutOrderAddItem());
      final _checkout = await _posService.addItem(
          checkout, barcode, symbology, quantity, entryMethod);
      emit(PosCheckoutOrderItemAdded(_checkout));
      emit(PosCheckoutReady(_checkout));
    } on PosException catch (oe) {
      if (oe.ecpError!.message.key.code == itemNotFound) {
        emit(PosCheckoutError(
          oe.ecpError!,
          checkout,
          PosCheckoutErrorView.basket,
          PosCheckoutErrorCode.itemNotFound,
        ));
      } else if (oe.ecpError!.message.key.code == orderAddItemBlockedForSale) {
        emit(PosCheckoutError(
          oe.ecpError!,
          checkout,
          PosCheckoutErrorView.basket,
          PosCheckoutErrorCode.orderAddItemBlockedForSale,
        ));
      } else {
        emit(PosCheckoutError(oe.ecpError!, checkout));
      }
    } on AuthException {
      emit(PosCheckoutLogout());
    }
  }

  Future<void> addPayment(
    Checkout checkout,
    String tenderId,
    double amount,
  ) async {
    try {
      emit(PosCheckoutAddPayment());
      final _checkout = await _posService.addPayment(
        checkout,
        tenderId,
        amount,
      );
      emit(PosCheckoutPaymentAdded(_checkout));
    } on PosException catch (oe) {
      emit(PosCheckoutAddPaymentError(oe.ecpError!, checkout));
    } on AuthException {
      emit(PosCheckoutLogout());
    }
  }

  Future<void> cancelCheckout(Checkout checkout, bool isLoggingOut) async {
    try {
      emit(PosCheckoutCancel());
      final _checkout = await _posService.cancelCheckout(
        checkout,
      );
      if (!isLoggingOut) {
        emit(PosCheckoutCancelled(_checkout));
      }
    } on PosException catch (oe) {
      emit(PosCheckoutError(oe.ecpError!, checkout));
    } on AuthException {
      emit(PosCheckoutLogout());
    }
  }

  Future<void> changeItemQuantity(
    Checkout checkout,
    String orderItemId,
    int quantity,
  ) async {
    try {
      emit(PosCheckoutItemQuantityChange());
      final _checkout =
          await _posService.changeItemQuantity(checkout, orderItemId, quantity);
      emit(PosCheckoutItemQuantityChanged(_checkout));
    } on PosException catch (oe) {
      if (oe.ecpError!.message.key.code ==
          orderChangeItemQuantityLessThanZero) {
        emit(PosCheckoutError(
          oe.ecpError!,
          checkout,
          PosCheckoutErrorView.basket,
          PosCheckoutErrorCode.orderChangeItemQuantityLessThanZero,
        ));
      } else {
        emit(PosCheckoutError(oe.ecpError!, checkout));
      }
    } on AuthException {
      emit(PosCheckoutLogout());
    }
  }

  Future<void> finishCheckout(Checkout checkout) async {
    try {
      emit(PosCheckoutFinish());
      final _checkout = await _posService.finishCheckout(
        checkout,
      );
      emit(PosCheckoutFinished(_checkout));
    } on PosException catch (oe) {
      emit(PosCheckoutError(oe.ecpError!, checkout));
    } on AuthException {
      emit(PosCheckoutLogout());
    }
  }

  Future<void> startNewCheckout() async {
    try {
      emit(PosCheckoutStart());
      final _checkout = await _posService.startNewCheckout();
      emit(PosCheckoutStarted(_checkout));
      emit(PosCheckoutReady(_checkout));
    } on PosException catch (oe) {
      if (oe.ecpError!.message.key.code == checkoutAlreadyExists) {
        emit(PosCheckoutError(
          oe.ecpError!,
          Checkout.empty,
          PosCheckoutErrorView.none,
          PosCheckoutErrorCode.checkoutAlreadyExists,
        ));
      } else {
        emit(PosCheckoutError(oe.ecpError!, Checkout.empty));
      }
    } on AuthException {
      emit(PosCheckoutLogout());
    }
  }

  Future<void> voidItemCheckout(Checkout checkout, String orderItemId) async {
    try {
      emit(PosCheckoutItemVoid());
      final _checkout = await _posService.voidItem(checkout, orderItemId);
      emit(PosCheckoutItemVoided(_checkout));
      emit(PosCheckoutReady(_checkout));
    } on PosException catch (pe) {
      emit(PosCheckoutError(pe.ecpError!, checkout));
    } on AuthException {
      emit(PosCheckoutLogout());
    }
  }

  Future<void> setPosCheckoutInitialState() async {
    emit(PosCheckoutInitial());
  }

  Future<void> setPosCheckoutLogoutState() async {
    emit(PosCheckoutLogout());
  }

  Future<void> setPosCheckoutOrderCompletedState(Checkout checkout) async {
    emit(PosCheckoutOrderCompleted(checkout));
  }

  Future<void> setPosCheckoutReadyState(Checkout checkout) async {
    emit(PosCheckoutReady(checkout));
  }
}
