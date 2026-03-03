import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  Future<User> register({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user!;
  }

  Future<User> login({required String email, required String password}) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user!;
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
