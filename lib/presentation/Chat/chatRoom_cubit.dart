import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/entities/room_entity.dart';
import 'package:my_project/domain/usecases/chatRoom_usecase.dart';
import 'package:my_project/domain/usecases/resetUnread_usecase.dart';

class ChatRoomCubit extends Cubit<void> {
  final CreateOrGetChatRoomUseCase createRoomUseCase;
  final ResetUnreadUseCase resetUnreadUseCase;

  ChatRoomCubit(
      this.createRoomUseCase,
      this.resetUnreadUseCase,
      ) : super(null);

  Future<ChatRoomResult> createRoom(
      String otherUserId,
      ) async {
    return await createRoomUseCase(otherUserId);
  }

  Future<void> resetUnread(
      String roomId,
      String currentUserId,
      ) async {
    await resetUnreadUseCase(roomId, currentUserId);
  }
}