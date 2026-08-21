import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/actions.dart';
import '../widgets/reveal.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    return Container(
      color: AppColors.background,
      child: ContentFrame(
        maxWidth: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Reveal(
              child: Center(child: Eyebrow(label: 'Contact')),
            ),
            SizedBox(height: isMobile ? Space.md : Space.md),
            Reveal(
              delay: const Duration(milliseconds: 60),
              child: SectionTitle(
                isMobile
                    ? "Let's build something amazing."
                    : "Let's build something\namazing together.",
                align: TextAlign.center,
                minSize: 36,
                maxSize: 66,
              ),
            ),
            SizedBox(height: isMobile ? Space.md : Space.md),
            Reveal(
              delay: const Duration(milliseconds: 120),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Text(
                  'Email is the fastest way to reach me. Happy to talk Flutter, '
                  'product detail or open source.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 15 : 16.5,
                    color: AppColors.inkLight,
                    height: 1.7,
                  ),
                ),
              ),
            ),
            SizedBox(height: isMobile ? Space.xl : 56),
            const Reveal(
              delay: Duration(milliseconds: 180),
              child: _PrimaryContactActions(),
            ),
            SizedBox(height: isMobile ? Space.xl : 64),
            const Reveal(
              delay: Duration(milliseconds: 240),
              child: _ContactCard(),
            ),
          ],
        ),
      ),
    );
  }
}

/// The page's one loud action, plus a quiet way to grab the address without
/// leaving the site. The old version was a single 300px glowing slab whose only
/// label was "Connect".
class _PrimaryContactActions extends StatelessWidget {
  const _PrimaryContactActions();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 14,
      runSpacing: 14,
      children: [
        _PulseGlow(
          child: ActionButton(
            label: 'Say hello',
            icon: Icons.arrow_outward_rounded,
            onPressed: () => launchUrl(Uri.parse('mailto:$kEmail')),
            tooltip: kEmail,
          ),
        ),
        const _CopyEmailButton(),
      ],
    );
  }
}

/// Slow breathing bloom behind the primary CTA — keeps the signature glow from
/// the first design without letting it swallow the layout.
class _PulseGlow extends StatefulWidget {
  final Widget child;
  const _PulseGlow({required this.child});

  @override
  State<_PulseGlow> createState() => _PulseGlowState();
}

class _PulseGlowState extends State<_PulseGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat(reverse: true);

  late final Animation<double> _pulse = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) => Bloom(
        intensity: 0.65 + 0.5 * _pulse.value,
        radius: Radii.chip,
        child: child!,
      ),
      child: widget.child,
    );
  }
}

class _CopyEmailButton extends StatefulWidget {
  const _CopyEmailButton();

  @override
  State<_CopyEmailButton> createState() => _CopyEmailButtonState();
}

class _CopyEmailButtonState extends State<_CopyEmailButton> {
  bool _copied = false;
  Timer? _reset;

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(const ClipboardData(text: kEmail));
    if (!mounted) return;
    setState(() => _copied = true);
    _reset?.cancel();
    _reset = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      label: _copied ? 'Copied!' : 'Copy email',
      icon: _copied ? Icons.check_rounded : Icons.content_copy_rounded,
      tone: ActionTone.ghost,
      tooltip: kEmail,
      onPressed: _copy,
    );
  }
}

/// Every channel spelled out. Bare icon circles left visitors guessing which
/// one was GitHub and which was a phone number.
class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    final isMobile = Breaks.isMobile(context);
    final channels = <_Channel>[
      _Channel(
        icon: const Glyph.material(Icons.alternate_email_rounded),
        label: 'Email',
        value: kEmail,
        url: 'mailto:$kEmail',
        copyValue: kEmail,
      ),
      _Channel(
        icon: const Glyph.material(Icons.call_outlined),
        label: 'Phone',
        value: kPhone,
        url: 'tel:$kPhone',
        copyValue: kPhone,
      ),
      _Channel(
        icon: const Glyph.brand(FontAwesomeIcons.github),
        label: 'GitHub',
        value: kGithub.replaceFirst('https://', ''),
        url: kGithub,
      ),
      _Channel(
        icon: const Glyph.brand(FontAwesomeIcons.linkedinIn),
        label: 'LinkedIn',
        value: kLinkedin.replaceFirst('https://', ''),
        url: kLinkedin,
      ),
    ];

    return GlassPanel(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = isMobile ? 1 : 2;
          final width = (constraints.maxWidth - (columns - 1) * 10) / columns;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final c in channels)
                SizedBox(
                  width: width,
                  child: _ChannelRow(channel: c),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Channel {
  final Glyph icon;
  final String label;
  final String value;
  final String url;
  final String? copyValue;

  const _Channel({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
    this.copyValue,
  });
}

class _ChannelRow extends StatefulWidget {
  final _Channel channel;
  const _ChannelRow({required this.channel});

  @override
  State<_ChannelRow> createState() => _ChannelRowState();
}

class _ChannelRowState extends State<_ChannelRow> {
  bool _copied = false;
  Timer? _reset;

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  Future<void> _copy(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    setState(() => _copied = true);
    _reset?.cancel();
    _reset = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.channel;
    return Pressable(
      onPressed: () => launchUrl(Uri.parse(c.url)),
      semanticLabel: '${c.label}: ${c.value}',
      builder: (context, hovered, focused) => AnimatedContainer(
        duration: Motion.fast,
        curve: Motion.curve,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: hovered ? 0.07 : 0.025),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: focused
                ? AppColors.heroYellow.withValues(alpha: 0.7)
                : (hovered ? AppColors.strokeStrong : AppColors.stroke),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hovered
                    ? AppColors.heroYellow.withValues(alpha: 0.16)
                    : Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: hovered
                      ? AppColors.heroYellow.withValues(alpha: 0.35)
                      : AppColors.stroke,
                ),
              ),
              child: c.icon.build(
                size: 17,
                color: hovered ? AppColors.heroYellow : AppColors.ink,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    c.label.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3,
                      color: AppColors.inkFaint,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _copied ? 'Copied to clipboard' : c.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _copied ? AppColors.live : AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (c.copyValue != null)
              IconAction(
                icon: Glyph.material(
                  _copied ? Icons.check_rounded : Icons.content_copy_rounded,
                ),
                tooltip: 'Copy ${c.label.toLowerCase()}',
                size: 32,
                onPressed: () => _copy(c.copyValue!),
              )
            else
              AnimatedSlide(
                duration: Motion.fast,
                offset: hovered ? const Offset(0.2, -0.2) : Offset.zero,
                child: Icon(
                  Icons.arrow_outward_rounded,
                  size: 18,
                  color: hovered ? AppColors.heroYellow : AppColors.inkFaint,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
