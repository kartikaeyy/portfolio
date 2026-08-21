import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ── Premium dark surfaces ──────────────────────────────────────────────
  static const background = Color(0xFF0E0E11); // near-black page
  static const surface = Color(0xFF16161B); // slightly raised
  static const cardBg = Color(0xFF17171C); // glassy card base
  static const cardHover = Color(0xFF20202A); // card lift on hover

  // ── Text ───────────────────────────────────────────────────────────────
  static const ink = Color(0xFFF5F5F2); // primary (off-white)
  static const inkLight = Color(0xFFA8A8B3); // secondary (muted grey)
  static const inkFaint = Color(0xFF74747F); // tertiary (labels, meta)

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

  // ── Status ───────────────────────────────────────────────────────────────
  static const live = Color(0xFF4ADE80); // "currently working" dot

  static const white = Color(0xFFFFFFFF);
}

/// Breakpoints for the three layouts the site actually ships: a single column
/// on phones, a roomier single column on tablets, and the two-column desktop.
class Breaks {
  const Breaks._();

  static const mobile = 768.0;
  static const tablet = 1100.0;

  static bool isMobile(BuildContext c) => MediaQuery.sizeOf(c).width < mobile;
  static bool isTablet(BuildContext c) {
    final w = MediaQuery.sizeOf(c).width;
    return w >= mobile && w < tablet;
  }

  static bool isDesktop(BuildContext c) => MediaQuery.sizeOf(c).width >= tablet;
}

/// One spacing scale for the whole site, so vertical rhythm stays consistent
/// instead of every section inventing its own numbers.
class Space {
  const Space._();

  static const xs = 6.0;
  static const sm = 12.0;
  static const md = 20.0;
  static const lg = 32.0;
  static const xl = 48.0;
  static const xxl = 72.0;
  static const section = 112.0; // gap between major sections (desktop)
  static const sectionMobile = 72.0;
}

class Radii {
  const Radii._();

  static const chip = 999.0;
  static const card = 20.0;
  static const panel = 28.0;
}

/// Shared motion vocabulary — everything moves with the same easing so the
/// page feels like one product rather than a pile of widgets.
class Motion {
  const Motion._();

  static const fast = Duration(milliseconds: 160);
  static const base = Duration(milliseconds: 280);
  static const slow = Duration(milliseconds: 600);
  static const reveal = Duration(milliseconds: 700);
  static const curve = Curves.easeOutCubic;
  static const emphasized = Curves.easeInOutCubic;
}

/// Page-level measurements: content is capped and centred so line lengths stay
/// readable on ultrawide monitors instead of stretching edge to edge.
class Layout {
  const Layout._();

  static const maxContent = 1200.0;
  static const maxProse = 620.0; // ~70 characters per line

  /// One gutter for the whole site. It deliberately matches the Work
  /// section's own padding (24 / 80) so every section heading starts on the
  /// same vertical line on phones and on desktop.
  static double sidePad(BuildContext c) =>
      MediaQuery.sizeOf(c).width < Breaks.mobile ? 24 : 80;

  /// Fluid value that scales linearly with viewport width between two
  /// breakpoints — used for display type so headlines never overflow on
  /// tablets or look undersized on large screens.
  static double fluid(
    BuildContext c, {
    required double min,
    required double max,
    double fromWidth = 360,
    double toWidth = 1440,
  }) {
    final w = MediaQuery.sizeOf(c).width.clamp(fromWidth, toWidth);
    final t = (w - fromWidth) / (toWidth - fromWidth);
    return min + (max - min) * t;
  }
}

/// Applies the shared side gutter and vertical section rhythm. Content is
/// left-aligned against that gutter — matching the Work section — unless a
/// [maxWidth] is given, which centres a narrower column (used by Chat).
class ContentFrame extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final double? top;
  final double? bottom;

  const ContentFrame({
    super.key,
    required this.child,
    this.maxWidth,
    this.top,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    final v = isMobile ? Space.sectionMobile : Space.section;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Layout.sidePad(context),
        top ?? v,
        Layout.sidePad(context),
        bottom ?? v,
      ),
      child: maxWidth == null
          ? child
          : Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth!),
                child: child,
              ),
            ),
    );
  }
}

/// Small all-caps label that sits above a section title, giving each section a
/// consistent entry point for the eye.
class Eyebrow extends StatelessWidget {
  final String label;
  final Color? color;

  const Eyebrow({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.heroYellow;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 1.5,
          decoration: BoxDecoration(
            color: c.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
            color: c.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

/// The section title used by Story and Chat, sized fluidly.
class SectionTitle extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double minSize;
  final double maxSize;

  const SectionTitle(
    this.text, {
    super.key,
    this.align = TextAlign.start,
    this.minSize = 38,
    this.maxSize = 68,
  });

  @override
  Widget build(BuildContext context) {
    final size = Layout.fluid(context, min: minSize, max: maxSize);
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
        height: 1.02,
        letterSpacing: -size * 0.03,
      ),
    );
  }
}

/// A hairline glass panel — the single card treatment shared by Story and
/// Chat so surfaces read as one family.
class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Color? tint;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.radius = Radii.panel,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(isMobile ? Space.md : Space.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (tint ?? AppColors.cardBg).withValues(alpha: 0.92),
            AppColors.cardBg.withValues(alpha: 0.55),
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.stroke),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Rounded rectangle with a soft yellow bloom behind it — used for the primary
/// call to action so it reads as the one loud element on the page.
class Bloom extends StatelessWidget {
  final Widget child;
  final double intensity;
  final double radius;

  const Bloom({
    super.key,
    required this.child,
    this.intensity = 1,
    this.radius = 60,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowYellow.withValues(alpha: 0.22 * intensity),
            blurRadius: 48 * intensity,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.glowYellow.withValues(alpha: 0.10 * intensity),
            blurRadius: 90 * intensity,
            spreadRadius: 16,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Utility: degrees → radians for the tilted polaroids.
double rad(double degrees) => degrees * math.pi / 180;

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
      // Yellow ripples on dark read as flashes; keep interaction feedback to
      // the hover/scale transitions the widgets define themselves.
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.white.withValues(alpha: 0.04),
      focusColor: AppColors.heroYellow.withValues(alpha: 0.18),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.heroYellow,
        selectionColor: AppColors.heroYellow.withValues(alpha: 0.28),
        selectionHandleColor: AppColors.heroYellow,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.hovered)
              ? Colors.white.withValues(alpha: 0.28)
              : Colors.white.withValues(alpha: 0.14),
        ),
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(3),
        crossAxisMargin: 2,
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: AppColors.navBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.strokeStrong),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
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
          height: 1.65,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.inkLight,
          height: 1.65,
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

  /// Keeps the browser/OS chrome in step with the page background.
  static const systemOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}
