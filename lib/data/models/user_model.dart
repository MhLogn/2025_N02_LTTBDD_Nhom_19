import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String fullName,
    required String username,
    required String email,
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
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
    };
  }
}