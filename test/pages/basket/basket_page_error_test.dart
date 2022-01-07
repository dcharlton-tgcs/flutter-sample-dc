import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:ecp_openapi/model/ecp_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_service/pos_service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/pages/basket/basket.dart';
import 'package:ui_flutter_app/pages/basket/basket_view.dart';
import 'package:ui_flutter_app/pages/basket/components/basket_list.dart';
import 'package:ui_flutter_app/common_widgets/navigation_bar.dart'
    as ecp_nav_bar;
import 'package:ui_flutter_app/pages/basket/components/checkout_area.dart';
import 'package:ui_flutter_app/pages/basket/components/totals_area.dart';
import 'package:ui_flutter_app/pages/processing/processing_view.dart';
import 'package:ui_peripheral_agent/cubit/peripheral_agent_cubits.dart';

import '../../../ecp_packages/pos_service/test/mock_service_data.dart';
import '../../helpers/pump_bloc_app.dart';

class FakePosState extends Fake implements PosState {}

class FakePeripheralState extends Fake implements PeripheralState {}

class MockPosCubit extends MockCubit<PosState> implements PosCubit {}

class MockScannerCubit extends MockCubit<PeripheralState>
    implements ScannerCubit {}

void main() {
  late EcpError ecpError;
  late Checkout newCheckout;
  late Checkout checkoutOneItem;
  late PosCubit posCubit;
  late ScannerCubit scannerCubit;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakePosState());
    registerFallbackValue(FakePeripheralState());
    newCheckout = mockNewCheckout;
    checkoutOneItem = mockCheckoutOneItem;
    ecpError = EcpError.empty;
  });

  group('Basket Page Errors Testing', () {
    setUp(() {
      posCubit = MockPosCubit();
      scannerCubit = MockScannerCubit();
    });

    testWidgets('default error', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      final expectedStates = [
        PosCheckoutError(
          ecpError,
          newCheckout,
        ),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStates));

      when(() => posCubit.state).thenReturn(PosCheckoutError(
        ecpError,
        newCheckout,
      ));
      await tester.pumpBlocApp(const BasketPage(), providers);
      await tester.pump();

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(BasketView), findsOneWidget);
      expect(find.byType(ProcessingView), findsOneWidget);
      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.secondaryAlertButtonKey), findsNothing);

      when(() => posCubit.setPosCheckoutReadyState(newCheckout))
          .thenAnswer((_) async {
        PosCheckoutReady(newCheckout);
      });
      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      await tester.pump();
      expect(find.byType(GeneralAlertDialog), findsNothing);
    });

    testWidgets('payment error', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      final expectedStates = [
        PosCheckoutAddPaymentError(ecpError, checkoutOneItem),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStates));
      when(() => posCubit.state)
          .thenReturn(PosCheckoutAddPaymentError(ecpError, checkoutOneItem));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ProcessingView), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsNothing);
      expect(find.byType(TotalsAreaWidget), findsNothing);
      expect(find.byType(CheckoutAreaWidget), findsNothing);
      expect(find.byType(ItemsListWidget), findsNothing);
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Failed to Process Payment'), findsWidgets);
      when(() => posCubit.setPosCheckoutReadyState(checkoutOneItem))
          .thenAnswer((_) async {
        PosCheckoutReady(checkoutOneItem);
      });
      when(() => posCubit.state).thenReturn(PosCheckoutReady(checkoutOneItem));

      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(SnackBar), findsNothing);
      await tester.pump();
      expect(posCubit.state, PosCheckoutReady(checkoutOneItem));
    });

    testWidgets('item not found error', (tester) async {
      var testJSON = '''
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
                  "itemId": "96"
                  }
              }
      }
      ''';
      var _itemNotFoundError = EcpErrorHandler.handleError(400, testJSON);

      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      final expectedStates = [
        PosCheckoutError(
          _itemNotFoundError,
          newCheckout,
          PosCheckoutErrorView.basket,
          PosCheckoutErrorCode.itemNotFound,
        ),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStates));

      when(() => posCubit.state).thenReturn(PosCheckoutError(
        _itemNotFoundError,
        newCheckout,
        PosCheckoutErrorView.basket,
        PosCheckoutErrorCode.itemNotFound,
      ));
      await tester.pumpBlocApp(const BasketPage(), providers);
      await tester.pumpAndSettle();

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ProcessingView), findsNothing);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsNothing);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);

      await tester.tapAt(tester.getCenter(find.byType(GenericAppBar)));
      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.secondaryAlertButtonKey), findsNothing);
      expect(find.text('CatalogItem with id 96 could not be found.'),
          findsWidgets);

      when(() => posCubit.setPosCheckoutReadyState(newCheckout))
          .thenAnswer((_) async {
        PosCheckoutReady(newCheckout);
      });
      when(() => posCubit.state).thenReturn(PosCheckoutReady(newCheckout));
      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(GeneralAlertDialog), findsNothing);
      expect(posCubit.state, PosCheckoutReady(newCheckout));
    });

    testWidgets('item blocked for sale error', (tester) async {
      var testJSON = '''
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
      var _itemBlockedError = EcpErrorHandler.handleError(400, testJSON);

      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      final expectedStates = [
        PosCheckoutError(
          _itemBlockedError,
          newCheckout,
          PosCheckoutErrorView.basket,
          PosCheckoutErrorCode.orderAddItemBlockedForSale,
        ),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStates));

      when(() => posCubit.state).thenReturn(PosCheckoutError(
        _itemBlockedError,
        newCheckout,
        PosCheckoutErrorView.basket,
        PosCheckoutErrorCode.orderAddItemBlockedForSale,
      ));
      await tester.pumpBlocApp(const BasketPage(), providers);
      await tester.pumpAndSettle();

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ProcessingView), findsNothing);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsNothing);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);

      await tester.tapAt(tester.getCenter(find.byType(GenericAppBar)));
      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.secondaryAlertButtonKey), findsNothing);
      expect(
          find.text(
              'Impossible to add item Pepsi Zero Sugar, item is blocked for sale.'),
          findsOneWidget);

      when(() => posCubit.setPosCheckoutReadyState(newCheckout))
          .thenAnswer((_) async {
        PosCheckoutReady(newCheckout);
      });
      when(() => posCubit.state).thenReturn(PosCheckoutReady(newCheckout));
      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(GeneralAlertDialog), findsNothing);
      expect(posCubit.state, PosCheckoutReady(newCheckout));
    });

    testWidgets('Cannot change quantity to zero', (tester) async {
      var testJSON = '''
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
      var _zeroNotAllowedError = EcpErrorHandler.handleError(400, testJSON);

      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      final expectedStates = [
        PosCheckoutError(
          _zeroNotAllowedError,
          checkoutOneItem,
          PosCheckoutErrorView.basket,
          PosCheckoutErrorCode.orderChangeItemQuantityLessThanZero,
        ),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStates));

      when(() => posCubit.state).thenReturn(PosCheckoutError(
        _zeroNotAllowedError,
        checkoutOneItem,
        PosCheckoutErrorView.basket,
        PosCheckoutErrorCode.orderChangeItemQuantityLessThanZero,
      ));
      await tester.pumpBlocApp(const BasketPage(), providers);
      await tester.pumpAndSettle();

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ProcessingView), findsNothing);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsNothing);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);

      await tester.tapAt(tester.getCenter(find.byType(GenericAppBar)));
      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.secondaryAlertButtonKey), findsNothing);
      expect(
          find.text(
              'Cannot change the quantity for item Milk. Quantity is less than 0.'),
          findsOneWidget);

      when(() => posCubit.setPosCheckoutReadyState(checkoutOneItem))
          .thenAnswer((_) async {
        PosCheckoutReady(checkoutOneItem);
      });
      when(() => posCubit.state).thenReturn(PosCheckoutReady(checkoutOneItem));
      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(GeneralAlertDialog), findsNothing);
      expect(posCubit.state, PosCheckoutReady(checkoutOneItem));
    });

    testWidgets('checkout already exists', (tester) async {
      var testJSON = '''
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
      var _checkoutAlreadyExistsError =
          EcpErrorHandler.handleError(400, testJSON);

      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      final expectedStates = [
        PosCheckoutError(
          _checkoutAlreadyExistsError,
          newCheckout,
          PosCheckoutErrorView.none,
          PosCheckoutErrorCode.checkoutAlreadyExists,
        ),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStates));

      when(() => posCubit.state).thenReturn(PosCheckoutError(
        _checkoutAlreadyExistsError,
        newCheckout,
        PosCheckoutErrorView.none,
        PosCheckoutErrorCode.checkoutAlreadyExists,
      ));
      await tester.pumpBlocApp(const BasketPage(), providers);
      await tester.pump();

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ProcessingView), findsOneWidget);

      await tester.tapAt(tester.getCenter(find.byType(GenericAppBar)));
      await tester.pump();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.secondaryAlertButtonKey), findsNothing);
      expect(
          find.text(
              'Impossible to create a checkout for Touchpoint Test1. There is already one ACTIVE.'),
          findsOneWidget);

      expect(find.text('Checkout already exists'), findsOneWidget);

      when(() => posCubit.setPosCheckoutInitialState()).thenAnswer((_) async {
        PosCheckoutInitial();
      });
      when(() => posCubit.state).thenReturn(PosCheckoutInitial());
      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      await tester.pump();
      expect(find.byType(GeneralAlertDialog), findsNothing);
      expect(posCubit.state, PosCheckoutInitial());
    });

    testWidgets('415 - spring-framework error', (tester) async {
      var testJSON = '''
      {
        "timestamp":"2021-10-08T11:23:26.685+00:00",
        "path":"/pos/checkouts/61602a2cc9866f06ac32e9bf/1/order/items",
        "status":415,
        "error":"Unsupported Media Type",
        "requestId":"6317a383"
      }
      ''';
      var _springFrameworkError = EcpErrorHandler.handleError(415, testJSON);

      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      final expectedStates = [
        PosCheckoutError(
          _springFrameworkError,
          newCheckout,
        ),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStates));

      when(() => posCubit.state).thenReturn(PosCheckoutError(
        _springFrameworkError,
        newCheckout,
      ));
      await tester.pumpBlocApp(const BasketPage(), providers);
      await tester.pump();

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ProcessingView), findsOneWidget);

      await tester.tapAt(tester.getCenter(find.byType(GenericAppBar)));
      await tester.pump();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.secondaryAlertButtonKey), findsNothing);
      expect(find.text('FAILURE - 415'), findsOneWidget);

      expect(find.byType(Text), findsNWidgets(5));

      when(() => posCubit.setPosCheckoutReadyState(newCheckout))
          .thenAnswer((_) async {
        PosCheckoutReady(newCheckout);
      });
      when(() => posCubit.state).thenReturn(PosCheckoutReady(newCheckout));
      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      await tester.pump();
      expect(find.byType(GeneralAlertDialog), findsNothing);
      expect(posCubit.state, PosCheckoutReady(newCheckout));
    });

    testWidgets('order already completed', (tester) async {
      var testJSON = '''
      {
          "attributes": {},
          "type": "FAILURE",
          "message": {
              "key": {
                  "group": "orders",
                  "code": "order-accept-other-state"
              },
              "defaultMessage": "Impossible to accept Order \${orderId}, Order is in state \${state}.",
              "placeholderValues": {
                  "orderId": "1111",
                  "state": "COMPLETED"
              }
          }
      }
      ''';
      var _orderAlreadyCompltedError =
          EcpErrorHandler.handleError(400, testJSON);

      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      final expectedStates = [
        PosCheckoutError(
          _orderAlreadyCompltedError,
          checkoutOneItem,
        ),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStates));

      when(() => posCubit.state).thenReturn(PosCheckoutError(
        _orderAlreadyCompltedError,
        newCheckout,
      ));
      await tester.pumpBlocApp(const BasketPage(), providers);
      await tester.pump();

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ProcessingView), findsOneWidget);

      await tester.tapAt(tester.getCenter(find.byType(GenericAppBar)));
      await tester.pump();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.secondaryAlertButtonKey), findsNothing);
      expect(find.text('FAILURE - order-accept-other-state'), findsOneWidget);

      expect(
          find.text(
              'Group: orders\nImpossible to accept Order 1111, Order is in state COMPLETED.'),
          findsOneWidget);

      when(() => posCubit.setPosCheckoutReadyState(checkoutOneItem))
          .thenAnswer((_) async {
        PosCheckoutReady(checkoutOneItem);
      });
      when(() => posCubit.state).thenReturn(PosCheckoutReady(checkoutOneItem));
      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      await tester.pump();
      expect(find.byType(GeneralAlertDialog), findsNothing);
      expect(posCubit.state, PosCheckoutReady(checkoutOneItem));
    });
  });
}
