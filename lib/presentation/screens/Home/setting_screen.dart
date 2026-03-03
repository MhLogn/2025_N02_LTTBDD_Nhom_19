import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/l10n/app_localizations.dart';
import 'package:my_project/presentation/auth/cubit/auth_cubit.dart';
import 'package:my_project/presentation/language/locale_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.changeLanguage),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(l10n.selectLanguage),
                  actions: [
                    TextButton(
                      onPressed: () {
                        localeCubit.changeLanguage('en');
                        Navigator.pop(context);
                      },
                      child: const Text("English"),
                    ),
                    TextButton(
                      onPressed: () {
                        localeCubit.changeLanguage('vi');
                        Navigator.pop(context);
                      },
                      child: const Text("Tiếng Việt"),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.logout, style: TextStyle(color: Colors.red)),
            onTap: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
    );
  }
}
