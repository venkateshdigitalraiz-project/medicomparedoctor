import 'package:flutter/material.dart';

/// Central place for all colors, gradients & text styles used across the
/// MediCompares dashboard so the UI stays consistent with the design mock.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF7B4FE0); // main purple
  static const Color primaryDark = Color(0xFF5E35C7);
  static const Color primaryLight = Color(0xFFB39CF0);

  static const Color scaffoldBg = Color(0xFFF6F4FC);
  static const Color cardBorder = Color(0xFFE7E1FA);

  static const Color textDark = Color(0xFF231A3D);
  static const Color textGrey = Color(0xFF8C87A0);

  static const Color success = Color(0xFF22B07D);
  static const Color successBg = Color(0xFFDFF7EC);

  static const Color warning = Color(0xFFF29A2E);
  static const Color warningBg = Color(0xFFFFF1DD);

  static const Color danger = Color(0xFFE2504A);
  static const Color dangerBg = Color(0xFFFCE3E2);

  static const Color info = Color(0xFF4C6FE0);
  static const Color infoBg = Color(0xFFE4E9FD);

  static const LinearGradient clinicStatusGradient = LinearGradient(
    colors: [Color(0xFFF1ECFC), Color(0xFFF8F1FB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [Color(0xFF8A5CF5), Color(0xFF6C3CE0)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto';

  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textGrey,
  );

  static const TextStyle statNumber = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.scaffoldBg,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        fontFamily: AppTextStyles.fontFamily,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.scaffoldBg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      );
}
