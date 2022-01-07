part of 'pos_service.dart';

class ECPPosService implements PosService {
  ECPPosService({
    required this.clientContext,
    required this.httpClient,
    required this.ecpPosAddress,
    required this.timeout,
    required this.authService,
  }) : super();

  final ClientContext clientContext;
  final http.Client httpClient;
  final String ecpPosAddress;
  final int timeout;
  final AuthService authService;

  @override
  Future<Checkout> addItem(Checkout checkout, String barcode, String symbology,
      int quantity, String entryMethod) async {
    var encoded;
    log('Adding an item to POS Order ${checkout.posOrder}');
    if (symbology == '') {
      encoded = jsonEncode(<String, dynamic>{
        'clientContext': {
          "touchpointId": clientContext.touchpointId,
          "currencyCode": clientContext.currencyCode,
        },
        'barcode': barcode,
        'quantity': quantity,
        'entryMethod': entryMethod,
        'inputAttributes': {},
      });
    } else {
      encoded = jsonEncode(<String, dynamic>{
        'clientContext': {
          "touchpointId": clientContext.touchpointId,
          "currencyCode": clientContext.currencyCode,
        },
        'barcode': barcode,
        'symbology': symbology,
        'quantity': quantity,
        'entryMethod': entryMethod,
        'inputAttributes': {},
      });
    }

    log('Encoded:$encoded');

    try {
      String _bearerToken = await authService.getBearerToken();
      final response = await httpClient
          .post(
            Uri.https(ecpPosAddress,
                'pos/checkouts/${checkout.checkoutId}/${checkout.metadata.entityVersion}/barcode'),
            headers: <String, String>{
              'Authorization': 'Bearer $_bearerToken',
              'Content-Type': 'application/json',
            },
            body: encoded,
          )
          .timeout(
            Duration(seconds: timeout),
          );

      if (response.statusCode == 200) {
        log('Response: ${response.body}');
        Map<String, dynamic> data = jsonDecode(response.body);
        return Checkout.fromJson(data);
      } else {
        throw PosAddItemException(
            EcpErrorHandler.handleError(response.statusCode, response.body));
      }
    } on TimeoutException {
      throw const PosTimeoutException();
    }
  }

  @override
  Future<Checkout> addPayment(
    Checkout checkout,
    String tenderId,
    double amount,
  ) async {
    try {
      var encoded = jsonEncode(<String, dynamic>{
        'clientContext': {
          'touchpointId': clientContext.touchpointId,
          'currencyCode': clientContext.currencyCode,
        },
        "authorizedAmount": {
          "amount": amount,
          "currencyCode": clientContext.currencyCode,
        },
        "tenderId": tenderId
      });
      log('Encoded:$encoded');
      String _bearerToken = await authService.getBearerToken();
      final response = await httpClient
          .post(
            Uri.https(
                ecpPosAddress,
                'pos/checkouts/${checkout.checkoutId}'
                '/${checkout.metadata.entityVersion}/order/payments'),
            headers: <String, String>{
              'Authorization': 'Bearer $_bearerToken',
              'Content-Type': 'application/json',
            },
            body: encoded,
          )
          .timeout(
            Duration(seconds: timeout),
          );

      if (response.statusCode == 200) {
        log('Response.body:${response.body}');
        Map<String, dynamic> data = jsonDecode(response.body);
        return Checkout.fromJson(data);
      } else {
        throw PosAddPaymentException(
            EcpErrorHandler.handleError(response.statusCode, response.body));
      }
    } on TimeoutException {
      throw const PosTimeoutException();
    }
  }

  @override
  Future<Checkout> cancelCheckout(
    Checkout checkout,
  ) async {
    try {
      var encoded = jsonEncode(<String, dynamic>{
        'clientContext': {
          'touchpointId': clientContext.touchpointId,
          'currencyCode': clientContext.currencyCode,
        },
      });
      log('Encoded:$encoded');
      String _bearerToken = await authService.getBearerToken();
      final response = await httpClient
          .post(
            Uri.https(
                ecpPosAddress,
                'pos/checkouts/${checkout.checkoutId}'
                '/${checkout.metadata.entityVersion}/cancel'),
            headers: <String, String>{
              'Authorization': 'Bearer $_bearerToken',
              'Content-Type': 'application/json',
            },
            body: encoded,
          )
          .timeout(
            Duration(seconds: timeout),
          );

      if (response.statusCode == 200) {
        log('Response.body:${response.body}');
        Map<String, dynamic> data = jsonDecode(response.body);
        return Checkout.fromJson(data);
      } else {
        throw PosCancelCheckoutException(
            EcpErrorHandler.handleError(response.statusCode, response.body));
      }
    } on TimeoutException {
      throw const PosTimeoutException();
    }
  }

