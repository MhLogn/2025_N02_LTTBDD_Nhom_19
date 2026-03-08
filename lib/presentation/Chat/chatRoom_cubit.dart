import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/entities/room_entity.dart';
import 'package:my_project/domain/usecases/chatRoom_usecase.dart';
import 'package:my_project/domain/usecases/markSeen_usecase.dart';
import 'package:my_project/domain/usecases/resetUnread_usecase.dart';

class ChatRoomCubit extends Cubit<void> {
  final CreateOrGetChatRoomUseCase createRoomUseCase;
  final ResetUnreadUseCase resetUnreadUseCase;
  final MarkMessagesSeenUseCase markMessagesSeenUseCase;

  ChatRoomCubit(this.createRoomUseCase, this.resetUnreadUseCase, this.markMessagesSeenUseCase) : super(null);

  Future<ChatRoomResult> createRoom(String otherUserId) async {
    return await createRoomUseCase(otherUserId);
  }

  Future<void> resetUnread(String roomId, String currentUserId) async {
    await resetUnreadUseCase(roomId, currentUserId);
  }

  Future<void> markSeen(String roomId, String currentUserId) async {
    await markMessagesSeenUseCase (roomId, currentUserId);
  }
}
