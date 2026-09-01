import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Settings > Appearance. Lets the user pick light, dark, or system
/// theme. Selection is visual-only for now (app-wide dark mode wiring
/// can be added later); this screen shows the picker and a live preview.
class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

enum _ThemeChoice { light, dark, system }

class _AppearanceScreenState extends State<AppearanceScreen> {
  _ThemeChoice _choice = _ThemeChoice.light;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('Appearance', style: AppTheme.heading(size: 18))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Theme', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: Column(
              children: [
                _themeOption(_ThemeChoice.light, 'Light', 'Bright background, dark text', Icons.light_mode_outlined),
                const Divider(height: 1, color: AppColors.border),
                _themeOption(_ThemeChoice.dark, 'Dark', 'Dark background, easy on the eyes', Icons.dark_mode_outlined),
                const Divider(height: 1, color: AppColors.border),
                _themeOption(_ThemeChoice.system, 'System', 'Match your device settings', Icons.settings_suggest_outlined),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Preview', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _preview(),
        ],
      ),
    );
  }

  Widget _themeOption(_ThemeChoice value, String title, String subtitle, IconData icon) {
    final selected = _choice == value;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => setState(() => _choice = value),
      leading: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.accentSoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.accent),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: AppTheme.muted()),
      trailing: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? AppColors.accent : AppColors.muted,
      ),
    );
  }

  Widget _preview() {
    final isDark = _choice == _ThemeChoice.dark;
    final bg = isDark ? const Color(0xFF1C1A18) : Colors.white;
    final card = isDark ? const Color(0xFF2A2622) : AppColors.bg;
    final text = isDark ? Colors.white : AppColors.text;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Winkly', style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                CircleAvatar(radius: 14, backgroundColor: AppColors.accentSoft,
                    child: const Text('B', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w700))),
                const SizedBox(width: 8),
                Text('Boo — typing…', style: TextStyle(color: text.withValues(alpha: 0.7), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: child,
        ),
      ),
    );
  }
}
