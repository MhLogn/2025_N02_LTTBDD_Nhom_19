import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/data/models/chat_model.dart';

class ChatRoomFirestoreDataSource {
  final FirebaseFirestore firestore;

  ChatRoomFirestoreDataSource(this.firestore);

  Future<String> createOrGetRoom(
      String currentUserId,
      String otherUserId,
      ) async {

    final query = await firestore
        .collection('chat_rooms')
        .where('members', arrayContains: currentUserId)
        .get();

    for (var doc in query.docs) {
      final members = List<String>.from(doc['members']);
      if (members.contains(otherUserId)) {
        return doc.id;
      }
    }

    final newRoom = await firestore.collection('chat_rooms').add({
      'members': [currentUserId, otherUserId],
      'lastMessage': '',
      'lastMessageTime': Timestamp.now(),
    });

    return newRoom.id;
  }
}