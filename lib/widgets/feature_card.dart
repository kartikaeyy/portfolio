import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import 'media.dart';

class FeatureCard extends StatefulWidget {
  final Feature feature;
  final VoidCallback onTap;

  const FeatureCard({super.key, required this.feature, required this.onTap});

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = Color(
      int.parse(widget.feature.accentColor.replaceFirst('#', '0xFF')),
    );
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.cardHover : AppColors.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _hovered
                  ? accent.withValues(alpha: 0.45)
                  : AppColors.stroke,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.28),
                      blurRadius: 40,
                      spreadRadius: -4,
                      offset: const Offset(0, 16),
                    ),
                  ]
                : const [],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Wide cards (desktop): phone on the left, content beside it.
              // Narrow cards: phone on top, content stacked below.
              final wide = constraints.maxWidth >= 480;
              return wide
                  ? _WideLayout(
                      feature: widget.feature,
                      accent: accent,
                      hovered: _hovered,
                    )
                  : _TallLayout(
                      feature: widget.feature,
                      accent: accent,
                      hovered: _hovered,
                    );
            },
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────── Tall (mobile) ───────────────────────────────

class _TallLayout extends StatelessWidget {
  final Feature feature;
  final Color accent;
  final bool hovered;
  const _TallLayout({
    required this.feature,
    required this.accent,
    required this.hovered,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _MediaPanel(
              feature: feature,
              accent: accent,
              showChips: true,
            ),
          ),
        ),
        _CardFooter(feature: feature, hovered: hovered),
      ],
    );
  }
}

// ────────────────────────────── Wide (desktop) ───────────────────────────────

class _WideLayout extends StatelessWidget {
  final Feature feature;
  final Color accent;
  final bool hovered;
  const _WideLayout({
    required this.feature,
    required this.accent,
    required this.hovered,
  });

  @override
  Widget build(BuildContext context) {
    const outer = 14.0;
    return Padding(
      padding: const EdgeInsets.all(outer),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 500,
            child: _MediaPanel(
              feature: feature,
              accent: accent,
              showChips: false,
            ),
          ),
          const SizedBox(width: 26),
          Expanded(
            child: _WideContent(
              feature: feature,
              accent: accent,
              hovered: hovered,
            ),
          ),
        ],
      ),
    );
  }
}

class _WideContent extends StatelessWidget {
  final Feature feature;
  final Color accent;
  final bool hovered;
  const _WideContent({
    required this.feature,
    required this.accent,
    required this.hovered,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              _AppIcon(color: feature.accentColor),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      feature.context,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            feature.tagline,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.inkLight,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: feature.techStack
                .map((t) => _TechChip(label: t, subtle: true))
                .toList(),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View feature',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: hovered ? 0.125 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Shared media + footer ───────────────────────────

/// Accent-gradient panel with the portrait phone-framed preview centered on it.
class _MediaPanel extends StatelessWidget {
  final Feature feature;
  final Color accent;
  final bool showChips;
  const _MediaPanel({
    required this.feature,
    required this.accent,
    required this.showChips,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.16),
                  accent.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: PhoneFrame(
                      child: MediaView(
                        video: feature.previewVideo,
                        image: feature.thumbnailImage,
                        accent: accent,
                        autoPlay: true,
                      ),
                    ),
                  ),
                ),
                if (showChips) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: feature.techStack
                        .take(3)
                        .map((t) => _TechChip(label: t))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.strokeStrong),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_outward_rounded,
                    size: 14,
                    color: AppColors.ink,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardFooter extends StatelessWidget {
  final Feature feature;
  final bool hovered;
  const _CardFooter({required this.feature, required this.hovered});

  @override
  Widget build(BuildContext context) {
    final accent = Color(
      int.parse(feature.accentColor.replaceFirst('#', '0xFF')),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AppIcon(color: feature.accentColor),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      feature.context,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedRotation(
                turns: hovered ? 0.125 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            feature.shortDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.inkLight,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  final String color;
  const _AppIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    final c = Color(int.parse(color.replaceFirst('#', '0xFF')));
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Icon(Icons.auto_awesome_rounded, color: c, size: 22),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  final bool subtle;
  const _TechChip({required this.label, this.subtle = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: subtle ? 0.05 : 0.08),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
    );
  }
}
