import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/l10n/app_localizations.dart';
import 'package:my_project/presentation/language/locale_cubit.dart';
import 'package:my_project/presentation/screens/Onboarding/onboarding_screen1.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.language_rounded,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                l10n?.chooseLanguage ?? "Choose Language",
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n?.languageTitle ??
                    "Please select your preferred language to continue",
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              _buildLanguageTile(
                context,
                languageCode: 'en',
                title: 'English',
                emoji: '🇺🇸',
              ),
              const SizedBox(height: 16),
              _buildLanguageTile(
                context,
                languageCode: 'vi',
                title: 'Tiếng Việt',
                emoji: '🇻🇳',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OnboardingScreen1(),
                      ),
                    );
                  },
                  child: Text(l10n?.continueText ?? "Continue"),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required String languageCode,
    required String title,
    required String emoji,
  }) {
    final currentLocale = context.watch<LocaleCubit>().state;
    final isSelected = currentLocale.languageCode == languageCode;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.read<LocaleCubit>().changeLanguage(languageCode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.08)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.black87,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: isSelected
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: theme.colorScheme.primary,
                      size: 28,
                      key: const ValueKey('checked'),
                    )
                  : Icon(
                      Icons.circle_outlined,
                      color: Colors.grey.shade300,
                      size: 28,
                      key: const ValueKey('unchecked'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
