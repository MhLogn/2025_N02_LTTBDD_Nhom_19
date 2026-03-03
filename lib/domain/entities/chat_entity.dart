class ChatRoomEntity {
  final String id;
  final List<String> members;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  ChatRoomEntity({
    required this.id,
    required this.members,
    this.lastMessage,
    this.lastMessageTime,
  });
}