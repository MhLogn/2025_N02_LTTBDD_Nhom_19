import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/domain/entities/chat_entity.dart';

class ChatRoomModel extends ChatRoomEntity {
  final Map<String, int> unreadCounts;

  ChatRoomModel({
    required super.id,
    required super.members,
    super.lastMessage,
    super.lastMessageTime,
    required this.unreadCounts,
  });

  factory ChatRoomModel.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return ChatRoomModel(
      id: id,
      members: List<String>.from(data['members']),
      lastMessage: data['lastMessage'],
      lastMessageTime:
      (data['lastMessageTime'] as Timestamp?)?.toDate(),
      unreadCounts: Map<String, int>.from(
        data['unreadCounts'] ?? {},
      )
    );
  }
}