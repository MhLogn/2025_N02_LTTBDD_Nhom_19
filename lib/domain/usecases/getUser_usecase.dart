import 'package:my_project/domain/entities/user_entity.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';

class GetAllUsersUseCase {
  final AuthRepository repository;

  GetAllUsersUseCase(this.repository);

  Stream<List<UserEntity>> call() {
    return repository.getAllUsers();
  }
}