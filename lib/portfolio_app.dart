import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'theme/app_theme.dart';
import 'widgets/nav_bar.dart';
import 'pages/hey_page.dart';
import 'pages/work_page.dart';
import 'pages/story_page.dart';
import 'pages/chat_page.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartikey — Mobile Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const _PortfolioShell(),
    );
  }
}

class _PortfolioShell extends StatefulWidget {
  const _PortfolioShell();

  @override
  State<_PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<_PortfolioShell> {
  final _scrollController = ScrollController();
  final _sectionKeys = List.generate(4, (_) => GlobalKey());
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final viewportTop = _scrollController.offset;
    // A section is "active" once its top passes above this anchor line.
    // Picking the last section above the anchor is stable for the first and
    // last sections, unlike a nearest-to-midpoint check.
    final anchor = viewportTop + MediaQuery.of(context).size.height * 0.35;

    int active = 0;
    for (int i = 0; i < _sectionKeys.length; i++) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final pos = box.localToGlobal(Offset.zero);
      final sectionTop =
          pos.dy + viewportTop - MediaQuery.of(context).padding.top;
      if (sectionTop <= anchor) {
        active = i;
      } else {
        break;
      }
    }

    if (active != _activeIndex) {
      setState(() => _activeIndex = active);
    }
  }

  void _scrollToSection(int index) {
    final ctx = _sectionKeys[index].currentContext;
    if (ctx == null) return;
    // Highlight the tapped tab immediately, even if the scroll barely moves
    // (e.g. tapping "Hey" while already at the top).
    if (index != _activeIndex) setState(() => _activeIndex = index);
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      alignment: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Section(sectionKey: _sectionKeys[0], child: const HeyPage()),
                _Section(sectionKey: _sectionKeys[1], child: const WorkPage()),
                _Section(sectionKey: _sectionKeys[2], child: const StoryPage()),
                _Section(sectionKey: _sectionKeys[3], child: const ChatPage()),
                const _Footer(),
              ],
            ),
          ),
          Positioned(
            top: isMobile ? 16 : 24,
            left: 0,
            right: 0,
            child: Center(
              child:
                  PortfolioNavBar(
                        currentIndex: _activeIndex,
                        onTap: _scrollToSection,
                        isMobile: isMobile,
                      )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.5, end: 0, curve: Curves.easeOut),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final GlobalKey sectionKey;
  final Widget child;

  const _Section({required this.sectionKey, required this.child});

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: sectionKey, child: child);
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Text(
        '© 2026 Kartikey Srivastava · Built with Flutter',
        style: TextStyle(
          fontSize: 13,
          color: AppColors.inkLight.withValues(alpha: 0.5),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
