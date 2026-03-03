import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/data/datasources/chat_firestore_datasources.dart';
import 'package:my_project/core/di/injection.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';
import 'package:my_project/l10n/app_localizations.dart';
import 'package:my_project/presentation/Chat/chatRoom_cubit.dart';
import 'package:my_project/presentation/Chat/chatList_cubit.dart';
import 'package:my_project/presentation/screens/Home/chatRoom_screen.dart';
import '../../../domain/entities/user_entity.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Chat Box",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<ChatCubit, List<UserEntity>>(
        builder: (context, users) {
          if (users.isEmpty) {
            return Center(
              child: Text(
                l10n.noUsersFound,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: users.length,
            separatorBuilder: (_, __) =>
                Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child: Divider(color: Colors.grey.shade300, height: 1),
                ),
            itemBuilder: (context, index) {
              final user = users[index];
              final isOnline = (user as dynamic).isOnline == true;

              return InkWell(
                onTap: () async {
                  final authRepo = sl<AuthRepository>();
                  final currentUser = await authRepo.getCurrentUser();

                  if (currentUser == null) return;

                  final result = await context
                      .read<ChatRoomCubit>()
                      .createRoom(
                      currentUser.id,
                      user.id
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatRoomScreen(
                            roomId: result.roomId,
                          ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.blue.shade100,
                              backgroundImage: user.photoUrl != null
                                  ? NetworkImage(user.photoUrl!)
                                  : null,
                              child: user.photoUrl == null
                                  ? Text(
                                user.fullName.isNotEmpty
                                    ? user.fullName[0].toUpperCase()
                                    : "?",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                                  : null,
                            ),
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
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isOnline ? l10n.online : "@${user.username}",
                              style: TextStyle(
                                fontSize: 13,
                                color: isOnline
                                    ? Colors.green
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        l10n.minutesAgo(2),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
