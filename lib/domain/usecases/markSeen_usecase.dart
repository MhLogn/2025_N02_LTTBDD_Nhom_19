import 'package:my_project/domain/repositories/chat_repository.dart';

class MarkMessagesSeenUseCase {
  final ChatRoomRepository repository;

  MarkMessagesSeenUseCase(this.repository);

  Future<void> call(
      String roomId,
      String currentUserId,
      ) {
    return repository.markMessagesSeen(
      roomId,
      currentUserId,
    );
  }
}