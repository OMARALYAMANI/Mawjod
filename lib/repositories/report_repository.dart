import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_data.dart';
import '../models/report.dart';

/// واجهة مستودع البلاغات (abstract).
///
/// هذه الواجهة تفصل منطق التطبيق عن مصدر البيانات. في Phase 3 نستخدم
/// تخزيناً محلياً دائماً عبر [LocalReportRepository]. في Phase 4 يكفي إضافة
/// تطبيق جديد (مثل FirestoreReportRepository) دون تغيير بقية التطبيق.
abstract class ReportRepository {
  Future<List<Report>> fetchReports();
  Future<void> add(Report report);
  Future<void> update(Report report);
  Future<void> delete(String id);
}

/// تطبيق محلي يحفظ البلاغات في جهاز المستخدم باستخدام SharedPreferences.
/// البيانات تبقى بعد إغلاق التطبيق (persistence حقيقي).
class LocalReportRepository implements ReportRepository {
  static const _key = 'reports_v1';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  /// يقرأ القائمة المخزّنة، ويزرع بيانات أولية عند أول تشغيل.
  Future<List<Report>> _read(SharedPreferences prefs) async {
    final raw = prefs.getString(_key);
    if (raw == null) {
      // أول تشغيل: ازرع عيّنة من المفقودات حتى لا تكون القائمة فارغة.
      await _write(prefs, kMockReports);
      return List.of(kMockReports);
    }
    final list = (jsonDecode(raw) as List)
        .map((e) => Report.fromMap(
            (e as Map<String, dynamic>)['id'] as String, e))
        .toList();
    return list;
  }

  Future<void> _write(SharedPreferences prefs, List<Report> reports) async {
    final data = reports.map((r) => {'id': r.id, ...r.toMap()}).toList();
    await prefs.setString(_key, jsonEncode(data));
  }

  @override
  Future<List<Report>> fetchReports() async {
    final prefs = await _prefs;
    await Future.delayed(const Duration(milliseconds: 400)); // محاكاة زمن القراءة
    final list = await _read(prefs);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<void> add(Report report) async {
    final prefs = await _prefs;
    final list = await _read(prefs);
    list.insert(0, report);
    await _write(prefs, list);
  }

  @override
  Future<void> update(Report report) async {
    final prefs = await _prefs;
    final list = await _read(prefs);
    final i = list.indexWhere((r) => r.id == report.id);
    if (i != -1) list[i] = report;
    await _write(prefs, list);
  }

  @override
  Future<void> delete(String id) async {
    final prefs = await _prefs;
    final list = await _read(prefs);
    list.removeWhere((r) => r.id == id);
    await _write(prefs, list);
  }
}
