part of '../pos_service.dart';

enum PosCheckoutErrorView { processing, basket, none }

enum PosCheckoutErrorCode {
  itemNotFound,
  orderAddItemBlockedForSale,
  checkoutAlreadyExists,
  orderChangeItemQuantityLessThanZero,
  none
}

abstract class PosState extends Equatable {}

class PosCheckoutAddPayment extends PosState {
  @override
  List<Object> get props => [];
}

class PosCheckoutAddPaymentError extends PosCheckoutError {
  PosCheckoutAddPaymentError(EcpError error, Checkout checkout)
      : super(
          error,
          checkout,
          PosCheckoutErrorView.processing,
        );
}

class PosCheckoutCancel extends PosState {
  @override
  List<Object> get props => [];
}

class PosCheckoutCancelled extends PosState {
  PosCheckoutCancelled(this.checkout);

  final Checkout checkout;

  @override
  List<Object> get props => [checkout];
}

class PosCheckoutError extends PosState {
  PosCheckoutError(this.ecpError, this.checkout,
      [this.view = PosCheckoutErrorView.none,
      this.code = PosCheckoutErrorCode.none]);

  final EcpError ecpError;
  final Checkout? checkout;
  final PosCheckoutErrorView? view;
  final PosCheckoutErrorCode? code;

  @override
  List<Object> get props => [ecpError, checkout!];
}

class PosCheckoutFinish extends PosState {
  @override
  List<Object> get props => [];
}

class PosCheckoutFinished extends PosState {
  PosCheckoutFinished(this.checkout);

  final Checkout checkout;

  @override
  List<Object> get props => [checkout];
}

class PosCheckoutInitial extends PosState {
  @override
  List<Object> get props => [];
}

class PosCheckoutItemQuantityChange extends PosState {
  @override
  List<Object> get props => [];
}

class PosCheckoutItemQuantityChanged extends PosState {
  PosCheckoutItemQuantityChanged(this.checkout);

  final Checkout checkout;

  @override
  List<Object> get props => [checkout];
}

class PosCheckoutLogout extends PosState {
  @override
  List<Object> get props => [];
}

class PosCheckoutOrderAddItem extends PosState {
  @override
  List<Object> get props => [];
}

class PosCheckoutOrderCompleted extends PosState {
  PosCheckoutOrderCompleted(this.checkout);

  final Checkout checkout;

  @override
  List<Object> get props => [checkout];
}

class PosCheckoutOrderItemAdded extends PosState {
  PosCheckoutOrderItemAdded(this.checkout);

  final Checkout checkout;

  @override
  List<Object> get props => [checkout];
}

class PosCheckoutPaymentAdded extends PosState {
  PosCheckoutPaymentAdded(this.checkout);

  final Checkout checkout;

  @override
  List<Object> get props => [checkout];
}

class PosCheckoutReady extends PosState {
  PosCheckoutReady(this.checkout);

  final Checkout checkout;

  @override
  List<Object> get props => [checkout];
}

class PosCheckoutStart extends PosState {
  @override
  List<Object> get props => [];
}

class PosCheckoutStarted extends PosState {
  PosCheckoutStarted(this.checkout);

  final Checkout checkout;

  @override
  List<Object> get props => [checkout];
}

class PosCheckoutItemVoid extends PosState {
  @override
  List<Object> get props => [];
}

class PosCheckoutItemVoided extends PosState {
  PosCheckoutItemVoided(this.checkout);

  final Checkout checkout;

  @override
  List<Object> get props => [checkout];
}
