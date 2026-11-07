import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../models/report.dart';
import '../repositories/auth_repository.dart';
import '../repositories/report_repository.dart';

/// الحالة المشتركة للتطبيق (Provider / ChangeNotifier).
///
/// تعتمد على طبقة المستودعات (Repository) لقراءة/كتابة البيانات،
/// فيسهل استبدال المصدر المحلي بـ Firebase في Phase 4 دون تغيير الواجهات.
class AppState extends ChangeNotifier {
  final AuthRepository auth;
  final ReportRepository reports;

  AppState({required this.auth, required this.reports});

  // ---- المصادقة ----
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  bool _bootstrapping = true;
  bool get bootstrapping => _bootstrapping;

  /// يُستدعى عند الإقلاع: يستعيد الجلسة المحفوظة ويحمّل البلاغات إن وُجدت.
  Future<void> bootstrap() async {
    _currentUser = await auth.currentUser();
    if (_currentUser != null) await loadReports();
    _bootstrapping = false;
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    _currentUser = await auth.signIn(email: email, password: password);
    await loadReports();
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _currentUser = await auth.signUp(
        name: name, email: email, phone: phone, password: password);
    await loadReports();
    notifyListeners();
  }

  Future<void> signOut() async {
    await auth.signOut();
    _currentUser = null;
    _reports.clear();
    notifyListeners();
  }

  // ---- البلاغات ----
  final List<Report> _reports = [];
  bool _isLoadingReports = false;
  bool get isLoadingReports => _isLoadingReports;
  String? _reportsError;
  String? get reportsError => _reportsError;

  String? categoryFilter; // null = الكل

  /// يقرأ البلاغات من المستودع مع حالتَي التحميل والخطأ.
  Future<void> loadReports() async {
    _isLoadingReports = true;
    _reportsError = null;
    notifyListeners();
    try {
      final list = await reports.fetchReports();
      _reports
        ..clear()
        ..addAll(list);
    } catch (e) {
      _reportsError = 'تعذّر تحميل البلاغات. تحقق من الاتصال وحاول مجدداً.';
    } finally {
      _isLoadingReports = false;
      notifyListeners();
    }
  }

  /// الخلاصة: المفقودات المفتوحة فقط، بعد فلتر الصنف، الأحدث أولاً.
  List<Report> get feed {
    final list = _reports
        .where((r) =>
            r.status == ReportStatus.open && r.type == ReportType.lost)
        .where((r) =>
            categoryFilter == null || r.category == categoryFilter)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  /// بلاغات المستخدم الحالي.
  List<Report> get myReports {
    final uid = _currentUser?.uid;
    final list = _reports.where((r) => r.ownerId == uid).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  void setCategoryFilter(String? category) {
    categoryFilter = category;
    notifyListeners();
  }

  Future<void> addReport(Report report) async {
    await reports.add(report);
    await loadReports();
  }

  Future<void> resolveReport(String id) async {
    final i = _reports.indexWhere((r) => r.id == id);
    if (i == -1) return;
    await reports.update(_reports[i].copyWith(status: ReportStatus.resolved));
    await loadReports();
  }

  Future<void> deleteReport(String id) async {
    await reports.delete(id);
    await loadReports();
  }
}
