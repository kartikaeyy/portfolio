import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _tagColors = [
  Color(0xFFB8E0FF),
  Color(0xFFB5F5C8),
  Color(0xFFFFE5A0),
  Color(0xFFE8C6FF),
  Color(0xFFFFD4B8),
  Color(0xFFC8F0E8),
];

class SkillTag extends StatelessWidget {
  final String label;
  final int colorIndex;

  const SkillTag({super.key, required this.label, required this.colorIndex});

  @override
  Widget build(BuildContext context) {
    final color = _tagColors[colorIndex % _tagColors.length];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
