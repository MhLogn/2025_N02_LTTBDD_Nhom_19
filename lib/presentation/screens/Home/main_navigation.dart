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

  final List<Widget> _screens = const [
    ChatListScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
        backgroundColor: theme.scaffoldBackgroundColor,
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Padding(
                    padding: EdgeInsets.only(bottom: 6.0),
                    child: Icon(Icons.chat_bubble_outline_rounded),
                  ),
                  activeIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 6.0),
                    child: Icon(Icons.chat_bubble_rounded),
                  ),
                  label: l10n.home,
                ),
                BottomNavigationBarItem(
                  icon: const Padding(
                    padding: EdgeInsets.only(bottom: 6.0),
                    child: Icon(Icons.person_outline_rounded),
                  ),
                  activeIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 6.0),
                    child: Icon(Icons.person_rounded),
                  ),
                  label: l10n.profile,
                ),
                BottomNavigationBarItem(
                  icon: const Padding(
                    padding: EdgeInsets.only(bottom: 6.0),
                    child: Icon(Icons.settings_outlined),
                  ),
                  activeIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 6.0),
                    child: Icon(Icons.settings_rounded),
                  ),
                  label: l10n.settings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
