// اختبارات طبقة المستودع والمصادقة — تثبت أن التدفّق يعمل من البداية للنهاية.
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mawjod/models/report.dart';
import 'package:mawjod/repositories/auth_repository.dart';
import 'package:mawjod/repositories/report_repository.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('ReportRepository: يزرع عيّنة ثم يضيف ويحفظ بلاغاً جديداً', () async {
    final repo = LocalReportRepository();

    final seeded = await repo.fetchReports();
    expect(seeded, isNotEmpty); // عيّنة أولية عند أول تشغيل

    final newReport = Report(
      id: 'test1',
      type: ReportType.lost,
      category: 'جوال',
      title: 'جوال اختبار',
      building: 'المكتبة',
      notes: '',
      imageUrl: '',
      status: ReportStatus.open,
      ownerId: 'u1',
      ownerName: 'Tester',
      ownerPhone: '0500000000',
      createdAt: DateTime.now(),
    );
    await repo.add(newReport);

    // مستودع جديد (يقرأ من نفس التخزين) يجب أن يجد البلاغ المحفوظ.
    final after = await LocalReportRepository().fetchReports();
    expect(after.any((r) => r.id == 'test1'), isTrue);
  });

  test('ReportRepository: تحديث الحالة إلى "تم العثور عليه" يُحفظ', () async {
    final repo = LocalReportRepository();
    final list = await repo.fetchReports();
    final first = list.first;
    await repo.update(first.copyWith(status: ReportStatus.resolved));

    final after = await repo.fetchReports();
    final updated = after.firstWhere((r) => r.id == first.id);
    expect(updated.status, ReportStatus.resolved);
  });

  test('AuthRepository: تسجيل الدخول بالحساب التجريبي ناجح', () async {
    final auth = LocalAuthRepository();
    final user = await auth.signIn(
        email: 's202249820@kfupm.edu.sa', password: '123456');
    expect(user.email, 's202249820@kfupm.edu.sa');

    // الجلسة محفوظة.
    final current = await auth.currentUser();
    expect(current?.uid, user.uid);
  });

  test('AuthRepository: يرفض إيميل خارج نطاق الجامعة', () async {
    final auth = LocalAuthRepository();
    expect(
      () => auth.signIn(email: 'omar@gmail.com', password: '123456'),
      throwsA(isA<Exception>()),
    );
  });

  test('AuthRepository: إنشاء حساب جديد ثم تسجيل الدخول به', () async {
    final auth = LocalAuthRepository();
    await auth.signUp(
      name: 'New Student',
      email: 's201111111@kfupm.edu.sa',
      phone: '0511111111',
      password: 'secret1',
    );
    await auth.signOut();
    final user = await auth.signIn(
        email: 's201111111@kfupm.edu.sa', password: 'secret1');
    expect(user.name, 'New Student');
  });
}
