import '../../domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends UserEntity {
  final String? photoUrl;
  final bool isOnline;
  final DateTime? lastSeen;
  final DateTime? createdAt;

  UserModel({
    required String id,
    required String fullName,
    required String username,
    required String email,
    this.photoUrl,
    this.isOnline = false,
    this.lastSeen,
    this.createdAt,
  }) : super(
    id: id,
    fullName: fullName,
    username: username,
    email: email,
  );

  factory UserModel.fromFirestore(
      Map<String, dynamic> json,
      String id,
      ) {
    return UserModel(
      id: id,
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null
          ? (json['lastSeen'] as Timestamp).toDate()
          : null,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen != null
          ? Timestamp.fromDate(lastSeen!)
          : null,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : Timestamp.now(),
    };
  }
}