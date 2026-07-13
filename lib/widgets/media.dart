import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';

/// Aspect ratio of a modern iPhone screen recording (portrait). All feature
/// videos are iOS captures, so media is framed to this ratio everywhere.
const double kPhoneAspect = 9 / 19.5;

/// Wraps portrait media (video / image) in an iPhone-style device frame —
/// dark bezel, rounded screen, a soft shadow and a subtle top island. Keeps
/// vertical iOS screen recordings looking native instead of cropped.
class PhoneFrame extends StatelessWidget {
  final Widget child;
  final double aspectRatio;
  const PhoneFrame({super.key, required this.child, this.aspectRatio = kPhoneAspect});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: RepaintBoundary(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0F),
            borderRadius: BorderRadius.circular(38),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 32,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(33),
            child: Stack(
              fit: StackFit.expand,
              children: [
                child,
                // Dynamic-island style pill.
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      width: 54,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// video_player only ships iOS / Android / web implementations. On desktop
/// (macOS / Windows / Linux) creating a controller throws, so we guard and
/// fall back to the poster image / styled mockup instead of crashing.
bool get _videoSupported =>
    kIsWeb ||
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

/// Renders a feature's media with graceful fallbacks:
///   video (where supported) → poster image → styled accent mockup.
///
/// [autoPlay] = true drives the card thumbnail (muted, looping, no controls).
/// [autoPlay] = false drives the detail page (poster + tap-to-play controls).
class MediaView extends StatefulWidget {
  final String? video;
  final String? image;
  final Color accent;
  final bool autoPlay;
  final BoxFit fit;

  const MediaView({
    super.key,
    this.video,
    this.image,
    required this.accent,
    this.autoPlay = false,
    this.fit = BoxFit.cover,
  });

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _playing = false;

  bool get _hasVideo => widget.video != null && _videoSupported;

  @override
  void initState() {
    super.initState();
    if (_hasVideo) _setupController();
  }

  void _setupController() {
    final src = widget.video!;
    final controller = MediaSource.isNetwork(src)
        ? VideoPlayerController.networkUrl(Uri.parse(src))
        : VideoPlayerController.asset(src);
    _controller = controller;

    controller.initialize().then((_) {
      if (!mounted) return;
      controller.setLooping(true);
      if (widget.autoPlay) {
        controller.setVolume(0); // muted autoplay for card previews
        controller.play();
        _playing = true;
      }
      setState(() => _initialized = true);
    }).catchError((_) {
      // Codec/network failure — fall through to poster/mockup.
      if (mounted) setState(() => _initialized = false);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final c = _controller;
    if (c == null || !_initialized) return;
    setState(() {
      if (c.value.isPlaying) {
        c.pause();
        _playing = false;
      } else {
        c.play();
        _playing = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Video ready → show it (isolated so its frames don't repaint siblings).
    if (_hasVideo && _initialized && _controller != null) {
      return RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: widget.fit,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
            if (!widget.autoPlay)
              _PlayOverlay(playing: _playing, accent: widget.accent, onTap: _togglePlay),
          ],
        ),
      );
    }

    // 2. Poster image (also the loading state while a video initializes).
    if (widget.image != null) {
      return _MediaImage(path: widget.image!, fit: widget.fit);
    }

    // 3. No media supplied → styled accent mockup.
    return _MediaFallback(accent: widget.accent);
  }
}

/// Loads an image/GIF from an asset or network URL, decoded at a sane size.
class _MediaImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  const _MediaImage({required this.path, required this.fit});

  @override
  Widget build(BuildContext context) {
    const decodeWidth = 1000; // cap decode cost; ~2x typical card/hero width
    final Widget image = MediaSource.isNetwork(path)
        ? Image.network(
            path,
            fit: fit,
            cacheWidth: decodeWidth,
            errorBuilder: (_, _, _) => const _MediaFallback(accent: AppColors.inkLight),
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : const ColoredBox(color: AppColors.cardBg),
          )
        : Image.asset(
            path,
            fit: fit,
            cacheWidth: decodeWidth,
            errorBuilder: (_, _, _) => const _MediaFallback(accent: AppColors.inkLight),
          );
    return image;
  }
}

/// Play / pause affordance for the detail-page video.
class _PlayOverlay extends StatelessWidget {
  final bool playing;
  final Color accent;
  final VoidCallback onTap;
  const _PlayOverlay({required this.playing, required this.accent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: playing ? 0.0 : 1.0,
          child: Container(
            color: Colors.black.withValues(alpha: 0.15),
            alignment: Alignment.center,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 16),
                ],
              ),
              child: Icon(Icons.play_arrow_rounded, color: accent, size: 40),
            ),
          ),
        ),
      ),
    );
  }
}

/// Styled placeholder shown when a project has no image or video yet.
class _MediaFallback extends StatelessWidget {
  final Color accent;
  const _MediaFallback({required this.accent});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withValues(alpha: 0.18), accent.withValues(alpha: 0.05)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone_iphone_rounded, color: accent.withValues(alpha: 0.55), size: 44),
            const SizedBox(height: 10),
            Text(
              'Media coming soon',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: accent.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
