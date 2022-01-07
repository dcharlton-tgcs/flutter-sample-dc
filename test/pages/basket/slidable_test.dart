import 'package:bloc_test/bloc_test.dart';
import 'package:ecp_common/ecp_common.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_service/pos_service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/pages/basket/basket.dart';
import 'package:ui_flutter_app/pages/basket/components/basket_list.dart';
import 'package:ui_flutter_app/pages/basket/components/bottom_sheet/quantity_keypad.dart';
import 'package:ui_flutter_app/common_widgets/navigation_bar.dart'
    as ecp_nav_bar;
import 'package:ui_flutter_app/pages/basket/components/checkout_area.dart';
import 'package:ui_flutter_app/pages/basket/components/totals_area.dart';
import 'package:ui_flutter_app/pages/logoff/logoff.dart';
import 'package:ui_flutter_app/theme/theme.dart';
import 'package:ui_peripheral_agent/cubit/peripheral_agent_cubits.dart';

import '../../../ecp_packages/pos_service/test/mock_service_data.dart';
import '../../helpers/pump_bloc_app.dart';

class FakePosState extends Fake implements PosState {}

class FakePeripheralState extends Fake implements PeripheralState {}

class MockPosCubit extends MockCubit<PosState> implements PosCubit {}

class MockScannerCubit extends MockCubit<PeripheralState>
    implements ScannerCubit {}

