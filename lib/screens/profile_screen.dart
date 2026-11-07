import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../state/app_state.dart';

/// شاشة الحساب: عرض/تعديل الاسم ورقم الجوال وتسجيل الخروج.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: user == null
          ? const SizedBox()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 8),
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0] : '؟',
                      style: const TextStyle(
                          fontSize: 40, color: AppTheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(user.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Center(
                  child: Text(user.email,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(color: Colors.grey.shade600)),
                ),
                const SizedBox(height: 24),
                _tile(Icons.person_outline, 'الاسم', user.name),
                _tile(Icons.phone_outlined, 'رقم الجوال', user.phone),
                _tile(Icons.email_outlined, 'الإيميل الجامعي', user.email),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('تعديل البيانات'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lost),
                  onPressed: () => context.read<AppState>().signOut(),
                  icon: const Icon(Icons.logout),
                  label: const Text('تسجيل الخروج'),
                ),
              ],
            ),
    );
  }

  Widget _tile(IconData icon, String label, String value) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value, textDirection: TextDirection.ltr),
      ),
    );
  }
}
