import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/entities/user_entity.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: Text(l10n.appName)),
      body: BlocBuilder<ChatCubit, ChatCubitState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.currentUser == null) {
            return Center(
              child: Text(
                l10n.noUsersFound,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            );
          }

          final me = state.currentUser!;
          final chatItems = state.chatItems;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              _buildSectionTitle(l10n.isYou, theme),
              _buildUserTile(
                user: me,
                theme: theme,
                currentUserId: me.id,
                isMe: true,
              ),
              if (chatItems.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildSectionTitle(l10n.appUsers, theme),
                ...chatItems.map(
                  (item) => _buildUserTile(
                    user: item.user,
                    theme: theme,
                    currentUserId: me.id,
                    unread: item.unreadCount,
                  ),
                ),
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
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.onSurface.withOpacity(0.4),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildUserTile({
    required UserEntity user,
    required ThemeData theme,
    required String currentUserId,
    bool isMe = false,
    int unread = 0,
  }) {
    final isOnline = user.isOnline;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isMe
              ? theme.colorScheme.primary.withOpacity(0.3)
              : theme.colorScheme.onSurface.withOpacity(0.05),
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
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoomScreen(
                        roomId: result.roomId,
                        currentUserId: currentUserId,
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
                            : theme.colorScheme.secondary,
                        image:
                            user.photoUrl != null && user.photoUrl!.isNotEmpty
                            ? DecorationImage(
                                image: MemoryImage(
                                  base64Decode(user.photoUrl!),
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: user.photoUrl == null || user.photoUrl!.isEmpty
                          ? Text(
                              user.fullName.isNotEmpty
                                  ? user.fullName[0].toUpperCase()
                                  : "?",
                              style: theme.textTheme.titleLarge?.copyWith(
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
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.scaffoldBackgroundColor,
                              width: 2.5,
                            ),
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
                          color: isMe
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.3,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _buildStatus(user, context),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isOnline
                                    ? (isMe
                                          ? const Color(0xFF10B981)
                                          : theme.colorScheme.onSurface
                                                .withOpacity(0.5))
                                    : theme.colorScheme.onSurface.withOpacity(
                                        0.5,
                                      ),
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
                          color: theme.colorScheme.error.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      unread > 99 ? "99+" : unread.toString(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
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

  String _buildStatus(UserEntity user, BuildContext context) {
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
