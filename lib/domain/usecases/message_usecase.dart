import 'package:my_project/domain/repositories/auth_repository.dart';
import 'package:my_project/domain/repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRoomRepository repository;
  final AuthRepository authRepository;

  SendMessageUseCase(this.repository, this.authRepository);

  Future<void> call(String roomId, String content) async {
    final currentUser = await authRepository.getCurrentUser();

    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    await repository.sendMessage(
      roomId: roomId,
      senderId: currentUser.id,
      content: content,
    );
  }
}