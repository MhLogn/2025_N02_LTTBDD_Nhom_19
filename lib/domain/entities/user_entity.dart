class UserEntity {
  final String id;
  final String fullName;
  final String username;
  final String email;

  final String? photoUrl;
  final bool isOnline;
  final DateTime? lastSeen;
  final DateTime? createdAt;

  UserEntity({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    this.photoUrl,
    this.isOnline = false,
    this.lastSeen,
    this.createdAt,
  });
}