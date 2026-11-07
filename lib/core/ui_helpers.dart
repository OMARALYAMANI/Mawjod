import 'package:flutter/material.dart';

import '../models/report.dart';
import 'theme.dart';

/// أيقونة مناسبة لكل تصنيف صنف.
IconData categoryIcon(String category) {
  switch (category) {
    case 'إلكترونيات':
      return Icons.devices_other;
    case 'سمّاعات / أجهزة صوت':
      return Icons.headphones;
    case 'جوال':
      return Icons.smartphone;
    case 'لابتوب / تابلت':
      return Icons.laptop_mac;
    case 'محفظة / بطاقات':
      return Icons.account_balance_wallet;
    case 'مفاتيح':
      return Icons.vpn_key;
    case 'حقيبة / شنطة':
      return Icons.backpack;
    case 'ملابس':
      return Icons.checkroom;
    case 'ساعة':
      return Icons.watch;
    case 'نظارة':
      return Icons.visibility;
    case 'كتب / أدوات دراسية':
      return Icons.menu_book;
    case 'أدوات رياضية':
      return Icons.sports_soccer;
    default:
      return Icons.inventory_2;
  }
}

/// لون البلاغ حسب نوعه (مفقود/موجود).
Color reportColor(ReportType type) =>
    type == ReportType.lost ? AppTheme.lost : AppTheme.found;

/// وسم (شارة) يوضّح نوع البلاغ.
class TypeBadge extends StatelessWidget {
  final ReportType type;
  const TypeBadge(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    final color = reportColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        type.label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

/// شارة الحالة: «مفقود» (أحمر) عند الفتح، و«تم العثور عليه» (أخضر) عند الحل.
class StatusBadge extends StatelessWidget {
  final Report report;
  const StatusBadge(this.report, {super.key});

  @override
  Widget build(BuildContext context) {
    final resolved = report.status == ReportStatus.resolved;
    final color = resolved ? AppTheme.found : reportColor(report.type);
    final text = resolved ? 'تم العثور عليه' : report.type.label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(resolved ? Icons.check_circle : Icons.error_outline,
              size: 13, color: color),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

/// نص الموقع: المبنى، أو «غير محدّد» إن كان فارغاً، مع «(غير مؤكد)» للموقع التقريبي.
String locationLabel(Report r) {
  final base = r.building.isEmpty ? 'المكان غير محدّد' : r.building;
  return r.approximateLocation ? '$base (غير مؤكد)' : base;
}

/// نص "منذ كذا" مبسّط بالعربية.
String timeAgo(DateTime date) {
  final d = DateTime.now().difference(date);
  if (d.inMinutes < 60) return 'قبل ${d.inMinutes} دقيقة';
  if (d.inHours < 24) return 'قبل ${d.inHours} ساعة';
  return 'قبل ${d.inDays} يوم';
}
