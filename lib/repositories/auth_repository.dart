import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../models/app_user.dart';

/// واجهة مستودع المصادقة (abstract) — تفصل التطبيق عن مزوّد الهوية.
/// Phase 3: تطبيق محلي عبر SharedPreferences. Phase 4: يُستبدل بـ Firebase Auth.
abstract class AuthRepository {
  Future<AppUser?> currentUser();
  Future<AppUser> signIn({required String email, required String password});
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
  Future<void> signOut();
}

/// تطبيق محلي للمصادقة: يسجّل الحسابات ويحفظ الجلسة على الجهاز.
class LocalAuthRepository implements AuthRepository {
  static const _usersKey = 'users_v1';
  static const _sessionKey = 'session_uid_v1';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<Map<String, dynamic>>> _users(SharedPreferences prefs) async {
    final raw = prefs.getString(_usersKey);
    if (raw == null) {
      // أول تشغيل: حساب تجريبي جاهز لاختبار الدكتور.
      final seed = [
        {
          'uid': 'u1',
          'name': 'Omar Alyamani',
          'email': 's202249820@kfupm.edu.sa',
          'phone': '0544455667',
          'password': '123456',
        }
      ];
      await prefs.setString(_usersKey, jsonEncode(seed));
      return seed;
    }
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  AppUser _toUser(Map<String, dynamic> m) => AppUser(
        uid: m['uid'] as String,
        name: m['name'] as String,
        email: m['email'] as String,
        phone: m['phone'] as String,
      );

  @override
  Future<AppUser?> currentUser() async {
    final prefs = await _prefs;
    final uid = prefs.getString(_sessionKey);
    if (uid == null) return null;
    final users = await _users(prefs);
    for (final u in users) {
      if (u['uid'] == uid) return _toUser(u);
    }
    return null;
  }

  @override
  Future<AppUser> signIn(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final e = email.trim().toLowerCase();
    if (!e.endsWith('@$kUniversityEmailDomain')) {
      throw Exception('يجب استخدام إيميل الجامعة (@$kUniversityEmailDomain)');
    }
    final prefs = await _prefs;
    final users = await _users(prefs);
    Map<String, dynamic>? m;
    for (final u in users) {
      if ((u['email'] as String).toLowerCase() == e) {
        m = u;
        break;
      }
    }
    if (m == null) {
      throw Exception('لا يوجد حساب بهذا الإيميل — أنشئ حساباً جديداً');
    }
    if (m['password'] != password) {
      throw Exception('كلمة المرور غير صحيحة');
    }
    await prefs.setString(_sessionKey, m['uid'] as String);
    return _toUser(m);
  }

  @override
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final e = email.trim().toLowerCase();
    if (!e.endsWith('@$kUniversityEmailDomain')) {
      throw Exception('يجب استخدام إيميل الجامعة (@$kUniversityEmailDomain)');
    }
    final prefs = await _prefs;
    final users = await _users(prefs);
    if (users.any((u) => (u['email'] as String).toLowerCase() == e)) {
      throw Exception('هذا الإيميل مسجّل مسبقاً');
    }
    final user = {
      'uid': 'u${DateTime.now().millisecondsSinceEpoch}',
      'name': name.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'password': password,
    };
    users.add(user);
    await prefs.setString(_usersKey, jsonEncode(users));
    await prefs.setString(_sessionKey, user['uid'] as String);
    return _toUser(user);
  }

  @override
  Future<void> signOut() async {
    final prefs = await _prefs;
    await prefs.remove(_sessionKey);
  }
}
