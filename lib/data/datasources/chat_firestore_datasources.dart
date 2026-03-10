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
        'unreadCounts': {sortedIds[0]: 0, sortedIds[1]: 0},
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
    String? replyTo,
  }) async {
    final roomRef = firestore.collection('chat_rooms').doc(roomId);

    final roomSnapshot = await roomRef.get();

    final members = List<String>.from(roomSnapshot['members']);

    final receiverId = members.firstWhere((id) => id != senderId);

    final messageRef = roomRef.collection('messages').doc();

    await firestore.runTransaction((transaction) async {
      transaction.set(messageRef, {
        'senderId': senderId,
        'content': content,
        'createdAt': Timestamp.now(),
        'isSeen': false,
        'seenAt': null,
        'replyTo': replyTo,
      });

      transaction.update(roomRef, {
        'lastMessage': content,
        'lastMessageTime': Timestamp.now(),
        'lastSenderId': senderId,
        'unreadCounts.$receiverId': FieldValue.increment(1),
      });
    });
  }

  Future<void> resetUnreadCount(String roomId, String currentUserId) async {
    await firestore.collection('chat_rooms').doc(roomId).update({
      'unreadCounts.$currentUserId': 0,
    });

    await markMessagesSeen(roomId, currentUserId);
  }

  Stream<List<ChatRoomModel>> getUserChatRooms(String userId) {
    return firestore
        .collection('chat_rooms')
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ChatRoomModel.fromFirestore(doc.data(), doc.id)).toList();
    });
  }

  Future<void> markMessagesSeen(String roomId, String currentUserId) async {
    final messagesRef = firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages');

    final unreadMessages = await messagesRef
        .where('senderId', isNotEqualTo: currentUserId)
        .where('isSeen', isEqualTo: false)
        .get();

    final batch = firestore.batch();

    for (var doc in unreadMessages.docs) {
      batch.update(doc.reference, {'isSeen': true, 'seenAt': Timestamp.now()});
    }

    await batch.commit();
  }
}
