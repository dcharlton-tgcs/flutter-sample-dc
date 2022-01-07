import 'package:ecp_common/ecp_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_flutter_app/common_widgets/navigation_bar.dart'
    as ecp_nav_bar;
import 'package:ui_flutter_app/pages/login/login.dart';

class LoginUser {
  static String username = const String.fromEnvironment(
    'username',
    defaultValue: 'mobiledev',
  );
  static String password = const String.fromEnvironment(
    'password',
    defaultValue: 'mobiledev',
  );
}

Future<void> loginAsUserSuccess(
    dynamic tester, String username, String password) async {
  const fieldLoginUsername = LoginPage.loginUserNameTextFieldKey;
  const fieldLoginPassword = LoginPage.loginPasswordTextFieldKey;
  const buttonLogin = LoginPage.loginPageButton;
  const buttonSingleAdd = ecp_nav_bar.NavigationBar.scanButtonKey;

  // Set currency to Euro and European format
  UiuxNumber.setLocale('en');

  // Ensure login page actually visible
  expect(find.byKey(buttonLogin), findsOneWidget);

  // Login with dummy user and password as all mocked for now
  await tester.enterText(find.byKey(fieldLoginUsername), username);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.enterText(find.byKey(fieldLoginPassword), password);
  await tester.testTextInput.receiveAction(TextInputAction.done);

  // Wait for keyboard to go away
  await tester.pumpAndSettle(const Duration(milliseconds: 200));

  // Login
  await tester.tap(find.byKey(buttonLogin));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));

  // Ensure it worked before returning
  expect(find.byKey(buttonSingleAdd), findsOneWidget);
}
