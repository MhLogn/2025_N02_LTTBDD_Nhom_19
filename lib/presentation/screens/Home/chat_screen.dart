import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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

  String _formatTime(DateTime? time, AppLocalizations l10n) {
    if (time == null) return '';
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0 && now.day == time.day) {
      return DateFormat('HH:mm').format(time);
    } else if (difference.inDays == 1 ||
        (difference.inDays == 0 && now.day != time.day)) {
      return l10n.yesterday;
    } else {
      return DateFormat('dd/MM').format(time);
    }
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.appName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<ChatCubit, ChatCubitState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.currentUser == null ||
              state.chatItems.isEmpty && state.currentUser == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noUsersFound,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          final me = state.currentUser!;
          final chatItems = state.chatItems;

          return ListView(
            padding: EdgeInsets.only(
              top: 8,
              bottom: MediaQuery.of(context).padding.bottom + 24,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildSectionTitle(l10n.isYou, theme),
              ),
              _buildUserTile(
                user: me,
                theme: theme,
                currentUserId: me.id,
                isMe: true,
                l10n: l10n,
              ),
              if (chatItems.isNotEmpty) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildSectionTitle(l10n.appUsers, theme),
                ),
                ...chatItems.map(
                  (item) => _buildUserTile(
                    user: item.user,
                    theme: theme,
                    currentUserId: me.id,
                    unread: item.unreadCount,
                    lastMessage: item.lastMessage,
                    lastMessageTime: item.lastMessageTime,
                    lastSenderId: item.lastSenderId,
                    l10n: l10n,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
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
    required AppLocalizations l10n,
    bool isMe = false,
    int unread = 0,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastSenderId,
  }) {
    final isOnline = user.isOnline;
    final hasUnread = unread > 0;
    final displayTime = _formatTime(lastMessageTime, l10n);

    String prefix = "";
    if (lastSenderId != null && lastSenderId == currentUserId) {
      prefix = "${l10n.isYou}: ";
    }

    Widget subtitleWidget;

    if (isMe) {
      subtitleWidget = Text(
        "@${user.username}",
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else if (lastMessage != null && lastMessage.isNotEmpty) {
      subtitleWidget = RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            if (prefix.isNotEmpty)
              TextSpan(
                text: prefix,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            TextSpan(
              text: lastMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: hasUnread
                    ? theme.colorScheme.onSurface.withOpacity(0.85)
                    : theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    } else {
      subtitleWidget = Row(
        children: [
          Text(
            "@${user.username}",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _buildStatus(user, context),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isOnline
                    ? const Color(0xFF10B981)
                    : theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: isOnline ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Material(
      color: hasUnread
          ? theme.colorScheme.primary.withOpacity(0.05)
          : Colors.transparent,
      child: InkWell(
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
                      otherUser: user,
                    ),
                  ),
                );
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isMe
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                      image: user.photoUrl != null && user.photoUrl!.isNotEmpty
                          ? DecorationImage(
                              image: MemoryImage(base64Decode(user.photoUrl!)),
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
                        width: 14,
                        height: 14,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            user.fullName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: hasUnread
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (displayTime.isNotEmpty && !isMe)
                          Text(
                            displayTime,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: hasUnread
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: hasUnread
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withOpacity(
                                      0.5,
                                    ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(child: subtitleWidget),
                        if (hasUnread)
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(minWidth: 20),
                            alignment: Alignment.center,
                            child: Text(
                              unread > 99 ? "99+" : unread.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
