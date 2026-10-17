import 'package:flutter/material.dart';

import '../core/theme.dart';

/// شاشة الإشعارات — تنبيهات بالمفقودات الجديدة والتحديثات.
/// (عيّنة تصميمية؛ ستُربط بإشعارات فعلية في المرحلة 3).
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _items = [
    _Notif(Icons.add_alert, 'مفقود جديد قريب منك',
        'تم نشر «سمّاعة AirPods بيضاء» في المكتبة.', 'قبل 20 دقيقة', true),
    _Notif(Icons.check_circle, 'تم العثور على مفقودك',
        'أبلغ أحد الطلاب أنه وجد «كتاب حسابات هندسية».', 'قبل ساعة', true),
    _Notif(Icons.campaign, 'مفقود جديد',
        'تم نشر «مجموعة مفاتيح» في ملعب كرة القدم.', 'قبل 3 ساعات', false),
    _Notif(Icons.info_outline, 'تذكير',
        'لا تنسَ تحديث حالة بلاغاتك إذا استرجعت غرضك.', 'قبل يوم', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
        itemBuilder: (_, i) {
          final n = _items[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
              child: Icon(n.icon, color: AppTheme.primary),
            ),
            title: Text(n.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(n.body),
            trailing: Text(n.time,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            tileColor:
                n.unread ? AppTheme.primary.withValues(alpha: 0.04) : null,
            isThreeLine: true,
          );
        },
      ),
    );
  }
}

class _Notif {
  final IconData icon;
  final String title;
  final String body;
  final String time;
  final bool unread;
  const _Notif(this.icon, this.title, this.body, this.time, this.unread);
}
