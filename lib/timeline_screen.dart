import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'entry_detail_screen.dart';

class _MonthGroup {
  final String month;
  final List<_TimelineEntry> entries;
  const _MonthGroup(this.month, this.entries);
}

class _TimelineEntry {
  final String emoji;
  final String title;
  final String subtitle;
  const _TimelineEntry(this.emoji, this.title, this.subtitle);
}

/// Scrapbook > Timeline. Groups memories by year, then by month, per
/// the spec's "Scrapbook Timeline" screen with sort & filter.
class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  String _sort = 'Date';
  final _sortOptions = const ['Date', 'Friend', 'Tag', 'Pinned first'];

  final Map<String, List<_MonthGroup>> _years = const {
    '2026': [
      _MonthGroup('August', [
        _TimelineEntry('🌊', 'Beach trip', '4 photos · title + note'),
        _TimelineEntry('🎙️', 'Voice memo — Amma', '0:42'),
        _TimelineEntry('📁', 'Shared album: College gang', '3 friends added photos'),
      ]),
      _MonthGroup('May', [
        _TimelineEntry('✈️', 'Trip to Ooty', '12 photos'),
      ]),
    ],
    '2025': [
      _MonthGroup('December', [
        _TimelineEntry('🎄', 'New Year plans', 'note · #family'),
      ]),
    ],
  };

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Sort by', style: AppTheme.heading(size: 16)),
            ),
            ..._sortOptions.map((o) => RadioListTile<String>(
                  activeColor: AppColors.accent,
                  title: Text(o),
                  value: o,
                  groupValue: _sort,
                  onChanged: (v) {
                    setState(() => _sort = v!);
                    Navigator.of(ctx).pop();
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalMemories = _years.values
        .expand((groups) => groups)
        .expand((g) => g.entries)
        .length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Timeline', style: AppTheme.heading(size: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort, color: AppColors.text),
            onPressed: _showSortSheet,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('$totalMemories memories · sorted by $_sort', style: AppTheme.muted()),
          const SizedBox(height: 14),
          for (final year in _years.keys) _yearSection(year, _years[year]!),
        ],
      ),
    );
  }

  Widget _yearSection(String year, List<_MonthGroup> months) {
    final count = months.expand((m) => m.entries).length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(year, style: AppTheme.heading(size: 20)),
              const SizedBox(width: 8),
              Text('$count memories', style: AppTheme.muted()),
            ],
          ),
          const SizedBox(height: 10),
          for (final m in months) _monthTile(m),
        ],
      ),
    );
  }

  Widget _monthTile(_MonthGroup m) {
    final preview = m.entries.map((e) => e.title).take(2).join(' · ');
    final more = m.entries.length > 2 ? ' · ${m.entries.length - 2} more' : '';

    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: ExpansionTile(
            iconColor: AppColors.accent,
            collapsedIconColor: AppColors.muted,
            title: Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 15, color: AppColors.accent),
                const SizedBox(width: 8),
                Text(m.month, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2, left: 23),
              child: Text('$preview$more', style: AppTheme.muted()),
            ),
            childrenPadding: const EdgeInsets.only(bottom: 8),
            children: m.entries
                .map((e) => ListTile(
                      leading: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.accentSoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(e.emoji, style: const TextStyle(fontSize: 16)),
                      ),
                      title: Text(e.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      subtitle: Text(e.subtitle, style: AppTheme.muted(size: 11)),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EntryDetailScreen(
                            emoji: e.emoji,
                            title: e.title,
                            subtitle: e.subtitle,
                            date: '${m.month}',
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
