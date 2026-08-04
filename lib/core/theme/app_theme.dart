import 'package:flutter/material.dart';

class AppPalette {
  AppPalette._();

  static const Color ink = Color(0xFF2F2B3A);
  static const Color canvas = Color(0xFFFFFBF6);
  static const Color lavender = Color(0xFFCBB8FF);
  static const Color mint = Color(0xFF9FD8CB);
  static const Color peach = Color(0xFFFFB7A1);
  static const Color sky = Color(0xFFA8D8FF);
  static const Color rose = Color(0xFFFFCAD4);
  static const Color sunshine = Color(0xFFFFD98E);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final ColorScheme colors = ColorScheme.fromSeed(
      seedColor: AppPalette.lavender,
      surface: AppPalette.canvas,
    );
    const RoundedRectangleBorder roundedCard = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: AppPalette.canvas,
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: roundedCard,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide.none,
        ),
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: AppPalette.lavender.withValues(alpha: 0.55),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}
