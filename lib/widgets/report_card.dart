import 'package:flutter/material.dart';

import '../core/ui_helpers.dart';
import '../models/report.dart';

/// بطاقة تعرض ملخّص بلاغ في القوائم (الخلاصة / بلاغاتي).
class ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback? onTap;
  final bool showTypeBadge;
  const ReportCard({
    super.key,
    required this.report,
    this.onTap,
    this.showTypeBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = reportColor(report.type);
    final resolved = report.status == ReportStatus.resolved;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ReportThumbnail(report: report, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showTypeBadge || resolved) ...[
                      Row(
                        children: [
                          if (showTypeBadge) TypeBadge(report.type),
                          if (showTypeBadge) const SizedBox(width: 8),
                          if (resolved)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('تم الحل',
                                  style: TextStyle(fontSize: 11)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],
                    Text(
                      report.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.place_outlined,
                            size: 15, color: Colors.grey.shade600),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            locationLabel(report),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13.5, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // وقت البلاغ — أوضح وأكبر
                    Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 15, color: color.withValues(alpha: 0.8)),
                        const SizedBox(width: 3),
                        Text(
                          timeAgo(report.createdAt),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// صورة البلاغ (إن وُجدت) أو أيقونة الصنف كبديل.
class ReportThumbnail extends StatelessWidget {
  final Report report;
  final Color color;
  const ReportThumbnail({super.key, required this.report, required this.color});

  @override
  Widget build(BuildContext context) {
    const double s = 72;
    final fallback = Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(categoryIcon(report.category), color: color, size: 32),
    );

    if (report.imageUrl.isEmpty) return fallback;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        report.imageUrl,
        width: s,
        height: s,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: s,
            height: s,
            color: Colors.grey.shade100,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stack) => fallback,
      ),
    );
  }
}
