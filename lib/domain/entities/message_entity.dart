class MessageEntity {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });
}