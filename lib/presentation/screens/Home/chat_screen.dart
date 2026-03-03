import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/core/di/injection.dart';
import 'package:my_project/domain/entities/user_entity.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';
import 'package:my_project/l10n/app_localizations.dart';
import 'package:my_project/presentation/Chat/chatList_cubit.dart';
import 'package:my_project/presentation/Chat/chatRoom_cubit.dart';
import 'package:my_project/presentation/screens/Home/chatRoom_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  UserEntity? currentUser;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final authRepo = sl<AuthRepository>();
    currentUser = await authRepo.getCurrentUser();

    if (mounted) {
      context.read<ChatCubit>().loadUsers();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Chat Box",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocBuilder<ChatCubit, List<UserEntity>>(
        builder: (context, users) {
          if (users.isEmpty || currentUser == null) {
            return Center(
              child: Text(
                l10n.noUsersFound,
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }

          final me = users.firstWhere((u) => u.id == currentUser!.id);

          final otherUsers = users
              .where((u) => u.id != currentUser!.id)
              .toList();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _buildSectionTitle("Bạn"),
              _buildUserTile(me, isMe: true),

              if (otherUsers.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSectionTitle("Người dùng chung ứng dụng"),
                ...otherUsers.map((user) => _buildUserTile(user)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildUserTile(UserEntity user, {bool isMe = false}) {
    final isOnline = user.isOnline;

    if (isMe) {
      return _buildUserTileContent(user, isOnline, 0, isMe: true);
    }

    final sortedIds = [currentUser!.id, user.id]..sort();
    final roomId = "${sortedIds[0]}_${sortedIds[1]}";

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(roomId)
          .snapshots(),
      builder: (context, snapshot) {
        int unread = 0;

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final unreadMap = data['unreadCounts'] as Map<String, dynamic>?;

          if (unreadMap != null) {
            unread = unreadMap[currentUser!.id] ?? 0;
          }
        }

        return _buildUserTileContent(user, isOnline, unread);
      },
    );
  }

  Widget _buildUserTileContent(
    UserEntity user,
    bool isOnline,
    int unread, {
    bool isMe = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: isMe
          ? null
          : () async {
              final result = await context.read<ChatRoomCubit>().createRoom(
                user.id,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatRoomScreen(
                    roomId: result.roomId,
                    currentUserId: currentUser!.id,
                  ),
                ),
              );
            },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isMe ? Colors.blue : Colors.blue.shade100,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? Text(
                          user.fullName.isNotEmpty
                              ? user.fullName[0].toUpperCase()
                              : "?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        )
                      : null,
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isMe ? Colors.blue : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _buildStatus(user),
                    style: TextStyle(
                      fontSize: 13,
                      color: isOnline ? Colors.green : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            if (unread > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  unread > 99 ? "99+" : unread.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _buildStatus(UserEntity user) {
    if (user.isOnline) return "Online";
    if (user.lastSeen == null) return "Offline";

    final diff = DateTime.now().difference(user.lastSeen!);

    if (diff.inSeconds < 60) {
      return "Vừa offline";
    } else if (diff.inMinutes < 60) {
      return "Offline ${diff.inMinutes} phút trước";
    } else if (diff.inHours < 24) {
      return "Offline ${diff.inHours} giờ trước";
    } else {
      return "Offline ${diff.inDays} ngày trước";
    }
  }
}
