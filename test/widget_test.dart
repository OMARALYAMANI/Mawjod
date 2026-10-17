// اختبار مبدئي: التطبيق يقلع ويعرض شاشة تسجيل الدخول.
import 'package:flutter_test/flutter_test.dart';

import 'package:mawjod/main.dart';

void main() {
  testWidgets('شاشة الدخول تظهر عند الإقلاع', (WidgetTester tester) async {
    await tester.pumpWidget(const MawjodApp());

    expect(find.text('موجود'), findsWidgets);
    expect(find.text('تسجيل الدخول'), findsWidgets);
  });
}
