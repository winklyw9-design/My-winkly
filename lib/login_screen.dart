import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_shell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _enter(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.auto_stories_outlined, color: AppColors.accent, size: 36),
              ),
              const SizedBox(height: 20),
              Text('Welcome to', style: AppTheme.muted(size: 14)),
              Text('Winkly', style: AppTheme.heading(size: 30)),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _enter(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.phone_outlined, size: 18),
                label: const Text('Continue with Phone'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => _enter(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.text,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.mail_outline, size: 18),
                label: const Text('Continue with Email'),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    style: AppTheme.muted(),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
