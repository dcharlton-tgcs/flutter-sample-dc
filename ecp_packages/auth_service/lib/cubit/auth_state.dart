part of '../auth_service.dart';

abstract class AuthState extends Equatable {}

class AuthError extends AuthState {
  AuthError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoggingIn extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoggedOut extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthSucceeded extends AuthState {
  @override
  List<Object> get props => [];
}
