import 'package:my_project/domain/entities/room_entity.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';
import 'package:my_project/domain/repositories/chat_repository.dart';

class CreateOrGetChatRoomUseCase {
  final ChatRoomRepository chatRoomRepository;
  final AuthRepository authRepository;

  CreateOrGetChatRoomUseCase(this.chatRoomRepository, this.authRepository);

  Future<ChatRoomResult> call(String otherUserId) async {
    final currentUser = await authRepository.getCurrentUser();

    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    // 🔥 tạo room bằng 2 id thật sự
    final roomId = await chatRoomRepository.createOrGetRoom(
      currentUser.id,
      otherUserId,
    );

    final users = await authRepository.getAllUsers().first;

    final otherUser = users.firstWhere((user) => user.id == otherUserId);

    return ChatRoomResult(
      roomId: roomId,
      currentUserFullName: currentUser.fullName,
      otherUserFullName: otherUser.fullName,
    );
  }
}
