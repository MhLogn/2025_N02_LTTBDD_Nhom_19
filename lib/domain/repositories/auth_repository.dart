import 'package:my_project/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  });

  Future<void> updateProfile({
    required String fullName,
    required String username,
    required String email,
    String? photoUrl,
  });

  Future<void> updateUserAfterLogin(String uid);

  Future<void> updateUserOffline(String uid);

  Stream<List<UserEntity>> getAllUsers();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> logout();

  Future<UserEntity?> getCurrentUser();
}
