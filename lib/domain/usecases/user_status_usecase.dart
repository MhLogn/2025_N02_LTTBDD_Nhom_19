import 'package:my_project/domain/repositories/auth_repository.dart';

class UpdateUserStatusUseCase {
  final AuthRepository repository;

  UpdateUserStatusUseCase(this.repository);

  Future<void> call(String uid, {required bool isOnline}) {
    if (isOnline) {
      return repository.updateUserAfterLogin(uid);
    } else {
      return repository.updateUserOffline(uid);
    }
  }
}