import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/usecases/getUser_usecase.dart';
import '../../../domain/entities/user_entity.dart';

class ChatCubit extends Cubit<List<UserEntity>> {
  final GetAllUsersUseCase getAllUsersUseCase;

  ChatCubit(this.getAllUsersUseCase) : super([]);

  void loadUsers() {
    getAllUsersUseCase().listen((users) {
      emit(users);
    });
  }


}