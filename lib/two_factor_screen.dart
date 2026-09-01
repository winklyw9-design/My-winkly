import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Account > Two-factor authentication. OTP-based login toggle with a
/// simple setup flow (send OTP -> verify).
class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({super.key});

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen> {
  bool _enabled = false;
  bool _otpSent = false;
  final _otpController = TextEditingController();

  void _startSetup() {
    setState(() => _otpSent = true);
  }

  void _verify() {
    if (_otpController.text.trim().length < 4) return;
    setState(() {
      _enabled = true;
      _otpSent = false;
      _otpController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Two-factor authentication enabled ✓')),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('Two-factor authentication', style: AppTheme.heading(size: 17))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionCard(
            child: SwitchListTile(
              activeThumbColor: AppColors.accent,
              contentPadding: EdgeInsets.zero,
              title: const Text('OTP-based login', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                _enabled ? 'Enabled — you\'ll get an OTP each login' : 'Off',
                style: AppTheme.muted(),
              ),
              value: _enabled,
              onChanged: (v) {
                if (v) {
                  _startSetup();
                } else {
                  setState(() {
                    _enabled = false;
                    _otpSent = false;
                  });
                }
              },
            ),
          ),
          if (_otpSent) ...[
            const SizedBox(height: 20),
            Text('Enter the OTP sent to +91 98765 43210', style: AppTheme.muted(size: 12)),
            const SizedBox(height: 8),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: '••••••',
                hintStyle: AppTheme.muted(),
                counterText: '',
                filled: true,
                fillColor: AppColors.card,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Verify & enable'),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'When enabled, you\'ll need to enter a one-time code sent to your phone every time you log in on a new device.',
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
