import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Settings > Storage and data. Shows a usage breakdown, backup status,
/// and the Recycle Bin (items deleted by the user, kept 30 days before
/// permanent deletion, per the app rules).
class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('Storage and data', style: AppTheme.heading(size: 18))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Storage used', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('1.8 GB', style: AppTheme.heading(size: 24)),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text('of 5 GB used', style: AppTheme.muted()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 10,
                      child: Row(
                        children: [
                          Expanded(flex: 52, child: Container(color: AppColors.accent)),
                          Expanded(flex: 20, child: Container(color: const Color(0xFFE0A96D))),
                          Expanded(flex: 15, child: Container(color: const Color(0xFFB08C4F))),
                          Expanded(flex: 13, child: Container(color: AppColors.border)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _legendRow(AppColors.accent, 'Photos', '940 MB'),
                  _legendRow(const Color(0xFFE0A96D), 'Voice notes', '360 MB'),
                  _legendRow(const Color(0xFFB08C4F), 'Links & text', '270 MB'),
                  _legendRow(AppColors.muted, 'Other', '230 MB'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _sectionCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Manage storage', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Review and free up space', style: AppTheme.muted()),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
                  onTap: () {},
                ),
                const Divider(height: 1, color: AppColors.border),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Backup', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Last backup: Today, 6:12 AM', style: AppTheme.muted()),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Recycle Bin', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: Column(
              children: [
                _binRow('Beach trip photos', '12 days left'),
                const Divider(height: 1, color: AppColors.border),
                _binRow('Voice memo — Amma', '27 days left'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Deleted items stay in the Recycle Bin for 30 days before they\'re permanently removed. Saved items are never auto-deleted.',
            style: AppTheme.muted(),
          ),
        ],
      ),
    );
  }

  Widget _legendRow(Color color, String label, String size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(size, style: AppTheme.muted()),
        ],
      ),
    );
  }

  Widget _binRow(String title, String daysLeft) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.accentSoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.delete_outline, size: 18, color: AppColors.accent),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(daysLeft, style: AppTheme.muted()),
      trailing: TextButton(
        onPressed: () {},
        child: Text('Restore', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
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
