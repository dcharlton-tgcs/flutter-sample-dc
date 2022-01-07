part of '../auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authService) : super(AuthInitial());

  final AuthService _authService;

  Future<void> login([String? userName, String? password]) async {
    try {
      emit(AuthLoggingIn());
      await _authService.login(userName, password);
      emit(AuthSucceeded());
    } on AuthException {
      emit(AuthError('Failed to log in'));
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    emit(AuthLoggedOut());
    emit(AuthInitial());
  }

  User? getActiveUser() {
    return _authService.getActiveUser();
  }
}
