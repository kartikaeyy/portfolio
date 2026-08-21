import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Hue per skill, kept as a small dot instead of a filled pastel pill — the
/// solid pastels fought the dark page and made every tag shout equally loud.
const _dotColors = [
  Color(0xFF6EC1FF),
  Color(0xFF5FE3A1),
  Color(0xFFFFD866),
  Color(0xFFC79BFF),
  Color(0xFFFF9E6B),
  Color(0xFF61E0D2),
];

class SkillTag extends StatefulWidget {
  final String label;
  final int colorIndex;

  const SkillTag({super.key, required this.label, required this.colorIndex});

  @override
  State<SkillTag> createState() => _SkillTagState();
}

class _SkillTagState extends State<SkillTag> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final dot = _dotColors[widget.colorIndex % _dotColors.length];
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: Motion.fast,
        curve: Motion.curve,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: _hovered ? 0.09 : 0.045),
          borderRadius: BorderRadius.circular(Radii.chip),
          border: Border.all(
            color: _hovered ? dot.withValues(alpha: 0.55) : AppColors.stroke,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Motion.fast,
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dot,
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: dot.withValues(alpha: 0.6),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 9),
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: _hovered ? AppColors.ink : AppColors.inkLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
