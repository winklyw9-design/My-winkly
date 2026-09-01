import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'two_factor_screen.dart';
import 'linked_devices_screen.dart';

/// Settings > Account. Covers phone number, security (2FA link lives
/// here per spec), and notification toggles.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _messageNotifs = true;
  bool _scrapbookNotifs = true;
  bool _soundEnabled = true;

  void _changeNumberFlow() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Change number', style: AppTheme.heading(size: 16)),
        content: Text(
          'We\'ll send an OTP to your new number to verify it before switching.',
          style: AppTheme.muted(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Continue', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('Account', style: AppTheme.heading(size: 18))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Phone number', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('+91 98765 43210', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('Verified', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
              trailing: TextButton(
                onPressed: _changeNumberFlow,
                child: Text('Change', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Security', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Two-factor authentication', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('OTP-based login · Off', style: AppTheme.muted()),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TwoFactorScreen()),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Linked devices', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('1 device signed in', style: AppTheme.muted()),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LinkedDevicesScreen()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Notifications', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: Column(
              children: [
                SwitchListTile(
                  activeThumbColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Message notifications', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('New chat messages', style: AppTheme.muted()),
                  value: _messageNotifs,
                  onChanged: (v) => setState(() => _messageNotifs = v),
                ),
                const Divider(height: 1, color: AppColors.border),
                SwitchListTile(
                  activeThumbColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Scrapbook likes', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('When friends react to your memories', style: AppTheme.muted()),
                  value: _scrapbookNotifs,
                  onChanged: (v) => setState(() => _scrapbookNotifs = v),
                ),
                const Divider(height: 1, color: AppColors.border),
                SwitchListTile(
                  activeThumbColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Sound', style: TextStyle(fontWeight: FontWeight.w600)),
                  value: _soundEnabled,
                  onChanged: (v) => setState(() => _soundEnabled = v),
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
