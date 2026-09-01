import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/new_tag.dart';

/// Result handed back to ScrapbookScreen when the user saves a new entry.
class ScrapbookEntryResult {
  final String title;
  final String subtitle;
  final String emoji;
  const ScrapbookEntryResult({required this.title, required this.subtitle, required this.emoji});
}

/// Scrapbook > New Entry. Matches the spec: Title, Add photos (multiple),
/// Add voice note (record/attach), All types of links (auto-preview), Tags.
class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _linkController = TextEditingController();
  final _tagController = TextEditingController();

  int _photoCount = 0;
  bool _hasVoiceNote = false;
  bool _isRecording = false;
  final List<String> _links = [];
  final List<String> _tags = [];

  void _addPhoto() {
    setState(() => _photoCount++);
  }

  void _toggleRecording() {
    if (_isRecording) {
      setState(() {
        _isRecording = false;
        _hasVoiceNote = true;
      });
    } else {
      setState(() => _isRecording = true);
    }
  }

  void _addLink() {
    final text = _linkController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _links.add(text);
      _linkController.clear();
    });
  }

  void _addTag() {
    final text = _tagController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _tags.add(text.startsWith('#') ? text : '#$text');
      _tagController.clear();
    });
  }

  void _save() {
    final title = _titleController.text.trim().isEmpty ? 'Untitled memory' : _titleController.text.trim();
    final parts = <String>[];
    if (_photoCount > 0) parts.add('$_photoCount photo${_photoCount > 1 ? 's' : ''}');
    if (_hasVoiceNote) parts.add('voice note');
    if (_links.isNotEmpty) parts.add('${_links.length} link${_links.length > 1 ? 's' : ''}');
    if (parts.isEmpty) parts.add('note');
    final subtitle = parts.join(' · ');
    final emoji = _hasVoiceNote ? '🎙️' : (_photoCount > 0 ? '📷' : '📝');

    Navigator.of(context).pop(ScrapbookEntryResult(title: title, subtitle: subtitle, emoji: emoji));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _linkController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Add Note', style: AppTheme.heading(size: 18)),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Save', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _label('Title'),
          _textField(_titleController, 'Write something...'),
          const SizedBox(height: 18),
          _label('Content'),
          _textField(_contentController, 'Write here...', maxLines: 4),
          const SizedBox(height: 20),

          _sectionCard(
            child: InkWell(
              onTap: _addPhoto,
              child: Row(
                children: [
                  _iconBox(Icons.photo_library_outlined),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Add photos', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        Text(
                          _photoCount == 0 ? 'multiple photo add options' : '$_photoCount photo${_photoCount > 1 ? 's' : ''} added',
                          style: AppTheme.muted(),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.add_circle_outline, color: AppColors.accent),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          _sectionCard(
            child: InkWell(
              onTap: _toggleRecording,
              child: Row(
                children: [
                  _iconBox(_isRecording ? Icons.stop_circle_outlined : Icons.mic_none_outlined,
                      active: _isRecording),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Add voice note', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            const SizedBox(width: 6),
                            const NewTag(),
                          ],
                        ),
                        Text(
                          _isRecording
                              ? 'Recording… tap to stop'
                              : (_hasVoiceNote ? 'Voice note recorded ✓' : 'record / attach audio clip'),
                          style: _isRecording
                              ? TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)
                              : AppTheme.muted(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _iconBox(Icons.link),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('All types of links', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          Text('paste any link — auto preview', style: AppTheme.muted()),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _linkController,
                        onSubmitted: (_) => _addLink(),
                        decoration: InputDecoration(
                          hintText: 'https://',
                          hintStyle: AppTheme.muted(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _addLink,
                      icon: Icon(Icons.add_circle, color: AppColors.accent),
                    ),
                  ],
                ),
                if (_links.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _links.map((l) => Chip(
                          label: Text(l, style: const TextStyle(fontSize: 11)),
                          backgroundColor: AppColors.bg,
                          side: const BorderSide(color: AppColors.border),
                          onDeleted: () => setState(() => _links.remove(l)),
                        )).toList(),
                  ),
                ],
                const SizedBox(height: 6),
              ],
            ),
          ),
          const SizedBox(height: 10),

          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Tags', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(width: 6),
                    const NewTag(),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagController,
                        onSubmitted: (_) => _addTag(),
                        decoration: InputDecoration(
                          hintText: '#travel #family #2026',
                          hintStyle: AppTheme.muted(),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _addTag,
                      icon: Icon(Icons.add_circle, color: AppColors.accent),
                    ),
                  ],
                ),
                if (_tags.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _tags.map((t) => Chip(
                          label: Text(t, style: const TextStyle(fontSize: 11)),
                          backgroundColor: AppColors.accentSoft,
                          labelStyle: const TextStyle(color: AppColors.accent),
                          side: BorderSide.none,
                          onDeleted: () => setState(() => _tags.remove(t)),
                        )).toList(),
                  ),
                ],
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: AppTheme.muted(size: 12)),
      );

  Widget _textField(TextEditingController c, String hint, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTheme.muted(),
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }

  Widget _iconBox(IconData icon, {bool active = false}) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? AppColors.accent : AppColors.accentSoft,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, size: 19, color: active ? Colors.white : AppColors.accent),
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
          padding: const EdgeInsets.all(14),
          child: child,
        ),
      ),
    );
  }
}
