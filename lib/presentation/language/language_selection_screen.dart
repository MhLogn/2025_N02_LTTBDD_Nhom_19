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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              Text(
                l10n?.chooseLanguage ?? "Choose Language",
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 40),

              _languageTile(
                context,
                languageCode: 'en',
                title: 'English',
              ),

              const SizedBox(height: 16),

              _languageTile(
                context,
                languageCode: 'vi',
                title: 'Tiếng Việt',
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
                  child: Text(
                    l10n?.continueText ?? "Continue",
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageTile(
      BuildContext context, {
        required String languageCode,
        required String title,
      }) {
    final currentLocale =
        context.watch<LocaleCubit>().state;

    final isSelected =
        currentLocale.languageCode == languageCode;

    return GestureDetector(
      onTap: () {
        context
            .read<LocaleCubit>()
            .changeLanguage(languageCode);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title)),
            if (isSelected)
              Icon(
                Icons.check,
                color:
                Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}