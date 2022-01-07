import 'package:auth_service/auth_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_service/pos_service.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ui_flutter_app/common_widgets/common_widgets.dart';
import 'package:ui_flutter_app/pages/login/login.dart';
import 'package:ui_flutter_app/pages/login/login_view.dart';

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

  group('Testing the Login page', () {
    setUp(() {
      authCubit = MockAuthCubit();
      posCubit = MockPosCubit();
    });

    const loginButtonKey = Key('login_page_button');
    const loginUsernameTextField = Key('login_username_text_field');
    const loginPasswordTextField = Key('login_password_text_field');

    testWidgets('Login page has three text widgets and one button widget',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: authCubit),
        BlocProvider.value(value: posCubit),
      ];

      when(() => authCubit.state).thenReturn(AuthInitial());

      await tester.pumpBlocApp(const LoginPage(), providers);

      expect(find.byType(GenericAppBar), findsOneWidget);
      expect(
          (tester.firstWidget(find.byType(GenericAppBar)) as GenericAppBar)
              .automaticallyImplyLeading,
          false);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(Text), findsNWidgets(3));
      expect(find.byType(GeneralButton), findsOneWidget);
    });

    testWidgets('Test if login button exists in login page', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: authCubit),
      ];

      when(() => authCubit.state).thenReturn(AuthInitial());
      when(() => authCubit.login('abc', 'abc'))
          .thenAnswer((_) async => AuthSucceeded());

      await tester.pumpBlocApp(const LoginPage(), providers);

      expect(find.byKey(loginUsernameTextField), findsOneWidget);
      expect(find.byKey(loginPasswordTextField), findsOneWidget);
      await tester.enterText(find.byKey(loginUsernameTextField), 'abc');
      await tester.enterText(find.byKey(loginPasswordTextField), 'abc');
      await tester.pumpAndSettle();

      expect(find.byKey(loginButtonKey), findsOneWidget);
      await tester.tap(find.byKey(loginButtonKey));

      verify(() => authCubit.login('abc', 'abc')).called(1);
    });

    testWidgets('Test if username text field exists in login page',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: authCubit),
      ];

      when(() => authCubit.state).thenReturn(AuthInitial());

      await tester.pumpBlocApp(const LoginPage(), providers);
      expect(find.byKey(loginUsernameTextField), findsOneWidget);
    });

    testWidgets('Test for writing in username text field from login page',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: authCubit),
      ];

      when(() => authCubit.state).thenReturn(AuthInitial());

      await tester.pumpBlocApp(const LoginPage(), providers);
      await tester.enterText(find.byKey(loginUsernameTextField), 'username');
    });

    testWidgets('Test if user and pass text form field exists in login page',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: authCubit),
      ];

      when(() => authCubit.state).thenReturn(AuthInitial());

      await tester.pumpBlocApp(const LoginPage(), providers);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('Test for writing in password text field from login page',
        (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: authCubit),
      ];

      when(() => authCubit.state).thenReturn(AuthInitial());

      await tester.pumpBlocApp(const LoginPage(), providers);
      await tester.enterText(find.byKey(loginPasswordTextField), 'password');
    });

    testWidgets('Test for auth successful', (tester) async {
      List<SingleChildWidget> providers = [
        BlocProvider.value(value: authCubit),
        BlocProvider.value(value: posCubit),
      ];

      when(() => posCubit.setPosCheckoutInitialState()).thenAnswer((_) async {
        PosCheckoutInitial();
      });

      when(() => authCubit.state).thenReturn(AuthSucceeded());
      final expectedStates = [
        AuthSucceeded(),
      ];
      whenListen(authCubit, Stream.fromIterable(expectedStates));

      final expectedStatesPos = [
        PosCheckoutInitial(),
      ];
      whenListen(posCubit, Stream.fromIterable(expectedStatesPos));

      await tester.pumpBlocApp(const LoginPage(), providers);
      expect(find.byType(LoginView), findsOneWidget);
    });
  });
}
