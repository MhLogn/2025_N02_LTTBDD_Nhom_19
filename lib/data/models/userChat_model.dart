import 'package:my_project/domain/entities/user_entity.dart';
import 'package:my_project/domain/entities/chat_entity.dart';

class UserChatRoomItem {
  final UserEntity user;
  final int unreadCount;
  final DateTime? lastMessageTime;

  UserChatRoomItem({
    required this.user,
    required this.unreadCount,
    this.lastMessageTime,
  });
}