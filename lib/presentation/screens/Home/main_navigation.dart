import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/l10n/app_localizations.dart';
import 'package:my_project/presentation/auth/cubit/auth_cubit.dart';
import 'package:my_project/presentation/auth/cubit/auth_state.dart';
import 'package:my_project/presentation/screens/Auth/login_screen.dart';
import 'package:my_project/presentation/screens/Home/chat_screen.dart';
import 'package:my_project/presentation/screens/Home/profile_screen.dart';
import 'package:my_project/presentation/screens/Home/setting_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ChatListScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
          );
        }
      },
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: l10n.home),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: l10n.profile,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: l10n.settings,
            ),
          ],
        ),
      ),
    );
  }
}
