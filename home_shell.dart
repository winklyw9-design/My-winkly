import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'scrapbook_screen.dart';
import 'chats_screen.dart';
import 'settings_screen.dart';

/// Main app shell. Per the confirmed spec, navigation lives in TOP tabs
/// (Scrapbook | Chats | Settings) — not a bottom nav bar.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Winkly', style: AppTheme.heading(size: 20)),
          bottom: TabBar(
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.muted,
            indicatorColor: AppColors.accent,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            tabs: const [
              Tab(text: 'Scrapbook'),
              Tab(text: 'Chats'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ScrapbookScreen(),
            ChatsScreen(),
            SettingsScreen(),
          ],
        ),
      ),
    );
  }
}
