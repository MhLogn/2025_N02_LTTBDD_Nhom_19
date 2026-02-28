import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/user_firestore_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource authDataSource;
  final UserFirestoreDataSource userDataSource;

  AuthRepositoryImpl({
    required this.authDataSource,
    required this.userDataSource,
  });

  @override
  Future<UserEntity> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    final firebaseUser = await authDataSource.register(
      email: email,
      password: password,
    );

    final userModel = UserModel(
      id: firebaseUser.uid,
      fullName: fullName,
      username: username,
      email: email,
    );

    await userDataSource.saveUser(userModel);

    return userModel;
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final firebaseUser = await authDataSource.login(
      email: email,
      password: password,
    );

    final user = await userDataSource.getUser(firebaseUser.uid);

    return user;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return authDataSource.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = authDataSource.getCurrentUser();
    if (firebaseUser == null) return null;

    return await userDataSource.getUser(firebaseUser.uid);
  }
}
