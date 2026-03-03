import 'package:my_project/data/datasources/chat_firestore_datasources.dart';
import 'package:my_project/domain/repositories/chat_repository.dart';

class ChatRoomRepositoryImpl implements ChatRoomRepository {
  final ChatRoomFirestoreDataSource dataSource;

  ChatRoomRepositoryImpl(this.dataSource);

  @override
  Future<String> createOrGetRoom(
      String currentUserId,
      String otherUserId,
      ) {
    return dataSource.createOrGetRoom(
      currentUserId,
      otherUserId,
    );
  }
}