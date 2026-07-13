import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class HeyPage extends StatelessWidget {
  const HeyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return isMobile ? const _MobileHero() : const _DesktopHero();
  }
}

class _DesktopHero extends StatelessWidget {
  const _DesktopHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF352E12),
            Color(0xFF17151A),
            AppColors.background,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          _DecorativeElements(),
          Padding(
            padding: const EdgeInsets.fromLTRB(80, 120, 80, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                      'Crafting apps that\npeople love to use.',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inkLight,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 24),
                Text(
                      'Kartikey\nSrivastava',
                      style: GoogleFonts.inter(
                        fontSize: 110,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        height: 0.9,
                        letterSpacing: -4,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 800.ms)
                    .slideY(begin: 0.15, end: 0),
                const SizedBox(height: 40),
                _RoleTags(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileHero extends StatelessWidget {
  const _MobileHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF352E12),
            Color(0xFF17151A),
            AppColors.background,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          _DecorativeElements(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 100, 24, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
                  'Crafting apps that\npeople love to use.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.inkLight,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                const SizedBox(height: 16),
                Text(
                  'Kartikey\nSrivastava',
                  style: GoogleFonts.inter(
                    fontSize: 64,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    height: 0.92,
                    letterSpacing: -2,
                  ),
                ).animate().fadeIn(delay: 100.ms, duration: 800.ms),
                const SizedBox(height: 32),
                _RoleTags(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleTags extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tags = ['Flutter', 'Dart', 'iOS & Android'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: tags
          .asMap()
          .entries
          .map(
            (e) => _RoleChip(label: e.value)
                .animate()
                .fadeIn(delay: (300 + e.key * 80).ms, duration: 400.ms)
                .slideX(begin: -0.1, end: 0),
          )
          .toList(),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  const _RoleChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.strokeStrong),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

class _DecorativeElements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: _ScribblePainter()));
  }
}

class _ScribblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Bottom squiggle
    final path1 = Path();
    path1.moveTo(size.width * 0.05, size.height * 0.85);
    path1.cubicTo(
      size.width * 0.12,
      size.height * 0.82,
      size.width * 0.18,
      size.height * 0.88,
      size.width * 0.25,
      size.height * 0.85,
    );
    path1.cubicTo(
      size.width * 0.32,
      size.height * 0.82,
      size.width * 0.38,
      size.height * 0.88,
      size.width * 0.45,
      size.height * 0.85,
    );
    canvas.drawPath(path1, paint);

    // Top right decorative curve
    final paint2 = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path2 = Path();
    path2.moveTo(size.width * 0.75, size.height * 0.1);
    path2.cubicTo(
      size.width * 0.8,
      size.height * 0.08,
      size.width * 0.85,
      size.height * 0.12,
      size.width * 0.9,
      size.height * 0.1,
    );
    canvas.drawPath(path2, paint2);

    // Star dots
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.3),
      4,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.92, size.height * 0.35),
      3,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.38),
      2.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
