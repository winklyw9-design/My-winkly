import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Chats > Add friend. Primary flow is mobile number, with email as
/// an alternative — matches the spec's Add friend flow rules.
class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  bool _useEmail = false;
  final _controller = TextEditingController();
  bool _sent = false;

  void _sendRequest() {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _sent = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text('Add friend', style: AppTheme.heading(size: 18))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(child: _tab('Mobile number', !_useEmail, () => setState(() { _useEmail = false; _sent = false; _controller.clear(); }))),
                Expanded(child: _tab('Email', _useEmail, () => setState(() { _useEmail = true; _sent = false; _controller.clear(); }))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (_sent)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.accent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Friend request sent to ${_controller.text}',
                        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
            )
          else ...[
            Text(
              _useEmail ? 'Enter their email address' : 'Enter their mobile number',
              style: AppTheme.muted(size: 12),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              keyboardType: _useEmail ? TextInputType.emailAddress : TextInputType.phone,
              decoration: InputDecoration(
                hintText: _useEmail ? 'friend@email.com' : '+91 98765 43210',
                hintStyle: AppTheme.muted(),
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
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Send friend request'),
              ),
            ),
            if (!_useEmail) ...[
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => setState(() { _useEmail = true; _controller.clear(); }),
                  child: Text('No number? Use email instead', style: TextStyle(color: AppColors.accent)),
                ),
              ),
            ],
          ],
          const SizedBox(height: 24),
          Text('From your contacts', style: AppTheme.muted(size: 12)),
          const SizedBox(height: 8),
          _contactRow('Divya R'),
          _contactRow('Karthik M'),
        ],
      ),
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? Colors.white : AppColors.muted,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _contactRow(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.accentSoft,
            child: Text(name[0], style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
          TextButton(
            onPressed: () {},
            child: Text('Add', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
