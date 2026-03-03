import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/entities/room_entity.dart';
import 'package:my_project/domain/usecases/chatRoom_usecase.dart';

class ChatRoomCubit extends Cubit<void> {
  final CreateOrGetChatRoomUseCase createRoomUseCase;

  ChatRoomCubit(this.createRoomUseCase) : super(null);

  Future<ChatRoomResult> createRoom(
    String currentUserId,
    String otherUserId,
  ) async {
    return await createRoomUseCase(currentUserId, otherUserId);
  }
}
