import 'package:bloc_test/bloc_test.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_service/pos_service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/pages/basket/basket.dart';
import 'package:ui_flutter_app/pages/basket/basket_view.dart';
import 'package:ui_peripheral_agent/cubit/peripheral_agent_cubits.dart';

import '../../../ecp_packages/pos_service/test/mock_service_data.dart';
import '../../helpers/pump_bloc_app.dart';

class FakePosState extends Fake implements PosState {}

class FakePeripheralState extends Fake implements PeripheralState {}

class MockPosCubit extends MockCubit<PosState> implements PosCubit {}

class MockScannerCubit extends MockCubit<PeripheralState>
    implements ScannerCubit {}

void main() {
  late Checkout newCheckout;
  late Checkout checkoutOneItem;
  late Checkout checkoutCancelledOneItem;
  late PosCubit posCubit;
  late ScannerCubit scannerCubit;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakePosState());
    registerFallbackValue(FakePeripheralState());
  });

  group('Cancel Checkout (Void Transaction)', () {
    setUp(() {
      posCubit = MockPosCubit();
      scannerCubit = MockScannerCubit();
      newCheckout = mockNewCheckout;
      checkoutOneItem = mockCheckoutOneItem;
      checkoutCancelledOneItem = mockCheckoutCancelledOneItem;
    });

    testWidgets('cancel checkout not available if no items', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(newCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byKey(BasketPage.cancelCheckoutKey), findsNothing);
    });

    testWidgets('tap cancel checkout button closes delete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(checkoutOneItem));
      await tester.pumpBlocApp(const BasketPage(), providers);

      //slide left  - delete button on right side of slideable
      await tester.drag(find.byType(Slidable), const Offset(-100.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byType(SlidableAction), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      expect(find.byKey(BasketPage.cancelCheckoutKey), findsOneWidget);
      await tester.tap(find.byKey(BasketPage.cancelCheckoutKey));
      await tester.pumpAndSettle();

      expect(find.byType(SlidableAction), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('cancel checkout with one item', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(checkoutOneItem));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byKey(BasketPage.cancelCheckoutKey), findsOneWidget);
      await tester.tap(find.byKey(BasketPage.cancelCheckoutKey));
      await tester.pumpAndSettle();

      await tester.tapAt(tester.getCenter(find.byType(GenericAppBar)));
      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey),
          findsOneWidget);
    });

    testWidgets('cancel checkout available after item voided', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(checkoutCancelledOneItem));
      await tester.pumpBlocApp(const BasketPage(), providers);

      expect(find.byKey(BasketPage.cancelCheckoutKey), findsOneWidget);
    });

    testWidgets('cancel checkout - select no', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(checkoutOneItem));
      await tester.pumpBlocApp(const BasketPage(), providers);

      when(() => posCubit.cancelCheckout(
            checkoutOneItem,
            false,
          )).thenAnswer((_) async => PosCheckoutReady(newCheckout));

      expect(find.byKey(BasketPage.cancelCheckoutKey), findsOneWidget);
      await tester.tap(find.byKey(BasketPage.cancelCheckoutKey));
      await tester.pumpAndSettle();

      await tester.tapAt(tester.getCenter(find.byType(GenericAppBar)));
      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey),
          findsOneWidget);

      await tester.tap(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsNothing);
      expect(find.byKey(BasketPage.cancelCheckoutKey), findsOneWidget);

      verifyNever(() => posCubit.cancelCheckout(
            checkoutOneItem,
            false,
          ));
    });

    testWidgets('cancel checkout - select yes', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(checkoutOneItem));
      await tester.pumpBlocApp(const BasketPage(), providers);

      when(() => posCubit.cancelCheckout(
            checkoutOneItem,
            false,
          )).thenAnswer((_) async => PosCheckoutReady(newCheckout));

      expect(find.byKey(BasketPage.cancelCheckoutKey), findsOneWidget);
      await tester.tap(find.byKey(BasketPage.cancelCheckoutKey));
      await tester.pumpAndSettle();

      await tester.tapAt(tester.getCenter(find.byType(GenericAppBar)));
      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey),
          findsOneWidget);

      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsNothing);
      expect(find.byKey(BasketPage.cancelCheckoutKey), findsOneWidget);

      verify(() => posCubit.cancelCheckout(
            checkoutOneItem,
            false,
          )).called(1);
    });

    testWidgets('renders empty basket after checkout cancelled',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];
      when(() => scannerCubit.state).thenReturn(PeripheralOpened());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutCancelled(checkoutOneItem));
      when(() => posCubit.startNewCheckout())
          .thenAnswer((_) async => PosCheckoutReady(newCheckout));
      await tester.pumpBlocApp(const BasketPage(), providers);
      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(find.byType(BasketView), findsOneWidget);
    });
  });
}
