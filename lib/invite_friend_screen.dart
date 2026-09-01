import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Settings > Invite a friend. Share link + QR code, per spec's
/// "QR code / share link to add friends instantly" onboarding rule.
class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('Invite a friend', style: AppTheme.heading(size: 18))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.qr_code_2, size: 96, color: AppColors.text),
                ),
                const SizedBox(height: 16),
                Text('Scan to add me on Winkly', style: AppTheme.muted()),
                const SizedBox(height: 4),
                Text('winkly.app/u/yourname', style: AppTheme.heading(size: 14)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _actionButton(
            icon: Icons.copy_outlined,
            label: 'Copy invite link',
          ),
          const SizedBox(height: 10),
          _actionButton(
            icon: Icons.share_outlined,
            label: 'Share via...',
            filled: true,
          ),
          const SizedBox(height: 20),
          Text('Or invite from contacts', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _contactRow('Divya R'),
          _contactRow('Karthik M'),
          _contactRow('Meena S'),
        ],
      ),
    );
  }

  Widget _actionButton({required IconData icon, required String label, bool filled = false}) {
    return SizedBox(
      width: double.infinity,
      child: filled
          ? ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(icon, size: 18),
              label: Text(label),
            )
          : OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.text,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(icon, size: 18),
              label: Text(label),
            ),
    );
  }

  Widget _contactRow(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.accentSoft,
            child: Text(name[0], style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
          TextButton(
            onPressed: () {},
            child: Text('Invite', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
