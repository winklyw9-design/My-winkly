import 'package:flutter/material.dart';
import '../data/scrapbook_store.dart';
import '../models/scrapbook_entry.dart';
import '../theme/app_theme.dart';
import '../widgets/new_tag.dart';
import 'entry_detail_screen.dart';
import 'new_entry_screen.dart';
import 'timeline_screen.dart';

class ScrapbookScreen extends StatefulWidget {
  const ScrapbookScreen({super.key});

  @override
  State<ScrapbookScreen> createState() => _ScrapbookScreenState();
}

class _ScrapbookScreenState extends State<ScrapbookScreen> {
  String _filter = 'All';
  final _filters = const ['All', 'Travel', 'Quotes'];

  Future<void> _openNewEntry() async {
    final result = await Navigator.of(context).push<ScrapbookEntryResult>(
      MaterialPageRoute(builder: (_) => const NewEntryScreen()),
    );
    if (result != null) {
      ScrapbookStore.instance.add(
        ScrapbookEntry(emoji: result.emoji, title: result.title, subtitle: result.subtitle, isNew: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: _openNewEntry,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ValueListenableBuilder<List<ScrapbookEntry>>(
        valueListenable: ScrapbookStore.instance.entries,
        builder: (context, entries, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              Row(
                children: [
                  Expanded(child: Text('Notes and tracks — memories you\'ve saved', style: AppTheme.muted())),
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TimelineScreen()),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text('Timeline', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final f = _filters[i];
                    final active = f == _filter;
                    return ChoiceChip(
                      label: Text(f),
                      selected: active,
                      onSelected: (_) => setState(() => _filter = f),
                      selectedColor: AppColors.accentSoft,
                      labelStyle: TextStyle(
                        color: active ? AppColors.accent : AppColors.muted,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      side: BorderSide(color: active ? AppColors.accent : AppColors.border),
                      backgroundColor: Colors.white,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (entries.isEmpty)
                _emptyState()
              else
                for (final e in entries)
                  _entryCard(emoji: e.emoji, icon: e.icon, title: e.title, subtitle: e.subtitle, isNew: e.isNew),
            ],
          );
        },
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(20)),
            child: Icon(Icons.auto_stories_outlined, size: 40, color: AppColors.accent),
          ),
          const SizedBox(height: 16),
          Text('No memories yet', style: AppTheme.heading(size: 16)),
          const SizedBox(height: 6),
          Text('Tap + to save your first photo, note, or voice memo',
              style: AppTheme.muted(), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _entryCard({
    String? emoji,
    IconData? icon,
    required String title,
    required String subtitle,
    bool isNew = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EntryDetailScreen(
                emoji: emoji ?? '📝',
                title: title,
                subtitle: subtitle,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: emoji != null
                      ? Text(emoji, style: const TextStyle(fontSize: 20))
                      : Icon(icon, color: AppColors.accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(title,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          ),
                          if (isNew) ...[const SizedBox(width: 6), const NewTag()],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppTheme.muted()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
