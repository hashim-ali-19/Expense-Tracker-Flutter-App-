import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ---------------------------------------------------------------------
/// Design tokens for "Penny Track" — a cool, tech-flavored identity:
/// deep navy + electric blue, a teal/amber accent pair, and a bold,
/// slightly angular type system. No pastels, no cute mascots — this
/// is meant to feel like a sharp little utility app.
/// ---------------------------------------------------------------------
class AppColors {
  // Brand
  static const Color electric = Color(0xFF3A86FF); // primary
  static const Color teal = Color(0xFF06D6A0); // secondary
  static const Color amber = Color(0xFFFF9F1C); // accent / highlight
  static const Color slate = Color(0xFF5C6784); // muted supporting tone

  // Neutrals
  static const Color bgLight = Color(0xFFF1F5F9);
  static const Color bgDark = Color(0xFF11151C);
  static const Color surfaceDark = Color(0xFF1B2432);
  static const Color inkLight = Color(0xFF1B2432);
  static const Color inkOnDark = Color(0xFFE7ECF5);

  // Category palette — cool, distinct tones (blues, greens, greys,
  // one warm amber for contrast) reused across list, chips, chart.
  static const Map<String, Color> categoryColors = {
    'Food': Color(0xFFFF9F1C),
    'Transport': Color(0xFF3A86FF),
    'Shopping': Color(0xFF8338EC),
    'Bills': Color(0xFF5C6784),
    'Entertainment': Color(0xFFEF476F),
    'Health': Color(0xFF06D6A0),
    'Education': Color(0xFF118AB2),
    'Other': Color(0xFF4B5563),
  };

  static Color categoryColor(String category) =>
      categoryColors[category] ?? slate;
}

class AppTheme {
  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? AppColors.bgDark : AppColors.bgLight;
    final ink = isDark ? AppColors.inkOnDark : AppColors.inkLight;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.electric,
      brightness: brightness,
      primary: AppColors.electric,
      secondary: AppColors.teal,
      tertiary: AppColors.amber,
      surface: isDark ? AppColors.surfaceDark : Colors.white,
    );

    final displayFont = GoogleFonts.rubikTextTheme();
    final bodyFont = GoogleFonts.interTextTheme();

    final textTheme = bodyFont
        .copyWith(
          headlineLarge: displayFont.headlineLarge
              ?.copyWith(color: ink, fontWeight: FontWeight.w700),
          headlineMedium: displayFont.headlineMedium
              ?.copyWith(color: ink, fontWeight: FontWeight.w700),
          headlineSmall: displayFont.headlineSmall
              ?.copyWith(color: ink, fontWeight: FontWeight.w700),
          titleLarge: displayFont.titleLarge
              ?.copyWith(color: ink, fontWeight: FontWeight.w700),
          titleMedium: displayFont.titleMedium
              ?.copyWith(color: ink, fontWeight: FontWeight.w600),
          bodyLarge: bodyFont.bodyLarge?.copyWith(color: ink),
          bodyMedium: bodyFont.bodyMedium?.copyWith(color: ink),
        )
        .apply(bodyColor: ink, displayColor: ink);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: scheme,
      textTheme: textTheme,
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.rubik(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: ink,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: ink),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? AppColors.surfaceDark : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : AppColors.electric.withOpacity(0.05),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.electric, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
        ),
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: ink.withOpacity(0.65),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.electric,
        foregroundColor: Colors.white,
        elevation: 4,
        extendedTextStyle: GoogleFonts.rubik(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.electric,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.rubik(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
        side: BorderSide.none,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: AppColors.inkLight,
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
