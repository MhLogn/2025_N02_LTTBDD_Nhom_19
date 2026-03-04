import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/l10n/app_localizations.dart';
import 'package:my_project/presentation/auth/cubit/auth_cubit.dart';
import 'package:my_project/presentation/auth/cubit/auth_state.dart';
import 'package:my_project/presentation/auth/cubit/auth_error_type.dart';
import 'package:my_project/presentation/screens/Auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final fullName = _fullNameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (fullName.isEmpty) {
      _showError(context, l10n.fieldRequired);
      return;
    }

    if (username.isEmpty) {
      _showError(context, l10n.fieldRequired);
      return;
    }

    if (email.isEmpty) {
      _showError(context, l10n.enterEmailRequired);
      return;
    }

    if (!_isValidEmail(email)) {
      _showError(context, l10n.auth_invalidEmail);
      return;
    }

    if (password.isEmpty) {
      _showError(context, l10n.passwordRequired);
      return;
    }

    if (password.length < 6) {
      _showError(context, l10n.passwordMinLength);
      return;
    }

    if (password != confirmPassword) {
      _showError(context, l10n.passwordNotMatch);
      return;
    }

    context.read<AuthCubit>().register(
      fullName: fullName,
      username: username,
      email: email,
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }

  String _mapAuthError(BuildContext context, AuthErrorType type) {
    final l10n = AppLocalizations.of(context)!;

    switch (type) {
      case AuthErrorType.invalidEmail:
        return l10n.auth_invalidEmail;
      case AuthErrorType.emailAlreadyInUse:
        return l10n.auth_emailAlreadyInUse;
      case AuthErrorType.weakPassword:
        return l10n.passwordMinLength;
      case AuthErrorType.tooManyRequests:
        return l10n.auth_tooManyRequests;
      case AuthErrorType.networkError:
        return l10n.auth_networkError;
      case AuthErrorType.authenticationFailed:
        return l10n.auth_authenticationFailed;
      case AuthErrorType.unknown:
        return l10n.auth_unknown;
      default:
        return l10n.auth_unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterSuccess) {
            _showError(context, l10n.registerSuccess);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }

          if (state is AuthError) {
            _showError(context, _mapAuthError(context, state.type));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      l10n.createAccount,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.registerSubtitle,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 48),
                    Text(l10n.fullName, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _fullNameController,
                      decoration: InputDecoration(hintText: l10n.enterFullName),
                    ),
                    const SizedBox(height: 20),
                    Text(l10n.username, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: l10n.chooseUsername,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(l10n.email, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: l10n.enterEmail),
                    ),
                    const SizedBox(height: 20),
                    Text(l10n.password, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: l10n.createPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey.shade500,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.confirmPassword,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: l10n.reEnterPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey.shade500,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _register(context),
                        child: Text(l10n.register),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "${l10n.alreadyHaveAccount} ",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                            children: [
                              TextSpan(
                                text: l10n.login,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
