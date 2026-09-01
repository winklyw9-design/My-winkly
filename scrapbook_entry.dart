import 'package:flutter/material.dart';

/// One saved memory in the Scrapbook. Shared model so both the
/// Scrapbook screen and the "save from chat" memory bridge use the
/// same shape.
class ScrapbookEntry {
  final String? emoji;
  final IconData? icon;
  final String title;
  final String subtitle;
  final bool isNew;

  const ScrapbookEntry({
    this.emoji,
    this.icon,
    required this.title,
    required this.subtitle,
    this.isNew = false,
  });
}
