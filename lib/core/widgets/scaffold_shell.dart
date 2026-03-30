import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/portfolio_config.dart';
import '../theme/app_theme.dart';
import 'diagonal_striped_background.dart';
import 'dashed_border_container.dart';

class ScaffoldShell extends ConsumerWidget {
  final Widget child;
  final String currentPath;

  const ScaffoldShell({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: StripedBackground(
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Center constrained content column with dashed borders
              Container(
                width: AppSpacing.maxContentWidth,
                height: double.infinity,
                constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.surfaceBorder.withValues(alpha: 0.5), width: 1),
                    right: BorderSide(color: AppColors.surfaceBorder.withValues(alpha: 0.5), width: 1),
                  ),
                  color: AppColors.background,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 120, top: 70), // Removed manual media padding
                  child: child,
                ),
              ),
              
              // Top Navigation Menu (Monofolio header)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: AppSpacing.maxContentWidth,
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.8),
                      border: Border(
                        bottom: BorderSide(color: AppColors.surfaceBorder, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.bolt, color: AppColors.textPrimary, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              PortfolioConfig.name,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _TopNavLink(itemPath: '/', label: 'Home', currentPath: currentPath),
                            _TopNavLink(itemPath: '/blog', label: 'Blog', currentPath: currentPath),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.wb_sunny_outlined, size: 16, color: AppColors.textPrimary),
                              onPressed: () {}, // Theme toggle placeholder
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // Floating bottom dock
              Positioned(
                bottom: 32,
                child: _DockNavigation(currentPath: currentPath),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopNavLink extends StatelessWidget {
  final String itemPath;
  final String label;
  final String currentPath;

  const _TopNavLink({required this.itemPath, required this.label, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    final isSelected = currentPath == itemPath;
    return InkWell(
      onTap: () => context.go(itemPath),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
            decorationColor: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _DockNavigation extends StatelessWidget {
  final String currentPath;
  const _DockNavigation({required this.currentPath});

  @override
  Widget build(BuildContext context) {
    final items = <_NavItem>[
      const _NavItem(path: '/', icon: Icons.home_outlined, label: 'Home'),
      const _NavItem(path: '/about', icon: Icons.help_outline, label: 'About'),
      const _NavItem(path: '/skills', icon: Icons.auto_awesome, label: 'Skills'),
      const _NavItem(path: '/projects', icon: Icons.mode_edit_outline, label: 'Projects'),
      const _NavItem(path: '/blog', icon: Icons.article_outlined, label: 'Blog'),
    ];

    return DashedBorderContainer(
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF09090B), // Blacker than background
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          final selected = currentPath == item.path;

          return Tooltip(
            message: item.label,
            decoration: BoxDecoration(
              color: const Color(0xFF09090B),
              border: Border.all(color: AppColors.surfaceBorder, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textPrimary),
            verticalOffset: 32,
            child: InkWell(
              onTap: () => context.go(item.path),
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: selected ? null : Border.all(color: AppColors.surfaceBorder.withValues(alpha: 0.3), width: 1),
                ),
                child: selected 
                  ? Stack(
                      children: [
                        Center(
                          child: Icon(
                            item.icon,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        // Corner brackets for selected state
                        Positioned(top: 0, left: 0, child: _DockCorner(isTop: true, isLeft: true)),
                        Positioned(top: 0, right: 0, child: _DockCorner(isTop: true, isLeft: false)),
                        Positioned(bottom: 0, left: 0, child: _DockCorner(isTop: false, isLeft: true)),
                        Positioned(bottom: 0, right: 0, child: _DockCorner(isTop: false, isLeft: false)),
                      ],
                    )
                  : Icon(
                      item.icon,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DockCorner extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _DockCorner({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? BorderSide(color: AppColors.textPrimary, width: 1.5) : BorderSide.none,
          bottom: !isTop ? BorderSide(color: AppColors.textPrimary, width: 1.5) : BorderSide.none,
          left: isLeft ? BorderSide(color: AppColors.textPrimary, width: 1.5) : BorderSide.none,
          right: !isLeft ? BorderSide(color: AppColors.textPrimary, width: 1.5) : BorderSide.none,
        ),
      ),
    );
  }
}

class _NavItem {
  final String path;
  final IconData icon;
  final String label;

  const _NavItem({required this.path, required this.icon, required this.label});
}
