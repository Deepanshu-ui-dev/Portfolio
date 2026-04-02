import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────
// FLOATING NAV BAR
//
// Tab order (must match _AppShell._screens exactly):
//   0 → Home       home_outlined       / home_rounded
//   1 → About      person_outline      / person_rounded
//   2 → Projects   work_outline        / work_rounded
//   3 → Skills     auto_awesome_outlined/ auto_awesome
//   4 → Contact    mail_outline        / mail_rounded
//
// Behaviour:
//   • Active: accent-colored icon + 3 px accent dot below
//   • Hover:  subtle activeBg fill, no border
//   • Icon switches via AnimatedSwitcher (scale pop)
//   • Tooltip: monospace, matches pill surface/border
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

class _FloatingNavBarState extends State<FloatingNavBar> {
  int _hoveredIndex = -1;

  static const _items = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'About',
    ),
    _NavItem(
      icon: Icons.work_outline_rounded,
      activeIcon: Icons.work_rounded,
      label: 'Projects',
    ),
    _NavItem(
      icon: Icons.auto_awesome_outlined,
      activeIcon: Icons.auto_awesome,
      label: 'Skills',
    ),
    _NavItem(
      icon: Icons.mail_outline_rounded,
      activeIcon: Icons.mail_rounded,
      label: 'Contact',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pillBg     = isDark ? const Color(0xFF111111) : Colors.white;
    final pillBorder = isDark ? const Color(0xFF252525)  : const Color(0xFFE0E0DC);
    final activeBg   = isDark ? const Color(0xFF1c1c1c)  : const Color(0xFFF2F2EF);
    final activeBdr  = isDark ? const Color(0xFF2e2e2e)  : const Color(0xFFD4D4D0);
    final accent     = isDark ? AppColors.accentDark     : AppColors.accentLight;
    final idleColor  = isDark ? const Color(0xFF4a4a4a)  : const Color(0xFFB0B0B0);
    const hoverColor = Color(0xFF777777);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: pillBg.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: pillBorder, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.50 : 0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_items.length, (i) {
                final isActive  = widget.currentIndex == i;
                final isHovered = _hoveredIndex == i && !isActive;
                final item      = _items[i];

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _hoveredIndex = i),
                  onExit:  (_) => setState(() => _hoveredIndex = -1),
                  child: GestureDetector(
                    onTap: () => widget.onTap(i),
                    child: Tooltip(
                      message: item.label,
                      preferBelow: false,
                      verticalOffset: 30,
                      waitDuration: const Duration(milliseconds: 500),
                      textStyle: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        letterSpacing: 1,
                        color: isDark
                            ? const Color(0xFFAAAAAA)
                            : const Color(0xFF555555),
                      ),
                      decoration: BoxDecoration(
                        color: pillBg,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: pillBorder, width: 0.5),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        width: 44,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isActive
                              ? activeBg
                              : isHovered
                                  ? activeBg.withValues(alpha: 0.55)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                          border: isActive
                              ? Border.all(color: activeBdr, width: 0.5)
                              : null,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Icon — scales between outline ↔ filled variant
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              switchInCurve: Curves.easeOutBack,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                isActive ? item.activeIcon : item.icon,
                                // Key forces AnimatedSwitcher to rebuild on change
                                key: ValueKey('nav_icon_${i}_$isActive'),
                                size: 17,
                                color: isActive
                                    ? accent
                                    : isHovered
                                        ? hoverColor
                                        : idleColor,
                              ),
                            ),

                            // Accent dot — scales in when tab becomes active
                            Positioned(
                              bottom: 5,
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOutBack,
                                scale: isActive ? 1.0 : 0.0,
                                child: Container(
                                  width: 3.0,
                                  height: 3.0,
                                  decoration: BoxDecoration(
                                    color: accent,
                                    shape: BoxShape.circle,
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
              }),
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