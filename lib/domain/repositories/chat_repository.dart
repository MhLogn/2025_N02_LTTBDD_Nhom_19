abstract class ChatRoomRepository {
  Future<String> createOrGetRoom(
      String currentUserId,
      String otherUserId,
      );
}