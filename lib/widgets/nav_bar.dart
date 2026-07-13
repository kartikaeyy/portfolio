import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PortfolioNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isMobile;

  const PortfolioNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isMobile = false,
  });

  static const _labels = ['Hey', 'Work', 'Story', 'Chat'];

  @override
  Widget build(BuildContext context) {
    if (isMobile) return _MobileNav(currentIndex: currentIndex, onTap: onTap);
    return _DesktopNav(currentIndex: currentIndex, onTap: onTap);
  }
}

class _DesktopNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _DesktopNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.navBg,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.strokeStrong),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(PortfolioNavBar._labels.length, (i) {
            final active = i == currentIndex;
            return GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: active ? AppColors.navActive : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  PortfolioNavBar._labels[i],
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.black : Colors.white,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MobileNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _MobileNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.navBg,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.strokeStrong),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SunIcon(),
          const Spacer(),
          GestureDetector(
            onTap: () => _showMobileMenu(context),
            child: Row(
              children: [
                Text(
                  'Menu',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.menu, color: Colors.white, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MobileMenuSheet(
        currentIndex: currentIndex,
        onTap: (i) {
          Navigator.pop(context);
          onTap(i);
        },
      ),
    );
  }
}

class _MobileMenuSheet extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _MobileMenuSheet({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.navBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.strokeStrong),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(PortfolioNavBar._labels.length, (i) {
          final active = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  PortfolioNavBar._labels[i],
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: active ? AppColors.navActive : Colors.white,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SunIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 20),
    );
  }
}
