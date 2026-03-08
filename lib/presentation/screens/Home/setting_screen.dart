import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/l10n/app_localizations.dart';
import 'package:my_project/presentation/auth/cubit/auth_cubit.dart';
import 'package:my_project/presentation/language/locale_cubit.dart';
import 'package:my_project/presentation/screens/Home/groupInfo_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          l10n.settings,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        children: [
          _buildSettingTile(
            context: context,
            theme: theme,
            icon: Icons.language_rounded,
            iconColor: theme.colorScheme.primary,
            title: l10n.changeLanguage,
            onTap: () {
              _showLanguageDialog(context, localeCubit, l10n, theme);
            },
          ),
          const SizedBox(height: 16),
          _buildSettingTile(
            context: context,
            theme: theme,
            icon: Icons.info_outline_rounded,
            iconColor: Colors.blueAccent,
            title: l10n.groupInfo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GroupInfoScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildSettingTile(
            context: context,
            theme: theme,
            icon: Icons.logout_rounded,
            iconColor: theme.colorScheme.error,
            title: l10n.logout,
            textColor: theme.colorScheme.error,
            hideArrow: true,
            onTap: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String title,
    Color? textColor,
    bool hideArrow = false,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor ?? Colors.black87,
                    ),
                  ),
                ),
                if (!hideArrow)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey.shade300,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(
      BuildContext context,
      LocaleCubit localeCubit,
      AppLocalizations l10n,
      ThemeData theme,
      ) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.selectLanguage,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),
              _buildLanguageOption(
                context: context,
                localeCubit: localeCubit,
                theme: theme,
                languageCode: 'en',
                title: 'English',
                flag: '🇺🇸',
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                context: context,
                localeCubit: localeCubit,
                theme: theme,
                languageCode: 'vi',
                title: 'Tiếng Việt',
                flag: '🇻🇳',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required LocaleCubit localeCubit,
    required ThemeData theme,
    required String languageCode,
    required String title,
    required String flag,
  }) {
    final isSelected = localeCubit.state.languageCode == languageCode;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        localeCubit.changeLanguage(languageCode);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? theme.colorScheme.primary : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}