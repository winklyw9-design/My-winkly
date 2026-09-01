import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/new_tag.dart';
import 'add_friend_screen.dart';
import 'chat_customization_screen.dart';
import 'chat_lock_screen.dart';
import 'chat_screen.dart';
import 'group_chat_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  static const _friends = ['Boo', 'Srii', 'Sound', 'Nathi', 'Gukan', 'Mani'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Text('Your circle — close-by friends', style: AppTheme.muted()),
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _friends.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) => InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ChatScreen(friendName: _friends[i])),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.accentSoft,
                      child: Text(_friends[i][0],
                          style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _groupRow(context),
          _chatRow(context, 'Srii', 'sent a photo to Scrapbook', '9:40', isNew: true),
          _chatRow(context, 'Boo', 'typing…', '9:35'),
          _chatRow(context, 'Mani', 'disappearing chat', 'Yest', locked: true, isNew: true),
          const SizedBox(height: 14),
          _actionCard(
            context,
            'Add friend',
            'via mobile number · email (alt.)',
            isNew: true,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddFriendScreen()),
            ),
          ),
          _actionCard(
            context,
            'Chat customization',
            'theme, wallpaper, font',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ChatCustomizationScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupRow(BuildContext context) {
    const members = ['Boo', 'Srii', 'Sound', 'Nathi', 'Gukan'];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
              builder: (_) => const GroupChatScreen(groupName: 'College Gang', members: members),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.accentSoft,
                          child: Text(members[0][0],
                              style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 11)),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 8,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.card,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.accent,
                            child: Text(members[1][0],
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('College Gang', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(width: 6),
                          const NewTag(),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('You: Almost there too!', style: AppTheme.muted()),
                    ],
                  ),
                ),
                Text('9:44', style: AppTheme.muted(size: 11)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatRow(BuildContext context, String name, String preview, String time,
      {bool locked = false, bool isNew = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
            MaterialPageRoute(builder: (_) => ChatScreen(friendName: name)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.accentSoft,
                  child: Text(name[0], style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          if (isNew) ...[const SizedBox(width: 6), const NewTag()],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(preview, style: AppTheme.muted()),
                    ],
                  ),
                ),
                if (locked)
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ChatLockScreen(friendName: name)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.lock_outline, size: 16, color: AppColors.lock),
                    ),
                  ),
                Text(time, style: AppTheme.muted(size: 11)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionCard(BuildContext context, String title, String subtitle,
      {bool isNew = false, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    if (isNew) ...[const SizedBox(width: 6), const NewTag()],
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTheme.muted()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
