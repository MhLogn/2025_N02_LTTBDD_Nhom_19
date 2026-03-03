import 'package:my_project/domain/entities/message_entity.dart';

abstract class ChatRoomRepository {
  Future<String> createOrGetRoom(String currentUserId,
      String otherUserId,);

  Stream<List<MessageEntity>> getMessages(String roomId);

  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String content,
  });
}