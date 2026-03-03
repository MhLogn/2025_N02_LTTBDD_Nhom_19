import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/data/models/chat_model.dart';
import 'package:my_project/data/models/message_model.dart';

class ChatRoomFirestoreDataSource {
  final FirebaseFirestore firestore;

  ChatRoomFirestoreDataSource(this.firestore);

  Future<String> createOrGetRoom(
    String currentUserId,
    String otherUserId,
  ) async {
    final sortedIds = [currentUserId, otherUserId]..sort();

    final roomId = "${sortedIds[0]}_${sortedIds[1]}";

    final roomRef = firestore.collection('chat_rooms').doc(roomId);

    final doc = await roomRef.get();

    if (!doc.exists) {
      await roomRef.set({
        'members': sortedIds,
        'lastMessage': '',
        'lastMessageTime': Timestamp.now(),
      });
    }

    return roomId;
  }

  Stream<List<MessageModel>> getMessages(String roomId) {
    return firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromSnapshot(doc))
              .toList(),
        );
  }

  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String content,
  }) async {
    final messageRef = firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .doc();

    final message = MessageModel(
      id: messageRef.id,
      senderId: senderId,
      content: content,
      createdAt: DateTime.now(),
    );

    await messageRef.set(message.toMap());

    await firestore.collection('chat_rooms').doc(roomId).update({
      'lastMessage': content,
      'lastMessageTime': Timestamp.now(),
    });
  }
}
