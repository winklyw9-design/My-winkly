import 'package:flutter/material.dart';
import '../models/scrapbook_entry.dart';

/// Single shared list of scrapbook entries, backed by a ValueNotifier
/// so any screen (Scrapbook tab, or a chat's "Save to Scrapbook"
/// action) can read and update it and have the UI stay in sync.
///
/// This is the "memory bridge": a photo saved from a chat lands here
/// without re-uploading, exactly like a normal scrapbook entry.
class ScrapbookStore {
  ScrapbookStore._();
  static final ScrapbookStore instance = ScrapbookStore._();

  final ValueNotifier<List<ScrapbookEntry>> entries = ValueNotifier([
    const ScrapbookEntry(emoji: '🌊', title: 'Beach trip', subtitle: '4 photos · title + note'),
    const ScrapbookEntry(icon: Icons.play_arrow, title: 'Voice memo — Amma', subtitle: '0:42', isNew: true),
    const ScrapbookEntry(emoji: '📁', title: 'Shared album: College gang', subtitle: '3 friends added photos', isNew: true),
  ]);

  void add(ScrapbookEntry entry) {
    entries.value = [entry, ...entries.value];
  }
}
