import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Chats > Chat customization. Theme color, wallpaper, and font style
/// per chat, per the spec's Chat customization rules.
class ChatCustomizationScreen extends StatefulWidget {
  const ChatCustomizationScreen({super.key});

  @override
  State<ChatCustomizationScreen> createState() => _ChatCustomizationScreenState();
}

class _ChatCustomizationScreenState extends State<ChatCustomizationScreen> {
  int _colorIndex = 0;
  int _wallpaperIndex = 0;
  int _fontIndex = 0;

  final _colors = const [
    AppColors.accent,
    Color(0xFF5C8DFF),
    Color(0xFF4FB477),
    Color(0xFFE0577A),
    Color(0xFF9D6FE0),
  ];

  final _wallpapers = const ['None', 'Dots', 'Waves', 'Grid'];
  final _fonts = const ['Default', 'iPhone style', 'Samsung style'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('Chat customization', style: AppTheme.heading(size: 18))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _preview(),
          const SizedBox(height: 24),
          Text('Theme color', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 10),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _colors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final selected = i == _colorIndex;
                return InkWell(
                  onTap: () => setState(() => _colorIndex = i),
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _colors[i],
                      shape: BoxShape.circle,
                      border: selected ? Border.all(color: AppColors.text, width: 2.5) : null,
                    ),
                    child: selected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text('Wallpaper', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: Column(
              children: _wallpapers.asMap().entries.map((e) {
                final i = e.key;
                return Column(
                  children: [
                    if (i > 0) const Divider(height: 1, color: AppColors.border),
                    RadioListTile<int>(
                      activeColor: AppColors.accent,
                      contentPadding: EdgeInsets.zero,
                      title: Text(e.value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      value: i,
                      groupValue: _wallpaperIndex,
                      onChanged: (v) => setState(() => _wallpaperIndex = v!),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Text('Font style', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _sectionCard(
            child: Column(
              children: _fonts.asMap().entries.map((e) {
                final i = e.key;
                return Column(
                  children: [
                    if (i > 0) const Divider(height: 1, color: AppColors.border),
                    RadioListTile<int>(
                      activeColor: AppColors.accent,
                      contentPadding: EdgeInsets.zero,
                      title: Text(e.value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      value: i,
                      groupValue: _fontIndex,
                      onChanged: (v) => setState(() => _fontIndex = v!),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _preview() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text('Hey! Loving the new theme', style: TextStyle(fontSize: 13)),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _colors[_colorIndex],
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('Looks great on you too 🎨', style: TextStyle(fontSize: 13, color: Colors.white)),
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
