import 'package:auth_service/auth_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:ecp_openapi/model/entry_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_service/pos_service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/common_widgets/navigation_bar.dart'
    as ecp_nav_bar;
import 'package:ui_flutter_app/pages/basket/basket.dart';
import 'package:ui_flutter_app/pages/basket/basket_view.dart';
import 'package:ui_flutter_app/pages/basket/components/basket_list.dart';
import 'package:ui_flutter_app/pages/basket/components/bottom_sheet/barcode_keypad.dart';
import 'package:ui_flutter_app/pages/basket/components/bottom_sheet/checkout_slider.dart';
import 'package:ui_flutter_app/pages/basket/components/bottom_sheet/quantity_keypad.dart';
import 'package:ui_flutter_app/pages/basket/components/checkout_area.dart';
import 'package:ui_flutter_app/pages/basket/components/totals_area.dart';
import 'package:ui_flutter_app/pages/processing/processing_view.dart';
import 'package:ui_flutter_app/pages/transaction_completed/transaction_completed_view.dart';
import 'package:ui_peripheral_agent/cubit/peripheral_agent_cubits.dart';

import '../../../ecp_packages/pos_service/test/mock_service_data.dart';
import '../../helpers/pump_bloc_app.dart';

class FakePosState extends Fake implements PosState {}

class FakePeripheralState extends Fake implements PeripheralState {}

class MockPosCubit extends MockCubit<PosState> implements PosCubit {}

class MockPrinterCubit extends MockCubit<PeripheralState>
    implements PrinterCubit {}

