import 'package:my_project/data/datasources/chat_firestore_datasources.dart';
import 'package:my_project/data/models/message_model.dart';
import 'package:my_project/domain/repositories/chat_repository.dart';

class ChatRoomRepositoryImpl implements ChatRoomRepository {
  final ChatRoomFirestoreDataSource dataSource;

  ChatRoomRepositoryImpl(this.dataSource);

  @override
  Future<String> createOrGetRoom(String currentUserId, String otherUserId) {
    return dataSource.createOrGetRoom(currentUserId, otherUserId);
  }

  @override
  Stream<List<MessageModel>> getMessages(String roomId) {
    return dataSource.getMessages(roomId);
  }

  @override
  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String content,
  }) async {
    return await dataSource.sendMessage(
      roomId: roomId,
      senderId: senderId,
      content: content,
    );
  }

  @override
  Future<void> markMessagesSeen(
      String roomId,
      String currentUserId,
      ) {
    return dataSource.markMessagesSeen(
      roomId,
      currentUserId,
    );
  }

  @override
  Future<void> resetUnreadCount(String roomId, String currentUserId) async {
    return await dataSource.resetUnreadCount(roomId, currentUserId);
  }
}
