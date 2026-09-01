import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Account > Linked devices. Shows where the account is signed in.
class LinkedDevicesScreen extends StatefulWidget {
  const LinkedDevicesScreen({super.key});

  @override
  State<LinkedDevicesScreen> createState() => _LinkedDevicesScreenState();
}

class _Device {
  final String name;
  final String detail;
  final bool isCurrent;
  const _Device(this.name, this.detail, {this.isCurrent = false});
}

class _LinkedDevicesScreenState extends State<LinkedDevicesScreen> {
  final List<_Device> _devices = [
    const _Device('Chrome · Windows', 'This device · Active now', isCurrent: true),
  ];

  void _logoutAll() {
    setState(() {
      _devices.removeWhere((d) => !d.isCurrent);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out of all other devices')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('Linked devices', style: AppTheme.heading(size: 18))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionCard(
            child: Column(
              children: _devices.asMap().entries.map((e) {
                final i = e.key;
                final d = e.value;
                return Column(
                  children: [
                    if (i > 0) const Divider(height: 1, color: AppColors.border),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.accentSoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.devices_outlined, size: 18, color: AppColors.accent),
                      ),
                      title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(d.detail, style: AppTheme.muted()),
                      trailing: d.isCurrent
                          ? Text('Current', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w700))
                          : null,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          if (_devices.length > 1)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _logoutAll,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade400,
                  side: BorderSide(color: Colors.red.shade200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Log out of all other devices'),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            'If you see a device you don\'t recognize, log out of it immediately and change your PIN.',
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
