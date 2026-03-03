import 'package:flutter/material.dart';

class ChatRoomScreen extends StatelessWidget {
  final String roomId;

  const ChatRoomScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Room")),
      body: Center(
        child: Text("Room ID: $roomId"),
      ),
    );
  }
}