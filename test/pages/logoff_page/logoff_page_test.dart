import 'package:auth_service/auth_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ecp_openapi/model/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_service/pos_service.dart';
import 'package:ui_flutter_app/app/app_utils.dart';
import 'package:ui_flutter_app/common_widgets/general_alert_dialog.dart';
import 'package:ui_flutter_app/pages/logoff/logoff.dart';
import 'package:provider/single_child_widget.dart';
import '../../helpers/pump_bloc_app.dart';
import '../../../ecp_packages/pos_service/test/mock_service_data.dart';
import '../login_page/login_page_test.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockPosCubit extends MockCubit<PosState> implements PosCubit {}

class FakePosState extends Fake implements PosState {}

void main() {
  late AuthCubit authCubit;
  late PosCubit posCubit;
  late Checkout newEmptyCheckout;
  late Checkout oneItemCheckout;
  late Checkout oneItemWithLinkedItemCheckout;
  late Checkout sevenNormalItemsCheckout;
  late Checkout sevenLinkedItemsCheckout;

  setUpAll(() {
    registerFallbackValue(FakeAuthState());
    registerFallbackValue(FakePosState());
    newEmptyCheckout = mockNewCheckout;
    oneItemCheckout = mockOneItemCheckout;
    oneItemWithLinkedItemCheckout = mockOneItemWithLinkedItem;
    sevenNormalItemsCheckout = mockCheckoutSevenItem;
    sevenLinkedItemsCheckout = mockCheckoutSevenLinkedItems;
  });
  group('Test the logoff page...', () {
    setUp(() {
      posCubit = MockPosCubit();
      authCubit = MockAuthCubit();
    });

    testWidgets('Test day period AM', (tester) async {
      AppUtils.time = '2021-11-18 08:19:51.248543';
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
      ];
      when(() => posCubit.state).thenReturn(PosCheckoutInitial());
      await tester.pumpBlocApp(const LogoffPage(), providers);
      expect(find.byType(Drawer), findsOneWidget);
      expect(
          (tester.widget(find.byKey(LogoffPage.logoutUsernameKey)) as Text)
              .data,
          'Good morning, Andreas!');
    });

    testWidgets('Test day period PM', (tester) async {
      AppUtils.time = '2021-11-18 13:19:51.248543';
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
      ];
      when(() => posCubit.state).thenReturn(PosCheckoutInitial());
      await tester.pumpBlocApp(const LogoffPage(), providers);
      expect(find.byType(Drawer), findsOneWidget);
      expect(
          (tester.widget(find.byKey(LogoffPage.logoutUsernameKey)) as Text)
              .data,
          'Good afternoon, Andreas!');
    });

    testWidgets('Test if widgets exist', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: authCubit),
      ];
      when(() => posCubit.state).thenReturn(PosCheckoutInitial());
      await tester.pumpBlocApp(const LogoffPage(), providers);
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('Test if onTap (No button) of Logoff Container works',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: authCubit),
      ];
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      when(() => authCubit.state).thenReturn(AuthSucceeded());

      await tester.pumpBlocApp(const LogoffPage(), providers);
      expect(find.byKey(LogoffPage.logoutContainerKey), findsOneWidget);
      await tester.tap(find.byKey(LogoffPage.logoutContainerKey));

      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey),
          findsOneWidget);
      await tester.tap(find.byKey(GeneralAlertDialog.primaryAlertButtonKey));
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets(
        'Test if onTap (Yes button) of Logoff Container works (Empty Checkout)',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: authCubit),
      ];
      when(() => authCubit.state).thenReturn(AuthSucceeded());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(newEmptyCheckout));
      when(() => authCubit.logout()).thenAnswer((_) async => AuthInitial());
      await tester.pumpBlocApp(const LogoffPage(), providers);
      when(() => posCubit.cancelCheckout(
            newEmptyCheckout,
            true,
          )).thenAnswer((_) async => PosCheckoutReady(newEmptyCheckout));
      expect(find.byKey(LogoffPage.logoutContainerKey), findsOneWidget);
      await tester.tap(find.byKey(LogoffPage.logoutContainerKey));

      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey),
          findsOneWidget);
      await tester.tap(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(GeneralAlertDialog), findsNothing);

      verify(() => posCubit.cancelCheckout(
            newEmptyCheckout,
            true,
          )).called(1);
      verify(() => authCubit.logout()).called(1);
    });

    testWidgets(
        'Test if onTap (Yes button) of Logoff Container works (One Item Checkout)',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: authCubit),
      ];
      when(() => authCubit.state).thenReturn(AuthSucceeded());
      when(() => posCubit.state).thenReturn(PosCheckoutReady(oneItemCheckout));
      when(() => authCubit.logout()).thenAnswer((_) async => AuthInitial());
      await tester.pumpBlocApp(const LogoffPage(), providers);
      when(() => posCubit.cancelCheckout(
            oneItemCheckout,
            true,
          )).thenAnswer((_) async => PosCheckoutReady(oneItemCheckout));
      expect(find.byKey(LogoffPage.logoutContainerKey), findsOneWidget);
      await tester.tap(find.byKey(LogoffPage.logoutContainerKey));

      await tester.pumpAndSettle();

      await tester
          .tapAt(tester.getCenter(find.byKey(LogoffPage.logoutUsernameKey)));
      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey),
          findsOneWidget);
      await tester.tap(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(GeneralAlertDialog), findsNothing);

      verify(() => posCubit.cancelCheckout(
            oneItemCheckout,
            true,
          )).called(1);
      verify(() => authCubit.logout()).called(1);
    });

    testWidgets('No Logoff when PosCheckoutOrderCompleted', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: authCubit),
      ];
      when(() => authCubit.state).thenReturn(AuthSucceeded());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutOrderCompleted(oneItemCheckout));
      when(() => authCubit.logout()).thenAnswer((_) async => AuthInitial());
      await tester.pumpBlocApp(const LogoffPage(), providers);
      when(() => posCubit.cancelCheckout(
            oneItemCheckout,
            true,
          )).thenAnswer((_) async => PosCheckoutReady(oneItemCheckout));
      expect(find.byKey(LogoffPage.logoutContainerKey), findsOneWidget);
      await tester.tap(find.byKey(LogoffPage.logoutContainerKey));

      await tester.pumpAndSettle();

      await tester
          .tapAt(tester.getCenter(find.byKey(LogoffPage.logoutUsernameKey)));
      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsNothing);
    });

    testWidgets(
        'Test if onTap (Yes button) of Logoff Container works (One Item With Linked Item Checkout)',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: authCubit),
      ];
      when(() => authCubit.state).thenReturn(AuthSucceeded());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(oneItemWithLinkedItemCheckout));
      when(() => authCubit.logout()).thenAnswer((_) async => AuthInitial());
      await tester.pumpBlocApp(const LogoffPage(), providers);
      when(() => posCubit.cancelCheckout(
                oneItemWithLinkedItemCheckout,
                true,
              ))
          .thenAnswer(
              (_) async => PosCheckoutReady(oneItemWithLinkedItemCheckout));
      expect(find.byKey(LogoffPage.logoutContainerKey), findsOneWidget);
      await tester.tap(find.byKey(LogoffPage.logoutContainerKey));

      await tester.pumpAndSettle();

      await tester
          .tapAt(tester.getCenter(find.byKey(LogoffPage.logoutUsernameKey)));
      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey),
          findsOneWidget);
      await tester.tap(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(GeneralAlertDialog), findsNothing);

      verify(() => posCubit.cancelCheckout(
            oneItemWithLinkedItemCheckout,
            true,
          )).called(1);
      verify(() => authCubit.logout()).called(1);
    });

    testWidgets(
        'Test if onTap (Yes button) of Logoff Container works (Seven Normal Items Checkout)',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: authCubit),
      ];
      when(() => authCubit.state).thenReturn(AuthSucceeded());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(sevenNormalItemsCheckout));
      when(() => authCubit.logout()).thenAnswer((_) async => AuthInitial());
      await tester.pumpBlocApp(const LogoffPage(), providers);
      when(() => posCubit.cancelCheckout(
                sevenNormalItemsCheckout,
                true,
              ))
          .thenAnswer((_) async => PosCheckoutReady(sevenNormalItemsCheckout));
      expect(find.byKey(LogoffPage.logoutContainerKey), findsOneWidget);
      await tester.tap(find.byKey(LogoffPage.logoutContainerKey));

      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey),
          findsOneWidget);
      await tester.tap(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(GeneralAlertDialog), findsNothing);

      verify(() => posCubit.cancelCheckout(
            sevenNormalItemsCheckout,
            true,
          )).called(1);
      verify(() => authCubit.logout()).called(1);
    });

    testWidgets(
        'Test if onTap (Yes button) of Logoff Container works (Seven Items With Linked Items Checkout)',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: posCubit),
        BlocProvider.value(value: authCubit),
      ];
      when(() => authCubit.state).thenReturn(AuthSucceeded());
      when(() => posCubit.state)
          .thenReturn(PosCheckoutReady(sevenLinkedItemsCheckout));
      when(() => posCubit.cancelCheckout(
                sevenLinkedItemsCheckout,
                true,
              ))
          .thenAnswer((_) async => PosCheckoutReady(sevenLinkedItemsCheckout));
      when(() => authCubit.logout()).thenAnswer((_) async => AuthInitial());
      await tester.pumpBlocApp(const LogoffPage(), providers);
      await tester.pumpAndSettle();
      expect(find.byKey(LogoffPage.logoutContainerKey), findsOneWidget);
      await tester.tap(find.byKey(LogoffPage.logoutContainerKey));

      await tester.pumpAndSettle();

      expect(find.byType(GeneralAlertDialog), findsOneWidget);
      expect(
          find.byKey(GeneralAlertDialog.primaryAlertButtonKey), findsOneWidget);
      expect(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey),
          findsOneWidget);
      await tester.tap(find.byKey(GeneralAlertDialog.secondaryAlertButtonKey));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(GeneralAlertDialog), findsNothing);

      verify(() => posCubit.cancelCheckout(
            sevenLinkedItemsCheckout,
            true,
          )).called(1);
      verify(() => authCubit.logout()).called(1);
    });
  });
}
