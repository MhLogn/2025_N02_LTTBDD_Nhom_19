import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/core/di/injection.dart';
import 'package:my_project/l10n/app_localizations.dart';
import 'package:my_project/presentation/profile/profile_cubit.dart';
import 'package:my_project/presentation/profile/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  String? photoUrl;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadUser();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.isSuccess != current.isSuccess ||
          previous.error != current.error ||
          previous.user != current.user,
      listener: (context, state) {
        if (state.user != null) {
          if (_fullNameController.text != state.user!.fullName) {
            _fullNameController.text = state.user!.fullName;
          }
          if (_usernameController.text != state.user!.username) {
            _usernameController.text = state.user!.username;
          }
          if (_emailController.text != state.user!.email) {
            _emailController.text = state.user!.email;
          }
          photoUrl = state.user!.photoUrl;
        }

        if (state.isSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(l10n.profileUpdatedSuccessfully),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
        }

        if (state.error != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(l10n.profile, style: theme.textTheme.headlineSmall),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: isLoading
                            ? null
                            : () async {
                                final picker = ImagePicker();
                                final picked = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );

                                if (picked == null) return;

                                final bytes = await File(
                                  picked.path,
                                ).readAsBytes();
                                final base64Image = base64Encode(bytes);

                                setState(() {
                                  photoUrl = base64Image;
                                });
                              },
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.secondary,
                                image: photoUrl != null
                                    ? DecorationImage(
                                        image: MemoryImage(
                                          base64Decode(photoUrl!),
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: photoUrl == null
                                  ? Icon(
                                      Icons.person_rounded,
                                      size: 56,
                                      color: theme.colorScheme.primary,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.scaffoldBackgroundColor,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: 20,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildTextField(
                      controller: _fullNameController,
                      label: l10n.fullName,
                      icon: Icons.person_outline_rounded,
                      theme: theme,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _usernameController,
                      label: l10n.username,
                      icon: Icons.badge_outlined,
                      theme: theme,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _emailController,
                      label: l10n.email,
                      icon: Icons.email_outlined,
                      theme: theme,
                      isEmail: true,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<ProfileCubit>().updateProfile(
                                  fullName: _fullNameController.text,
                                  username: _usernameController.text,
                                  email: _emailController.text,
                                  photoUrl: photoUrl,
                                );
                              },
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(l10n.saveChanges),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: theme.scaffoldBackgroundColor.withOpacity(0.5),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ThemeData theme,
    bool isEmail = false,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: isEmail
              ? TextInputType.emailAddress
              : TextInputType.text,
          decoration: InputDecoration(
            hintText: label,
            prefixIcon: Icon(
              icon,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
  }
}
