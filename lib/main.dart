import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'screens/login_screen.dart';
import 'state/app_state.dart';

void main() {
  runApp(const MawjodApp());
}

class MawjodApp extends StatelessWidget {
  const MawjodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
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
        home: const LoginScreen(),
      ),
    );
  }
}
