import 'package:my_project/domain/entities/user_entity.dart';

class ProfileState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final UserEntity? user;

  const ProfileState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.user,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    UserEntity? user,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      user: user ?? this.user,
    );
  }
}