void main() {
  late Checkout emptyCheckout;
  late Checkout oneItemCheckout;
  late Checkout twoItemCheckout;
  late Checkout sevenItemCheckout;
  late Checkout oneItemVoidedCheckout;
  late Checkout oneLinkedItemVoidedCheckout;
  late PosCubit posCubit;
  late ScannerCubit scannerCubit;

  TestWidgetsFlutterBinding.ensureInitialized();

  const _quantityTextKey = ItemsListWidget.quantityTextKey;
  const _descTextKey = ItemsListWidget.descTextKey;
  const _unitPriceTextKey = ItemsListWidget.unitPriceTextKey;
  const _priceTextKey = ItemsListWidget.priceTextKey;
  const _itemContainerKey = ItemsListWidget.itemContainerKey;
  const _listScrollbarKey = ItemsListWidget.listScrollbarKey;
  const scanButtonKey = ecp_nav_bar.NavigationBar.scanButtonKey;
  const keypadButtonKey = ecp_nav_bar.NavigationBar.keypadButtonKey;
  const basketButtonKey = ecp_nav_bar.NavigationBar.basketButtonKey;
  const settingsButtonKey = ecp_nav_bar.NavigationBar.settingsButtonKey;
  const proceedToCheckoutButtonKey = CheckoutAreaWidget.proceedToCheckoutKey;

  setUpAll(() {
    registerFallbackValue(FakePosState());
    registerFallbackValue(FakePeripheralState());

    emptyCheckout = mockNewCheckout;
    oneItemCheckout = mockOneItemCheckout;
    twoItemCheckout = mockCheckoutTwoItem;
    sevenItemCheckout = mockCheckoutSevenItem;
    oneItemVoidedCheckout = mockCheckoutOneItemVoided;
    oneLinkedItemVoidedCheckout = mockCheckoutOneLinkedItemVoided;
  });

  group('Slidable', () {
    setUp(() {
      posCubit = MockPosCubit();
      scannerCubit = MockScannerCubit();
    });

    testWidgets('renders basket with no item', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(emptyCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsOneWidget);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GeneralButton), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(8));
      expect(find.byKey(const Key('quantityPadKey0')), findsNothing);
      expect(find.byType(Slidable), findsNothing);
      expect(find.byType(SlidableAction), findsNothing);
    });

    testWidgets('renders basket with one item', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      when(() => posCubit.voidItemCheckout(
            oneItemCheckout,
            '615c5446f2ab7f4b405ee4e8',
          )).thenAnswer((_) async => PosCheckoutReady(oneItemVoidedCheckout));

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsOneWidget);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GeneralButton), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(13));
      expect(find.byKey(const Key('quantityPadKey0')), findsOneWidget);

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Milk'), findsOneWidget);
      expect(find.text(UiuxNumber.currency(2.22)), findsNWidgets(2));

      expect(tester.widget<Text>(find.byKey(_unitPriceTextKey)).style!.fontSize,
          12.0);

      expect(tester.widget<Text>(find.byKey(_quantityTextKey)).style, isNull);
      expect(
        tester.widget<Text>(find.byKey(_descTextKey)).style,
        const TextStyle(
          fontSize: 16.0,
          color: UiuxColours.primaryTextColor,
        ),
      );
      expect(
          tester.widget<Text>(find.byKey(_unitPriceTextKey)).style!.decoration,
          isNull);
      expect(tester.widget<Text>(find.byKey(_priceTextKey)).style, isNull);

      expect(tester.widget<Container>(find.byKey(_itemContainerKey)).color,
          isNull);

      expect(find.byType(Slidable), findsOneWidget);
      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);

      //slide right - nothing on left side of slidable
      await tester.drag(find.byType(Slidable), const Offset(100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);

      //slide left  - delete button on right side of slideable
      await tester.drag(find.byType(Slidable), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      expect(find.byKey(const Key('quantityPadKey0')), findsNothing);

      expect(find.text('1'), findsNothing);
      expect(find.text('Milk'), findsOneWidget);
      expect(find.text(UiuxNumber.currency(2.22)), findsNWidgets(1));

      await tester.tap(find.byType(SlidableAction));
      await tester.pumpAndSettle();

      verify(() => posCubit.voidItemCheckout(
            oneItemCheckout,
            '615c5446f2ab7f4b405ee4e8',
          )).called(1);
    });

    testWidgets('renders basket with one voided item', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(oneItemVoidedCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsOneWidget);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GeneralButton), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(13));
      expect(find.byKey(const Key('quantityPadKey0')), findsOneWidget);
      await tester.tap(find.byKey(const Key('quantityPadKey0')));
      await tester.pumpAndSettle();
      expect(find.byType(QuantityKeypadSlider), findsNothing);

      expect(tester.widget<Text>(find.byKey(_unitPriceTextKey)).style!.fontSize,
          12.0);

      expect(tester.widget<Container>(find.byKey(_itemContainerKey)).color,
          UiuxColours.voidedBackgroundColour);

      expect(
          tester.widget<Text>(find.byKey(_quantityTextKey)).style!.decoration,
          TextDecoration.lineThrough);
      expect(tester.widget<Text>(find.byKey(_descTextKey)).style!.decoration,
          TextDecoration.lineThrough);
      expect(
          tester.widget<Text>(find.byKey(_unitPriceTextKey)).style!.decoration,
          TextDecoration.lineThrough);
      expect(tester.widget<Text>(find.byKey(_priceTextKey)).style!.decoration,
          TextDecoration.lineThrough);

      expect(tester.widget<Text>(find.byKey(_quantityTextKey)).style!.fontStyle,
          FontStyle.italic);
      expect(tester.widget<Text>(find.byKey(_descTextKey)).style!.fontStyle,
          FontStyle.italic);
      expect(
          tester.widget<Text>(find.byKey(_unitPriceTextKey)).style!.fontStyle,
          FontStyle.italic);
      expect(tester.widget<Text>(find.byKey(_priceTextKey)).style!.fontStyle,
          FontStyle.italic);

      expect(find.byType(Slidable), findsOneWidget);
      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);

      //slide right - nothing on left of slidable
      await tester.drag(find.byType(Slidable), const Offset(100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);

      //slide left  - noting on right of slidable
      await tester.drag(find.byType(Slidable), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('Test void item with linked item', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(oneLinkedItemVoidedCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      await tester.pumpAndSettle();

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsOneWidget);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GeneralButton), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(13));

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Coke Cherry EAN 8'), findsOneWidget);
      expect(find.text(UiuxNumber.currency(5.00)), findsNWidgets(2));
      expect(find.text('deposit item: +' + UiuxNumber.currency(0.05)),
          findsOneWidget);

      expect(find.byType(Slidable), findsOneWidget);
      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);

      expect(
          tester
              .widget<Container>(find.byKey(ItemsListWidget.itemContainerKey))
              .color,
          UiuxColours.voidedBackgroundColour);

      expect(
          tester
              .widget<Text>(find.byKey(ItemsListWidget.linkedItemPriceKey))
              .style!
              .decoration,
          TextDecoration.lineThrough);
      expect(
          tester
              .widget<Text>(find.byKey(ItemsListWidget.descTextKey))
              .style!
              .decoration,
          TextDecoration.lineThrough);
      expect(
          tester
              .widget<Text>(find.byKey(ItemsListWidget.unitPriceTextKey))
              .style!
              .decoration,
          TextDecoration.lineThrough);

      expect(
          tester
              .widget<Text>(find.byKey(ItemsListWidget.quantityTextKey))
              .style!
              .decoration,
          TextDecoration.lineThrough);

      expect(
          tester
              .widget<Text>(find.byKey(ItemsListWidget.priceTextKey))
              .style!
              .decoration,
          TextDecoration.lineThrough);

      expect(
          tester
              .widget<Text>(find.byKey(ItemsListWidget.quantityTextKey))
              .style!
              .fontStyle,
          FontStyle.italic);
      expect(
          tester
              .widget<Text>(find.byKey(ItemsListWidget.descTextKey))
              .style!
              .fontStyle,
          FontStyle.italic);
      expect(
          tester
              .widget<Text>(find.byKey(ItemsListWidget.unitPriceTextKey))
              .style!
              .fontStyle,
          FontStyle.italic);
      expect(
          tester
              .widget<Text>(find.byKey(ItemsListWidget.priceTextKey))
              .style!
              .fontStyle,
          FontStyle.italic);
      expect(
          tester
              .widget<Text>(find.byKey(ItemsListWidget.linkedItemPriceKey))
              .style!
              .fontStyle,
          FontStyle.italic);

      expect(
          (tester.firstWidget(find.byKey(proceedToCheckoutButtonKey))
                  as GeneralButton)
              .buttonDisabled,
          true);
    });

    testWidgets('renders two items - shows one delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(twoItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsOneWidget);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GeneralButton), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(18));
      expect(find.byKey(const Key('quantityPadKey0')), findsOneWidget);
      expect(find.byKey(const Key('quantityPadKey1')), findsOneWidget);
      expect(find.byKey(const Key('quantityPadKey2')), findsNothing);
      expect(find.byType(Slidable), findsNWidgets(2));
      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);

      //slide first item left
      await tester.drag(
          find.byKey(const Key('slidableKey0')), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      //slide second item left - first item closes
      await tester.drag(
          find.byKey(const Key('slidableKey1')), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('Scroll closes delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(sevenItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(ecp_nav_bar.NavigationBar), findsOneWidget);
      expect(find.byType(TotalsAreaWidget), findsOneWidget);
      expect(find.byType(CheckoutAreaWidget), findsOneWidget);
      expect(find.byType(ItemsListWidget), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GeneralButton), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(43));
      expect(find.byKey(const Key('quantityPadKey0')), findsOneWidget);
      expect(find.byKey(const Key('quantityPadKey1')), findsOneWidget);
      expect(find.byKey(const Key('quantityPadKey2')), findsOneWidget);
      expect(find.byKey(const Key('quantityPadKey3')), findsOneWidget);
      expect(find.byKey(const Key('quantityPadKey4')), findsOneWidget);
      expect(find.byKey(const Key('quantityPadKey5')), findsOneWidget);
      expect(find.byKey(const Key('quantityPadKey6')), findsOneWidget);
      expect(find.byKey(const Key('quantityPadKey7')), findsNothing);

      expect(find.byType(Slidable), findsNWidgets(7));
      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);

      expect(find.byKey(_listScrollbarKey), findsOneWidget);

      //slide first item left
      await tester.drag(
          find.byKey(const Key('slidableKey3')), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      //scroll up
      await tester.drag(find.byKey(_listScrollbarKey), const Offset(0, -60));
      await tester.pumpAndSettle();

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);

      await tester.drag(
          find.byKey(const Key('slidableKey3')), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      //scroll down
      await tester.drag(find.byKey(_listScrollbarKey), const Offset(0, 60));
      await tester.pumpAndSettle();

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('tap quantity closes delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(twoItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      //slide left  - delete button on right side of slideable
      await tester.drag(
          find.byKey(const Key('slidableKey0')), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.byKey(const Key('quantityPadKey1')));
      await tester.pumpAndSettle();

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('tap another slider closes delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(twoItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      //slide left  - delete button on right side of slideable
      await tester.drag(
          find.byKey(const Key('slidableKey0')), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.byKey(const Key('slidableKey1')));
      await tester.pumpAndSettle();

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('tap outside slider closes delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      //slide left  - delete button on right side of slideable
      await tester.drag(find.byType(Slidable), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.byKey(const Key('basket_page_app_bar_key')));
      await tester.pumpAndSettle();

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('tap app bar menu closes delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      //slide left  - delete button on right side of slideable
      await tester.drag(find.byType(Slidable), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('logoff page closes delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));

      await tester.pumpBlocApp(const BasketPage(), providers);

      //slide left  - delete button on right side of slideable
      await tester.drag(find.byType(Slidable), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.pumpBlocApp(const LogoffPage(), providers);
      expect(find.byType(Drawer), findsOneWidget);

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('tap scan closes delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      //slide left  - delete button on right side of slideable
      await tester.drag(find.byType(Slidable), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.byKey(scanButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('tap keypad closes delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      //slide left  - delete button on right side of slideable
      await tester.drag(find.byType(Slidable), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.byKey(keypadButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('tap settings closes delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      //slide left  - delete button on right side of slideable
      await tester.drag(find.byType(Slidable), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.byKey(settingsButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('tap basket closes delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      //slide left  - delete button on right side of slideable
      await tester.drag(find.byType(Slidable), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.byKey(basketButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('tap proceed to checkout closes delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      //slide left  - delete button on right side of slideable
      await tester.drag(find.byType(Slidable), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.byKey(proceedToCheckoutButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });
  });
}
