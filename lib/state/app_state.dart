import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../data/mock_data.dart';
import '../models/app_user.dart';
import '../models/report.dart';

/// الحالة المشتركة للتطبيق (shared state) باستخدام ChangeNotifier + Provider.
///
/// تمسك: المستخدم الحالي، قائمة البلاغات، وحالة التحميل، والفلاتر.
/// في المرحلة 3 ستُستبدل المصادر الوهمية بـ Firebase Auth و Cloud Firestore.
class AppState extends ChangeNotifier {
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  final List<Report> _reports = [];
  bool _isLoadingReports = false;
  bool get isLoadingReports => _isLoadingReports;

  // فلتر الخلاصة الرئيسية (حسب نوع الصنف).
  String? categoryFilter; // null = الكل

  /// محاكاة تسجيل الدخول: تتحقق من نطاق الإيميل الجامعي.
  /// ترمي استثناءً عند فشل التحقق ليعرضه واجهة الشاشة.
  Future<void> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 900)); // محاكاة الشبكة
    if (!email.trim().toLowerCase().endsWith('@$kUniversityEmailDomain')) {
      throw Exception('يجب استخدام إيميل الجامعة (@$kUniversityEmailDomain)');
    }
    _currentUser = AppUser(
      uid: 'u1',
      name: 'Omar Alyamani',
      email: email.trim(),
      phone: '0544455667',
    );
    await loadReports();
    notifyListeners();
  }

  void signOut() {
    _currentUser = null;
    _reports.clear();
    notifyListeners();
  }

  /// محاكاة جلب البلاغات مع حالة تحميل.
  Future<void> loadReports() async {
    _isLoadingReports = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1200));
    _reports
      ..clear()
      ..addAll(kMockReports);
    _isLoadingReports = false;
    notifyListeners();
  }

  /// الخلاصة: المفقودات المفتوحة فقط (لم يُعثر عليها بعد)، بعد فلتر الصنف، الأحدث أولاً.
  List<Report> get feed {
    final list = _reports
        .where((r) =>
            r.status == ReportStatus.open && r.type == ReportType.lost)
        .where((r) {
      if (categoryFilter != null && r.category != categoryFilter) return false;
      return true;
    }).toList()
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

  /// تحديد فلتر الصنف (null = عرض الكل).
  void setCategoryFilter(String? category) {
    categoryFilter = category;
    notifyListeners();
  }

  void addReport(Report report) {
    _reports.insert(0, report);
    notifyListeners();
  }

  void resolveReport(String id) {
    final i = _reports.indexWhere((r) => r.id == id);
    if (i != -1) {
      _reports[i] = _reports[i].copyWith(status: ReportStatus.resolved);
      notifyListeners();
    }
  }

  void deleteReport(String id) {
    _reports.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
