import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      color: AppColors.background,
      child: isMobile ? const _MobileChat() : const _DesktopChat(),
    );
  }
}

class _DesktopChat extends StatelessWidget {
  const _DesktopChat();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            "Let's build something\namazing together.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 72,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              height: 0.95,
              letterSpacing: -2,
            ),
          ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.15, end: 0),
          const SizedBox(height: 80),
          _GlowConnectButton(),
          const SizedBox(height: 80),
          _ContactFooter(),
        ],
      ),
    );
  }
}

class _MobileChat extends StatelessWidget {
  const _MobileChat();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            "Let's build something amazing.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              height: 1.0,
              letterSpacing: -1.5,
            ),
          ).animate().fadeIn(duration: 700.ms),
          const SizedBox(height: 60),
          _GlowConnectButton(),
          const SizedBox(height: 60),
          _ContactFooter(),
        ],
      ),
    );
  }
}

class _GlowConnectButton extends StatefulWidget {
  const _GlowConnectButton();

  @override
  State<_GlowConnectButton> createState() => _GlowConnectButtonState();
}

class _GlowConnectButtonState extends State<_GlowConnectButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, child) => MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse('mailto:$kEmail')),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow
              Container(
                width: _hovered ? 340 : 300,
                height: _hovered ? 140 : 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.glowYellow.withValues(alpha: 0.3 * _pulseAnim.value),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                    BoxShadow(
                      color: AppColors.glowYellow.withValues(alpha: 0.15 * _pulseAnim.value),
                      blurRadius: 100,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
              // Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _hovered ? 320 : 280,
                height: _hovered ? 100 : 88,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF4A3F00),
                      const Color(0xFF2A2200),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    color: AppColors.glowYellow.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.glowYellow.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Connect',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heroYellow,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 700.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          curve: Curves.elasticOut,
        );
  }
}

class _ContactFooter extends StatelessWidget {
  const _ContactFooter();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stroke),
      ),
      child: isMobile
          ? Column(
              children: [
                _EmailRow(),
                const SizedBox(height: 20),
                _SocialRow(),
              ],
            )
          : Row(
              children: [
                _EmailRow(),
                const Spacer(),
                _SocialRow(),
              ],
            ),
    ).animate().fadeIn(delay: 500.ms, duration: 600.ms);
  }
}

class _EmailRow extends StatefulWidget {
  @override
  State<_EmailRow> createState() => _EmailRowState();
}

class _EmailRowState extends State<_EmailRow> {
  bool _copied = false;

  void _copy() async {
    await Clipboard.setData(const ClipboardData(text: kEmail));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copy,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _copied ? Icons.check_circle_outline : Icons.send_outlined,
            size: 20,
            color: AppColors.ink,
          ),
          const SizedBox(width: 10),
          Text(
            _copied ? 'Copied!' : kEmail,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socials = [
      (icon: Icons.code, url: kGithub, label: 'GitHub'),
      (icon: Icons.work_outline, url: kLinkedin, label: 'LinkedIn'),
      (icon: Icons.alternate_email, url: 'mailto:$kEmail', label: 'Email'),
      (icon: Icons.call_outlined, url: 'tel:$kPhone', label: 'Phone'),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: socials.map((s) => _SocialIcon(icon: s.icon, url: s.url)).toList(),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  const _SocialIcon({required this.icon, required this.url});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(left: 8),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _hovered ? AppColors.heroYellow : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: _hovered ? Colors.transparent : AppColors.strokeStrong,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: _hovered ? AppColors.background : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
