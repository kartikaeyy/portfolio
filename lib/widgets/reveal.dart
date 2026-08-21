import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'section_scope.dart';

/// Fades + lifts its child in the first time it scrolls into view.
///
/// The whole site lives inside one long scroll view, so entrance animations
/// attached at build time all fire on load — by the time you reach the Story
/// section, everything has already animated. [Reveal] watches the page scroll
/// position instead and plays once, when the content is actually seen.
class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Distance in logical pixels the child travels upward as it appears.
  final double offsetY;

  /// How far up the viewport the child's top edge must reach before it plays,
  /// as a fraction of viewport height (0.9 ≈ just inside the bottom edge).
  final double trigger;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = Motion.reveal,
    this.offsetY = 26,
    this.trigger = 0.9,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  bool _shown = false;
  bool _scheduled = false;
  ScrollController? _controller;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = SectionScope.maybeOf(context)?.controller;
    if (next != _controller) {
      _controller?.removeListener(_check);
      _controller = next;
      _controller?.addListener(_check);
    }
    // Content that is already on screen (the first section) should not wait
    // for a scroll event to appear.
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (_scheduled || !mounted) return;
    // No page scroll to listen to (a preview, a test, an embedded use): show
    // the content rather than leaving it invisible forever.
    if (_controller == null) {
      _scheduled = true;
      setState(() => _shown = true);
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final viewport = MediaQuery.sizeOf(context).height;
    if (top > viewport * widget.trigger) return;

    _scheduled = true;
    _controller?.removeListener(_check);
    if (widget.delay == Duration.zero) {
      setState(() => _shown = true);
    } else {
      _timer = Timer(widget.delay, () {
        if (mounted) setState(() => _shown = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: _shown ? 1 : 0),
      duration: widget.duration,
      curve: Motion.curve,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0, 1),
        child: Transform.translate(
          offset: Offset(0, (1 - t) * widget.offsetY),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// Staggers a column of children so a list reveals as a wave rather than all
/// at once.
List<Widget> revealStagger(
  List<Widget> children, {
  Duration step = const Duration(milliseconds: 90),
  double offsetY = 26,
}) {
  return [
    for (var i = 0; i < children.length; i++)
      Reveal(delay: step * i, offsetY: offsetY, child: children[i]),
  ];
}
