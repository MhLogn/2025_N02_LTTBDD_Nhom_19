import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserFirestoreDataSource {
  final FirebaseFirestore _firestore;

  UserFirestoreDataSource(this._firestore);

  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toFirestore());
  }

  Future<UserModel> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    return UserModel.fromFirestore(doc.data()!, doc.id);
  }

  Future<void> updateUserProfile({
    required String uid,
    required String fullName,
    required String username,
    required String email,
    String? photoUrl,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'fullName': fullName,
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
    });
  }
}
