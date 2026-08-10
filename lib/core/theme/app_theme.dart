import 'package:flutter/material.dart';

class AppPalette {
  AppPalette._();

  static const Color ink = Color(0xFF2F2B3A);
  static const Color mutedInk = Color(0xFF6D667A);
  static const Color canvas = Color(0xFFFFFBF6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color lavender = Color(0xFFCBB8FF);
  static const Color lavenderDeep = Color(0xFF8057D9);
  static const Color mint = Color(0xFF9FD8CB);
  static const Color mintDeep = Color(0xFF2D8C79);
  static const Color peach = Color(0xFFFFB7A1);
  static const Color coral = Color(0xFFFF806B);
  static const Color sky = Color(0xFFA8D8FF);
  static const Color rose = Color(0xFFFFCAD4);
  static const Color sunshine = Color(0xFFFFD98E);
  static const Color lemon = Color(0xFFFFEEB5);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[lavender, sky, mint],
  );

  static const LinearGradient actionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[lavenderDeep, Color(0xFFA76EE7)],
  );

  static const List<Color> playfulSequence = <Color>[
    lavender,
    mint,
    peach,
    sky,
    rose,
    sunshine,
  ];
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final ColorScheme colors =
        ColorScheme.fromSeed(
          seedColor: AppPalette.lavenderDeep,
          brightness: Brightness.light,
          surface: AppPalette.canvas,
        ).copyWith(
          primary: AppPalette.lavenderDeep,
          secondary: AppPalette.mintDeep,
          tertiary: AppPalette.coral,
          onSurface: AppPalette.ink,
        );
    const RoundedRectangleBorder roundedCard = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(26)),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: AppPalette.canvas,
      splashFactory: InkSparkle.splashFactory,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: AppPalette.ink,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          color: AppPalette.ink,
          fontWeight: FontWeight.w800,
        ),
        bodyMedium: TextStyle(color: AppPalette.mutedInk, height: 1.35),
      ),
      cardTheme: CardThemeData(
        color: AppPalette.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: roundedCard,
        shadowColor: AppPalette.lavenderDeep.withValues(alpha: 0.10),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          borderSide: BorderSide(
            color: AppPalette.lavenderDeep.withValues(alpha: 0.55),
            width: 2,
          ),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppPalette.canvas,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppPalette.canvas,
        modalBackgroundColor: AppPalette.canvas,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 76,
        backgroundColor: AppPalette.surface,
        elevation: 0,
        indicatorColor: AppPalette.lavender.withValues(alpha: 0.72),
        indicatorShape: const StadiumBorder(),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          return TextStyle(
            color: states.contains(WidgetState.selected)
                ? AppPalette.lavenderDeep
                : AppPalette.mutedInk,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w900
                : FontWeight.w700,
          );
        }),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size.square(48)),
      ),
      tooltipTheme: const TooltipThemeData(
        waitDuration: Duration(milliseconds: 350),
        showDuration: Duration(seconds: 3),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppPalette.surface,
        selectedColor: AppPalette.lavender.withValues(alpha: 0.72),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        labelStyle: const TextStyle(fontWeight: FontWeight.w800),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
          side: BorderSide(
            color: AppPalette.lavenderDeep.withValues(alpha: 0.28),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppPalette.lavenderDeep,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: StadiumBorder(),
        extendedTextStyle: TextStyle(fontWeight: FontWeight.w900),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppPalette.ink,
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppPalette.lavenderDeep,
        linearTrackColor: Color(0xFFEDE7FA),
      ),
    );
  }
}
