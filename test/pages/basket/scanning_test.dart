import 'package:bloc_test/bloc_test.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:ecp_openapi/model/entry_method.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_service/pos_service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ui_flutter_app/pages/basket/basket.dart';
import 'package:ui_flutter_app/common_widgets/navigation_bar.dart'
    as ecp_nav_bar;
import 'package:ui_peripheral_agent/cubit/peripheral_cubit.dart';
import 'package:ui_peripheral_agent/cubit/scanner_cubit.dart';

import '../../../ecp_packages/pos_service/test/mock_service_data.dart';
import '../../helpers/pump_bloc_app.dart';

class FakePosState extends Fake implements PosState {}

class MockPosCubit extends MockCubit<PosState> implements PosCubit {}

class FakePeripheralState extends Fake implements PeripheralState {}

class MockScannerCubit extends MockCubit<PeripheralState>
    implements ScannerCubit {}

void main() {
  const scanButtonKey = ecp_nav_bar.NavigationBar.scanButtonKey;

  late Checkout emptyCheckout;
  late Checkout oneItemCheckout;
  late PosCubit posCubit;
  late ScannerCubit scannerCubit;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakePosState());
    registerFallbackValue(FakePeripheralState());
    emptyCheckout = mockEmptyPosOrderCheckout;
    oneItemCheckout = mockOneItemCheckout;
  });

  group('Basket Page', () {
    setUp(() {
      posCubit = MockPosCubit();
      scannerCubit = MockScannerCubit();
      emptyCheckout = mockEmptyPosOrderCheckout;
      oneItemCheckout = mockOneItemCheckout;
    });

    testWidgets('Test scan button', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];

      when(() => posCubit.state).thenReturn(PosCheckoutReady(emptyCheckout));
      when(() => scannerCubit.state).thenReturn(PeripheralClaimed());

      await tester.pumpBlocApp(const BasketPage(), providers);

      // Locate the scan button
      var scanButton = find.byKey(scanButtonKey);
      expect(scanButton, findsOneWidget);

      // Get the centre of the scan button for the gesture
      final Offset centre = tester.getCenter(scanButton);

      // Initial gesture is a DOWN
      final TestGesture gesture = await tester.startGesture(centre);

      // Let that settle
      await tester.pump(const Duration(seconds: 1));

      // Lift up
      await gesture.cancel();
      await gesture.down(centre);
      await tester.pumpAndSettle();
      await gesture.up();
      await tester.pumpAndSettle();

      verify(() => scannerCubit.enableSoftScan()).called(2);
      verify(() => scannerCubit.disableSoftScan()).called(2);

      expect(find.byKey(scanButtonKey), findsOneWidget);
    });

    testWidgets('Test item added', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: scannerCubit),
      ];

      when(() => posCubit.state).thenReturn(PosCheckoutReady(emptyCheckout));
      when(() => scannerCubit.state).thenReturn(PeripheralClaimed());
      when(() => scannerCubit.state)
          .thenReturn(ScannerData('UPCA', '036000291452'));
      final expectedStates = [
        ScannerData('UPCA', '036000291452'),
      ];
      whenListen(scannerCubit, Stream.fromIterable(expectedStates));

      // Prepare for addItem
      when(() => posCubit.addItem(
            emptyCheckout,
            '036000291452',
            'UPCA',
            1,
            EntryMethod.SCANNED.value,
          )).thenAnswer((_) async => PosCheckoutReady(oneItemCheckout));

      await tester.pumpBlocApp(const BasketPage(), providers);

      // Locate the scan button
      var scanButton = find.byKey(scanButtonKey);
      expect(scanButton, findsOneWidget);

      // Get the centre of the scan button for the gesture
      final Offset centre = tester.getCenter(scanButton);

      // Initial gesture is a DOWN
      final TestGesture gesture = await tester.startGesture(centre);

      // Let that settle
      await tester.pump(const Duration(seconds: 1));

      // Lift up
      await tester.pumpAndSettle();
      await gesture.up();
      await tester.pumpAndSettle();

      verify(() => posCubit.addItem(
            emptyCheckout,
            '036000291452',
            'UPCA',
            1,
            EntryMethod.SCANNED.value,
          )).called(1);

      expect(find.byKey(scanButtonKey), findsOneWidget);
    });
  });
}
