part of 'pos_service.dart';

class PosException implements Exception {
  const PosException({this.ecpError = EcpError.empty});

  final EcpError? ecpError;
}

class PosAddItemException extends PosException {
  const PosAddItemException([EcpError? ecpError]) : super(ecpError: ecpError);
}

class PosAddPaymentException extends PosException {
  const PosAddPaymentException([EcpError? ecpError])
      : super(ecpError: ecpError);
}

class PosCancelCheckoutException extends PosException {
  const PosCancelCheckoutException([EcpError? ecpError])
      : super(ecpError: ecpError);
}

class PosChangeItemQuantityException extends PosException {
  const PosChangeItemQuantityException([EcpError? ecpError])
      : super(ecpError: ecpError);
}

class PosFinishCheckoutException extends PosException {
  const PosFinishCheckoutException([EcpError? ecpError])
      : super(ecpError: ecpError);
}

class PosStartNewCheckoutException extends PosException {
  const PosStartNewCheckoutException([EcpError? ecpError])
      : super(ecpError: ecpError);
}

class PosTimeoutException extends PosException {
  const PosTimeoutException([EcpError? ecpError]) : super(ecpError: ecpError);
}

class PosCheckoutVoidItemException extends PosException {
  const PosCheckoutVoidItemException([EcpError? ecpError])
      : super(ecpError: ecpError);
}
