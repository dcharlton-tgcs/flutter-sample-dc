import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:pos_service/pos_service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ui_flutter_app/pages/launcher/launch.dart';
import 'package:ui_flutter_app/pages/launcher/launch_view.dart';
import 'package:ui_peripheral_agent/cubit/peripheral_agent_cubits.dart';

import '../helpers/pump_bloc_app.dart';

class FakeClient extends Fake implements http.Client {}

class FakePosState extends Fake implements PosState {}

class FakePeripheralState extends Fake implements PeripheralState {}

class MockPrinterCubit extends MockCubit<PeripheralState>
    implements PrinterCubit {}

class MockScannerCubit extends MockCubit<PeripheralState>
    implements ScannerCubit {}

class MockPeripheralCubit extends MockCubit<PeripheralState>
    implements PeripheralCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PrinterCubit printerCubit;
  late ScannerCubit scannerCubit;
  late PeripheralCubit peripheralCubit;

  setUpAll(() {
    registerFallbackValue(FakePosState());
    registerFallbackValue(FakePeripheralState());
  });

  group('App', () {
    setUp(() {
      printerCubit = MockPrinterCubit();
      scannerCubit = MockScannerCubit();
      peripheralCubit = MockPeripheralCubit();
    });

    testWidgets('launch page', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: printerCubit),
        BlocProvider.value(value: scannerCubit),
        BlocProvider.value(value: peripheralCubit),
      ];

      when(() => printerCubit.listenForEvents()).thenAnswer((_) async {
        return;
      });
      when(() => scannerCubit.listenForEvents()).thenAnswer((_) async {
        return;
      });
      when(() => peripheralCubit.listenForEvents()).thenAnswer((_) async {
        return;
      });
      when(() => printerCubit.state).thenReturn(PeripheralInitial());
      when(() => scannerCubit.state).thenReturn(PeripheralInitial());
      when(() => peripheralCubit.state).thenReturn(PeripheralInitial());

      await tester.pumpBlocApp(const LaunchPage(), providers);
      expect(find.byType(LaunchPage), findsOneWidget);
      expect(find.byType(LaunchView), findsOneWidget);
    });
  });
}
