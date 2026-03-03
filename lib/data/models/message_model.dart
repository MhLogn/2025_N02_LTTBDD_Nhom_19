import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.senderId,
    required super.content,
    required super.createdAt,
    required super.isSeen,
    super.seenAt,
  });

  factory MessageModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MessageModel(
      id: doc.id,
      senderId: data['senderId'],
      content: data['content'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isSeen: data['isSeen'] ?? false,
      seenAt: data['seenAt'] != null
          ? (data['seenAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'isSeen': isSeen,
      'seenAt': seenAt != null ? Timestamp.fromDate(seenAt!) : null,
    };
  }
}