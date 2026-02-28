import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthCubit({required this.loginUseCase, required this.registerUseCase})
    : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());

      final user = await loginUseCase(email: email, password: password);

      emit(AuthAuthenticated(user.id));
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(_mapFirebaseError(e)));
      } else {
        emit(AuthError("Something went wrong. Please try again."));
      }
    }
  }

  Future<void> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      await registerUseCase(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
      );

      emit(AuthRegisterSuccess());
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(_mapFirebaseError(e)));
      } else {
        emit(AuthError("Something went wrong. Please try again."));
      }
    }
  }

  void logout() {
    emit(AuthUnauthenticated());
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';

      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'Incorrect email or password.';

      case 'email-already-in-use':
        return 'This email is already in use.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Network error. Please check your connection.';

      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
