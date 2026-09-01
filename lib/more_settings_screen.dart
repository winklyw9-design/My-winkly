import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Settings > More. Covers the remaining "Settings — Extended" spec
/// items: Language, Accessibility, Notifications is already in Account,
/// Help & feedback, About/version.
class MoreSettingsScreen extends StatefulWidget {
  const MoreSettingsScreen({super.key});

  @override
  State<MoreSettingsScreen> createState() => _MoreSettingsScreenState();
}

class _MoreSettingsScreenState extends State<MoreSettingsScreen> {
  String _language = 'English';
  double _fontScale = 1.0;
  bool _highContrast = false;

  void _pickLanguage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'தமிழ்'].map((lang) => ListTile(
                title: Text(lang, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: _language == lang ? Icon(Icons.check, color: AppColors.accent) : null,
                onTap: () {
                  setState(() => _language = lang);
                  Navigator.of(ctx).pop();
                },
              )).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('More settings', style: AppTheme.heading(size: 18))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Language', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('App language', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(_language == 'English' ? 'தமிழ் / English' : 'English / தமிழ்', style: AppTheme.muted()),
              trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
              onTap: _pickLanguage,
            ),
          ),
          const SizedBox(height: 20),
          Text('Accessibility', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Font size', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Slider(
                    activeColor: AppColors.accent,
                    value: _fontScale,
                    min: 0.85,
                    max: 1.3,
                    divisions: 3,
                    label: _fontScale <= 0.85 ? 'Small' : (_fontScale >= 1.3 ? 'Large' : 'Default'),
                    onChanged: (v) => setState(() => _fontScale = v),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                SwitchListTile(
                  activeThumbColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('High contrast', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Increase text and border contrast', style: AppTheme.muted()),
                  value: _highContrast,
                  onChanged: (v) => setState(() => _highContrast = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Support', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Help & feedback', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening help center…')),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('About / version', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Winkly 1.0.0', style: AppTheme.muted()),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'Winkly',
                    applicationVersion: '1.0.0',
                    applicationIcon: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.auto_stories_outlined, color: AppColors.accent),
                    ),
                    children: [
                      const SizedBox(height: 8),
                      Text('Chat. Save. Share. Remember.', style: AppTheme.muted()),
                    ],
                  ),
                ),
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
