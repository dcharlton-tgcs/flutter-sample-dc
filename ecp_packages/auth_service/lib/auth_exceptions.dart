part of 'auth_service.dart';

class AuthException implements Exception {}

class EndpointAccessException extends LoginException {}

class InitException implements AuthException {}

class LoggedOutException implements AuthException {}

class LoginException implements AuthException {}

class NotInitialisedException extends InitException {}

class NotLoggedInException extends LoginException {}
