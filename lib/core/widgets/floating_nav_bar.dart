import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────
// FLOATING NAV BAR — chanhdai.com-inspired
//
// Design language:
//   • Pure Zinc surface + borders (no tinting, no color bg)
//   • 8px corner radius — flat and editorial, not pill-shaped
//   • All 5 items show their label (9px mono, ALL CAPS, spaced)
//   • Active: Emerald accent icon + label, tiny accent underline
//   • Hover: subtle zinc fill, icon brightens
//   • Spring-physics entrance from bottom
//
// Tab order (must match _AppShell._screens exactly):
//   0 Home | 1 About | 2 Projects | 3 Skills | 4 Contact
// ─────────────────────────────────────────────────────────────

class FloatingNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar>
    with SingleTickerProviderStateMixin {
  int _hoveredIndex = -1;
  late final AnimationController _entranceCtrl;
  late final Animation<double> _entranceFade;
  late final Animation<Offset> _entranceSlide;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _entranceFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    );
    _entranceSlide = Tween<Offset>(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      // easeOutQuint — fast deceleration, no overshooting jank
      curve: const Cubic(0.22, 1.0, 0.36, 1.0),
    ));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _entranceCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  static const _items = [
    _NavItem(icon: Icons.home_outlined,         activeIcon: Icons.home_rounded,         label: 'HOME'),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded,       label: 'ABOUT'),
    _NavItem(icon: Icons.work_outline_rounded,   activeIcon: Icons.work_rounded,         label: 'WORK'),
    _NavItem(icon: Icons.auto_awesome_outlined,  activeIcon: Icons.auto_awesome,         label: 'SKILLS'),
    _NavItem(icon: Icons.mail_outline_rounded,   activeIcon: Icons.mail_rounded,         label: 'CONTACT'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark     = Theme.of(context).brightness == Brightness.dark;
    final navBg      = isDark ? AppColors.surfaceDark     : AppColors.surfaceLight;
    final navBorder  = isDark ? AppColors.borderDark      : AppColors.borderLight;
    final hoverFill  = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final activeFill = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final accent     = isDark ? AppColors.accentDark      : AppColors.accentLight;
    final idleIcon   = isDark ? AppColors.textSecDark     : AppColors.textSecLight;
    final hoverIcon  = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return FadeTransition(
      opacity: _entranceFade,
      child: SlideTransition(
        position: _entranceSlide,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: navBg.withValues(alpha: isDark ? 0.90 : 0.95),
                      borderRadius: AppRadius.card,
                      border: Border.all(color: navBorder, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.40 : 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    // Inner horizontal padding only — items decide vertical
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(_items.length, (i) {
                        final isActive  = widget.currentIndex == i;
                        final isHovered = _hoveredIndex == i && !isActive;
                        final item = _items[i];

                        final iconColor = isActive
                            ? accent
                            : isHovered
                                ? hoverIcon
                                : idleIcon;

                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => _hoveredIndex = i),
                          onExit:  (_) => setState(() => _hoveredIndex = -1),
                          child: GestureDetector(
                            onTap: () => widget.onTap(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 140),
                              curve: Curves.easeOut,
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              width: 58,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? activeFill
                                    : isHovered
                                        ? hoverFill
                                        : Colors.transparent,
                                borderRadius: AppRadius.subtle,
                                border: isActive
                                    ? Border.all(color: navBorder, width: 0.5)
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 160),
                                      switchInCurve: Curves.easeOutBack,
                                      switchOutCurve: Curves.easeIn,
                                      transitionBuilder: (child, anim) =>
                                          ScaleTransition(scale: anim, child: child),
                                      child: Icon(
                                        isActive ? item.activeIcon : item.icon,
                                        key: ValueKey('icon_${i}_$isActive'),
                                        size: 18,
                                        color: iconColor,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      curve: Curves.easeOutCubic,
                                      width: isActive ? 14 : 0,
                                      height: 1.5,
                                      decoration: BoxDecoration(
                                        color: accent,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NAV ITEM MODEL
// ─────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}