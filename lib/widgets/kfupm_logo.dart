import 'package:flutter/material.dart';

import '../core/theme.dart';

/// شعار هوية جامعة الملك فهد للبترول والمعادن (KFUPM).
///
/// شارة دائرية بألوان الجامعة الخضراء.
/// ملاحظة: لاستخدام الشعار الرسمي، ضع ملف `assets/images/kfupm_logo.png`
/// واستبدل محتوى الدائرة بـ `Image.asset('assets/images/kfupm_logo.png')`.
class KfupmLogo extends StatelessWidget {
  final double size;
  const KfupmLogo({super.key, this.size = 108});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, AppTheme.secondary],
        ),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, color: Colors.white, size: size * 0.30),
          SizedBox(height: size * 0.04),
          Text(
            'KFUPM',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: size * 0.16,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
