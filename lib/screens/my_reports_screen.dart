import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../core/ui_helpers.dart';
import '../models/report.dart';
import '../state/app_state.dart';
import '../widgets/report_card.dart';
import '../widgets/state_views.dart';

/// شاشة «بلاغاتي»: إدارة بلاغات المستخدم.
/// الضغط على الكارت يوسّعه لعرض التفاصيل (الصنف/الموقع/الملاحظات) — بدون الانتقال لصفحة أخرى.
class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = state.myReports;

    return Scaffold(
      appBar: AppBar(title: const Text('بلاغاتي')),
      body: state.isLoadingReports
          ? const LoadingView()
          : items.isEmpty
              ? const EmptyView(
                  icon: Icons.post_add,
                  title: 'لم تنشر أي بلاغ بعد',
                  subtitle: 'اضغط زر «إبلاغ» لإضافة أول بلاغ لك.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 6, bottom: 90),
                  itemCount: items.length,
                  itemBuilder: (_, i) => _MyReportTile(report: items[i]),
                ),
    );
  }
}

class _MyReportTile extends StatefulWidget {
  final Report report;
  const _MyReportTile({required this.report});

  @override
  State<_MyReportTile> createState() => _MyReportTileState();
}

class _MyReportTileState extends State<_MyReportTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.report;
    final color = reportColor(r.type);
    final open = r.status == ReportStatus.open;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          // رأس الكارت — الضغط عليه يوسّع/يطوي التفاصيل
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ReportThumbnail(report: r, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatusBadge(r),
                        const SizedBox(height: 6),
                        Text(r.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.schedule,
                                size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 3),
                            Text(timeAgo(r.createdAt),
                                style: TextStyle(
                                    fontSize: 12.5,
                                    color: Colors.grey.shade700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey),
                ],
              ),
            ),
          ),

          // التفاصيل عند التوسّع
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _info(Icons.category_outlined, 'الصنف', r.category),
                  _info(Icons.place_outlined, 'الموقع', r.building),
                  _info(Icons.notes_outlined, 'الملاحظات',
                      r.notes.isEmpty ? 'لا توجد ملاحظات' : r.notes),
                ],
              ),
            ),
          ],

          // منطقة الأزرار
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Row(
              children: [
                if (open)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          context.read<AppState>().resolveReport(r.id),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.found),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('وجدته'),
                    ),
                  )
                else
                  const Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: AppTheme.found, size: 20),
                        SizedBox(width: 6),
                        Text('تم العثور عليه',
                            style: TextStyle(
                                color: AppTheme.found,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'حذف',
                  onPressed: () => _confirmDelete(context, r.id),
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف البلاغ'),
        content: const Text('هل تريد حذف هذا البلاغ نهائياً؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('حذف')),
        ],
      ),
    );
    if (res == true && context.mounted) {
      context.read<AppState>().deleteReport(id);
    }
  }
}
