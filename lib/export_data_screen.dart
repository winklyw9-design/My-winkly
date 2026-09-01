import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Settings > Export my data. Lets the user request a copy of their
/// scrapbook + chats as a zip or PDF, per the Privacy & security rules.
class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({super.key});

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

enum _ExportFormat { zip, pdf }

class _ExportDataScreenState extends State<ExportDataScreen> {
  _ExportFormat _format = _ExportFormat.zip;
  bool _includeScrapbook = true;
  bool _includeChats = true;
  bool _requested = false;

  void _requestExport() {
    setState(() => _requested = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('Export my data', style: AppTheme.heading(size: 18))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_requested) ...[
            _sectionCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.accentSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.hourglass_top, color: AppColors.accent, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Preparing your export', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          Text('We\'ll notify you when it\'s ready to download', style: AppTheme.muted()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text('What to include', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: Column(
              children: [
                CheckboxListTile(
                  activeColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Scrapbook', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Photos, notes, voice memos, links', style: AppTheme.muted()),
                  value: _includeScrapbook,
                  onChanged: (v) => setState(() => _includeScrapbook = v ?? true),
                ),
                const Divider(height: 1, color: AppColors.border),
                CheckboxListTile(
                  activeColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Chats', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Message history with all friends', style: AppTheme.muted()),
                  value: _includeChats,
                  onChanged: (v) => setState(() => _includeChats = v ?? true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Format', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: Column(
              children: [
                RadioListTile<_ExportFormat>(
                  activeColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('ZIP archive', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Original files, folder structure', style: AppTheme.muted()),
                  value: _ExportFormat.zip,
                  groupValue: _format,
                  onChanged: (v) => setState(() => _format = v!),
                ),
                const Divider(height: 1, color: AppColors.border),
                RadioListTile<_ExportFormat>(
                  activeColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('PDF summary', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Readable document, easy to print', style: AppTheme.muted()),
                  value: _ExportFormat.pdf,
                  groupValue: _format,
                  onChanged: (v) => setState(() => _format = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_includeScrapbook || _includeChats) && !_requested ? _requestExport : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.border,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(_requested ? 'Export requested' : 'Request export'),
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
