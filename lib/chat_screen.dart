import 'package:flutter/material.dart';
import '../data/scrapbook_store.dart';
import '../models/scrapbook_entry.dart';
import '../theme/app_theme.dart';

class _Message {
  final String text;
  final bool fromMe;
  final String time;
  final bool isPhoto;
  const _Message(this.text, this.fromMe, this.time, {this.isPhoto = false});
}

/// One-on-one chat conversation. Opened by tapping a friend's row
/// in the Chats tab.
class ChatScreen extends StatefulWidget {
  final String friendName;
  final String status;
  const ChatScreen({super.key, required this.friendName, this.status = 'Online'});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final List<_Message> _messages = [
    const _Message('Hey! Did you see the new photos I added?', false, '9:12'),
    const _Message('Not yet, let me check the scrapbook', true, '9:14'),
    const _Message('🌊 Beach trip photo', false, '9:14', isPhoto: true),
    const _Message('Omg these are gorgeous, saving my favorite', true, '9:20'),
  ];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text, true, 'now'));
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.accentSoft,
              child: Text(widget.friendName[0],
                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.friendName, style: AppTheme.heading(size: 15)),
                Text(widget.status, style: AppTheme.muted(size: 11)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined, color: AppColors.text),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _bubble(_messages[i]),
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _bubble(_Message m) {
    final align = m.fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bg = m.fromMe ? AppColors.accent : AppColors.card;
    final fg = m.fromMe ? Colors.white : AppColors.text;
    final radius = m.fromMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16), bottomRight: Radius.circular(4))
        : const BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4), bottomRight: Radius.circular(16));

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: align,
        children: [
          GestureDetector(
            onLongPress: m.isPhoto ? () => _showPhotoOptions(m) : null,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: radius,
                border: m.fromMe ? null : Border.all(color: AppColors.border),
              ),
              child: m.isPhoto
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 160,
                          height: 110,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: fg.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.image_outlined, color: fg.withValues(alpha: 0.7), size: 32),
                        ),
                        const SizedBox(height: 6),
                        Text(m.text, style: TextStyle(color: fg, fontSize: 13)),
                      ],
                    )
                  : Text(m.text, style: TextStyle(color: fg, fontSize: 14, height: 1.3)),
            ),
          ),
          const SizedBox(height: 3),
          Text(m.time, style: AppTheme.muted(size: 10)),
        ],
      ),
    );
  }

  void _showPhotoOptions(_Message m) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.auto_stories_outlined, color: AppColors.accent),
              title: const Text('Save to Scrapbook', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('Adds this photo to your memories without re-uploading', style: AppTheme.muted()),
              onTap: () {
                ScrapbookStore.instance.add(
                  ScrapbookEntry(
                    emoji: '📷',
                    title: '${widget.friendName}\'s photo',
                    subtitle: 'Saved from chat',
                    isNew: true,
                  ),
                );
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved to Scrapbook ✓')),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.muted),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: 'Message',
                  hintStyle: AppTheme.muted(),
                  filled: true,
                  fillColor: AppColors.bg,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: _send,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_upward, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
