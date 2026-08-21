import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/actions.dart';
import '../widgets/section_scope.dart';

/// The hero. Fills the first viewport, states who Kartikey is, and — unlike the
/// previous version — gives the visitor somewhere to go next.
class HeyPage extends StatelessWidget {
  const HeyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = Breaks.isMobile(context);
    final scope = SectionScope.maybeOf(context);

    // Clears the floating nav, then pushes the headline into the upper-middle
    // of the viewport — a fixed top padding left tall screens looking empty.
    final topPad = isMobile
        ? math.max(108.0, size.height * 0.11)
        : math.max(138.0, size.height * 0.13);

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: math.max(620, size.height)),
      child: Stack(
        children: [
          const Positioned.fill(child: _HeroBackdrop()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ContentFrame(
                top: topPad,
                bottom: isMobile ? 32 : 40,
                child: const _HeroContent(),
              ),
              if (scope != null)
                Padding(
                  padding: EdgeInsets.only(bottom: isMobile ? 28 : 40),
                  child: Center(
                    child: _ScrollCue(
                      onTap: () => scope.goToSection(SectionScope.work),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent();

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    final scope = SectionScope.maybeOf(context);
    final nameSize = Layout.fluid(context, min: 44, max: 98);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StatusPill(),
        SizedBox(height: isMobile ? 22 : 28),
        Text(
              'Kartikey\nSrivastava',
              style: GoogleFonts.inter(
                fontSize: nameSize,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                height: 0.92,
                letterSpacing: -nameSize * 0.038,
              ),
            )
            .animate()
            .fadeIn(delay: 80.ms, duration: 800.ms)
            .slideY(begin: 0.12, end: 0, curve: Motion.curve),
        SizedBox(height: isMobile ? 18 : 24),
        Text(
              'Crafting apps that people love to use.',
              style: GoogleFonts.inter(
                fontSize: Layout.fluid(context, min: 18, max: 26),
                fontWeight: FontWeight.w500,
                color: AppColors.ink.withValues(alpha: 0.9),
                height: 1.35,
                letterSpacing: -0.4,
              ),
            )
            .animate()
            .fadeIn(delay: 220.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Layout.maxProse),
          child:
              Text(
                    'Flutter developer shipping cross-platform apps for iOS and '
                    'Android — onboarding revamps, app-wide localization and the '
                    'kind of animation detail you feel more than you notice.',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 15 : 17,
                      color: AppColors.inkLight,
                      height: 1.7,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),
        ),
        SizedBox(height: isMobile ? 26 : 32),
        Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ActionButton(
                  label: 'See my work',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => scope?.goToSection(SectionScope.work),
                ),
                IconAction(
                  icon: const Glyph.brand(FontAwesomeIcons.github),
                  tooltip: 'GitHub',
                  size: 46,
                  onPressed: () => launchUrl(Uri.parse(kGithub)),
                ),
                IconAction(
                  icon: const Glyph.brand(FontAwesomeIcons.linkedinIn),
                  tooltip: 'LinkedIn',
                  size: 46,
                  onPressed: () => launchUrl(Uri.parse(kLinkedin)),
                ),
              ],
            )
            .animate()
            .fadeIn(delay: 420.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
        SizedBox(height: isMobile ? 28 : 36),
        const _HeroStats()
            .animate()
            .fadeIn(delay: 560.ms, duration: 700.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }
}

/// "Currently" badge with a live dot — answers the first thing a recruiter
/// looks for before they scroll.
class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    final current = kExperiences.first;
    final isMobile = Breaks.isMobile(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Radii.chip),
        border: Border.all(color: AppColors.strokeStrong),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              '${current.role} @ ${current.company}',
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 10 : 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Three numbers pulled straight from the portfolio data, so the hero can make
/// a concrete claim without anything to keep in sync by hand.
class _HeroStats extends StatelessWidget {
  const _HeroStats();

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          constraints: const BoxConstraints(maxWidth: 520),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.strokeStrong, Colors.transparent],
            ),
          ),
        ),
        SizedBox(height: isMobile ? 18 : 22),
      ],
    );
  }
}

/// Bottom-of-hero affordance: tells the visitor there is more, and takes them
/// there when clicked.
class _ScrollCue extends StatelessWidget {
  final VoidCallback onTap;
  const _ScrollCue({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPressed: onTap,
      semanticLabel: 'Scroll to my work',
      builder: (context, hovered, focused) => AnimatedOpacity(
        duration: Motion.fast,
        opacity: hovered ? 1 : 0.62,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SCROLL',
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.4,
                color: AppColors.inkLight,
              ),
            ),
            const SizedBox(height: 8),
            const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 22,
                  color: AppColors.inkLight,
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(
                  begin: -3,
                  end: 4,
                  duration: 1200.ms,
                  curve: Curves.easeInOut,
                ),
          ],
        ),
      ),
    );
  }
}

/// Warm gradient, drifting light and a faint dot grid. Replaces the loose
/// hand-drawn squiggles with something that reads as depth at any size.
class _HeroBackdrop extends StatelessWidget {
  const _HeroBackdrop();

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3A3113),
                  Color(0xFF1B1720),
                  AppColors.background,
                ],
                stops: [0.0, 0.46, 0.92],
              ),
            ),
          ),
          Positioned(
            top: -160,
            right: isMobile ? -180 : -80,
            child: _Orb(
              size: isMobile ? 420 : 620,
              color: AppColors.glowYellow,
              alpha: 0.14,
              seconds: 9,
            ),
          ),
          Positioned(
            bottom: -140,
            left: isMobile ? -200 : -60,
            child: _Orb(
              size: isMobile ? 380 : 560,
              color: const Color(0xFF7C5CFF),
              alpha: 0.10,
              seconds: 12,
            ),
          ),
          const Positioned.fill(child: CustomPaint(painter: _GridPainter())),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double alpha;
  final int seconds;

  const _Orb({
    required this.size,
    required this.color,
    required this.alpha,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child:
          Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(alpha: alpha),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(
                begin: -22,
                end: 22,
                duration: Duration(seconds: seconds),
                curve: Curves.easeInOut,
              ),
    );
  }
}

/// Faint dot grid plus a top vignette — texture you notice only as polish.
class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 34.0;
    final dot = Paint()..color = Colors.white.withValues(alpha: 0.035);
    for (var y = spacing; y < size.height; y += spacing) {
      // Fade the grid out toward the bottom so it dissolves into the page.
      final fade = 1 - (y / size.height).clamp(0.0, 1.0);
      dot.color = Colors.white.withValues(alpha: 0.05 * fade);
      for (var x = spacing; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1, dot);
      }
    }

    final vignette = Paint()
      ..shader =
          RadialGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.35)],
            stops: const [0.55, 1.0],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.35),
              radius: math.max(size.width, size.height) * 0.75,
            ),
          );
    canvas.drawRect(Offset.zero & size, vignette);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
