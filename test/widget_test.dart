// اختبار مبدئي للتأكد من إقلاع التطبيق.
import 'package:flutter_test/flutter_test.dart';

import 'package:mawjod/main.dart';

void main() {
  testWidgets('التطبيق يقلع ويعرض الاسم', (WidgetTester tester) async {
    await tester.pumpWidget(const MawjodApp());
    await tester.pumpAndSettle();

    expect(find.text('موجود'), findsWidgets);
    expect(find.text('البيئة جاهزة ✅'), findsOneWidget);
  });
}
