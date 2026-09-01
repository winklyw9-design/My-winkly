import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/settings_row.dart';
import 'account_screen.dart';
import 'app_lock_screen.dart';
import 'appearance_screen.dart';
import 'export_data_screen.dart';
import 'invite_friend_screen.dart';
import 'more_settings_screen.dart';
import 'privacy_screen.dart';
import 'storage_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ListView(
        children: [
          const SizedBox(height: 8),
          SettingsRow(
            title: '① Account',
            subtitle: 'security, notifications, change number',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AccountScreen()),
            ),
          ),
          SettingsRow(
            title: '② Privacy',
            subtitle: 'blocked accounts',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PrivacyScreen()),
            ),
          ),
          SettingsRow(
            title: '③ Storage and data',
            subtitle: 'backup · manage storage',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const StorageScreen()),
            ),
          ),
          SettingsRow(
            title: '④ Invite a friend',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const InviteFriendScreen()),
            ),
          ),
          SettingsRow(
            title: '⑤ App lock',
            subtitle: 'PIN / fingerprint',
            isNew: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AppLockScreen()),
            ),
          ),
          SettingsRow(
            title: '⑥ Appearance',
            subtitle: 'light / dark / system',
            isNew: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AppearanceScreen()),
            ),
          ),
          SettingsRow(
            title: '⑦ Export my data',
            isNew: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ExportDataScreen()),
            ),
          ),
          SettingsRow(
            title: '⑧ More settings',
            subtitle: 'language, accessibility, help, about',
            isNew: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MoreSettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
