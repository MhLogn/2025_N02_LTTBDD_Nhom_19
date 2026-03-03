import 'package:my_project/domain/entities/message_entity.dart';
import 'package:my_project/domain/repositories/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRoomRepository repository;

  GetMessagesUseCase(this.repository);

  Stream<List<MessageEntity>> call(String roomId) {
    return repository.getMessages(roomId);
  }
}