import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'repositories/auth_repository.dart';
import 'repositories/report_repository.dart';
import 'screens/login_screen.dart';
import 'screens/root_nav.dart';
import 'state/app_state.dart';
import 'widgets/kfupm_logo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MawjodApp());
}

class MawjodApp extends StatelessWidget {
  const MawjodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // طبقة المستودعات المحلية (تُستبدل بـ Firebase في Phase 4).
      create: (_) => AppState(
        auth: LocalAuthRepository(),
        reports: LocalReportRepository(),
      )..bootstrap(),
      child: MaterialApp(
        title: 'موجود',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const _AuthGate(),
      ),
    );
  }
}

/// يوجّه المستخدم حسب حالة الجلسة: شاشة إقلاع ثم الدخول أو الواجهة الرئيسية.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (state.bootstrapping) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KfupmLogo(size: 96),
              SizedBox(height: 24),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }
    return state.isLoggedIn ? const RootNav() : const LoginScreen();
  }
}
