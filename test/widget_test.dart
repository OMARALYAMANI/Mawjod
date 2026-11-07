// اختبار دخان: التطبيق يقلع ويعرض شاشة الإقلاع ثم شاشة الدخول.
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mawjod/main.dart';

void main() {
  testWidgets('التطبيق يقلع بدون أخطاء', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MawjodApp());

    // شاشة الإقلاع تعرض شعار الجامعة.
    expect(find.text('KFUPM'), findsOneWidget);

    // بعد انتهاء الإقلاع (لا جلسة) تظهر شاشة تسجيل الدخول.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('تسجيل الدخول'), findsWidgets);
  });
}
