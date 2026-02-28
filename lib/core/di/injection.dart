import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/domain/usecases/forgot_password_usecase.dart';

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

  /// Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authDataSource: sl(), userDataSource: sl()),
  );

  /// UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));

  /// AuthCubit
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      forgotPasswordUseCase: sl(),
    ),
  );
}
