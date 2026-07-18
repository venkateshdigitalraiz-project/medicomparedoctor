import 'package:flutter/material.dart';

class AppColors {
  static const Color darkBlueColor = Color(0xFF0A1F44);
  static const Color darkBlueColor1 = Color(0xFF000B58);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);
  static const Color greenColor = Color(0xFF008080);
  static const Color greenColor1 = Color(0xFF008000);
  static const Color yellowColor = Color(0xFFFFC727);
  static const Color blackColor1 = Color(0xFF2E2E2E);
  static const Color greyColor = Color(0xFFEBEBEB);
  static const Color greyColor1 = Color(0xFFC7C7C7);
  static const Color greyColor2 = Color(0xFFD9D9D9);
  static const Color greyColor3 = Color(0xFFF5F5F5);
  static const Color greyColor4 = Color(0xFFDBDBDB);
  static const Color greyColor5 = Color(0xFF8B93AA);
  static const Color greyColor6 = Color(0xFF4A4A4A);
  static const Color greyColor7 = Color(0xFFCCCCCC);
  static const Color greyColor8 = Color(0xFF787575);
  static const Color greyColor9 = Color(0xFFF3F3F3);
  static const Color skyBlurColor = Color(0xFF045B7E);
  static const Color violetColor = Color(0xFF7877CD);
  static const Color violetColor1 = Color(0xFFDAE2F8);
  static const Color purpleColor = Color(0xFF601CA3);

  static const background = Color(0xFFF5F8FF);
  static const purple = Color(0xFF601CA3);
  static const purpleDark = Color(0xFF5B3EE8);

  static const textDark = Color(0xFF1E1E2D);
  static const textGrey = Color(0xFF9098A9);

  // Stat card + status accent colors
  static const blue = Color(0xFF3B82F6);
  static const green = Color(0xFF17A673);
  static const orange = Color(0xFFE8792D);
  static const red = Color(0xFFE94B4B);

  static const chipBorder = Color(0xFFE3E7F1);
  static const cardBorder = Color(0xFFEDF0F7);

  static const Color headerBackground = Color(0xFFEAF2FF);
  static const Color scaffoldBackground = Color(0xFFFFFFFF);

  static const Color primaryPurple = Color(0xFF5B2A86);
  static const Color deepPurple = Color(0xFF3A1F6B);

  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);

  static const Color statBlueIconBg = Color(0xFFE0EAFF);
  static const Color statOrangeIconBg = Color(0xFFFFE7D6);
  static const Color statGreenIconBg = Color(0xFFD7F7E8);

  static const Color statBlueIcon = Color(0xFF3B82F6);
  static const Color statOrangeIcon = Color(0xFFF97316);
  static const Color statGreenIcon = Color(0xFF16A34A);

  static const Color divider = Color(0xFFE5E7EB);
  final LinearGradient gridViewGradient = const LinearGradient(
    colors: [darkBlueColor, whiteColor],

    // Transition from primary to secondary color
    begin: Alignment.topCenter, // The gradient starts at the top-left corner
    end: Alignment.bottomCenter, // The gradient ends at the bottom-right corner
  );
  final LinearGradient gridViewGradient1 = const LinearGradient(
    colors: [darkBlueColor, whiteColor],

    // Transition from primary to secondary color
    begin: Alignment.centerLeft, // The gradient starts at the top-left corner
    end: Alignment.centerRight, // The gradient ends at the bottom-right corner
  );
  final LinearGradient couponGradient = const LinearGradient(
    colors: [darkBlueColor1, blackColor],

    // Transition from primary to secondary color
    begin: Alignment.centerLeft, // The gradient starts at the top-left corner
    end: Alignment.centerRight, // The gradient ends at the bottom-right corner
  );

  final LinearGradient postNewJobGradient = LinearGradient(
    colors: [whiteColor, yellowColor.withValues(alpha: 0.13)],

    // Transition from primary to secondary color
    begin: Alignment.topCenter, // The gradient starts at the top-left corner
    end: Alignment.bottomCenter, // The gradient ends at the bottom-right corner
  );

  final LinearGradient mostBookedGradient = LinearGradient(
    colors: [whiteColor, skyBlurColor.withValues(alpha: 0.4), whiteColor],

    // Transition from primary to secondary color
    begin: Alignment.topCenter, // The gradient starts at the top-left corner
    end: Alignment.bottomCenter, // The gradient ends at the bottom-right corner
  );
  final LinearGradient testimonialGradient = LinearGradient(
    colors: [whiteColor, violetColor1],

    // Transition from primary to secondary color
    begin: Alignment.topCenter, // The gradient starts at the top-left corner
    end: Alignment.bottomCenter, // The gradient ends at the bottom-right corner
  );
}
