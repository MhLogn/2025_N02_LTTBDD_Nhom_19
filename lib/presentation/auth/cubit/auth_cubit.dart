import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_project/domain/usecases/login_usecase.dart';
import 'package:my_project/domain/usecases/register_usecase.dart';
import 'package:my_project/domain/usecases/forgot_password_usecase.dart';
import 'auth_state.dart';
import 'auth_error_type.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
  }) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (state is AuthLoading) return;

    emit(AuthLoading());

    try {
      final user = await loginUseCase(
        email: email,
        password: password,
      );

      emit(AuthAuthenticated(user.id));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e)));
    } catch (_) {
      emit(AuthError(AuthErrorType.unknown));
    }
  }

  Future<void> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    if (state is AuthLoading) return;

    emit(AuthLoading());

    try {
      await registerUseCase(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
      );

      emit(AuthRegisterSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e)));
    } catch (_) {
      emit(AuthError(AuthErrorType.unknown));
    }
  }

  Future<void> forgotPassword({
    required String email,
  }) async {
    if (state is AuthLoading) return;

    emit(AuthLoading());

    try {
      await forgotPasswordUseCase(email: email);
      emit(AuthPasswordResetSent());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e)));
    } catch (_) {
      emit(AuthError(AuthErrorType.unknown));
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    emit(AuthUnauthenticated());
  }

  AuthErrorType _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return AuthErrorType.invalidEmail;

      case 'invalid-credential':
      case 'invalid-login-credentials':
        return AuthErrorType.wrongCredentials;

      case 'email-already-in-use':
        return AuthErrorType.emailAlreadyInUse;

      case 'weak-password':
        return AuthErrorType.weakPassword;

      case 'too-many-requests':
        return AuthErrorType.tooManyRequests;

      case 'network-request-failed':
        return AuthErrorType.networkError;

      default:
        return AuthErrorType.authenticationFailed;
    }
  }
}