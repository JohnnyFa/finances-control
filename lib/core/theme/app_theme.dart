import 'package:finances_control/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,

      primary: AppColors.primaryLight,
      onPrimary: Colors.white,

      secondary: Color(0xFF66BB6A),
      onSecondary: Colors.white,

      error: Color(0xFFD32F2F),
      onError: Colors.white,

      surface: AppColors.lightSurface,
      onSurface: Color(0xFF1C1C1C),

      tertiary: Color(0xFFF1F3F5),      // quase branco, elegante
      onTertiary: Color(0xFF1C1C1C),    // texto escuro
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,

      // Agora definimos explicitamente:
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightSurface,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 0,
          minimumSize: const Size(double.infinity, 64),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,

      primary: AppColors.primaryDark,
      onPrimary: Colors.white,

      secondary: Color(0xFF4CAF50),
      onSecondary: Colors.black,

      error: Color(0xFFEF5350),
      onError: Colors.black,

      surface: AppColors.darkSurface,
      onSurface: Colors.white,

      tertiary: Color(0xFF23262F),     // levemente elevado
      onTertiary: Colors.white,

    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 0,
          minimumSize: const Size(double.infinity, 64),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
