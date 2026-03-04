import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/core/di/injection.dart';
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
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully"),
            ),
          );
        }

        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.user != null) {
          _fullNameController.text = state.user!.fullName;
          _usernameController.text = state.user!.username;
          _emailController.text = state.user!.email;
          photoUrl = state.user!.photoUrl;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              "Profile",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final picked =
                        await picker.pickImage(source: ImageSource.gallery);

                        if (picked == null) return;

                        final bytes = await File(picked.path).readAsBytes();
                        final base64Image = base64Encode(bytes);

                        setState(() {
                          photoUrl = base64Image;
                        });
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.shade100,
                        backgroundImage: photoUrl != null
                            ? MemoryImage(base64Decode(photoUrl!))
                            : null,
                        child: photoUrl == null
                            ? const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _buildTextField(
                      controller: _fullNameController,
                      label: "Full Name",
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _usernameController,
                      label: "Username",
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088CC),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: state.isLoading
                            ? null
                            : () {
                          context
                              .read<ProfileCubit>()
                              .updateProfile(
                            fullName:
                            _fullNameController.text,
                            username:
                            _usernameController.text,
                            email:
                            _emailController.text,
                            photoUrl: photoUrl,
                          );
                        },
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (state.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(),
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
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
      ),
    );
  }
}