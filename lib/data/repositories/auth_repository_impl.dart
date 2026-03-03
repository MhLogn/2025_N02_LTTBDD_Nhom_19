import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<void> updateUserAfterLogin(String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
      'isOnline': true,
      'lastSeen': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> updateUserOffline(String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
      'isOnline': false,
      'lastSeen': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromFirestore(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return authDataSource.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'isOnline': false,
        'lastSeen': Timestamp.now(),
      }, SetOptions(merge: true));
    }

    await authDataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = authDataSource.getCurrentUser();
    if (firebaseUser == null) return null;

    return await userDataSource.getUser(firebaseUser.uid);
  }
}
