import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/entities/user_entity.dart';
import 'package:my_project/domain/usecases/getChatRoom_usecase.dart';
import 'package:my_project/domain/usecases/getUser_usecase.dart';
import 'package:my_project/domain/usecases/chatRoom_usecase.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';

class UserChatRoomItem {
  final UserEntity user;
  final int unreadCount;
  final DateTime? lastMessageTime;

  UserChatRoomItem({
    required this.user,
    required this.unreadCount,
    this.lastMessageTime,
  });
}

class ChatCubitState {
  final bool isLoading;
  final UserEntity? currentUser;
  final List<UserChatRoomItem> chatItems;

  ChatCubitState({
    this.isLoading = true,
    this.currentUser,
    this.chatItems = const [],
  });
}

class ChatCubit extends Cubit<ChatCubitState> {
  final AuthRepository authRepository;
  final GetAllUsersUseCase getAllUsersUseCase;
  final GetUserChatRoomsUseCase getUserChatRoomsUseCase;

  StreamSubscription? _usersSubscription;
  StreamSubscription? _roomsSubscription;

  List<UserEntity> _allUsers = [];
  List<dynamic> _userRooms = [];

  ChatCubit(
    this.authRepository,
    this.getAllUsersUseCase,
    this.getUserChatRoomsUseCase,
  ) : super(ChatCubitState());

  Future<void> init() async {
    await _cancelSubscriptions();
    _allUsers.clear();
    _userRooms.clear();
    emit(ChatCubitState(isLoading: true, currentUser: null, chatItems: []));

    final currentUser = await authRepository.getCurrentUser();
    if (currentUser == null) {
      emit(ChatCubitState(isLoading: false));
      return;
    }

    emit(
      ChatCubitState(isLoading: true, currentUser: currentUser, chatItems: []),
    );

    _usersSubscription = getAllUsersUseCase().listen((users) {
      _allUsers = users;
      _combineData();
    });

    _roomsSubscription = getUserChatRoomsUseCase(currentUser.id).listen((
      rooms,
    ) {
      _userRooms = rooms;
      _combineData();
    });
  }

  void _combineData() {
    if (_allUsers.isEmpty || state.currentUser == null) {
      return;
    }

    UserEntity? updatedCurrentUser;
    try {
      updatedCurrentUser = _allUsers.firstWhere(
        (u) => u.id == state.currentUser!.id,
      );
    } catch (_) {
      updatedCurrentUser = state.currentUser;
    }

    final currentUserId = state.currentUser!.id;
    List<UserChatRoomItem> items = [];

    for (var user in _allUsers) {
      if (user.id == currentUserId) continue;

      final sortedIds = [currentUserId, user.id]..sort();
      final expectedRoomId = "${sortedIds[0]}_${sortedIds[1]}";

      dynamic foundRoom;
      for (var room in _userRooms) {
        if (room.id == expectedRoomId) {
          foundRoom = room;
          break;
        }
      }

      int unread = 0;
      DateTime? time;

      if (foundRoom != null) {
        final unreadMap = foundRoom.unreadCounts as Map<String, dynamic>?;
        if (unreadMap != null) {
          unread = (unreadMap[currentUserId] ?? 0) as int;
        }
        time = foundRoom.lastMessageTime;
      }

      items.add(
        UserChatRoomItem(
          user: user,
          unreadCount: unread,
          lastMessageTime: time,
        ),
      );
    }

    items.sort((a, b) {
      if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
      if (a.lastMessageTime == null) return 1;
      if (b.lastMessageTime == null) return -1;
      return b.lastMessageTime!.compareTo(a.lastMessageTime!);
    });

    emit(
      ChatCubitState(
        isLoading: false,
        currentUser: state.currentUser,
        chatItems: items,
      ),
    );
  }

  Future<void> _cancelSubscriptions() async {
    await _usersSubscription?.cancel();
    await _roomsSubscription?.cancel();
    _usersSubscription = null;
    _roomsSubscription = null;
  }

  void clearDataOnLogout() {
    _cancelSubscriptions();
    _allUsers.clear();
    _userRooms.clear();
    emit(ChatCubitState(isLoading: true, currentUser: null, chatItems: []));
  }

  @override
  Future<void> close() {
    _cancelSubscriptions();
    return super.close();
  }
}
