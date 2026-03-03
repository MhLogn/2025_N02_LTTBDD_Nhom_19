import 'package:my_project/domain/repositories/chat_repository.dart';

class ResetUnreadUseCase {
  final ChatRoomRepository repository;

  ResetUnreadUseCase(this.repository);

  Future<void> call(
      String roomId,
      String currentUserId,
      ) async {
    return await repository.resetUnreadCount(
      roomId,
      currentUserId,
    );
  }
}