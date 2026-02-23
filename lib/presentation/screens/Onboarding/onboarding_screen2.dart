import 'package:flutter/material.dart';
import 'package:my_project/presentation/screens/Auth/auth_screen.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/onboarding2.png",
                height: 220,
              ),
              const SizedBox(height: 50),
              Text(
                "Simple & Secure",
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Your conversations are private and protected with modern security",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AuthScreen(),
                      ),
                    );
                  },
                  child: const Text("Get Started"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}