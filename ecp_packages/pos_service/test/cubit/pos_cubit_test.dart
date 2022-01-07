import 'package:auth_service/auth_service.dart';
import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:ecp_openapi/model/ecp_error.dart';
import 'package:ecp_openapi/model/entry_method.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_service/pos_service.dart';

class MockECPPosService extends Mock implements PosService {}

class MockCheckout extends Mock implements Checkout {}

void main() {
  late MockECPPosService _posService;
  late EcpError _ecpError;

  setUpAll(() {
    _posService = MockECPPosService();
    _ecpError = EcpError.empty;
  });

  group('PosCubit (AddItem)', () {
    test('emits PosOrderAddItem, PosOrderItemAdded, PosCheckoutReady', () {
      var posCubit = PosCubit(_posService);
      var mockCheckoutPosOrder = MockCheckout();
      var mockCheckoutPosOrderAdded = MockCheckout();

      when(() => _posService.addItem(
            mockCheckoutPosOrder,
            '3600542267724',
            'EAN13',
            3,
            EntryMethod.SCANNED.value,
          )).thenAnswer((_) async {
        return mockCheckoutPosOrderAdded;
      });

      posCubit.addItem(
        mockCheckoutPosOrder,
        '3600542267724',
        'EAN13',
        3,
        EntryMethod.SCANNED.value,
      );
      expect(posCubit.state, PosCheckoutOrderAddItem());

      expectLater(
        posCubit.stream,
        emitsInOrder(
          [
            PosCheckoutOrderItemAdded(mockCheckoutPosOrderAdded),
            PosCheckoutReady(mockCheckoutPosOrderAdded),
          ],
        ),
      );
    });

    test('Add item emits PosError', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();

      when(() => _posService.addItem(
            mockCheckout,
            '3600542267724',
            'EAN13',
            3,
            EntryMethod.SCANNED.value,
          )).thenThrow(const PosException());

      posCubit.addItem(
        mockCheckout,
        '3600542267724',
        'EAN13',
        3,
        EntryMethod.SCANNED.value,
      );
      expect(posCubit.state, PosCheckoutError(_ecpError, mockCheckout));
    });

    test('Add item emits AuthException', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();

      when(() => _posService.addItem(
            mockCheckout,
            '3600542267724',
            'EAN13',
            3,
            EntryMethod.SCANNED.value,
          )).thenThrow(AuthException());

      posCubit.addItem(
        mockCheckout,
        '3600542267724',
        'EAN13',
        3,
        EntryMethod.SCANNED.value,
      );
      expect(posCubit.state, PosCheckoutLogout());
    });

    test('Emits PosError when item not found', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      var testJson = ''' 
      {
            "attributes": {},
            "type": "FAILURE",
            "message": {
                "key": {
                    "group": "orders",
                    "code": "item-not-found"
                },
                "defaultMessage": "CatalogItem with id \${itemId} could not be found.",
                "placeholderValues": {
                    "touchpointId": "test123"
                    }
                }
        }
      ''';
      var itemNotFoundError = EcpErrorHandler.handleError(400, testJson);

      when(() => _posService.addItem(
            mockCheckout,
            '3600542267724',
            'EAN13',
            3,
            EntryMethod.SCANNED.value,
          )).thenThrow(PosException(ecpError: itemNotFoundError));

      posCubit.addItem(
        mockCheckout,
        '3600542267724',
        'EAN13',
        3,
        EntryMethod.SCANNED.value,
      );

      expect(
          posCubit.state,
          PosCheckoutError(
            itemNotFoundError,
            mockCheckout,
            PosCheckoutErrorView.basket,
            PosCheckoutErrorCode.itemNotFound,
          ));
    });

    test('Emits PosError when item blocked', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      var testJson = ''' 
      {
          "attributes": {},
          "type": "FAILURE",
          "message": {
              "key": {
                  "group": "orders",
                  "code": "order-add-item-blocked-for-sale"
              },
              "defaultMessage": "Impossible to add item \${itemDescription}, item is blocked for sale.",
              "placeholderValues": {
                  "itemDescription": {
                      "default": {
                          "languageCode": "default",
                          "text": "Pepsi Zero Sugar"
                      }	
                  }
              }
          }
      }
      ''';
      var itemBlockedError = EcpErrorHandler.handleError(400, testJson);

      when(() => _posService.addItem(
            mockCheckout,
            '3600542267724',
            'EAN13',
            3,
            EntryMethod.SCANNED.value,
          )).thenThrow(PosException(ecpError: itemBlockedError));

      posCubit.addItem(
        mockCheckout,
        '3600542267724',
        'EAN13',
        3,
        EntryMethod.SCANNED.value,
      );

      expect(
          posCubit.state,
          PosCheckoutError(
            itemBlockedError,
            mockCheckout,
            PosCheckoutErrorView.basket,
            PosCheckoutErrorCode.orderAddItemBlockedForSale,
          ));
    });
  });

  group('AddPayment', () {
    test('emits PosAddPayment,PosPaymentAdded', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      var mockCheckoutPaid = MockCheckout();

      when(() => _posService.addPayment(mockCheckout, '1', 1.00))
          .thenAnswer((_) async {
        return mockCheckoutPaid;
      });

      posCubit.addPayment(mockCheckout, '1', 1.00);
      expect(posCubit.state, PosCheckoutAddPayment());

      expectLater(
        posCubit.stream,
        emits(
          PosCheckoutPaymentAdded(mockCheckoutPaid),
        ),
      );
    });
    test('add payment emits PosError', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      when(() => _posService.addPayment(mockCheckout, '1', 1.00))
          .thenThrow(const PosException());

      posCubit.addPayment(mockCheckout, '1', 1.00);
      expect(
          posCubit.state, PosCheckoutAddPaymentError(_ecpError, mockCheckout));
    });
    test('add payment emits AuthException', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      when(() => _posService.addPayment(mockCheckout, '1', 1.00))
          .thenThrow(AuthException());

      posCubit.addPayment(mockCheckout, '1', 1.00);
      expect(posCubit.state, PosCheckoutLogout());
    });
  });

  group('CancelCheckout', () {
    test('emits PosCheckoutCancel,PosCheckoutCancelled', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      var mockCheckoutCancelled = MockCheckout();

      when(() => _posService.cancelCheckout(mockCheckout))
          .thenAnswer((_) async {
        return mockCheckoutCancelled;
      });

      posCubit.cancelCheckout(mockCheckout, false);
      expect(posCubit.state, PosCheckoutCancel());

      expectLater(
        posCubit.stream,
        emits(
          PosCheckoutCancelled(mockCheckoutCancelled),
        ),
      );
    });
    test('Emits PosCheckoutError (Cancel Checkout)', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      when(() => _posService.cancelCheckout(mockCheckout))
          .thenThrow(const PosException());

      posCubit.cancelCheckout(mockCheckout, false);
      expect(posCubit.state, PosCheckoutError(_ecpError, mockCheckout));
    });
    test('Emits AuthException (Cancel Checkout)', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      when(() => _posService.cancelCheckout(mockCheckout))
          .thenThrow(AuthException());

      posCubit.cancelCheckout(mockCheckout, false);
      expect(posCubit.state, PosCheckoutLogout());
    });
  });

  group('PosCubit (ChangeItemQuantity)', () {
    test('Emits PosCheckoutItemQuantityChange, PosCheckoutQuantityChanged', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      var mockCheckoutQuantityChanged = MockCheckout();

      when(() => _posService.changeItemQuantity(
          mockCheckout, '615c5446f2ab7f4b405ee4e8', 2)).thenAnswer((_) async {
        return mockCheckoutQuantityChanged;
      });

      posCubit.changeItemQuantity(mockCheckout, '615c5446f2ab7f4b405ee4e8', 2);
      expect(posCubit.state, PosCheckoutItemQuantityChange());

      expectLater(
        posCubit.stream,
        emits(
          PosCheckoutItemQuantityChanged(mockCheckoutQuantityChanged),
        ),
      );
    });

    test('Emits PosError (Change Item Quantity)', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();

      when(() => _posService.changeItemQuantity(
              mockCheckout, '615c5446f2ab7f4b405ee4e8', 2))
          .thenThrow(const PosException());

      posCubit.changeItemQuantity(mockCheckout, '615c5446f2ab7f4b405ee4e8', 2);
      expect(posCubit.state, PosCheckoutError(_ecpError, mockCheckout));
    });
    test('Emits AuthException (Change Item Quantity)', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();

      when(() => _posService.changeItemQuantity(
              mockCheckout, '615c5446f2ab7f4b405ee4e8', 2))
          .thenThrow(AuthException());

      posCubit.changeItemQuantity(mockCheckout, '615c5446f2ab7f4b405ee4e8', 2);
      expect(posCubit.state, PosCheckoutLogout());
    });

    test('Emits PosError when quantity zero (Change Item Quantity)', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      var testJson = ''' 
      {
          "attributes": {},
          "type": "FAILURE",
          "message": {
              "key": {
                  "group": "orders",
                  "code": "order-change-item-quantity-less-than-zero"
              },
              "defaultMessage": "Cannot change the quantity for item \${itemDescription}. Quantity is less than 0.",
              "placeholderValues": {
                  "itemDescription": {
                      "default": {
                          "languageCode": "default",
                          "text": "Milk"
                      }
                  }
              }
          }
      }
      ''';
      var quantityZeroError = EcpErrorHandler.handleError(400, testJson);

      when(() => _posService.changeItemQuantity(
              mockCheckout, '615c5446f2ab7f4b405ee4e8', 2))
          .thenThrow(PosException(ecpError: quantityZeroError));

      posCubit.changeItemQuantity(mockCheckout, '615c5446f2ab7f4b405ee4e8', 2);

      expect(
          posCubit.state,
          PosCheckoutError(
            quantityZeroError,
            mockCheckout,
            PosCheckoutErrorView.basket,
            PosCheckoutErrorCode.orderChangeItemQuantityLessThanZero,
          ));
    });
  });

  group('FinishCheckout', () {
    test('emits PosCheckoutFinish,PosCheckoutFinished', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      var mockCheckoutFinished = MockCheckout();

      when(() => _posService.finishCheckout(mockCheckout))
          .thenAnswer((_) async {
        return mockCheckoutFinished;
      });

      posCubit.finishCheckout(mockCheckout);
      expect(posCubit.state, PosCheckoutFinish());

      expectLater(
        posCubit.stream,
        emits(
          PosCheckoutFinished(mockCheckoutFinished),
        ),
      );
    });
    test('finish checkout emits PosError', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      when(() => _posService.finishCheckout(mockCheckout))
          .thenThrow(const PosException());

      posCubit.finishCheckout(mockCheckout);
      expect(posCubit.state, PosCheckoutError(_ecpError, mockCheckout));
    });
    test('finish checkout emits AuthException', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      when(() => _posService.finishCheckout(mockCheckout))
          .thenThrow(AuthException());

      posCubit.finishCheckout(mockCheckout);
      expect(posCubit.state, PosCheckoutLogout());
    });
  });

  group('PosCubit (setState)', () {
    test('set PosCheckoutInitial state', () {
      var posCubit = PosCubit(_posService);

      posCubit.setPosCheckoutInitialState();
      expect(posCubit.state, PosCheckoutInitial());
    });
    test('set PosCheckoutLogout state', () {
      var posCubit = PosCubit(_posService);

      posCubit.setPosCheckoutLogoutState();
      expect(posCubit.state, PosCheckoutLogout());
    });
    test('set PosCheckoutReady state', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();

      posCubit.setPosCheckoutReadyState(mockCheckout);
      expect(posCubit.state, PosCheckoutReady(mockCheckout));
    });
    test('set PosCheckoutOrderCompleted state', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();

      posCubit.setPosCheckoutOrderCompletedState(mockCheckout);
      expect(posCubit.state, PosCheckoutOrderCompleted(mockCheckout));
    });
  });

  group('StartNewCheckout', () {
    test('initial state', () {
      var posCubit = PosCubit(_posService);
      expect(posCubit.state, PosCheckoutInitial());
    });

    test('emits PosCheckoutStart,PosCheckoutStarted,PosCheckoutReady', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();

      when(() => _posService.startNewCheckout()).thenAnswer((_) async {
        return mockCheckout;
      });

      posCubit.startNewCheckout();
      expect(posCubit.state, PosCheckoutStart());

      expectLater(
        posCubit.stream,
        emitsInOrder(
          [
            PosCheckoutStarted(mockCheckout),
            PosCheckoutReady(mockCheckout),
          ],
        ),
      );
    });
    test('Emits PosCheckoutError (Start New Checkout)', () {
      var posCubit = PosCubit(_posService);
      when(() => _posService.startNewCheckout())
          .thenThrow(const PosException());

      posCubit.startNewCheckout();
      expect(posCubit.state, PosCheckoutError(_ecpError, Checkout.empty));
    });
    test('Emits AuthException (Start New Checkout)', () {
      var posCubit = PosCubit(_posService);
      when(() => _posService.startNewCheckout()).thenThrow(AuthException());

      posCubit.startNewCheckout();
      expect(posCubit.state, PosCheckoutLogout());
    });

    test('Emits PosCheckoutError checkout already exists (Start New Checkout)',
        () {
      var posCubit = PosCubit(_posService);
      var testJson = ''' 
      {
        "attributes":{},
        "type":"FAILURE",
        "message":
        {
          "key":
          {
            "group":
            "pos",
            "code":
            "checkout-already-exists"
          },
          "defaultMessage":"Impossible to create a checkout for Touchpoint \${touchpointId}. There is already one ACTIVE.",
          "placeholderValues":
          {
            "touchpointId":"Test1"
          }
        }
      }
      ''';
      var checkoutAlreadyExistsError =
          EcpErrorHandler.handleError(400, testJson);

      when(() => _posService.startNewCheckout())
          .thenThrow(PosException(ecpError: checkoutAlreadyExistsError));

      posCubit.startNewCheckout();
      expect(
          posCubit.state,
          PosCheckoutError(
            checkoutAlreadyExistsError,
            Checkout.empty,
            PosCheckoutErrorView.none,
            PosCheckoutErrorCode.checkoutAlreadyExists,
          ));
    });
  });

  group('PosCubit (Void Checkout Item)', () {
    test('Emits PosCheckoutItemVoid, PosCheckoutItemVoided', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();
      var mockCheckoutItemVoided = MockCheckout();

      when(() => _posService.voidItem(
            mockCheckout,
            '232323',
          )).thenAnswer((_) async {
        return mockCheckoutItemVoided;
      });

      posCubit.voidItemCheckout(
        mockCheckout,
        '232323',
      );
      expect(posCubit.state, PosCheckoutItemVoid());

      expectLater(
        posCubit.stream,
        emitsInOrder(
          [
            PosCheckoutItemVoided(mockCheckoutItemVoided),
            PosCheckoutReady(mockCheckoutItemVoided),
          ],
        ),
      );
    });

    test('Emits PosCheckoutError (Void Checkout Item)', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();

      when(() => _posService.voidItem(
            mockCheckout,
            '232323',
          )).thenThrow(const PosException());

      posCubit.voidItemCheckout(
        mockCheckout,
        '232323',
      );
      expect(posCubit.state, PosCheckoutError(_ecpError, mockCheckout));
    });
    test('Emits AuthException (Void Checkout Item)', () {
      var posCubit = PosCubit(_posService);
      var mockCheckout = MockCheckout();

      when(() => _posService.voidItem(
            mockCheckout,
            '232323',
          )).thenThrow(AuthException());

      posCubit.voidItemCheckout(
        mockCheckout,
        '232323',
      );
      expect(posCubit.state, PosCheckoutLogout());
    });
  });
}
