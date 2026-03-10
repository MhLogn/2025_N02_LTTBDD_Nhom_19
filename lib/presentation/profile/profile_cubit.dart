import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/repositories/auth_repository.dart';
import 'profile_state.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository authRepository;

  ProfileCubit(this.authRepository) : super(const ProfileState());

  Future<void> loadUser() async {
    try {
      emit(state.copyWith(isLoading: true, isSuccess: false, error: null));

      final user = await authRepository.getCurrentUser();

      emit(state.copyWith(isLoading: false, user: user));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String username,
    required String email,
    String? photoUrl,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, isSuccess: false, error: null));

      await authRepository.updateProfile(
        fullName: fullName,
        username: username,
        email: email,
        photoUrl: photoUrl,
      );

      final updatedUser = await authRepository.getCurrentUser();

      emit(
        state.copyWith(isLoading: false, isSuccess: true, user: updatedUser),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> pickAvatarBase64() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final bytes = await File(picked.path).readAsBytes();
    final base64Image = base64Encode(bytes);

    final currentUser = await authRepository.getCurrentUser();
    if (currentUser == null) return;

    await authRepository.updateProfile(
      fullName: currentUser.fullName,
      username: currentUser.username,
      email: currentUser.email,
      photoUrl: base64Image,
    );

    final updated = await authRepository.getCurrentUser();

    emit(state.copyWith(user: updated));
  }

  void clearDataOnLogout() {
    emit(const ProfileState());
  }
}
