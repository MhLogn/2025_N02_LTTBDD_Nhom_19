import 'package:my_project/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call({required String email}) {
    return repository.sendPasswordResetEmail(email: email);
  }
}