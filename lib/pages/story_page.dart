import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/skill_tag.dart';

class StoryPage extends StatelessWidget {
  const StoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      color: AppColors.background,
      child: isMobile ? const _MobileStory() : const _DesktopStory(),
    );
  }
}

class _DesktopStory extends StatelessWidget {
  const _DesktopStory();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _BioPart()),
              const SizedBox(width: 60),
              Expanded(flex: 3, child: _PhotoCollage()),
            ],
          ),
          const SizedBox(height: 80),
          _SkillsSection(),
          const SizedBox(height: 80),
          _ExperienceSection(),
          const SizedBox(height: 80),
          _EducationSection(),
        ],
      ),
    );
  }
}

class _MobileStory extends StatelessWidget {
  const _MobileStory();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BioPart(),
          const SizedBox(height: 40),
          _PhotoCollage(),
          const SizedBox(height: 60),
          _SkillsSection(),
          const SizedBox(height: 60),
          _ExperienceSection(),
          const SizedBox(height: 60),
          _EducationSection(),
        ],
      ),
    );
  }
}

class _BioPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Story',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 48 : 72,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            height: 0.95,
            letterSpacing: -2,
          ),
        ).animate().fadeIn(duration: 600.ms),
        const SizedBox(height: 32),
        Text(
          "I don't have dark secrets, only bright ones.",
          style: GoogleFonts.inter(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
            height: 1.3,
          ),
        ).animate().fadeIn(delay: 150.ms, duration: 600.ms),
        const SizedBox(height: 20),
        Text(
          "I'm a Flutter developer and final-year CS student at JUIT, shipping cross-platform apps "
          'that feel great on both iOS and Android. From revamped onboarding flows to app-wide '
          'localization, I care deeply about every detail that makes an app a pleasure to use.',
          style: GoogleFonts.inter(fontSize: isMobile ? 15 : 17, color: AppColors.inkLight, height: 1.7),
        ).animate().fadeIn(delay: 250.ms, duration: 600.ms),
        const SizedBox(height: 16),
        Text(
          "I'm currently a Flutter Intern at Apna Mart, and have built features at Ente and "
          'Imagined. When I\'m not writing Dart, I\'m contributing to open source — from CCExtractor\'s '
          'Ultimate Alarm Clock to the encrypted photo app at Ente.',
          style: GoogleFonts.inter(fontSize: isMobile ? 15 : 17, color: AppColors.inkLight, height: 1.7),
        ).animate().fadeIn(delay: 350.ms, duration: 600.ms),
      ],
    );
  }
}

class _PhotoCollage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 10,
            child: _PolaroidCard(
              emoji: '📱',
              caption: 'Building cool stuff',
              rotation: -6,
              color: const Color(0xFFE8F4FD),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
          ),
          Positioned(
            right: 10,
            top: 0,
            child: _PolaroidCard(
              emoji: '🚀',
              caption: 'Shipping features',
              rotation: 5,
              color: const Color(0xFFFFF3E0),
            ).animate().fadeIn(delay: 550.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
          ),
          Positioned(
            left: 60,
            bottom: 0,
            child: _PolaroidCard(
              emoji: '☕',
              caption: 'Fueled by coffee',
              rotation: 3,
              color: const Color(0xFFF3E5F5),
            ).animate().fadeIn(delay: 700.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
          ),
        ],
      ),
    );
  }
}

class _PolaroidCard extends StatelessWidget {
  final String emoji;
  final String caption;
  final double rotation;
  final Color color;

  const _PolaroidCard({
    required this.emoji,
    required this.caption,
    required this.rotation,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation * 3.14159 / 180,
      child: Container(
        width: 150,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.stroke),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              caption,
              style: GoogleFonts.pacifico(fontSize: 12, color: AppColors.ink),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What I do',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: kSkills
                .asMap()
                .entries
                .map((e) => SkillTag(label: e.value, colorIndex: e.key)
                    .animate()
                    .fadeIn(delay: (e.key * 60).ms, duration: 400.ms)
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)))
                .toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms);
  }
}

class _ExperienceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 36 : 56,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: -1,
          ),
        ).animate().fadeIn(duration: 600.ms),
        const SizedBox(height: 32),
        ...kExperiences.asMap().entries.map(
              (e) => _ExperienceCard(exp: e.value)
                  .animate()
                  .fadeIn(delay: (e.key * 150).ms, duration: 500.ms)
                  .slideY(begin: 0.1, end: 0),
            ),
      ],
    );
  }
}

class _EducationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Education',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 36 : 56,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: -1,
          ),
        ).animate().fadeIn(duration: 600.ms),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kEducation.institution,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${kEducation.degree}  ·  ${kEducation.detail}',
                      style: GoogleFonts.inter(fontSize: 15, color: AppColors.inkLight, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.heroYellow.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: AppColors.heroYellow.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  kEducation.period,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.heroYellow),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 150.ms, duration: 500.ms).slideY(begin: 0.1, end: 0),
      ],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final Experience exp;
  const _ExperienceCard({required this.exp});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exp.role,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exp.company,
                      style: GoogleFonts.inter(fontSize: 15, color: AppColors.inkLight),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.heroYellow.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: AppColors.heroYellow.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  exp.period,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.heroYellow),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            exp.description,
            style: GoogleFonts.inter(fontSize: 15, color: AppColors.inkLight, height: 1.6),
          ),
          const SizedBox(height: 16),
          ...exp.highlights.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7, right: 10),
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: AppColors.inkLight,
                    ),
                  ),
                  Expanded(
                    child: Text(h, style: GoogleFonts.inter(fontSize: 15, color: AppColors.inkLight, height: 1.5)),
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
