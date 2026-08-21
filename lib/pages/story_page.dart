import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/experience_timeline.dart';
import '../widgets/reveal.dart';
import '../widgets/skill_tag.dart';

class StoryPage extends StatelessWidget {
  const StoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    final gap = isMobile ? Space.xxl : 96.0;

    return Container(
      color: AppColors.background,
      child: ContentFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Reveal(child: _StoryHeader()),
            SizedBox(height: isMobile ? Space.xl : 56),
            if (isMobile)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Reveal(child: _Bio()),
                  SizedBox(height: Space.xl),
                  Reveal(delay: Duration(milliseconds: 120), child: _Collage()),
                ],
              )
            else
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: Reveal(child: _Bio())),
                  SizedBox(width: 56),
                  Expanded(
                    flex: 5,
                    child: Reveal(
                      delay: Duration(milliseconds: 140),
                      child: _Collage(),
                    ),
                  ),
                ],
              ),
            SizedBox(height: gap),
            const Reveal(child: _Toolkit()),
            SizedBox(height: gap),
            const _EducationSection(),
          ],
        ),
      ),
    );
  }
}

class _StoryHeader extends StatelessWidget {
  const _StoryHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Eyebrow(label: 'About me'),
        SizedBox(height: Space.md),
        SectionTitle('My Story'),
      ],
    );
  }
}

class _Bio extends StatelessWidget {
  const _Bio();

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    final body = GoogleFonts.inter(
      fontSize: isMobile ? 15 : 16.5,
      color: AppColors.inkLight,
      height: 1.75,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: Layout.maxProse),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "I don't have dark secrets, only bright ones.",
            style: GoogleFonts.inter(
              fontSize: isMobile ? 20 : 23,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              height: 1.35,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: Space.md),
          Text(
            "I'm a Flutter developer and final-year CS student at JUIT, shipping "
            'cross-platform apps that feel great on both iOS and Android. From '
            'revamped onboarding flows to app-wide localization, I care deeply '
            'about every detail that makes an app a pleasure to use.',
            style: body,
          ),
          const SizedBox(height: Space.sm),
          Text(
            "I'm currently a Flutter Intern at Apna Mart, and have built features "
            "at Ente and Imagined. When I'm not writing Dart, I'm contributing to "
            "open source — from CCExtractor's Ultimate Alarm Clock to the "
            'encrypted photo app at Ente.',
            style: body,
          ),
        ],
      ),
    );
  }
}

// ── Collage ───────────────────────────────────────────────────────────────────

class _Collage extends StatelessWidget {
  const _Collage();

  @override
  Widget build(BuildContext context) {
    // Fixed-size cluster, centred in whatever column it lands in — absolute
    // left/right offsets against a full-width box left the cards scattered
    // with a hole in the middle.
    return Center(
      child: SizedBox(
        width: 360,
        height: 376,
        child: Stack(
          clipBehavior: Clip.none,
          children: const [
            Positioned(
              left: 0,
              top: 0,
              child: _Polaroid(
                icon: Icons.phone_iphone_rounded,
                caption: 'Building cool stuff',
                rotation: -7,
                tint: Color(0xFF6EC1FF),
              ),
            ),
            Positioned(
              right: 0,
              top: 22,
              child: _Polaroid(
                icon: Icons.rocket_launch_rounded,
                caption: 'Shipping features',
                rotation: 6,
                tint: Color(0xFFFFB86B),
              ),
            ),
            Positioned(
              left: 84,
              top: 202,
              child: _Polaroid(
                icon: Icons.local_cafe_rounded,
                caption: 'Fuelled by coffee',
                rotation: 3,
                tint: Color(0xFFC79BFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tilted photo card that straightens and lifts under the cursor — the tiny
/// bit of play the rest of the page keeps restrained.
class _Polaroid extends StatefulWidget {
  final IconData icon;
  final String caption;
  final double rotation;
  final Color tint;

  const _Polaroid({
    required this.icon,
    required this.caption,
    required this.rotation,
    required this.tint,
  });

  @override
  State<_Polaroid> createState() => _PolaroidState();
}

class _PolaroidState extends State<_Polaroid> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: _hovered ? 1 : 0),
        duration: Motion.base,
        curve: Motion.curve,
        builder: (context, t, child) => Transform.translate(
          offset: Offset(0, -10 * t),
          child: Transform.rotate(
            angle: rad(widget.rotation * (1 - t)),
            child: child,
          ),
        ),
        child: Container(
          width: 150,
          padding: const EdgeInsets.fromLTRB(11, 11, 11, 9),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1D24),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _hovered
                  ? widget.tint.withValues(alpha: 0.4)
                  : AppColors.stroke,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _hovered ? 0.55 : 0.4),
                blurRadius: _hovered ? 34 : 22,
                offset: Offset(0, _hovered ? 16 : 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 108,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.tint.withValues(alpha: 0.46),
                      widget.tint.withValues(alpha: 0.16),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(widget.icon, size: 38, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.caption,
                style: GoogleFonts.pacifico(
                  fontSize: 12.5,
                  color: AppColors.ink.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Toolkit ───────────────────────────────────────────────────────────────────

class _Toolkit extends StatelessWidget {
  const _Toolkit();

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    return GlassPanel(
      padding: EdgeInsets.all(isMobile ? 24 : 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow(label: 'Toolkit'),
                    const SizedBox(height: Space.sm),
                    Text(
                      'What I build with',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 25 : 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${kSkills.length}',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 26 : 34,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink.withValues(alpha: 0.12),
                  height: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? Space.md : Space.lg),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var i = 0; i < kSkills.length; i++)
                SkillTag(label: kSkills[i], colorIndex: i),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Education ─────────────────────────────────────────────────────────────────

class _EducationSection extends StatelessWidget {
  const _EducationSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Reveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(label: 'Studies'),
              SizedBox(height: Space.md),
              SectionTitle('Education', minSize: 34, maxSize: 56),
            ],
          ),
        ),
        SizedBox(height: isMobile ? Space.lg : Space.xl),
        Reveal(
          delay: const Duration(milliseconds: 80),
          child: GlassPanel(
            padding: EdgeInsets.all(isMobile ? 22 : 28),
            radius: Radii.card,
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _EducationIcon(),
                      const SizedBox(height: Space.md),
                      const _EducationText(),
                      const SizedBox(height: Space.md),
                      PeriodPill(text: kEducation.period),
                    ],
                  )
                : Row(
                    children: [
                      const _EducationIcon(),
                      const SizedBox(width: 18),
                      const Expanded(child: _EducationText()),
                      const SizedBox(width: 14),
                      PeriodPill(text: kEducation.period),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _EducationIcon extends StatelessWidget {
  const _EducationIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.heroYellow.withValues(alpha: 0.12),
        border: Border.all(color: AppColors.heroYellow.withValues(alpha: 0.26)),
      ),
      child: const Icon(
        Icons.school_rounded,
        size: 22,
        color: AppColors.heroYellow,
      ),
    );
  }
}

class _EducationText extends StatelessWidget {
  const _EducationText();

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kEducation.institution,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 17 : 19,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${kEducation.degree}  ·  ${kEducation.detail}',
          style: GoogleFonts.inter(
            fontSize: 14.5,
            color: AppColors.inkLight,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
