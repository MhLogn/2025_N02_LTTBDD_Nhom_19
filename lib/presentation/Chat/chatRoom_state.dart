import 'package:my_project/domain/entities/chat_entity.dart';

abstract class ChatListState {}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ChatRoomEntity> rooms;

  ChatListLoaded(this.rooms);
}

class ChatListError extends ChatListState {
  final String message;

  ChatListError(this.message);
}