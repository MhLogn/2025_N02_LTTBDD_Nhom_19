import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/data/datasources/chat_firestore_datasources.dart';
import 'package:my_project/data/repositories/chat_repository_impl.dart';
import 'package:my_project/domain/repositories/chat_repository.dart';
import 'package:my_project/domain/usecases/chatRoom_usecase.dart';
import 'package:my_project/domain/usecases/forgot_password_usecase.dart';
import 'package:my_project/domain/usecases/getUser_usecase.dart';
import 'package:my_project/domain/usecases/logout_usecase.dart';
import 'package:my_project/domain/usecases/user_status_usecase.dart';
import 'package:my_project/presentation/Chat/chatRoom_cubit.dart';
import 'package:my_project/presentation/Chat/chatList_cubit.dart';

import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/datasources/user_firestore_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/auth/cubit/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Firebase instances
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  /// DataSources
  sl.registerLazySingleton(() => FirebaseAuthDataSource(sl()));

  sl.registerLazySingleton(() => UserFirestoreDataSource(sl()));

  sl.registerLazySingleton<ChatRoomFirestoreDataSource>(
    () => ChatRoomFirestoreDataSource(FirebaseFirestore.instance),
  );

  /// Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authDataSource: sl(), userDataSource: sl()),
  );

  sl.registerLazySingleton<ChatRoomRepository>(
    () => ChatRoomRepositoryImpl(sl<ChatRoomFirestoreDataSource>()),
  );

  /// UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));

  sl.registerLazySingleton(() => UpdateUserStatusUseCase(sl()));

  sl.registerLazySingleton(() => GetAllUsersUseCase(sl()));

  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  sl.registerLazySingleton(
    () => CreateOrGetChatRoomUseCase(sl<ChatRoomRepository>(), sl<AuthRepository>()),
  );

  /// AuthCubit
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      forgotPasswordUseCase: sl(),
      updateUserStatusUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  /// ChatListCubit
  sl.registerFactory(() => ChatCubit(sl()));

  /// ChatRoomCubit
  sl.registerFactory(() => ChatRoomCubit(sl()));
}
