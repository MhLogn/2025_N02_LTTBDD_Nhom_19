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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text("Chat Box")),
      body: BlocBuilder<ChatCubit, List<UserEntity>>(
        builder: (context, users) {
          if (users.isEmpty || currentUser == null) {
            return Center(
              child: Text(
                l10n.noUsersFound,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
            );
          }

          final me = users.firstWhere((u) => u.id == currentUser!.id);
          final otherUsers =
              users.where((u) => u.id != currentUser!.id).toList()
                ..sort((a, b) {
                  final aIds = [currentUser!.id, a.id]..sort();
                  final bIds = [currentUser!.id, b.id]..sort();

                  final aRoom = "${aIds[0]}_${aIds[1]}";
                  final bRoom = "${bIds[0]}_${bIds[1]}";

                  return bRoom.compareTo(aRoom);
                });

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              _buildSectionTitle(l10n.isYou, theme),
              _buildUserTile(me, theme, isMe: true),
              if (otherUsers.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildSectionTitle(l10n.appUsers, theme),
                ...otherUsers.map((user) => _buildUserTile(user, theme)),
              ],
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildUserTile(UserEntity user, ThemeData theme, {bool isMe = false}) {
    final isOnline = user.isOnline;

    if (isMe) {
      return _buildUserTileContent(user, isOnline, 0, theme, isMe: true);
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
        DateTime? lastMessageTime;

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;

          final unreadMap = data['unreadCounts'] as Map<String, dynamic>?;
          if (unreadMap != null) {
            unread = unreadMap[currentUser!.id] ?? 0;
          }

          if (data['lastMessageTime'] != null) {
            lastMessageTime = (data['lastMessageTime'] as Timestamp).toDate();
          }
        }

        return _buildUserTileContent(
          user,
          isOnline,
          unread,
          theme,
          lastMessageTime: lastMessageTime,
        );
      },
    );
  }

  Widget _buildUserTileContent(
    UserEntity user,
    bool isOnline,
    int unread,
    ThemeData theme, {
    bool isMe = false,
    DateTime? lastMessageTime,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isMe
              ? theme.colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isMe
                            ? theme.colorScheme.primary
                            : theme.colorScheme.primary.withOpacity(0.1),
                        image: user.photoUrl != null
                            ? DecorationImage(
                                image: NetworkImage(user.photoUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: user.photoUrl == null
                          ? Text(
                              user.fullName.isNotEmpty
                                  ? user.fullName[0].toUpperCase()
                                  : "?",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isMe
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.primary,
                              ),
                            )
                          : null,
                    ),
                    if (isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
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
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isMe
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withOpacity(0.9),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Text(
                            "@${user.username}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.outlineVariant,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              _buildStatus(user),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isOnline
                                    ? (isMe
                                          ? Colors.green.shade600
                                          : Colors.grey.shade500)
                                    : theme.colorScheme.onSurfaceVariant
                                          .withOpacity(0.7),
                                fontWeight: isOnline
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (unread > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.error.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      unread > 99 ? "99+" : unread.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildStatus(UserEntity user) {
    final l10n = AppLocalizations.of(context)!;

    if (user.isOnline) return l10n.online;
    if (user.lastSeen == null) return l10n.offline;

    final diff = DateTime.now().difference(user.lastSeen!);

    if (diff.inSeconds < 60) {
      return l10n.justOffline;
    } else if (diff.inMinutes < 60) {
      return l10n.offlineMinutes(diff.inMinutes);
    } else if (diff.inHours < 24) {
      return l10n.offlineHours(diff.inHours);
    } else {
      return l10n.offlineDays(diff.inDays);
    }
  }
}
