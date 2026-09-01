import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Settings > App lock. Lets the user turn on a PIN (and see a
/// fingerprint option) that will be asked for whenever the app opens.
class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  bool _lockEnabled = false;
  bool _fingerprintEnabled = false;
  String _pin = '';

  void _startSetPin() {
    showDialog(
      context: context,
      builder: (_) => _PinSetupDialog(
        onConfirmed: (pin) {
          setState(() {
            _pin = pin;
            _lockEnabled = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('App lock', style: AppTheme.heading(size: 18))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionCard(
            child: Column(
              children: [
                SwitchListTile(
                  activeThumbColor: AppColors.accent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('App lock', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    _lockEnabled ? 'PIN required to open Winkly' : 'Off',
                    style: AppTheme.muted(),
                  ),
                  value: _lockEnabled,
                  onChanged: (v) {
                    if (v) {
                      _startSetPin();
                    } else {
                      setState(() {
                        _lockEnabled = false;
                        _fingerprintEnabled = false;
                        _pin = '';
                      });
                    }
                  },
                ),
                if (_lockEnabled) ...[
                  const Divider(height: 1, color: AppColors.border),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Change PIN'),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
                    onTap: _startSetPin,
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  SwitchListTile(
                    activeThumbColor: AppColors.accent,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Use fingerprint instead', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Unlock with fingerprint when available', style: AppTheme.muted()),
                    value: _fingerprintEnabled,
                    onChanged: (v) => setState(() => _fingerprintEnabled = v),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'When app lock is on, Winkly asks for your PIN every time you open it.',
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

/// Simple 4-digit PIN entry dialog reused for setting the app PIN.
class _PinSetupDialog extends StatefulWidget {
  final void Function(String pin) onConfirmed;
  const _PinSetupDialog({required this.onConfirmed});

  @override
  State<_PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends State<_PinSetupDialog> {
  String _pin = '';

  void _tap(String d) {
    if (_pin.length >= 4) return;
    setState(() => _pin += d);
    if (_pin.length == 4) {
      Future.delayed(const Duration(milliseconds: 200), () {
        widget.onConfirmed(_pin);
        if (mounted) Navigator.of(context).pop();
      });
    }
  }

  void _backspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, color: AppColors.accent, size: 32),
            const SizedBox(height: 10),
            Text('Set your PIN', style: AppTheme.heading(size: 16)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final filled = i < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? AppColors.accent : AppColors.border,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            _keypad(),
          ],
        ),
      ),
    );
  }

  Widget _keypad() {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];
    return SizedBox(
      width: 220,
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: keys.map((k) {
          if (k.isEmpty) return const SizedBox();
          return InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => k == '⌫' ? _backspace() : _tap(k),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.bg,
                shape: BoxShape.circle,
              ),
              child: Text(k, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
