import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MinimalHoverCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const MinimalHoverCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  State<MinimalHoverCard> createState() => _MinimalHoverCardState();
}

class _MinimalHoverCardState extends State<MinimalHoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.surfaceBorder.withValues(alpha: 0.3) : AppColors.background,
            border: Border.all(
              color: _isHovered ? AppColors.textTertiary : AppColors.surfaceBorder,
              width: 1,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

