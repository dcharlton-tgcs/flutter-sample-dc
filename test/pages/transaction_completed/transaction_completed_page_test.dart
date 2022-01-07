import 'package:bloc_test/bloc_test.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_service/pos_service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/l10n/l10n.dart';
import 'package:ui_flutter_app/pages/processing/processing_view.dart';
import 'package:ui_flutter_app/pages/transaction_completed/transaction_completed.dart';
import 'package:ui_flutter_app/pages/transaction_completed/transaction_completed_view.dart';
import 'package:ui_flutter_app/temporary/receipt_builder.dart';
import 'package:ui_peripheral_agent/cubit/peripheral_agent_cubits.dart';

import '../../../ecp_packages/pos_service/test/mock_service_data.dart';
import '../../helpers/pump_bloc_app.dart';

class FakePosState extends Fake implements PosState {}

class FakePeripheralState extends Fake implements PeripheralState {}

class MockPosCubit extends MockCubit<PosState> implements PosCubit {}

class MockPrinterCubit extends MockCubit<PeripheralState>
    implements PrinterCubit {}

void main() {
  late Checkout paidItemCheckout;
  late Checkout completedItemCheckout;
  late Checkout oneItemWithLinkedItemCheckout;
  late PosCubit posCubit;
  late PrinterCubit printerCubit;

  setUp(() {
    registerFallbackValue(FakePosState());
    registerFallbackValue(FakePeripheralState());
    posCubit = MockPosCubit();
    printerCubit = MockPrinterCubit();
    paidItemCheckout = mockCheckoutOneItemPaid;
    completedItemCheckout = mockCheckoutFinished;
    oneItemWithLinkedItemCheckout = mockOneItemWithLinkedItem;
  });

  group('Transaction completed page', () {
    const yesButtonKey = TransactionCompletedPage.yesButtonKey;
    const noButtonKey = TransactionCompletedPage.noButtonKey;

    testWidgets('Invalid state', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: printerCubit),
      ];

      Widget widgetToTest = Localizations(
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: const Locale('en'),
        child: const TransactionCompletedPage(),
      );

      when(() => posCubit.state).thenReturn(PosCheckoutReady(paidItemCheckout));
      when(() => printerCubit.state).thenReturn(PeripheralInitial());

      await tester.pumpBlocApp(widgetToTest, providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
              .automaticallyImplyLeading,
          false);
      expect(find.byType(TransactionCompletedView), findsNothing);
      expect(find.byType(Text), findsOneWidget);
      expect(find.text('Invalid State'), findsOneWidget);
    });

    testWidgets('Renders print intial state', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: printerCubit),
      ];

      Widget widgetToTest = Localizations(
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: const Locale('en'),
        child: const TransactionCompletedPage(),
      );

      when(() => posCubit.state)
          .thenReturn(PosCheckoutOrderCompleted(paidItemCheckout));
      when(() => printerCubit.state).thenReturn(PeripheralClaimed());

      await tester.pumpBlocApp(widgetToTest, providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
              .automaticallyImplyLeading,
          false);
      expect(find.byType(TransactionCompletedView), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(4));
      expect(find.text('Does the customer want a receipt?'), findsOneWidget);
      expect(find.text('Receipt print failed.  Do you want to retry?'),
          findsNothing);
      expect(find.byType(GeneralButton), findsNWidgets(2));
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
      await tester.pumpAndSettle();
    });

    testWidgets('Renders print ready state', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: printerCubit),
      ];

      Widget widgetToTest = Localizations(
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: const Locale('en'),
        child: const TransactionCompletedPage(),
      );

      when(() => posCubit.state)
          .thenReturn(PosCheckoutOrderCompleted(paidItemCheckout));
      when(() => printerCubit.state).thenReturn(PeripheralClaimed());

      await tester.pumpBlocApp(widgetToTest, providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
              .automaticallyImplyLeading,
          false);
      expect(find.byType(TransactionCompletedView), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(4));
      expect(find.text('Does the customer want a receipt?'), findsOneWidget);
      expect(find.text('Receipt print failed.  Do you want to retry?'),
          findsNothing);
      expect(find.byType(GeneralButton), findsNWidgets(2));
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      expect(find.text('Retry'), findsNothing);
      await tester.pumpAndSettle();
    });

    testWidgets('Renders processing page print in progress', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: printerCubit),
      ];

      Widget widgetToTest = Localizations(
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: const Locale('en'),
        child: const TransactionCompletedPage(),
      );

      when(() => posCubit.state)
          .thenReturn(PosCheckoutOrderCompleted(paidItemCheckout));
      when(() => printerCubit.state).thenReturn(PeripheralOpened());

      await tester.pumpBlocApp(widgetToTest, providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
              .automaticallyImplyLeading,
          false);
      expect(find.byType(TransactionCompletedView), findsOneWidget);
      expect(find.byType(ProcessingView), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(1));
    });

    testWidgets('Renders print complete', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: printerCubit),
      ];

      Widget widgetToTest = Localizations(
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: const Locale('en'),
        child: const TransactionCompletedPage(),
      );

      when(() => posCubit.state)
          .thenReturn(PosCheckoutOrderCompleted(paidItemCheckout));
      when(() => printerCubit.state).thenReturn(PrintNormalComplete());
      final expectedStates = [
        PrintNormalComplete(),
      ];
      whenListen(printerCubit, Stream.fromIterable(expectedStates));

      await tester.pumpBlocApp(widgetToTest, providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
              .automaticallyImplyLeading,
          false);
      expect(find.byType(TransactionCompletedView), findsOneWidget);
      expect(find.byType(ProcessingView), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(1));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Receipt Printed Successfully'), findsWidgets);
      when(() => posCubit.state).thenReturn(PosCheckoutInitial());
      when(() => printerCubit.state).thenReturn(PeripheralClaimed());
      when(() => posCubit.finishCheckout(paidItemCheckout)).thenAnswer(
          (_) async => PosCheckoutOrderCompleted(completedItemCheckout));
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(SnackBar), findsNothing);
      verify(() => printerCubit.disablePeripheral()).called(1);
    });

    testWidgets('Tap the No button', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: printerCubit),
      ];

      Widget widgetToTest = Localizations(
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: const Locale('en'),
        child: const TransactionCompletedPage(),
      );

      when(() => posCubit.state)
          .thenReturn(PosCheckoutOrderCompleted(paidItemCheckout));
      when(() => printerCubit.state).thenReturn(PeripheralClaimed());
      await tester.pumpBlocApp(widgetToTest, providers);

      expect(find.byKey(noButtonKey), findsOneWidget);

      when(() => posCubit.state)
          .thenReturn(PosCheckoutOrderCompleted(completedItemCheckout));
      when(() => printerCubit.state).thenReturn(PeripheralClaimed());
      when(() => posCubit.finishCheckout(paidItemCheckout)).thenAnswer(
          (_) async => PosCheckoutOrderCompleted(completedItemCheckout));

      await tester.tap(find.byKey(noButtonKey));
      expect(posCubit.state, PosCheckoutOrderCompleted(completedItemCheckout));
      expect(printerCubit.state, PeripheralClaimed());
      await tester.pumpAndSettle();
    });

    testWidgets('Tap the Yes button', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: printerCubit),
      ];

      Widget widgetToTest = Localizations(
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: const Locale('en'),
        child: const TransactionCompletedPage(),
      );

      when(() => posCubit.state)
          .thenReturn(PosCheckoutOrderCompleted(paidItemCheckout));
      when(() => printerCubit.state).thenReturn(PeripheralClaimed());
      await tester.pumpBlocApp(widgetToTest, providers);

      expect(find.byKey(yesButtonKey), findsOneWidget);
      when(() => printerCubit.state).thenReturn(PeripheralClaimed());
      when(() => printerCubit.printNormal('TestReceipt: '))
          .thenAnswer((_) async => PrintNormalComplete());

      await tester.tap(find.byKey(yesButtonKey));
      verify(() => printerCubit.enablePeripheral()).called(1);
      verify(() => printerCubit.printNormal(
          ReceiptBuilder.buildReceipt(paidItemCheckout))).called(1);
      await tester.pumpAndSettle();
    });

    testWidgets('Tap the Yes button - linked item', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: printerCubit),
      ];

      Widget widgetToTest = Localizations(
        delegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: const Locale('en'),
        child: const TransactionCompletedPage(),
      );

      when(() => posCubit.state)
          .thenReturn(PosCheckoutOrderCompleted(oneItemWithLinkedItemCheckout));
      when(() => printerCubit.state).thenReturn(PeripheralClaimed());
      await tester.pumpBlocApp(widgetToTest, providers);

      expect(find.byKey(yesButtonKey), findsOneWidget);
      when(() => printerCubit.state).thenReturn(PeripheralClaimed());
      when(() => printerCubit.printNormal('TestReceipt: '))
          .thenAnswer((_) async => PrintNormalComplete());

      await tester.tap(find.byKey(yesButtonKey));
      verify(() => printerCubit.enablePeripheral()).called(1);
      verify(() => printerCubit.printNormal(
              ReceiptBuilder.buildReceipt(oneItemWithLinkedItemCheckout)))
          .called(1);
      await tester.pumpAndSettle();
    });

    // TODO: Test cannot be done until PA supports print error
    // testWidgets('Renders retry print page', (tester) async {
    //   List<SingleChildWidget> providers = [
    //     BlocProvider.value(value: posCubit),
    //     BlocProvider.value(value: printerCubit),
    //   ];

    //   Widget widgetToTest = Localizations(
    //     delegates: const [
    //       AppLocalizations.delegate,
    //       GlobalMaterialLocalizations.delegate,
    //       GlobalWidgetsLocalizations.delegate
    //     ],
    //     locale: const Locale('en'),
    //     child: const TransactionCompletedPage(),
    //   );

    //   when(() => posCubit.state)
    //       .thenReturn(PosCheckoutOrderCompleted(paidItemCheckout));
    //   when(() => printerCubit.state).thenReturn(PeripheralClaimed());

    //   await tester.pumpBlocApp(widgetToTest, providers);
    //   expect(find.byType(GenericAppBar), findsOneWidget);
    //   expect(
    //       (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
    //           .automaticallyImplyLeading,
    //       false);
    //   expect(find.byType(TransactionCompletedView), findsOneWidget);
    //   expect(find.byType(Text), findsNWidgets(4));
    //   expect(find.text('Does the customer want a receipt?'), findsNothing);
    //   expect(find.text('Receipt print failed.  Do you want to retry?'),
    //       findsOneWidget);
    //   expect(find.byType(GeneralButton), findsNWidgets(2));
    //   expect(find.text('Yes'), findsNothing);
    //   expect(find.text('No'), findsOneWidget);
    //   expect(find.text('Retry'), findsOneWidget);
    //   await tester.pumpAndSettle();
    // });

    // TODO: Test cannot be done until PA supports print error
    //testWidgets('Renders print error', (tester) async {
    //   List<SingleChildWidget> providers = [
    //     BlocProvider.value(value: posCubit),
    //     BlocProvider.value(value: printerCubit),
    //   ];

    //   Widget widgetToTest = Localizations(
    //     delegates: const [
    //       AppLocalizations.delegate,
    //       GlobalMaterialLocalizations.delegate,
    //       GlobalWidgetsLocalizations.delegate
    //     ],
    //     locale: const Locale('en'),
    //     child: const TransactionCompletedPage(),
    //   );

    //   when(() => posCubit.state)
    //       .thenReturn(PosCheckoutOrderCompleted(paidItemCheckout));
    //   when(() => printerCubit.state).thenReturn(PrintError('Failed to print'));
    //   final expectedStates = [
    //     PrintError('Failed to print'),
    //   ];
    //   whenListen(printCubit, Stream.fromIterable(expectedStates));

    //   await tester.pumpBlocApp(widgetToTest, providers);
    //   expect(find.byType(GenericAppBar), findsOneWidget);
    //   expect(
    //       (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
    //           .automaticallyImplyLeading,
    //       false);
    //   expect(find.byType(TransactionCompletedView), findsOneWidget);
    //   expect(find.byType(ProcessingView), findsOneWidget);
    //   expect(find.byType(Text), findsNWidgets(1));
    //   await tester.pump();
    //   expect(find.byType(SnackBar), findsOneWidget);
    //   expect(find.text('Failed to Print Receipt!'), findsWidgets);
    //   when(() => printerCubit.setPrintRetryState()).thenAnswer((_) async {
    //     PrintRetry();
    //   });
    //   when(() => printerCubit.state).thenReturn(PrintRetry());
    //   await tester.pump(const Duration(seconds: 3));
    //   await tester.pump(const Duration(seconds: 1));
    //   await tester.pump(const Duration(seconds: 1));
    //   expect(find.byType(SnackBar), findsNothing);
    //   expect(printerCubit.state, PrintRetry());
    // });

    // TODO: Test cannot be done until PA supports print error
    // testWidgets('Tap the retry button', (tester) async {
    //   List<SingleChildWidget> providers = [
    //     BlocProvider.value(value: posCubit),
    //     BlocProvider.value(value: printCubit),
    //   ];

    //   Widget widgetToTest = Localizations(
    //     delegates: const [
    //       AppLocalizations.delegate,
    //       GlobalMaterialLocalizations.delegate,
    //       GlobalWidgetsLocalizations.delegate
    //     ],
    //     locale: const Locale('en'),
    //     child: const TransactionCompletedPage(),
    //   );

    //   when(() => posCubit.state)
    //       .thenReturn(PosCheckoutOrderCompleted(paidItemCheckout));
    //   when(() => printCubit.state).thenReturn(PrintRetry());
    //   await tester.pumpBlocApp(widgetToTest, providers);

    //   expect(find.byKey(yesButtonKey), findsOneWidget);

    //   when(() => printCubit.state).thenReturn(PrintComplete());
    //   when(() => printCubit.print('TestReceipt: '))
    //       .thenAnswer((_) async => PrintComplete());

    //   await tester.tap(find.byKey(yesButtonKey));
    //   expect(printCubit.state, PrintComplete());
    //   await tester.pumpAndSettle();
    // });

    // TODO: Test cannot be done until PA supports print error
    // testWidgets('Tap the Retry No button', (tester) async {
    //   List<SingleChildWidget> providers = [
    //     BlocProvider.value(value: posCubit),
    //     BlocProvider.value(value: printCubit),
    //   ];

    //   Widget widgetToTest = Localizations(
    //     delegates: const [
    //       AppLocalizations.delegate,
    //       GlobalMaterialLocalizations.delegate,
    //       GlobalWidgetsLocalizations.delegate
    //     ],
    //     locale: const Locale('en'),
    //     child: const TransactionCompletedPage(),
    //   );

    //   when(() => posCubit.state)
    //       .thenReturn(PosCheckoutOrderCompleted(paidItemCheckout));
    //   when(() => printCubit.state).thenReturn(PrintRetry());
    //   await tester.pumpBlocApp(widgetToTest, providers);

    //   expect(find.byKey(noButtonKey), findsOneWidget);

    //   when(() => posCubit.state)
    //       .thenReturn(PosCheckoutOrderCompleted(completedItemCheckout));
    //   when(() => printCubit.setPrintReadyState()).thenAnswer((_) async {
    //     PrintReady();
    //   });
    //   when(() => printCubit.state).thenReturn(PrintReady());
    //   when(() => posCubit.finishCheckout(paidItemCheckout)).thenAnswer(
    //       (_) async => PosCheckoutOrderCompleted(completedItemCheckout));

    //   await tester.tap(find.byKey(noButtonKey));
    //   expect(posCubit.state, PosCheckoutOrderCompleted(completedItemCheckout));
    //   expect(printCubit.state, PrintReady());
    //   await tester.pumpAndSettle();
    // });
  });
}
