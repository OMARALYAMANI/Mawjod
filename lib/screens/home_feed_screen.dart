import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/ui_helpers.dart';
import '../state/app_state.dart';
import '../widgets/report_card.dart';
import '../widgets/state_views.dart';
import 'notifications_screen.dart';
import 'report_details_screen.dart';

/// الشاشة الرئيسية: قائمة المفقودات اللحظية مع تصفية حسب نوع الصنف.
class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('موجود'),
        // زر الإشعارات (يظهر في جهة اليسار في الواجهة العربية)
        actions: [
          IconButton(
            tooltip: 'الإشعارات',
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط التصفية: زر «فلتر بالصنف» على اليمين + الصنف النشط
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _openCategoryFilter(context),
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text('فلتر بالصنف'),
                ),
                const SizedBox(width: 8),
                if (state.categoryFilter != null)
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: InputChip(
                        avatar: Icon(categoryIcon(state.categoryFilter!),
                            size: 18),
                        label: Text(state.categoryFilter!,
                            overflow: TextOverflow.ellipsis),
                        onDeleted: () => state.setCategoryFilter(null),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _buildBody(context, state)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppState state) {
    if (state.isLoadingReports) {
      return const LoadingView(message: 'جارٍ تحميل المفقودات...');
    }
    if (state.reportsError != null) {
      return ErrorView(
        message: state.reportsError!,
        onRetry: () => context.read<AppState>().loadReports(),
      );
    }
    final items = state.feed;
    if (items.isEmpty) {
      return const EmptyView(
        icon: Icons.search_off,
        title: 'لا توجد مفقودات مطابقة',
        subtitle: 'جرّب تغيير التصنيف أو أضف بلاغاً جديداً عبر زر «إبلاغ».',
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<AppState>().loadReports(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 6, bottom: 90),
        itemCount: items.length,
        itemBuilder: (_, i) => ReportCard(
          report: items[i],
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => ReportDetailsScreen(report: items[i])),
          ),
        ),
      ),
    );
  }

  /// قائمة اختيار الصنف للتصفية.
  void _openCategoryFilter(BuildContext context) {
    final state = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (ctx, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Text('التصفية حسب الصنف',
                      style: Theme.of(ctx).textTheme.titleLarge),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      state.setCategoryFilter(null);
                      Navigator.pop(ctx);
                    },
                    child: const Text('عرض الكل'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: kItemCategories.length,
                itemBuilder: (_, i) {
                  final c = kItemCategories[i];
                  final selected = state.categoryFilter == c;
                  return ListTile(
                    leading: Icon(categoryIcon(c)),
                    title: Text(c),
                    trailing: selected
                        ? Icon(Icons.check_circle,
                            color: Theme.of(ctx).colorScheme.primary)
                        : null,
                    selected: selected,
                    onTap: () {
                      state.setCategoryFilter(c);
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
