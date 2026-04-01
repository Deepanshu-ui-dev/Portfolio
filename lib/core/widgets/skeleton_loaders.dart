import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────
// REDACTED SKELETON LOADERS FOR PORTFOLIO
// ─────────────────────────────────────────────

/// Generic theme-aware skeleton loader using redacted package
class RedactedSkeletonLoader extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Duration animationDuration;

  const RedactedSkeletonLoader({
    super.key,
    required this.child,
    this.isLoading = true,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return child.redacted(
      context: context,
      redact: true,
      configuration: RedactedConfiguration(
        animationDuration: animationDuration,
      ),
    );
  }
}

/// Skeleton loader for image cards (photography section)
class ImageCardSkeleton extends StatelessWidget {
  final double width;
  final double height;

  const ImageCardSkeleton({
    super.key,
    this.width = 160,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.5),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// Skeleton loader for text lines
class TextLineSkeleton extends StatelessWidget {
  final double width;
  final double height;

  const TextLineSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Skeleton loader for avatar/profile images
class AvatarSkeleton extends StatelessWidget {
  final double radius;

  const AvatarSkeleton({super.key, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.5),
      ),
    );
  }
}

/// Skeleton loader for button areas
class ButtonSkeleton extends StatelessWidget {
  final double width;
  final double height;

  const ButtonSkeleton({
    super.key,
    this.width = 100,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.5),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Skeleton loader for card containers
class CardSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;

  const CardSkeleton({
    super.key,
    this.width,
    this.height = 200,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        border: Border.all(color: border),
      ),
      child: child ??
          Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
    );
  }
}

/// Animated pulsing skeleton effect
class PulsingSkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Duration duration;

  const PulsingSkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<PulsingSkeletonBox> createState() => _PulsingSkeletonBoxState();
}

class _PulsingSkeletonBoxState extends State<PulsingSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}
