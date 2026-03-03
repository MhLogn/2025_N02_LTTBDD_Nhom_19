class MessageEntity {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final bool isSeen;
  final DateTime? seenAt;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.isSeen,
    this.seenAt,
  });
}