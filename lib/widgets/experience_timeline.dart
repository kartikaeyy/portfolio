import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import 'reveal.dart';

/// The roles behind the shipped work — a timeline rail, one card per role, with
/// long highlight lists collapsed. Lives next to the Work carousel so the
/// features and the jobs that produced them read as one story.
class ExperienceTimeline extends StatelessWidget {
  const ExperienceTimeline({super.key});

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
              Eyebrow(label: 'Where I have worked'),
              SizedBox(height: Space.md),
              SectionTitle('Experience', minSize: 34, maxSize: 56),
            ],
          ),
        ),
        SizedBox(height: isMobile ? Space.lg : Space.xl),
        for (var i = 0; i < kExperiences.length; i++)
          Reveal(
            delay: Duration(milliseconds: 90 * i),
            child: _TimelineRow(
              exp: kExperiences[i],
              isLast: i == kExperiences.length - 1,
            ),
          ),
      ],
    );
  }
}

/// A timeline rail + card. The rail gives the three roles an order at a glance,
/// which a stack of identical cards did not.
class _TimelineRow extends StatelessWidget {
  final Experience exp;
  final bool isLast;

  const _TimelineRow({required this.exp, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    final railWidth = isMobile ? 26.0 : 40.0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: railWidth,
            child: Column(
              children: [
                const SizedBox(height: 26),
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.heroYellow,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.glowYellow.withValues(alpha: 0.5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 1.5,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.heroYellow.withValues(alpha: 0.35),
                          isLast
                              ? Colors.transparent
                              : Colors.white.withValues(alpha: 0.08),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isMobile ? Space.md : Space.md),
              child: _ExperienceCard(exp: exp),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final Experience exp;
  const _ExperienceCard({required this.exp});

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    final exp = widget.exp;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: Motion.base,
        curve: Motion.curve,
        padding: EdgeInsets.all(isMobile ? 20 : 28),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.cardHover.withValues(alpha: 0.75)
              : AppColors.cardBg.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(Radii.card),
          border: Border.all(
            color: _hovered ? AppColors.strokeStrong : AppColors.stroke,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _hovered ? 0.4 : 0.25),
              blurRadius: _hovered ? 38 : 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CompanyMark(exp: exp),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exp.role,
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 17 : 19,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        exp.company,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.inkLight,
                        ),
                      ),
                      if (isMobile) ...[
                        const SizedBox(height: 10),
                        PeriodPill(text: exp.period),
                      ],
                    ],
                  ),
                ),
                if (!isMobile) PeriodPill(text: exp.period),
              ],
            ),
            const SizedBox(height: Space.md),
            Text(
              exp.description,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 14.5 : 15.5,
                color: AppColors.inkLight,
                height: 1.65,
              ),
            ),
            const SizedBox(height: Space.md),
            _Highlights(items: exp.highlights),
          ],
        ),
      ),
    );
  }
}

/// The company's real logo in a rounded tile, falling back to a monogram if the
/// asset is missing so a card never renders a broken image.
class _CompanyMark extends StatelessWidget {
  final Experience exp;
  const _CompanyMark({required this.exp});

  static const _size = 44.0;

  @override
  Widget build(BuildContext context) {
    final logo = exp.logoAsset;
    return Container(
      width: _size,
      height: _size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: AppColors.strokeStrong),
      ),
      child: logo == null
          ? _Monogram(label: exp.company)
          : ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.asset(
                logo,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
                semanticLabel: '${exp.company} logo',
                errorBuilder: (_, _, _) => _Monogram(label: exp.company),
              ),
            ),
    );
  }
}

/// Company initial in a tinted square — the stand-in when there is no mark.
class _Monogram extends StatelessWidget {
  final String label;
  const _Monogram({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.heroYellow.withValues(alpha: 0.22),
            AppColors.heroYellow.withValues(alpha: 0.06),
          ],
        ),
      ),
      child: Center(
        child: Text(
          label.characters.first.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.heroYellow,
          ),
        ),
      ),
    );
  }
}

class PeriodPill extends StatelessWidget {
  final String text;
  const PeriodPill({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final current = text.toLowerCase().contains('present');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: (current ? AppColors.live : AppColors.heroYellow).withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(Radii.chip),
        border: Border.all(
          color: (current ? AppColors.live : AppColors.heroYellow).withValues(
            alpha: 0.3,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (current) ...[
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.live,
              ),
            ),
            const SizedBox(width: 7),
          ],
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: current ? AppColors.live : AppColors.heroYellow,
            ),
          ),
        ],
      ),
    );
  }
}

/// Highlight bullets, collapsed to a readable few. The current role has ten of
/// them; showing all by default turned the card into a wall of text.
class _Highlights extends StatefulWidget {
  final List<String> items;
  const _Highlights({required this.items});

  static const _collapsedCount = 4;

  @override
  State<_Highlights> createState() => _HighlightsState();
}

class _HighlightsState extends State<_Highlights> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final hidden = items.length - _Highlights._collapsedCount;
    final visible = _expanded || hidden <= 0
        ? items
        : items.take(_Highlights._collapsedCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: Motion.base,
          curve: Motion.emphasized,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [for (final h in visible) _Bullet(text: h)],
          ),
        ),
        if (hidden > 0) ...[
          const SizedBox(height: Space.xs),
          _TextToggle(
            label: _expanded ? 'Show less' : 'Show $hidden more',
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
        ],
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 12),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.heroYellow.withValues(alpha: 0.7),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14.5,
                color: AppColors.inkLight,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextToggle extends StatefulWidget {
  final String label;
  final bool expanded;
  final VoidCallback onTap;

  const _TextToggle({
    required this.label,
    required this.expanded,
    required this.onTap,
  });

  @override
  State<_TextToggle> createState() => _TextToggleState();
}

class _TextToggleState extends State<_TextToggle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: _hovered
                      ? AppColors.heroYellowLight
                      : AppColors.heroYellow,
                  decoration: _hovered
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: AppColors.heroYellowLight,
                ),
              ),
              const SizedBox(width: 4),
              AnimatedRotation(
                duration: Motion.base,
                turns: widget.expanded ? 0.5 : 0,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: _hovered
                      ? AppColors.heroYellowLight
                      : AppColors.heroYellow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
