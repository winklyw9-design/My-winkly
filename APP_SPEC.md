# Winkly — App Spec (Main Concept, Confirmed)

Navigation: **Top tabs** — Scrapbook | Chats | Settings (built as TabBar in home_shell.dart)

## Core Screens (v1) — BUILT
- Onboarding (3-slide intro) — lib/screens/onboarding_screen.dart
- Login — lib/screens/login_screen.dart
- Home shell with top tabs — lib/screens/home_shell.dart
- Scrapbook tab — lib/screens/scrapbook_screen.dart
- Chats tab — lib/screens/chats_screen.dart
- Settings tab — lib/screens/settings_screen.dart

## Still to build (v2 polish, from spec)
- Scrapbook: New Entry screen (title, add photos, voice note, links, tags)
- Scrapbook: Timeline view (grouped by year/month, sort & filter)
- Chats: Group chat screen (reactions, reply-to-message)
- Chats: Chat detail/conversation screen
- Settings: Extended settings (2FA, linked devices, language, accessibility, notifications, help, about)
- Profile screen (cover photo, bio, QR share, status message)
- Empty states (illustration + "No memories yet" + Create entry CTA)

## Rules to keep in mind while building
- Storage: permanent storage, 30-day Recycle Bin before permanent delete
- Add friend: mobile number primary, email alternative
- Chat customization: theme + wallpaper + font per chat
- Memory bridge: long-press chat photo → "Save to Scrapbook"
- Voice notes: waveform + duration playback
- Privacy: app lock (PIN/fingerprint), disappearing chats, data export, 2FA

This is a fresh build — old Talkio bottom-nav design is not used.
