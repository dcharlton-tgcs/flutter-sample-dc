import 'package:auth_service/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuthService _authService;

  setUpAll(() {
    _authService = MockAuthService();
  });

  group('AuthCubit (login)', () {
    test('initial state', () {
      var authCubit = AuthCubit(_authService);
      expect(authCubit.state, AuthInitial());
    });
    test('get active user', () {
      var authCubit = AuthCubit(_authService);
      User? user = authCubit.getActiveUser();
      expect(user, isInstanceOf<User?>());
    });
    test('logging in', () {
      var authCubit = AuthCubit(_authService);

      when(() => _authService.login('abc', '123')).thenAnswer((_) async {
        return;
      });

      authCubit.login('abc', '123');
      expect(authCubit.state, AuthLoggingIn());

      expectLater(
        authCubit.stream,
        emits(
          AuthSucceeded(),
        ),
      );
    });
    test('failed login', () {
      var authCubit = AuthCubit(_authService);

      when(() => _authService.login('abc', '123')).thenThrow(LoginException());
      authCubit.login('abc', '123');
      expect(authCubit.state, AuthError('Failed to log in'));
    });
    test('logging out', () {
      var authCubit = AuthCubit(_authService);

      when(() => _authService.logout()).thenAnswer((_) async {
        return;
      });

      authCubit.logout();
      expectLater(
        authCubit.stream,
        emitsInOrder(
          [AuthLoggedOut(), AuthInitial()],
        ),
      );
    });
  });
}
