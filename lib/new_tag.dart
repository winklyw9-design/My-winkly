import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The small orange "NEW" pill used throughout the spec to mark
/// v2 features. Reused everywhere so it stays visually consistent.
class NewTag extends StatelessWidget {
  const NewTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'NEW',
        style: TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
