import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/ui_helpers.dart';
import '../models/report.dart';

/// شاشة تفاصيل البلاغ — صورة الغرض وتفاصيله وأزرار التواصل المباشر.
class ReportDetailsScreen extends StatelessWidget {
  final Report report;
  const ReportDetailsScreen({super.key, required this.report});

  /// فتح تطبيق الاتصال مباشرة برقم الناشر.
  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: report.ownerPhone);
    await launchUrl(uri);
  }

  /// فتح واتساب مباشرة على رقم الناشر (مع تحويل الرقم لصيغة دولية).
  Future<void> _whatsapp() async {
    var n = report.ownerPhone.replaceAll(RegExp(r'\D'), '');
    if (n.startsWith('0')) n = '966${n.substring(1)}';
    final uri = Uri.parse('https://wa.me/$n');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final color = reportColor(report.type);
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل البلاغ')),
      body: ListView(
        children: [
          // صورة الغرض (أو أيقونة الصنف كبديل)
          _Banner(report: report, color: color),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TypeBadge(report.type),
                    const Spacer(),
                    // الوقت — أوضح وأكبر
                    Icon(Icons.schedule,
                        size: 18, color: color.withValues(alpha: 0.85)),
                    const SizedBox(width: 4),
                    Text(timeAgo(report.createdAt),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        )),
                  ],
                ),
                const SizedBox(height: 12),
                Text(report.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _InfoRow(Icons.category_outlined, 'الصنف', report.category),
                _InfoRow(Icons.place_outlined, 'الموقع', report.building),
                if (report.notes.isNotEmpty)
                  _InfoRow(Icons.notes_outlined, 'ملاحظات', report.notes),
                const Divider(height: 32),

                Text('التواصل مع الناشر',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _call,
                        icon: const Icon(Icons.call),
                        label: const Text('اتصال'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _whatsapp,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF25D366),
                          side: const BorderSide(color: Color(0xFF25D366)),
                        ),
                        icon: const Icon(Icons.chat),
                        label: const Text('رسالة واتساب'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// صورة الغرض كبانر علوي، أو أيقونة الصنف كبديل.
class _Banner extends StatelessWidget {
  final Report report;
  final Color color;
  const _Banner({required this.report, required this.color});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      height: 220,
      color: color.withValues(alpha: 0.10),
      child: Center(
        child: Icon(categoryIcon(report.category), size: 90, color: color),
      ),
    );
    if (report.imageUrl.isEmpty) return fallback;
    return Image.network(
      report.imageUrl,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          height: 220,
          color: Colors.grey.shade100,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stack) => fallback,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
