import 'package:my_project/domain/entities/chat_entity.dart';
import 'package:my_project/domain/repositories/chat_repository.dart';

class GetUserChatRoomsUseCase {
  final ChatRoomRepository repository;

  GetUserChatRoomsUseCase(this.repository);

  Stream<List<ChatRoomEntity>> call(String userId) {
    return repository.getUserChatRooms(userId);
  }
}