class MockScannerCubit extends MockCubit<PeripheralState>
    implements ScannerCubit {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  const keypadButtonKey = ecp_nav_bar.NavigationBar.keypadButtonKey;
  const basketButtonKey = ecp_nav_bar.NavigationBar.basketButtonKey;
  const settingsButtonKey = ecp_nav_bar.NavigationBar.settingsButtonKey;
  const proceedToCheckoutButtonKey = CheckoutAreaWidget.proceedToCheckoutKey;
  const couponButtonKey = CheckoutSliderWidget.couponButtonKey;
  const cardButtonKey = CheckoutSliderWidget.cardButtonKey;
  const basketItemsScrollList = ItemsListWidget.listScrollbarKey;

  late Checkout newEmptyCheckout;
  late Checkout oneItemCheckout;
  late Checkout oneItemWithLinkedItemCheckout;
  late Checkout oneNegativeItemCheckout;
  late Checkout twoNegativeItemsCheckout;
  late Checkout oneNegativeNormalLinkedItemsCheckout;
  late Checkout paidItemOrder;
  late Checkout completedItemOrder;
  late Checkout sevenNormalItemsCheckout;
  late Checkout sevenLinkedItemsCheckout;
  late PosCubit posCubit;
  late ScannerCubit scannerCubit;
  late AuthCubit authCubit;
  late PrinterCubit printerCubit;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakePosState());
    registerFallbackValue(FakePeripheralState());
    newEmptyCheckout = mockNewCheckout;
    oneItemCheckout = mockOneItemCheckout;
    oneItemWithLinkedItemCheckout = mockOneItemWithLinkedItem;
    paidItemOrder = mockCheckoutOneItemPaid;
    completedItemOrder = mockCheckoutFinished;
    sevenNormalItemsCheckout = mockCheckoutSevenItem;
    sevenLinkedItemsCheckout = mockCheckoutSevenLinkedItems;
    oneNegativeItemCheckout = mockCheckoutOneNegativeItem;
    twoNegativeItemsCheckout = mockCheckoutTwoNegativeItems;
    oneNegativeNormalLinkedItemsCheckout =
        mockCheckoutOneNegativeNormalLinkedItems;
  });

  group('Basket Page', () {
    setUp(() {
      posCubit = MockPosCubit();
      scannerCubit = MockScannerCubit();
      authCubit = MockAuthCubit();
      printerCubit = MockPrinterCubit();
    });

    testWidgets('renders basket with single negative item', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(oneNegativeItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsOneWidget);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GeneralButton), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(13));
      expect(find.text('Items: 1'), findsOneWidget);
      expect(
          find.text('Total: ' +
              UiuxNumber.currency(
                  oneNegativeItemCheckout.posOrder.totals.amount)),
          findsNWidgets(1));
      expect(find.text('Basket page'), findsNWidgets(2));
    });

    testWidgets('renders basket with multiple negative items', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(twoNegativeItemsCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsOneWidget);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GeneralButton), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(18));
      expect(find.text('Items: 2'), findsOneWidget);
      expect(
          find.text('Total: ' +
              UiuxNumber.currency(
                  twoNegativeItemsCheckout.posOrder.totals.amount)),
          findsNWidgets(1));
      expect(find.text('Basket page'), findsNWidgets(2));
    });

    testWidgets(
        'renders basket with multiple one normal item, one linked item and one negative item',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(oneNegativeNormalLinkedItemsCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsOneWidget);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GeneralButton), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(23));
      expect(find.text('Items: 4'), findsOneWidget);
      expect(
          find.text('Total: ' +
              UiuxNumber.currency(
                  oneNegativeNormalLinkedItemsCheckout.posOrder.totals.amount)),
          findsNWidgets(1));
      expect(find.text('Basket page'), findsNWidgets(2));
    });

    testWidgets('renders initial basket', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutInitial());
      when(() => posCubit.startNewCheckout())
          .thenAnswer((_) async => PosCheckoutReady(newEmptyCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(BasketView), findsOneWidget);
      expect(find.text('Basket page'), findsOneWidget);
    });

    testWidgets('renders empty basket', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(newEmptyCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsOneWidget);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GeneralButton), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(8));
      expect(find.text('Items: 0'), findsOneWidget);
      expect(
          find.text('Total:' +
              UiuxNumber.currency(newEmptyCheckout.posOrder.totals.amount)),
          findsNWidgets(1));
      expect(find.text('Basket page'), findsNWidgets(2));
      expect(
          tester
              .widget<GeneralButton>(find.byKey(proceedToCheckoutButtonKey))
              .buttonDisabled,
          isTrue);
    });

    testWidgets('renders basket with one item that cannot be changed',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(mockOneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsOneWidget);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GeneralButton), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(13));
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Milk'), findsOneWidget);
      expect(find.text(UiuxNumber.currency(2.22)), findsNWidgets(2));
      expect(find.text('Items: 1'), findsOneWidget);
      expect(find.text('Total:' + UiuxNumber.currency(2.22)), findsNWidgets(1));
      expect(find.text('Basket page'), findsNWidgets(2));
      expect(
          tester
              .widget<GeneralButton>(find.byKey(proceedToCheckoutButtonKey))
              .buttonDisabled,
          isFalse);
    });

    testWidgets('payment added', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];

      final expectedStates = [
        PosCheckoutPaymentAdded(paidItemOrder),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStates));
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutPaymentAdded(paidItemOrder));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ProcessingView), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsNothing);
      expect(find.byType(TotalsAreaWidget), findsNothing);
      expect(find.byType(CheckoutAreaWidget), findsNothing);
      expect(find.byType(ItemsListWidget), findsNothing);
      expect(find.text('Payment'), findsOneWidget);
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Payment Taken Successfully'), findsWidgets);
      when(() => posCubit.setPosCheckoutOrderCompletedState(paidItemOrder))
          .thenAnswer((_) async {
        PosCheckoutOrderCompleted(paidItemOrder);
      });
      when(() => posCubit.state)
          .thenReturn(PosCheckoutOrderCompleted(paidItemOrder));
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(SnackBar), findsNothing);
      expect(posCubit.state, PosCheckoutOrderCompleted(paidItemOrder));
    });

    testWidgets('add payment', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];

      final expectedStates = [
        PosCheckoutPaymentAdded(paidItemOrder),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStates));
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutAddPayment());
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ProcessingView), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsNothing);
      expect(find.byType(TotalsAreaWidget), findsNothing);
      expect(find.byType(CheckoutAreaWidget), findsNothing);
      expect(find.byType(ItemsListWidget), findsNothing);
      expect(find.text('Payment'), findsOneWidget);
    });

    testWidgets('logout', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: authCubit),
        BlocProvider.value(value: scannerCubit),
      ];

      final expectedStates = [
        PosCheckoutLogout(),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStates));
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutLogout());
      when(() => authCubit.logout()).thenAnswer((_) async => AuthInitial());
      await tester.pumpBlocApp(const BasketPage(), providers);
      verify(() => authCubit.logout()).called(1);
    });

    testWidgets('print receipt (transaction completed)', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
        BlocProvider.value(value: printerCubit),
      ];
      when(() => posCubit.state)
          .thenReturn(PosCheckoutOrderCompleted(paidItemOrder));
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => printerCubit.state).thenReturn(PeripheralClaimed());
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Payment'), findsOneWidget);

      expect(find.byType(TransactionCompletedView), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(5));
      expect(find.text('Does the customer want a receipt?'), findsOneWidget);
      expect(find.text('Receipt print failed.  Do you want to retry?'),
          findsNothing);
      expect(find.byType(GeneralButton), findsNWidgets(2));
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
    });

    testWidgets('finish checkout', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      final expectedStates = [
        PosCheckoutFinished(completedItemOrder),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStates));
      when(() => posCubit.state)
          .thenReturn(PosCheckoutFinished(completedItemOrder));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsOneWidget);
      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ProcessingView), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsNothing);
      expect(find.byType(TotalsAreaWidget), findsNothing);
      expect(find.byType(CheckoutAreaWidget), findsNothing);
      expect(find.byType(ItemsListWidget), findsNothing);
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Checkout Completed Successfully'), findsWidgets);
      when(() => posCubit.setPosCheckoutInitialState()).thenAnswer((_) async {
        PosCheckoutInitial();
      });
      when(() => posCubit.state).thenReturn(PosCheckoutInitial());
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(SnackBar), findsNothing);
      expect(posCubit.state, PosCheckoutInitial());
    });

    testWidgets('Proceed-to-checkout button disabled', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(newEmptyCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));
      expect(find.byKey(proceedToCheckoutButtonKey), findsOneWidget);
      await tester.tap(find.byKey(proceedToCheckoutButtonKey));
      expect(
          tester
              .widget<GeneralButton>(find.byKey(proceedToCheckoutButtonKey))
              .buttonDisabled,
          isTrue);
      await tester.pumpAndSettle();
    });

    testWidgets('Proceed-to-checkout button enabled', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));
      expect(find.byKey(proceedToCheckoutButtonKey), findsOneWidget);
      await tester.tap(find.byKey(proceedToCheckoutButtonKey));
      expect(
          tester
              .widget<GeneralButton>(find.byKey(proceedToCheckoutButtonKey))
              .buttonDisabled,
          isFalse);
      await tester.pumpAndSettle();
    });

    testWidgets('Proceed-to-checkout then tap coupon button', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      when(() => posCubit.addPayment(oneItemCheckout, '1', 2.22))
          .thenAnswer((_) async => PosCheckoutPaymentAdded(paidItemOrder));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));
      expect(find.byKey(proceedToCheckoutButtonKey), findsOneWidget);
      await tester.tap(find.byKey(proceedToCheckoutButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(CheckoutSliderWidget), findsOneWidget);
      expect(find.byType(DividerBottomSheetWidget), findsOneWidget);
      expect(find.byKey(couponButtonKey), findsOneWidget);

      await tester.tap(find.byKey(couponButtonKey));
      expect(find.byType(CheckoutSliderWidget), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      verifyNever(() => posCubit.addPayment(oneItemCheckout, '1', 2.22));
    });

    testWidgets('Proceed-to-checkout then tap card button', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));
      expect(find.byKey(proceedToCheckoutButtonKey), findsOneWidget);
      await tester.tap(find.byKey(proceedToCheckoutButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(CheckoutSliderWidget), findsOneWidget);
      expect(find.byType(DividerBottomSheetWidget), findsOneWidget);
      expect(find.byKey(cardButtonKey), findsOneWidget);
      var cardButton = find.byKey(cardButtonKey);

      when(() => posCubit.addPayment(oneItemCheckout, '1', 2.22))
          .thenAnswer((_) async => PosCheckoutPaymentAdded(paidItemOrder));

      await tester.tap(cardButton);
      await tester.pumpAndSettle();
      verify(() => posCubit.addPayment(oneItemCheckout, '1', 2.22)).called(1);
    });

    testWidgets('basket_list displays one item', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      await tester.pumpBlocApp(
          Column(
            children: [
              ItemsListWidget(checkout: oneItemCheckout),
            ],
          ),
          providers);

      expect(find.byType(Text), findsNWidgets(5));
      expect(find.byKey(const Key('quantityPadKey0')), findsOneWidget);
      expect(find.text('Milk'), findsOneWidget);
      expect(find.text(UiuxNumber.currency(2.22)), findsNWidgets(2));
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('Touching quantity shows bottom sheet (Linked item)',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(oneItemWithLinkedItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));
      expect(find.byKey(ItemsListWidget.itemContainerKey), findsOneWidget);
      expect(find.byKey(const Key('quantityPadKey0')), findsOneWidget);
      await tester.tap(find.byKey(const Key('quantityPadKey0')));
      await tester.pumpAndSettle();
      expect(find.byType(QuantityKeypadSlider), findsOneWidget);
      expect(find.byType(DividerBottomSheetWidget), findsOneWidget);
      expect(find.byType(KeypadLabelField), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(KeypadLabelField))
                  as KeypadLabelField)
              .descText,
          'Diet Coke EAN 8');
      expect(
          (tester.firstWidget(find.byType(KeypadLabelField))
                  as KeypadLabelField)
              .fieldText,
          '1');
      expect(find.byType(Keypad), findsOneWidget);
    });

    testWidgets('Touching quantity shows bottom sheet (Normal item)',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));
      expect(find.byKey(const Key('quantityPadKey0')), findsOneWidget);
      await tester.tap(find.byKey(const Key('quantityPadKey0')));
      await tester.pumpAndSettle();
      expect(find.byType(QuantityKeypadSlider), findsOneWidget);
      expect(find.byType(DividerBottomSheetWidget), findsOneWidget);
      expect(find.byType(KeypadLabelField), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(KeypadLabelField))
                  as KeypadLabelField)
              .descText,
          'Milk');
      expect(
          (tester.firstWidget(find.byType(KeypadLabelField))
                  as KeypadLabelField)
              .fieldText,
          '1');
      expect(find.byType(Keypad), findsOneWidget);
    });

    testWidgets('Touching quantity shows bottom sheet (Multiple Normal items)',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(sevenNormalItemsCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));
      for (int i = 0; i < sevenNormalItemsCheckout.posOrder.items.length; i++) {
        expect(
            find.byKey(Key('quantityPadKey' + i.toString())), findsOneWidget);
        await tester.tap(find.byKey(Key('quantityPadKey' + i.toString())));
        await tester.pumpAndSettle();
        expect(find.byType(QuantityKeypadSlider), findsOneWidget);
        expect(find.byType(DividerBottomSheetWidget), findsOneWidget);
        expect(find.byType(KeypadLabelField), findsOneWidget);
        expect(find.byType(Keypad), findsOneWidget);

        await tester.tapAt(tester.getCenter(find.byType(GenericAppBar)));
        await tester.pumpAndSettle();
        expect(find.byType(QuantityKeypadSlider), findsNothing);

        //scroll down
        await tester.drag(
            find.byKey(basketItemsScrollList), const Offset(0, -60));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Touching quantity shows bottom sheet (Multiple Linked items)',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(sevenLinkedItemsCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));

      var nonLinkedItems = (sevenNormalItemsCheckout.posOrder.items)
          .where((item) => item.parentOrderItemId == 'null')
          .toList();

      for (int i = 0; i < nonLinkedItems.length; i++) {
        expect(
            find.byKey(Key('quantityPadKey' + i.toString())), findsOneWidget);
        await tester.tap(find.byKey(Key('quantityPadKey' + i.toString())));
        await tester.pumpAndSettle();
        expect(find.byType(QuantityKeypadSlider), findsOneWidget);
        expect(find.byType(DividerBottomSheetWidget), findsOneWidget);
        expect(find.byType(KeypadLabelField), findsOneWidget);
        expect(find.byType(Keypad), findsOneWidget);

        await tester.tapAt(tester.getCenter(find.byType(GenericAppBar)));
        await tester.pumpAndSettle();
        expect(find.byType(QuantityKeypadSlider), findsNothing);

        //scroll down
        await tester.drag(
            find.byKey(basketItemsScrollList), const Offset(0, -60));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Verify if multiple linked items are displayed properly',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(sevenLinkedItemsCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));

      var nonLinkedItems = (sevenNormalItemsCheckout.posOrder.items)
          .where((item) => item.parentOrderItemId == 'null')
          .toList();

      expect(nonLinkedItems.length, 7);

      // how many items are displayed first
      expect(find.text('Diet Coke EAN 8'), findsNWidgets(7));
      expect(find.text(UiuxNumber.currency(4.88)), findsNWidgets(14));
      expect(find.text('linked item: +' + UiuxNumber.currency(0.15)),
          findsNWidgets(7));

      //scroll down
      await tester.drag(
          find.byKey(basketItemsScrollList), const Offset(0, -60));
      await tester.pumpAndSettle();

      // items after scroll down
      expect(find.text('Diet Coke EAN 8'), findsNWidgets(7));
      expect(find.text(UiuxNumber.currency(4.88)), findsNWidgets(14));
      expect(find.text('linked item: +' + UiuxNumber.currency(0.15)),
          findsNWidgets(7));
    });

    testWidgets('Quantity change slider', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      when(() =>
          posCubit.changeItemQuantity(
              oneItemCheckout, '615c5446f2ab7f4b405ee4e8', 2)).thenAnswer(
          (_) async => PosCheckoutReady(mockOneItemQuantityChangedPosCheckout));

      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));

      expect(find.byKey(const Key('quantityPadKey0')), findsOneWidget);
      await tester.tap(find.byKey(const Key('quantityPadKey0')));
      await tester.pumpAndSettle();
      expect(find.byType(Keypad), findsOneWidget);

      await tester.tap(find.byKey(Keypad.keypadTwoButtonKey));
      await tester.pump();

      await tester.tap(find.byKey(Keypad.keypadAddButtonKey));
      await tester.pumpAndSettle();

      verify(() => posCubit.changeItemQuantity(
          oneItemCheckout, '615c5446f2ab7f4b405ee4e8', 2)).called(1);
    });

    testWidgets('Quantity change slider empty text', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      when(() =>
          posCubit.changeItemQuantity(
              oneItemCheckout, '615c5446f2ab7f4b405ee4e8', 2)).thenAnswer(
          (_) async => PosCheckoutReady(mockOneItemQuantityChangedPosCheckout));

      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));

      expect(find.byKey(const Key('quantityPadKey0')), findsOneWidget);
      await tester.tap(find.byKey(const Key('quantityPadKey0')));
      await tester.pumpAndSettle();
      expect(find.byType(Keypad), findsOneWidget);

      await tester.tap(find.byKey(Keypad.keypadTwoButtonKey));
      await tester.pump();

      TextEditingController _keypadController = (tester
              .firstWidget(find.byType(KeypadLabelField)) as KeypadLabelField)
          .keypadController;

      _keypadController.text = '';

      await tester.tap(find.byKey(Keypad.keypadAddButtonKey));
      await tester.pumpAndSettle();

      verifyNever(() => posCubit.changeItemQuantity(
          oneItemCheckout, '615c5446f2ab7f4b405ee4e8', 2));
    });

    testWidgets('Quantity change slider max digits', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));

      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));

      expect(find.byKey(const Key('quantityPadKey0')), findsOneWidget);
      await tester.tap(find.byKey(const Key('quantityPadKey0')));
      await tester.pumpAndSettle();
      expect(find.byType(QuantityKeypadSlider), findsOneWidget);
      expect(find.byType(DividerBottomSheetWidget), findsOneWidget);
      expect(find.byType(KeypadLabelField), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(KeypadLabelField))
                  as KeypadLabelField)
              .descText,
          'Milk');
      expect(
          (tester.firstWidget(find.byType(KeypadLabelField))
                  as KeypadLabelField)
              .fieldText,
          '1');
      expect(find.byType(Keypad), findsOneWidget);

      await tester.tap(find.byKey(Keypad.keypadTwoButtonKey));
      await tester.pump();
      expect(find.text('2'), findsNWidgets(2));
      await tester.tap(find.byKey(Keypad.keypadTwoButtonKey));
      await tester.pump();
      expect(find.text('22'), findsOneWidget);
      await tester.tap(find.byKey(Keypad.keypadTwoButtonKey));
      await tester.pump();
      expect(find.text('222'), findsOneWidget);
      await tester.tap(find.byKey(Keypad.keypadTwoButtonKey));
      await tester.pump();
      expect(find.text('222'), findsOneWidget);
    });

    testWidgets('keypad button tap basket and settings icon', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));

      expect(find.byKey(settingsButtonKey), findsOneWidget);
      await tester.tap(find.byKey(settingsButtonKey));
      await tester.pumpAndSettle();

      expect(find.byKey(basketButtonKey), findsOneWidget);
      await tester.tap(find.byKey(basketButtonKey));
      await tester.pumpAndSettle();
    });

    testWidgets('keypad button shows bottom sheet', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));

      expect(find.byKey(keypadButtonKey), findsOneWidget);
      await tester.tap(find.byKey(keypadButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(BarcodeKeypadSlider), findsOneWidget);
      expect(find.byType(DividerBottomSheetWidget), findsOneWidget);
      expect(find.byType(KeypadInputField), findsOneWidget);
      expect(find.byType(Keypad), findsOneWidget);
    });

    testWidgets('keypad add button calls additem', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(mockEmptyPosOrderCheckout));

      when(() => posCubit.addItem(
            mockEmptyPosOrderCheckout,
            '666',
            '',
            1,
            EntryMethod.MANUAL.value,
          )).thenAnswer((_) async => PosCheckoutReady(oneItemCheckout));

      await tester.pumpBlocApp(const ecp_nav_bar.NavigationBar(), providers);

      expect(find.byKey(keypadButtonKey), findsOneWidget);
      await tester.tap(find.byKey(keypadButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(Keypad), findsOneWidget);

      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byKey(Keypad.keypadSixButtonKey));
        await tester.pump();
      }

      await tester.tap(find.byKey(Keypad.keypadAddButtonKey));
      await tester.pumpAndSettle();

      verify(() => posCubit.addItem(
            mockEmptyPosOrderCheckout,
            '666',
            '',
            1,
            EntryMethod.MANUAL.value,
          )).called(1);
    });

    testWidgets('Test linked items', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(oneItemWithLinkedItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsNWidgets(2));

      expect(find.byType(Text), findsNWidgets(13));
      expect(
          (tester.widget(find.byKey(ItemsListWidget.linkedItemPriceKey))
                  as Text)
              .data,
          'linked item: +' + UiuxNumber.currency(0.15));
    });

    testWidgets('renders basket on PosCheckoutItemQuantityChanged',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());

      when(() => posCubit.state)
          .thenReturn(PosCheckoutItemQuantityChanged(oneItemCheckout));
      when(() => posCubit.setPosCheckoutReadyState(oneItemCheckout))
          .thenAnswer((_) async => PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.text('Basket page'), findsOneWidget);
      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(BasketView), findsOneWidget);
    });
  });
}
