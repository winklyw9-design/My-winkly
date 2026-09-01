import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Full view of a single scrapbook entry. Opened by tapping an entry
/// in the Scrapbook list or Timeline.
class EntryDetailScreen extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String date;

  const EntryDetailScreen({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.date = 'Today',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(title, style: AppTheme.heading(size: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.text),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.card,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  title: Text('Move to Recycle Bin?', style: AppTheme.heading(size: 16)),
                  content: Text('You can restore this within 30 days from Storage settings.', style: AppTheme.muted()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Cancel', style: TextStyle(color: AppColors.muted)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text('Delete', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 56)),
          ),
          const SizedBox(height: 16),
          Text(date, style: AppTheme.muted()),
          const SizedBox(height: 6),
          Text(title, style: AppTheme.heading(size: 22)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.muted),
                const SizedBox(width: 8),
                Expanded(child: Text(subtitle, style: const TextStyle(fontSize: 13))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.text,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.share_outlined, size: 16),
                  label: const Text('Share'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.text,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
