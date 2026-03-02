import 'package:my_project/presentation/auth/cubit/auth_error_type.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;

  AuthAuthenticated(this.userId);
}

class AuthError extends AuthState {
  final AuthErrorType type;

  AuthError(this.type);
}

class AuthPasswordResetSent extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthRegisterSuccess extends AuthState {}
