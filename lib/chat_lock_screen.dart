import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Per-chat privacy screen. Opened from a chat's options menu.
/// Lets the user lock that one chat (PIN/fingerprint to open it)
/// and toggle disappearing messages for it.
class ChatLockScreen extends StatefulWidget {
  final String friendName;
  const ChatLockScreen({super.key, required this.friendName});

  @override
  State<ChatLockScreen> createState() => _ChatLockScreenState();
}

class _ChatLockScreenState extends State<ChatLockScreen> {
  bool _chatLocked = false;
  bool _disappearing = false;
  String _disappearDuration = '24 hours';

  final _durations = const ['1 hour', '24 hours', '7 days'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('Chat privacy', style: AppTheme.heading(size: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.accentSoft,
                child: Text(widget.friendName[0],
                    style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Text(widget.friendName, style: AppTheme.heading(size: 16)),
            ],
          ),
          const SizedBox(height: 20),
          _sectionCard(
            child: SwitchListTile(
              activeThumbColor: AppColors.accent,
              contentPadding: EdgeInsets.zero,
              title: const Text('Lock this chat', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                _chatLocked ? 'Hidden from chat list, opens with PIN/fingerprint' : 'Off',
                style: AppTheme.muted(),
              ),
              value: _chatLocked,
              onChanged: (v) => setState(() => _chatLocked = v),
            ),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            child: Column(
              children: [
                SwitchListTile(
                  activeThumbColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Disappearing messages', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    _disappearing ? 'New messages vanish after $_disappearDuration' : 'Off',
                    style: AppTheme.muted(),
                  ),
                  value: _disappearing,
                  onChanged: (v) => setState(() => _disappearing = v),
                ),
                if (_disappearing) ...[
                  const Divider(height: 1, color: AppColors.border),
                  ..._durations.map((d) => RadioListTile<String>(
                        activeColor: AppColors.accent,
                        contentPadding: EdgeInsets.zero,
                        title: Text(d),
                        value: d,
                        groupValue: _disappearDuration,
                        onChanged: (v) => setState(() => _disappearDuration = v!),
                      )),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Locked chats are hidden from your chat list and only open with your PIN or fingerprint.',
            style: AppTheme.muted(),
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
