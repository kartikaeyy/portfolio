import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import 'actions.dart';

/// Floating glass nav. Every breakpoint gets the same segmented pill with a
/// sliding indicator — the old phone layout hid the sections behind a "Menu"
/// sheet and showed a sun icon that toggled nothing.
class PortfolioNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isMobile;

  /// True once the page has scrolled off the hero — the bar deepens its
  /// backdrop so labels stay readable over content.
  final bool elevated;

  const PortfolioNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isMobile = false,
    this.elevated = false,
  });

  static const labels = ['Hey', 'Work', 'Story', 'Chat'];

  @override
  Widget build(BuildContext context) {
    final hPad = isMobile ? 13.0 : 20.0;
    final labelStyle = GoogleFonts.inter(
      fontSize: isMobile ? 14 : 15,
      fontWeight: FontWeight.w600,
    );

    var widest = 0.0;
    for (final l in labels) {
      final tp = TextPainter(
        text: TextSpan(text: l, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      widest = widest > tp.width ? widest : tp.width;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        // Never let the pill run past the screen on small phones.
        final maxTab =
            (available - 2 * Layout.sidePad(context) - 12) / labels.length;
        final tabWidth = (widest + hPad * 2).clamp(
          56.0,
          maxTab.clamp(56.0, 200.0),
        );
        final tabHeight = isMobile ? 38.0 : 40.0;

        return ClipRRect(
          borderRadius: BorderRadius.circular(Radii.chip),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: AnimatedContainer(
              duration: Motion.base,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.navBg.withValues(alpha: elevated ? 0.82 : 0.6),
                borderRadius: BorderRadius.circular(Radii.chip),
                border: Border.all(
                  color: elevated ? AppColors.strokeStrong : AppColors.stroke,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: elevated ? 0.55 : 0.35,
                    ),
                    blurRadius: elevated ? 34 : 22,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: tabWidth * labels.length,
                    height: tabHeight,
                    child: Stack(
                      children: [
                        // Sliding pill — one indicator that travels between
                        // tabs instead of four blocks flicking on and off.
                        AnimatedPositioned(
                          duration: Motion.base,
                          curve: Motion.emphasized,
                          left: tabWidth * currentIndex,
                          top: 0,
                          bottom: 0,
                          width: tabWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.navActive,
                              borderRadius: BorderRadius.circular(Radii.chip),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.glowYellow.withValues(
                                    alpha: 0.28,
                                  ),
                                  blurRadius: 18,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            for (var i = 0; i < labels.length; i++)
                              _NavTab(
                                label: labels[i],
                                width: tabWidth,
                                height: tabHeight,
                                active: i == currentIndex,
                                style: labelStyle,
                                onTap: () => onTap(i),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isMobile) ...[
                    Container(
                      width: 1,
                      height: 22,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: AppColors.stroke,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: IconAction(
                        icon: const Glyph.material(Icons.mail_outline_rounded),
                        tooltip: 'Email $kEmail',
                        size: 34,
                        onPressed: () => launchUrl(Uri.parse('mailto:$kEmail')),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavTab extends StatelessWidget {
  final String label;
  final double width;

  /// Matches the indicator track's height so the label centres against the
  /// sliding pill instead of shrink-wrapping to the top of the track.
  final double height;
  final bool active;
  final TextStyle style;
  final VoidCallback onTap;

  const _NavTab({
    required this.label,
    required this.width,
    required this.height,
    required this.active,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPressed: onTap,
      semanticLabel: '$label section',
      builder: (context, hovered, focused) => SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Hover wash sits under the label but over the page, so inactive
            // tabs still answer the cursor.
            Positioned.fill(
              child: AnimatedOpacity(
                duration: Motion.fast,
                opacity: !active && (hovered || focused) ? 1 : 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Radii.chip),
                    border: focusRing(focused),
                  ),
                ),
              ),
            ),
            AnimatedDefaultTextStyle(
              duration: Motion.base,
              style: style.copyWith(
                height: 1,
                color: active
                    ? AppColors.background
                    : (hovered ? AppColors.ink : AppColors.inkLight),
              ),
              child: Text(label, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
