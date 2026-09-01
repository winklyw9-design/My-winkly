import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Settings > Privacy. Shows blocked accounts and privacy-related
/// toggles (read receipts, last seen, profile visibility).
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _BlockedUser {
  final String name;
  const _BlockedUser(this.name);
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _readReceipts = true;
  bool _lastSeen = true;
  bool _profileVisible = true;

  final List<_BlockedUser> _blocked = [
    const _BlockedUser('Arun K'),
    const _BlockedUser('Priya S'),
  ];

  void _unblock(_BlockedUser u) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Unblock ${u.name}?', style: AppTheme.heading(size: 16)),
        content: Text(
          '${u.name} will be able to message you and see your profile again.',
          style: AppTheme.muted(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.muted)),
          ),
          TextButton(
            onPressed: () {
              setState(() => _blocked.remove(u));
              Navigator.of(ctx).pop();
            },
            child: Text('Unblock', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('Privacy', style: AppTheme.heading(size: 18))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('General', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: Column(
              children: [
                SwitchListTile(
                  activeThumbColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Read receipts', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Let friends see when you\'ve read their messages', style: AppTheme.muted()),
                  value: _readReceipts,
                  onChanged: (v) => setState(() => _readReceipts = v),
                ),
                const Divider(height: 1, color: AppColors.border),
                SwitchListTile(
                  activeThumbColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Last seen', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Show when you were last online', style: AppTheme.muted()),
                  value: _lastSeen,
                  onChanged: (v) => setState(() => _lastSeen = v),
                ),
                const Divider(height: 1, color: AppColors.border),
                SwitchListTile(
                  activeThumbColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Profile visible to everyone', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Turn off to only allow friends to view your profile', style: AppTheme.muted()),
                  value: _profileVisible,
                  onChanged: (v) => setState(() => _profileVisible = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Blocked accounts', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          if (_blocked.isEmpty)
            _sectionCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('No blocked accounts', style: AppTheme.muted()),
                ),
              ),
            )
          else
            _sectionCard(
              child: Column(
                children: _blocked.asMap().entries.map((entry) {
                  final i = entry.key;
                  final u = entry.value;
                  return Column(
                    children: [
                      if (i > 0) const Divider(height: 1, color: AppColors.border),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.accentSoft,
                          child: Text(u.name[0],
                              style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
                        ),
                        title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        trailing: TextButton(
                          onPressed: () => _unblock(u),
                          child: Text('Unblock', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            'Blocked accounts can\'t message you, see your scrapbook, or see when you\'re online.',
            style: AppTheme.muted(),
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
