import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_project/domain/entities/message_entity.dart';
import 'package:my_project/domain/entities/user_entity.dart';
import 'package:my_project/l10n/app_localizations.dart';
import 'package:my_project/presentation/Chat/message_cubit.dart';
import 'package:my_project/presentation/Chat/chatRoom_cubit.dart';
import 'package:my_project/presentation/screens/Home/message_screen.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  final String currentUserId;
  final UserEntity otherUser;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.currentUserId,
    required this.otherUser,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  MessageEntity? _replyingMessage;

  @override
  void initState() {
    super.initState();
    context.read<MessageCubit>().listenMessages(widget.roomId);
    context.read<ChatRoomCubit>().resetUnread(
      widget.roomId,
      widget.currentUserId,
    );
    context.read<ChatRoomCubit>().markSeen(widget.roomId, widget.currentUserId);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await context.read<MessageCubit>().sendMessage(
      widget.roomId,
      text,
      replyTo: _replyingMessage?.content,
    );
    _controller.clear();

    if (_replyingMessage != null) {
      setState(() {
        _replyingMessage = null;
      });
    }

    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final otherUser = widget.otherUser;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.secondary,
                image:
                    otherUser.photoUrl != null && otherUser.photoUrl!.isNotEmpty
                    ? DecorationImage(
                        image: MemoryImage(base64Decode(otherUser.photoUrl!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              alignment: Alignment.center,
              child: otherUser.photoUrl == null || otherUser.photoUrl!.isEmpty
                  ? Text(
                      otherUser.fullName.isNotEmpty
                          ? otherUser.fullName[0].toUpperCase()
                          : "?",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUser.fullName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _buildStatus(otherUser, context),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: otherUser.isOnline
                          ? const Color(0xFF10B981)
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: BlocListener<MessageCubit, List<MessageEntity>>(
        listener: (context, messages) {
          if (messages.isNotEmpty) {
            context.read<ChatRoomCubit>().markSeen(
              widget.roomId,
              widget.currentUserId,
            );
            context.read<ChatRoomCubit>().resetUnread(
              widget.roomId,
              widget.currentUserId,
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageCubit, List<MessageEntity>>(
                builder: (context, messages) {
                  final List<dynamic> items = [];
                  for (int i = 0; i < messages.length; i++) {
                    final currentMsg = messages[i];

                    if (i == 0 ||
                        !_isSameDay(
                          messages[i - 1].createdAt,
                          currentMsg.createdAt,
                        )) {
                      items.add(currentMsg.createdAt);
                    }
                    items.add(currentMsg);
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      if (item is DateTime) {
                        return _buildDateHeader(item, theme);
                      }

                      final message = item as MessageEntity;
                      final isMe = message.senderId == widget.currentUserId;

                      return GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! > 100) {
                            setState(() {
                              _replyingMessage = message;
                            });
                          }
                        },
                        child: MessageBubble(message: message, isMe: isMe),
                      );
                    },
                  );
                },
              ),
            ),
            _buildInputBar(theme, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(DateTime date, ThemeData theme) {
    final now = DateTime.now();
    final l10n = AppLocalizations.of(context)!;
    String label;

    if (_isSameDay(date, now)) {
      label = l10n.today;
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      label = l10n.yesterday;
    } else {
      label = DateFormat('dd/MM/yyyy').format(date);
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar(ThemeData theme, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_replyingMessage != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: theme.colorScheme.primary.withOpacity(0.05),
                child: Row(
                  children: [
                    Icon(
                      Icons.reply,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _replyingMessage!.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => setState(() => _replyingMessage = null),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.image_rounded,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: l10n.message,
                        fillColor: const Color(0xFFF5F6FA),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: theme.colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
