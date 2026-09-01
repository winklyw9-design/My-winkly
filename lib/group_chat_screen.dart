import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _GroupMessage {
  final String sender;
  final String text;
  final bool fromMe;
  final String time;
  final String? replyTo;
  final List<String> reactions;
  const _GroupMessage(this.sender, this.text, this.fromMe, this.time, {this.replyTo, this.reactions = const []});
}

/// Group chat conversation. Matches spec's "New: Group chats" rules:
/// multi-person chats, emoji reactions on messages, reply-to-specific
/// message (threaded quote).
class GroupChatScreen extends StatefulWidget {
  final String groupName;
  final List<String> members;
  const GroupChatScreen({super.key, required this.groupName, required this.members});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  _GroupMessage? _replyingTo;

  final List<_GroupMessage> _messages = [
    const _GroupMessage('Srii', 'Reached! 📍', false, '9:40'),
    const _GroupMessage('Boo', 'On the way 🚗', false, '9:41'),
    const _GroupMessage('Mani', 'same', false, '9:42', replyTo: 'On the way 🚗', reactions: ['😂', '😂']),
    const _GroupMessage('You', 'Almost there too!', true, '9:44', reactions: ['👍']),
  ];

  final _quickReactions = const ['👍', '❤️', '😂', '😮', '🙏'];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_GroupMessage('You', text, true, 'now', replyTo: _replyingTo?.text));
      _controller.clear();
      _replyingTo = null;
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

  void _showReactionPicker(_GroupMessage m) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _quickReactions.map((r) => InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        setState(() {
                          final i = _messages.indexOf(m);
                          final newReactions = List<String>.from(m.reactions)..add(r);
                          _messages[i] = _GroupMessage(m.sender, m.text, m.fromMe, m.time, replyTo: m.replyTo, reactions: newReactions);
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(r, style: const TextStyle(fontSize: 26)),
                      ),
                    )).toList(),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.reply, color: AppColors.accent),
                title: const Text('Reply', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  setState(() => _replyingTo = m);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
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
            Stack(
              children: [
                for (int i = 0; i < (widget.members.length > 3 ? 3 : widget.members.length); i++)
                  Padding(
                    padding: EdgeInsets.only(left: i * 14.0),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.accentSoft,
                      child: Text(widget.members[i][0],
                          style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                  ),
              ],
            ),
            SizedBox(width: widget.members.length > 3 ? 52 : (widget.members.length * 14.0 + 8)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.groupName, style: AppTheme.heading(size: 15), overflow: TextOverflow.ellipsis),
                  Text('${widget.members.join(', ')}', style: AppTheme.muted(size: 11), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
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
          if (_replyingTo != null) _replyBar(),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _bubble(_GroupMessage m) {
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
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: align,
        children: [
          if (!m.fromMe)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 3),
              child: Text(m.sender, style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          GestureDetector(
            onLongPress: () => _showReactionPicker(m),
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: radius,
                border: m.fromMe ? null : Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (m.replyTo != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: fg.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(left: BorderSide(color: fg.withValues(alpha: 0.4), width: 2)),
                      ),
                      child: Text(m.replyTo!, style: TextStyle(color: fg.withValues(alpha: 0.8), fontSize: 11)),
                    ),
                  Text(m.text, style: TextStyle(color: fg, fontSize: 14, height: 1.3)),
                ],
              ),
            ),
          ),
          if (m.reactions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(m.reactions.join(' '), style: const TextStyle(fontSize: 12)),
              ),
            ),
          const SizedBox(height: 3),
          Text(m.time, style: AppTheme.muted(size: 10)),
        ],
      ),
    );
  }

  Widget _replyBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Container(width: 3, height: 30, color: AppColors.accent),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Replying to ${_replyingTo!.sender}',
                    style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w700)),
                Text(_replyingTo!.text, style: AppTheme.muted(size: 12), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: AppColors.muted),
            onPressed: () => setState(() => _replyingTo = null),
          ),
        ],
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
