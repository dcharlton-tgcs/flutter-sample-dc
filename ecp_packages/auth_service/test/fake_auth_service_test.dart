import 'package:auth_service/auth_service.dart';
import 'package:auth_service/fake_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> authParams = {};

  test('login user throws authexception', () async {
    var authService = FakeAuthService();
    authService.initialise(authParams);

    expect(() => authService.login('testuser', 'abc'),
        throwsA(isA<AuthException>()));
  });

  test('login user login valid', () async {
    var authService = FakeAuthService();
    var user = await authService.login('testuser', 'abcdefgh');
    expect(user.userName, 'testuser');
    expect(user.firstName, isNotEmpty);
    expect(user.lastName, isNotEmpty);
  });

  test('logout', () async {
    var authService = FakeAuthService();
    await authService.logout();
  });

  group('general:', () {
    test('active user empt', () async {
      var authService = FakeAuthService();
      authService.initialise(authParams);
      var user = authService.getActiveUser();
      expect(user, isInstanceOf<User?>());
    });
    test('known bearer token', () async {
      var authService = FakeAuthService();
      authService.initialise(authParams);
      var token = await authService.getBearerToken();
      expect(token, 'NoTokenForFakeAuth');
    });
  });
}
