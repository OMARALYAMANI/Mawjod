import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme.dart';

void main() {
  runApp(const MawjodApp());
}

class MawjodApp extends StatelessWidget {
  const MawjodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'موجود',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      // إعداد اللغة العربية والاتجاه من اليمين لليسار (RTL).
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const _SetupReadyScreen(),
    );
  }
}

/// شاشة مؤقتة تؤكد أن البيئة جاهزة للبناء عليها.
/// ستُستبدل لاحقاً بشاشة تسجيل الدخول والخلاصة الرئيسية.
class _SetupReadyScreen extends StatelessWidget {
  const _SetupReadyScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('موجود')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle,
                  size: 80, color: AppTheme.found),
              const SizedBox(height: 16),
              Text(
                'البيئة جاهزة ✅',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'تطبيق «موجود» — مفقودات طلاب جامعة الملك فهد للبترول والمعادن\n'
                'المكتبات مثبّتة والملفات مجهّزة. جاهزون نبدأ بناء النسخة الأولية.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
