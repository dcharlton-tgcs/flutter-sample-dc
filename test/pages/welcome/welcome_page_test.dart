import 'package:auth_service/auth_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_service/pos_service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/pages/welcome/welcome.dart';

import '../../helpers/pump_bloc_app.dart';

class FakeAuthState extends Fake implements AuthState {}

class FakePosState extends Fake implements PosState {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockPosCubit extends MockCubit<PosState> implements PosCubit {}

void main() {
  late AuthCubit authCubit;
  late PosCubit posCubit;

  setUpAll(() {
    registerFallbackValue(FakeAuthState());
    registerFallbackValue(FakePosState());
  });

  group('Testing the Welcome page', () {
    setUp(() {
      authCubit = MockAuthCubit();
      posCubit = MockPosCubit();
    });

    testWidgets('login page', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: authCubit),
      ];

      when(() => authCubit.state).thenReturn(AuthInitial());

      when(() => authCubit.login()).thenAnswer((_) async => AuthSucceeded());

      await tester.pumpBlocApp(const WelcomePage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
              .automaticallyImplyLeading,
          false);
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(6));
      expect(find.byType(GeneralButton), findsNWidgets(2));
      expect(find.byKey(WelcomePage.loginButtonKey), findsOneWidget);
      expect(find.byKey(WelcomePage.onBoardButtonKey), findsOneWidget);
      expect(find.byKey(WelcomePage.needHelpLinkKey), findsOneWidget);
      await tester.tap(find.byKey(WelcomePage.onBoardButtonKey));
      await tester.tap(find.byKey(WelcomePage.needHelpLinkKey));
      await tester.tap(find.byKey(WelcomePage.loginButtonKey));
      await tester.pumpAndSettle();

      verify(() => authCubit.login()).called(1);
    });

    testWidgets('logged out state', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: authCubit),
      ];

      when(() => authCubit.state).thenReturn(AuthLoggedOut());

      when(() => authCubit.login()).thenAnswer((_) async => AuthSucceeded());

      await tester.pumpBlocApp(const WelcomePage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
              .automaticallyImplyLeading,
          false);
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(6));
      expect(find.byType(GeneralButton), findsNWidgets(2));
      expect(find.byKey(WelcomePage.loginButtonKey), findsOneWidget);
      expect(find.byKey(WelcomePage.onBoardButtonKey), findsOneWidget);
      expect(find.byKey(WelcomePage.needHelpLinkKey), findsOneWidget);
      await tester.tap(find.byKey(WelcomePage.loginButtonKey));
      await tester.pumpAndSettle();

      verify(() => authCubit.login()).called(1);
    });

    testWidgets('login failed', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: authCubit),
      ];

      when(() => authCubit.state).thenReturn(AuthError('Login Failed'));
      final expectedStates = [
        AuthError('Login Failed'),
      ];
      whenListen(authCubit, Stream.fromIterable(expectedStates));

      when(() => authCubit.login()).thenAnswer((_) async => AuthSucceeded());

      await tester.pumpBlocApp(const WelcomePage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
              .automaticallyImplyLeading,
          false);

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(6));
      expect(find.byType(GeneralButton), findsNWidgets(2));
      expect(find.byKey(WelcomePage.loginButtonKey), findsOneWidget);
      expect(find.byKey(WelcomePage.onBoardButtonKey), findsOneWidget);
      expect(find.byKey(WelcomePage.needHelpLinkKey), findsOneWidget);

      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(SnackBar), findsNothing);

      await tester.tap(find.byKey(WelcomePage.loginButtonKey));
      await tester.pumpAndSettle();

      verify(() => authCubit.login()).called(1);
    });

    testWidgets('processing logging in', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: authCubit),
      ];

      when(() => authCubit.state).thenReturn(AuthLoggingIn());

      await tester.pumpBlocApp(const WelcomePage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
              .automaticallyImplyLeading,
          false);

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(GeneralButton), findsNothing);
      expect(find.byKey(WelcomePage.loginButtonKey), findsNothing);
      expect(find.byKey(WelcomePage.onBoardButtonKey), findsNothing);
      expect(find.byKey(WelcomePage.needHelpLinkKey), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('auth successful state', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: authCubit),
        BlocProvider.value(value: posCubit),
      ];

      when(() => authCubit.state).thenReturn(AuthSucceeded());
      final expectedStates = [
        AuthSucceeded(),
      ];
      whenListen(authCubit, Stream.fromIterable(expectedStates));

      when(() => posCubit.setPosCheckoutInitialState()).thenAnswer((_) async {
        PosCheckoutInitial();
      });
      when(() => posCubit.state).thenReturn(PosCheckoutInitial());

      await tester.pumpBlocApp(const WelcomePage(), providers);

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(GeneralButton), findsNothing);
      expect(find.byKey(WelcomePage.loginButtonKey), findsNothing);
      expect(find.byKey(WelcomePage.onBoardButtonKey), findsNothing);
      expect(find.byKey(WelcomePage.needHelpLinkKey), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(posCubit.state, PosCheckoutInitial());
      verify(() => posCubit.setPosCheckoutInitialState()).called(1);
    });
  });
}
