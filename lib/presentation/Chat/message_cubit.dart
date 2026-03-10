import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/entities/message_entity.dart';
import 'package:my_project/domain/usecases/getMessage_usecase.dart';
import 'package:my_project/domain/usecases/message_usecase.dart';

class MessageCubit extends Cubit<List<MessageEntity>> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  MessageCubit(
      this.getMessagesUseCase,
      this.sendMessageUseCase,
      ) : super([]);

  void listenMessages(String roomId) {
    getMessagesUseCase(roomId).listen((messages) {
      emit(messages);
    });
  }

  Future<void> sendMessage(String roomId, String content, {String? replyTo}) async {
    if (content.trim().isEmpty) return;

    await sendMessageUseCase(roomId, content, replyTo: replyTo);
  }
}