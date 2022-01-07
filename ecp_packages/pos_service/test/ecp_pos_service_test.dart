import 'dart:convert';

import 'package:auth_service/appauth/app_auth_service.dart';
import 'package:auth_service/auth_service.dart';
import 'package:auth_service/fake_auth_service.dart';
import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:ecp_openapi/model/checkout_state.dart';
import 'package:ecp_openapi/model/client_context.dart';
import 'package:ecp_openapi/model/entry_method.dart';
import 'package:ecp_openapi/model/order_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pos_service/pos_service.dart';

import 'ecp_pos_service_test.mocks.dart';
import 'mock_service_data.dart';

@GenerateMocks([http.Client])
void main() {
  const mockEcpError = '''
    {
      "attributes": {},
      "type": "FAILURE",
      "message": {
          "key": {
              "group": "pos",
              "code": "checkout-already-exists"
          },
          "defaultMessage": "Impossible to create a checkout for Touchpoint 1. There is already one ACTIVE.",
          "placeholderValues": {
              "touchpointId": "1"
          }
      }
    }
  ''';

  var epResponse = '''
  {
      "end_session_endpoint":"i_am_end_session",
      "userinfo_endpoint":"i_am_userinfo"
  }        
  ''';

  var keycloakResponse = '''
  {
      "access_token": "accesstoken",
      "expires_in": 36000,
      "refresh_expires_in": 1800,
      "refresh_token": "refreshtoken",
      "token_type": "Bearer",
      "not-before-policy": 0,
      "session_state": "ff86b477-b399-449d-94f5-7d756c4858df",
      "scope": "profile email"
  }
  ''';

  var domain = 'my.domain';
  var authority = 'my.authority';
  var discoveryUrl = 'openid-configuration';
  var clientId = 'a-client-id';
  var bundleId = 'a.bundle.id';
  var scopes = ['scope1', 'scope2', 'scope3', 'scope4'];
  var clientsecret = 'secret';
  var unencodedPath = 'a/unencoded/path';

  Map<String, dynamic> authParams = {
    AppAuthService.auth0DiscoveryUrl: discoveryUrl,
    AppAuthService.auth0Authority: authority,
    AppAuthService.auth0Domain: domain,
    AppAuthService.auth0ClientId: clientId,
    AppAuthService.auth0BundleId: bundleId,
    AppAuthService.auth0Scopes: scopes,
    AppAuthService.auth0ClientSecret: clientsecret,
    AppAuthService.auth0UnencodedPath: unencodedPath,
  };

  late http.Client _httpClient;
  late ECPPosService _posService;
  late ClientContext _clientContext;
  late AuthService _authService;

  setUpAll(() async {
    _clientContext = ClientContext(
      touchpointId: 'test123',
      currencyCode: UiuxNumber.currencyCode,
    );

    _httpClient = MockClient();
    _posService = ECPPosService(
      clientContext: _clientContext,
      httpClient: _httpClient,
      ecpPosAddress: '1.2.3.4',
      timeout: 1,
      authService: FakeAuthService(),
    );

    _authService = FakeAuthService();

    when(
      _httpClient.get(Uri.https(domain, discoveryUrl)),
    ).thenAnswer((_) async {
      // Provide a valid response
      return http.Response(epResponse, 200);
    });
    await _authService.initialise(authParams, _httpClient);

    when(
      _httpClient.post(Uri.https(authority, unencodedPath),
          headers: anyNamed('headers'),
          body: 'grant_type=password&'
              'client_id=$clientId&'
              'client_secret=$clientsecret&'
              'username=abc&'
              'password=abc&'),
    ).thenAnswer((_) async {
      // Provide a valid response
      return http.Response(keycloakResponse, 200);
    });
    await _authService.login('abcd', 'abcd');
  });

  group('ECP Order Service (Native Methods):', () {
    const MethodChannel channel = MethodChannel('pos_service');

    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return '42';
      });
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
    });

    test('getPlatformVersion', () async {
      expect(await PosService.platformVersion, '42');
    });
  });

  group('ECP Pos Service (Add Item)', () {
    test('Adds item to existing checkout', () async {
      when(
        _httpClient.post(
          Uri.https(_posService.ecpPosAddress, 'pos/checkouts'),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                'touchpointId': _clientContext.touchpointId,
                'currencyCode': _clientContext.currencyCode,
              },
            },
          ),
        ),
      ).thenAnswer(
          (_) async => http.Response(mockEmptyPosOrderCheckoutJSON, 200));

      var checkout = await _posService.startNewCheckout();
      expect(checkout, isA<Checkout>());

      when(
        _httpClient.post(
          Uri.https(
            _posService.ecpPosAddress,
            'pos/checkouts/615c5405c9866f06ac32e989/1/barcode',
          ),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                'touchpointId': checkout.touchpointId,
                'currencyCode': UiuxNumber.currencyCode,
              },
              'barcode': '1',
              'symbology': '2',
              'quantity': 1,
              'entryMethod': EntryMethod.SCANNED.value,
              'inputAttributes': {},
            },
          ),
        ),
      ).thenAnswer(
        (_) async => http.Response(mockOneItemPosCheckoutJSON, 200),
      );

      var newCheckout = await _posService.addItem(
        checkout,
        '1',
        '2',
        1,
        EntryMethod.SCANNED.value,
      );
      expect(newCheckout.posOrder.items.length, 1);
    });

    test('Throws PosTimeoutException (Add Item)', () async {
      when(
        _httpClient.post(
          Uri.https(_posService.ecpPosAddress, 'pos/checkouts'),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                'touchpointId': _clientContext.touchpointId,
                'currencyCode': UiuxNumber.currencyCode,
              },
            },
          ),
        ),
      ).thenAnswer(
          (_) async => http.Response(mockEmptyPosOrderCheckoutJSON, 200));

      var checkout = await _posService.startNewCheckout();
      expect(checkout, isA<Checkout>());

      when(
        _httpClient.post(
          Uri.https(
            _posService.ecpPosAddress,
            'pos/checkouts/615c5405c9866f06ac32e989/1/barcode',
          ),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                'touchpointId': checkout.touchpointId,
                'currencyCode': UiuxNumber.currencyCode,
              },
              'barcode': '3600542267724',
              'symbology': 'EAN13',
              'quantity': 1,
              'entryMethod': EntryMethod.SCANNED.value,
              'inputAttributes': {},
            },
          ),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 5));
        return http.Response(mockEcpError, 404);
      });
      expect(
          () => _posService.addItem(
                checkout,
                '3600542267724',
                'EAN13',
                1,
                EntryMethod.SCANNED.value,
              ),
          throwsA(isA<PosTimeoutException>()));
    });

    test('Throws PosAddItemException (Add Item)', () async {
      when(
        _httpClient.post(
          Uri.https(_posService.ecpPosAddress, 'pos/checkouts'),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                'touchpointId': _clientContext.touchpointId,
                'currencyCode': _clientContext.currencyCode,
              },
            },
          ),
        ),
      ).thenAnswer(
          (_) async => http.Response(mockEmptyPosOrderCheckoutJSON, 200));

      var checkout = await _posService.startNewCheckout();
      expect(checkout, isA<Checkout>());

      when(
        _httpClient.post(
          Uri.https(
            _posService.ecpPosAddress,
            'pos/checkouts/615c5405c9866f06ac32e989/1/barcode',
          ),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                'touchpointId': checkout.touchpointId,
                'currencyCode': UiuxNumber.currencyCode,
              },
              'barcode': '3600542267724',
              'symbology': 'EAN13',
              'quantity': 1,
              'entryMethod': EntryMethod.SCANNED.value,
              'inputAttributes': {},
            },
          ),
        ),
      ).thenAnswer((_) async => http.Response(mockEcpError, 404));

      expect(
          () => _posService.addItem(
                checkout,
                '3600542267724',
                'EAN13',
                1,
                EntryMethod.SCANNED.value,
              ),
          throwsA(isA<PosAddItemException>()));
    });
  });

  group('ECP Pos Service (Add Payment):', () {
    test('Adds payment to checkout', () async {
      var checkout = Checkout.fromJson(
        jsonDecode(http.Response(mockCheckoutOneItemJSON, 200).body),
      );
      when(
        _httpClient.post(
          Uri.https(
              _posService.ecpPosAddress,
              'pos/checkouts/${checkout.checkoutId}'
              '/${checkout.metadata.entityVersion}/order/payments'),
          headers: anyNamed('headers'),
          body: jsonEncode(<String, dynamic>{
            'clientContext': {
              'touchpointId': _clientContext.touchpointId,
              'currencyCode': _clientContext.currencyCode,
            },
            "authorizedAmount": {
              "amount": 1.00,
              "currencyCode": _clientContext.currencyCode,
            },
            "tenderId": '1'
          }),
        ),
      ).thenAnswer(
          (_) async => http.Response(mockCheckoutOneItemPaidJSON, 200));

      var paidCheckout = await _posService.addPayment(checkout, '1', 1.00);
      expect(paidCheckout, isA<Checkout>());
      expect(paidCheckout.state, CheckoutState.ACTIVE);
      expect(paidCheckout.posOrder.state, OrderState.CHECKOUT);
      expect(paidCheckout.metadata.entityVersion, 2);
      expect(paidCheckout.posOrder.payments[0].authorizedAmount.amount, 1.00);
      expect(paidCheckout.posOrder.payments[0].tender.tenderId, '1');
    });

    test('throws PosTimeoutException (Add Payment)', () async {
      var checkout = Checkout.fromJson(
        jsonDecode(http.Response(mockCheckoutOneItemJSON, 200).body),
      );
      when(
        _httpClient.post(
          Uri.https(
              _posService.ecpPosAddress,
              'pos/checkouts/${checkout.checkoutId}'
              '/${checkout.metadata.entityVersion}/order/payments'),
          headers: anyNamed('headers'),
          body: jsonEncode(<String, dynamic>{
            'clientContext': {
              'touchpointId': _clientContext.touchpointId,
              'currencyCode': _clientContext.currencyCode,
            },
            "authorizedAmount": {
              "amount": 1.00,
              "currencyCode": _clientContext.currencyCode,
            },
            "tenderId": '1'
          }),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 5));
        return http.Response('Timeout', 408);
      });

      expect(
          _posService.addPayment(checkout, '1', 1.00),
          throwsA(
            isA<PosTimeoutException>(),
          ));
    });

    test('throws PosAddpaymentException', () async {
      var checkout = Checkout.fromJson(
        jsonDecode(http.Response(mockCheckoutOneItemJSON, 200).body),
      );
      when(
        _httpClient.post(
          Uri.https(
              _posService.ecpPosAddress,
              'pos/checkouts/${checkout.checkoutId}'
              '/${checkout.metadata.entityVersion}/order/payments'),
          headers: anyNamed('headers'),
          body: jsonEncode(<String, dynamic>{
            'clientContext': {
              'touchpointId': _clientContext.touchpointId,
              'currencyCode': _clientContext.currencyCode,
            },
            "authorizedAmount": {
              "amount": 1.00,
              "currencyCode": _clientContext.currencyCode,
            },
            "tenderId": '1'
          }),
        ),
      ).thenAnswer((_) async => http.Response(mockEcpError, 400));

      expect(
          _posService.addPayment(checkout, '1', 1.00),
          throwsA(
            isA<PosAddPaymentException>(),
          ));
    });
  });

  group('ECP Pos Service (Cancel Checkout):', () {
    test('Cancels a checkout; void transaction', () async {
      var checkout = Checkout.fromJson(
        jsonDecode(http.Response(mockNewCheckoutJSON, 200).body),
      );
      when(
        _httpClient.post(
          Uri.https(
              _posService.ecpPosAddress,
              'pos/checkouts/${checkout.checkoutId}'
              '/${checkout.metadata.entityVersion}/cancel'),
          headers: anyNamed('headers'),
          body: jsonEncode(<String, dynamic>{
            'clientContext': {
              'touchpointId': _clientContext.touchpointId,
              'currencyCode': _clientContext.currencyCode,
            },
          }),
        ),
      ).thenAnswer((_) async => http.Response(mockCancelledCheckoutJSON, 200));

      var cancelledCheckout = await _posService.cancelCheckout(checkout);
      expect(cancelledCheckout, isA<Checkout>());
      expect(cancelledCheckout.state, CheckoutState.FINISHED);
      expect(cancelledCheckout.posOrder.state, OrderState.CANCELLED);
      expect(cancelledCheckout.metadata.entityVersion, 2);
    });

    test('throws PosTimeoutException (Cancel Checkout)', () async {
      var checkout = Checkout.fromJson(
        jsonDecode(http.Response(mockNewCheckoutJSON, 200).body),
      );
      when(
        _httpClient.post(
          Uri.https(
              _posService.ecpPosAddress,
              'pos/checkouts/${checkout.checkoutId}'
              '/${checkout.metadata.entityVersion}/cancel'),
          headers: anyNamed('headers'),
          body: jsonEncode(<String, dynamic>{
            'clientContext': {
              'touchpointId': _clientContext.touchpointId,
              'currencyCode': _clientContext.currencyCode,
            },
          }),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 5));
        return http.Response('Timeout', 408);
      });

      expect(
          _posService.cancelCheckout(checkout),
          throwsA(
            isA<PosTimeoutException>(),
          ));
    });

    test('throws PosCancelCheckoutException', () async {
      var checkout = Checkout.fromJson(
        jsonDecode(http.Response(mockNewCheckoutJSON, 200).body),
      );
      when(
        _httpClient.post(
          Uri.https(
              _posService.ecpPosAddress,
              'pos/checkouts/${checkout.checkoutId}'
              '/${checkout.metadata.entityVersion}/cancel'),
          headers: anyNamed('headers'),
          body: jsonEncode(<String, dynamic>{
            'clientContext': {
              'touchpointId': _clientContext.touchpointId,
              'currencyCode': _clientContext.currencyCode,
            },
          }),
        ),
      ).thenAnswer(
        (_) async => http.Response(mockEcpError, 400),
      );

      expect(
          _posService.cancelCheckout(checkout),
          throwsA(
            isA<PosCancelCheckoutException>(),
          ));
    });
  });

  group('ECP POS Service (Change Item Quantity) ', () {
    test('Changes quantity of an existing item in checkout', () async {
      when(
        _httpClient.post(
          Uri.https(_posService.ecpPosAddress, 'pos/checkouts'),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                "touchpointId": _clientContext.touchpointId,
                "currencyCode": _clientContext.currencyCode,
              },
            },
          ),
        ),
      ).thenAnswer(
          (_) async => http.Response(mockEmptyPosOrderCheckoutJSON, 200));

      var checkout = await _posService.startNewCheckout();
      expect(checkout, isA<Checkout>());

      when(
        _httpClient.post(
          Uri.https(
            _posService.ecpPosAddress,
            'pos/checkouts/${checkout.checkoutId}'
            '/${checkout.metadata.entityVersion}/barcode',
          ),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                "touchpointId": _clientContext.touchpointId,
                "currencyCode": _clientContext.currencyCode,
              },
              'barcode': '3600542267724',
              'symbology': 'EAN13',
              'quantity': 1,
              'entryMethod': EntryMethod.SCANNED.value,
              'inputAttributes': {},
            },
          ),
        ),
      ).thenAnswer(
        (_) async => http.Response(mockOneItemPosCheckoutJSON, 200),
      );

      var oneItemCheckout = await _posService.addItem(
        checkout,
        '3600542267724',
        'EAN13',
        1,
        EntryMethod.SCANNED.value,
      );
      expect(oneItemCheckout.posOrder.items.length, 1);
      expect(oneItemCheckout.posOrder.items.first.quantity, 1);

      when(
        _httpClient.post(
          Uri.https(
            _posService.ecpPosAddress,
            'pos/checkouts/${oneItemCheckout.checkoutId}'
            '/${oneItemCheckout.metadata.entityVersion}'
            '/order/items/615c5446f2ab7f4b405ee4e8/quantity',
          ),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                "touchpointId": _clientContext.touchpointId,
                "currencyCode": _clientContext.currencyCode,
              },
              'quantity': 2,
            },
          ),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response(mockOneItemQuantityChangedPosCheckoutJSON, 200),
      );

      var oneItemQuantityChangedCheckout = await _posService.changeItemQuantity(
          mockOneItemCheckout, '615c5446f2ab7f4b405ee4e8', 2);
      expect(oneItemQuantityChangedCheckout.posOrder.items.first.quantity, 2);
    });

    test('Throws PosTimeoutException (Change Item Quantity)', () {
      when(
        _httpClient.post(
          Uri.https(
            _posService.ecpPosAddress,
            'pos/checkouts/615c5405c9866f06ac32e989'
            '/2/order/items/615c5446f2ab7f4b405ee4e8/quantity',
          ),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                "touchpointId": _clientContext.touchpointId,
                "currencyCode": _clientContext.currencyCode,
              },
              'quantity': 2,
            },
          ),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 5));
        return http.Response(mockEcpError, 404);
      });

      var checkout = mockOneItemCheckout;
      expect(
          () => _posService.changeItemQuantity(
              checkout, '615c5446f2ab7f4b405ee4e8', 2),
          throwsA(isA<PosTimeoutException>()));
    });

    test('Throws PosChangeItemQuantityException', () async {
      when(
        _httpClient.post(
          Uri.https(
            _posService.ecpPosAddress,
            'pos/checkouts/615c5405c9866f06ac32e989'
            '/2/order/items/615c5446f2ab7f4b405ee4e8/quantity',
          ),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                "touchpointId": _clientContext.touchpointId,
                "currencyCode": _clientContext.currencyCode,
              },
              'quantity': 2,
            },
          ),
        ),
      ).thenAnswer((_) async => http.Response(mockEcpError, 404));

      var checkout = mockOneItemCheckout;
      expect(
          () => _posService.changeItemQuantity(
              checkout, '615c5446f2ab7f4b405ee4e8', 2),
          throwsA(isA<PosChangeItemQuantityException>()));
    });
  });

  group('ECP Pos Service (Finish Checkout):', () {
    test('Finishes/completes a checkout', () async {
      var checkout = Checkout.fromJson(
        jsonDecode(http.Response(mockNewCheckoutJSON, 200).body),
      );
      when(
        _httpClient.post(
          Uri.https(
              _posService.ecpPosAddress,
              'pos/checkouts/${checkout.checkoutId}'
              '/${checkout.metadata.entityVersion}/finish'),
          headers: anyNamed('headers'),
          body: jsonEncode(<String, dynamic>{
            'clientContext': {
              'touchpointId': _clientContext.touchpointId,
              'currencyCode': _clientContext.currencyCode,
            },
          }),
        ),
      ).thenAnswer(
        (_) async => http.Response(mockCheckoutFinishedJSON, 200),
      );

      var finishedCheckout = await _posService.finishCheckout(checkout);
      expect(finishedCheckout, isA<Checkout>());
      expect(finishedCheckout.state, CheckoutState.FINISHED);
      expect(finishedCheckout.posOrder.state, OrderState.COMPLETED);
      expect(finishedCheckout.metadata.entityVersion, 2);
    });

    test('throws PosTimeoutException (Finish Checkout)', () async {
      var checkout = Checkout.fromJson(
        jsonDecode(http.Response(mockNewCheckoutJSON, 200).body),
      );
      when(
        _httpClient.post(
          Uri.https(
              _posService.ecpPosAddress,
              'pos/checkouts/${checkout.checkoutId}'
              '/${checkout.metadata.entityVersion}/finish'),
          headers: anyNamed('headers'),
          body: jsonEncode(<String, dynamic>{
            'clientContext': {
              'touchpointId': _clientContext.touchpointId,
              'currencyCode': _clientContext.currencyCode,
            },
          }),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 5));
        return http.Response('Timeout', 408);
      });

      expect(
          _posService.finishCheckout(checkout),
          throwsA(
            isA<PosTimeoutException>(),
          ));
    });

    test('throws PosFinishCheckoutException', () async {
      var checkout = Checkout.fromJson(
        jsonDecode(http.Response(mockNewCheckoutJSON, 200).body),
      );
      when(
        _httpClient.post(
          Uri.https(
              _posService.ecpPosAddress,
              'pos/checkouts/${checkout.checkoutId}'
              '/${checkout.metadata.entityVersion}/finish'),
          headers: anyNamed('headers'),
          body: jsonEncode(<String, dynamic>{
            'clientContext': {
              'touchpointId': _clientContext.touchpointId,
              'currencyCode': _clientContext.currencyCode,
            },
          }),
        ),
      ).thenAnswer((_) async => http.Response(mockEcpError, 400));

      expect(
          _posService.finishCheckout(checkout),
          throwsA(
            isA<PosFinishCheckoutException>(),
          ));
    });
  });

  group('ECP Pos Service (Start New Checkout):', () {
    test('Starts a new active checkout', () async {
      when(
        _httpClient.post(
          Uri.https(_posService.ecpPosAddress, 'pos/checkouts'),
          headers: anyNamed('headers'),
          body: jsonEncode(<String, dynamic>{
            'clientContext': {
              'touchpointId': _clientContext.touchpointId,
              'currencyCode': _clientContext.currencyCode,
            },
          }),
        ),
      ).thenAnswer((_) async => http.Response(mockNewCheckoutJSON, 200));

      var checkout = await _posService.startNewCheckout();
      expect(checkout, isA<Checkout>());
      expect(checkout.state, CheckoutState.ACTIVE);
    });

    test('Throws PosTimeoutException (Start New Checkout)', () async {
      when(
        _httpClient.post(
          Uri.https(_posService.ecpPosAddress, 'pos/checkouts'),
          headers: anyNamed('headers'),
          body: jsonEncode(<String, dynamic>{
            'clientContext': {
              'touchpointId': _clientContext.touchpointId,
              'currencyCode': _clientContext.currencyCode,
            },
          }),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 5));
        return http.Response('Timeout', 408);
      });

      expect(
          _posService.startNewCheckout(),
          throwsA(
            isA<PosTimeoutException>(),
          ));
    });

    test('throws PosStartNewCheckoutException', () async {
      when(
        _httpClient.post(
          Uri.https(_posService.ecpPosAddress, 'pos/checkouts'),
          headers: anyNamed('headers'),
          body: jsonEncode(<String, dynamic>{
            'clientContext': {
              'touchpointId': _clientContext.touchpointId,
              'currencyCode': _clientContext.currencyCode,
            },
          }),
        ),
      ).thenAnswer((_) async => http.Response(mockEcpError, 400));

      expect(
          _posService.startNewCheckout(),
          throwsA(
            isA<PosStartNewCheckoutException>(),
          ));
    });
  });

  group('ECP Pos Service (Void Checkout item)', () {
    test('Voids item in checkout', () async {
      when(
        _httpClient.post(
          Uri.https(_posService.ecpPosAddress, 'pos/checkouts'),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                'touchpointId': _clientContext.touchpointId,
                'currencyCode': _clientContext.currencyCode,
              },
            },
          ),
        ),
      ).thenAnswer(
          (_) async => http.Response(mockEmptyPosOrderCheckoutJSON, 200));

      var checkout = await _posService.startNewCheckout();
      expect(checkout, isA<Checkout>());

      when(
        _httpClient.post(
          Uri.https(
            _posService.ecpPosAddress,
            'pos/checkouts/${checkout.checkoutId}'
            '/${checkout.metadata.entityVersion}/barcode',
          ),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                'touchpointId': checkout.touchpointId,
                'currencyCode': UiuxNumber.currencyCode,
              },
              'barcode': '3600542267724',
              'symbology': 'EAN13',
              'quantity': 1,
              'entryMethod': EntryMethod.SCANNED.value,
              'inputAttributes': {},
            },
          ),
        ),
      ).thenAnswer(
        (_) async => http.Response(mockOneItemPosCheckoutJSON, 200),
      );

      var newCheckout = await _posService.addItem(
        checkout,
        '3600542267724',
        'EAN13',
        1,
        EntryMethod.SCANNED.value,
      );
      expect(newCheckout.posOrder.items.length, 1);
      expect(newCheckout.posOrder.items.first.quantity, 1);
      expect(newCheckout.posOrder.items.first.voided, false);

      when(
        _httpClient.post(
          Uri.https(
            _posService.ecpPosAddress,
            'pos/checkouts/${newCheckout.checkoutId}'
            '/${newCheckout.metadata.entityVersion}/order'
            '/items/615c5446f2ab7f4b405ee4e8/void',
          ),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                'touchpointId': _clientContext.touchpointId,
                'currencyCode': _clientContext.currencyCode,
              },
            },
          ),
        ),
      ).thenAnswer(
        (_) async => http.Response(mockCheckoutOneItemVoidedJSON, 200),
      );

      var checkoutOneItemVoided = await _posService.voidItem(
        newCheckout,
        '615c5446f2ab7f4b405ee4e8',
      );
      expect(checkoutOneItemVoided.posOrder.items.length, 1);
      expect(checkoutOneItemVoided.posOrder.items.first.quantity, 1);
      expect(checkoutOneItemVoided.posOrder.items.first.voided, true);
    });

    test('Throws PosTimeoutException (Void Item Checkout)', () async {
      var checkout = mockOneItemCheckout;
      when(
        _httpClient.post(
          Uri.https(
              _posService.ecpPosAddress,
              'pos/checkouts/${checkout.checkoutId}'
              '/${checkout.metadata.entityVersion}/order'
              '/items/615c5446f2ab7f4b405ee4e8/void'),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                'touchpointId': _clientContext.touchpointId,
                'currencyCode': _clientContext.currencyCode,
              },
            },
          ),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 5));
        return http.Response(mockEcpError, 408);
      });

      expect(
          () => _posService.voidItem(
                checkout,
                '615c5446f2ab7f4b405ee4e8',
              ),
          throwsA(isA<PosTimeoutException>()));
    });

    test('Throws PosCheckoutVoidItemException', () async {
      var checkout = mockOneItemCheckout;
      when(
        _httpClient.post(
          Uri.https(
              _posService.ecpPosAddress,
              'pos/checkouts/${checkout.checkoutId}'
              '/${checkout.metadata.entityVersion}/order'
              '/items/615c5446f2ab7f4b405ee4e8/void'),
          headers: anyNamed('headers'),
          body: jsonEncode(
            <String, dynamic>{
              'clientContext': {
                'touchpointId': _clientContext.touchpointId,
                'currencyCode': _clientContext.currencyCode,
              },
            },
          ),
        ),
      ).thenAnswer((_) async => http.Response(mockEcpError, 404));

      expect(
          () => _posService.voidItem(
                checkout,
                '615c5446f2ab7f4b405ee4e8',
              ),
          throwsA(isA<PosCheckoutVoidItemException>()));
    });
  });
}
