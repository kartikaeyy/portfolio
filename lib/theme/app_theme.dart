import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ── Premium dark surfaces ──────────────────────────────────────────────
  static const background = Color(0xFF0E0E11); // near-black page
  static const surface = Color(0xFF16161B); // slightly raised
  static const cardBg = Color(0xFF17171C); // glassy card base
  static const cardHover = Color(0xFF20202A); // card lift on hover

  // ── Text ───────────────────────────────────────────────────────────────
  static const ink = Color(0xFFF5F5F2); // primary (off-white)
  static const inkLight = Color(0xFF9B9BA5); // secondary (muted grey)

  // ── Glass hairline strokes ──────────────────────────────────────────────
  static const stroke = Color(0x14FFFFFF); // white ~8%
  static const strokeStrong = Color(0x29FFFFFF); // white ~16%

  // ── Signature accent (kept from the warm palette — pops on dark) ─────────
  static const heroYellow = Color(0xFFFFE566);
  static const heroYellowLight = Color(0xFFFFF3B0);
  static const glowYellow = Color(0xFFFFD700);

  // ── Floating nav ─────────────────────────────────────────────────────────
  static const navBg = Color(0xFF1B1B22);
  static const navActive = Color(0xFFFFE566);

  static const white = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData get theme {
    // Start from a dark base so any un-overridden text style stays light.
    final base = ThemeData(brightness: Brightness.dark);
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.heroYellow,
        onPrimary: AppColors.background,
        secondary: AppColors.heroYellow,
        surface: AppColors.background,
        onSurface: AppColors.ink,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 96,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          height: 0.95,
          letterSpacing: -3,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 64,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          height: 0.95,
          letterSpacing: -2,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          height: 1.1,
          letterSpacing: -1,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
          height: 1.2,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: AppColors.inkLight,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.inkLight,
          height: 1.6,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
      useMaterial3: true,
    );
  }
}