  @override
  Future<Checkout> changeItemQuantity(
    Checkout checkout,
    String orderItemId,
    int quantity,
  ) async {
    var encoded = jsonEncode(<String, dynamic>{
      'clientContext': {
        "touchpointId": clientContext.touchpointId,
        "currencyCode": clientContext.currencyCode,
      },
      'quantity': quantity,
    });
    log('Encoded:$encoded');

    try {
      String _bearerToken = await authService.getBearerToken();
      final response = await httpClient
          .post(
            Uri.https(
                ecpPosAddress,
                'pos/checkouts/${checkout.checkoutId}'
                '/${checkout.metadata.entityVersion}'
                '/order/items/$orderItemId/quantity'),
            headers: <String, String>{
              'Authorization': 'Bearer $_bearerToken',
              'Content-Type': 'application/json',
            },
            body: encoded,
          )
          .timeout(
            Duration(seconds: timeout),
          );

      if (response.statusCode == 200) {
        log('Response: ${response.body}');
        Map<String, dynamic> data = jsonDecode(response.body);
        return Checkout.fromJson(data);
      } else {
        throw PosChangeItemQuantityException(
            EcpErrorHandler.handleError(response.statusCode, response.body));
      }
    } on TimeoutException {
      throw const PosTimeoutException();
    }
  }

  @override
  Future<Checkout> finishCheckout(
    Checkout checkout,
  ) async {
    try {
      var encoded = jsonEncode(<String, dynamic>{
        'clientContext': {
          'touchpointId': clientContext.touchpointId,
          'currencyCode': clientContext.currencyCode,
        },
      });
      log('Encoded:$encoded');
      String _bearerToken = await authService.getBearerToken();
      final response = await httpClient
          .post(
            Uri.https(
                ecpPosAddress,
                'pos/checkouts/${checkout.checkoutId}'
                '/${checkout.metadata.entityVersion}/finish'),
            headers: <String, String>{
              'Authorization': 'Bearer $_bearerToken',
              'Content-Type': 'application/json',
            },
            body: encoded,
          )
          .timeout(
            Duration(seconds: timeout),
          );

      if (response.statusCode == 200) {
        log('Response.body:${response.body}');
        Map<String, dynamic> data = jsonDecode(response.body);
        return Checkout.fromJson(data);
      } else {
        throw PosFinishCheckoutException(
            EcpErrorHandler.handleError(response.statusCode, response.body));
      }
    } on TimeoutException {
      throw const PosTimeoutException();
    }
  }

  @override
  Future<Checkout> startNewCheckout() async {
    try {
      var encoded = jsonEncode(<String, dynamic>{
        'clientContext': {
          'touchpointId': clientContext.touchpointId,
          'currencyCode': clientContext.currencyCode,
        },
      });
      log('Encoded:$encoded');
      String _bearerToken = await authService.getBearerToken();
      final response = await httpClient
          .post(
            Uri.https(ecpPosAddress, 'pos/checkouts'),
            headers: <String, String>{
              'Authorization': 'Bearer $_bearerToken',
              'Content-Type': 'application/json',
            },
            body: encoded,
          )
          .timeout(
            Duration(seconds: timeout),
          );

      if (response.statusCode == 200) {
        log('Response.body:${response.body}');
        Map<String, dynamic> data = jsonDecode(response.body);
        return Checkout.fromJson(data);
      } else {
        throw PosStartNewCheckoutException(
            EcpErrorHandler.handleError(response.statusCode, response.body));
      }
    } on TimeoutException {
      throw const PosTimeoutException();
    }
  }

  @override
  Future<Checkout> voidItem(Checkout checkout, String orderItemId) async {
    log('Void $orderItemId item in checkout ${checkout.checkoutId}');
    try {
      var encoded = jsonEncode(<String, dynamic>{
        'clientContext': {
          'touchpointId': clientContext.touchpointId,
          'currencyCode': clientContext.currencyCode,
        },
      });
      String _bearerToken = await authService.getBearerToken();
      final response = await httpClient
          .post(
            Uri.https(
              ecpPosAddress,
              'pos/checkouts/${checkout.checkoutId}'
              '/${checkout.metadata.entityVersion}/order/'
              'items/$orderItemId/void',
            ),
            headers: <String, String>{
              'Authorization': 'Bearer $_bearerToken',
              'Content-Type': 'application/json',
            },
            body: encoded,
          )
          .timeout(
            Duration(seconds: timeout),
          );

      if (response.statusCode == 200) {
        log('Response: ${response.body}');

        Map<String, dynamic> data = jsonDecode(response.body);
        return Checkout.fromJson(data);
      } else {
        throw PosCheckoutVoidItemException(
            EcpErrorHandler.handleError(response.statusCode, response.body));
      }
    } on TimeoutException {
      throw const PosTimeoutException();
    }
  }
}
