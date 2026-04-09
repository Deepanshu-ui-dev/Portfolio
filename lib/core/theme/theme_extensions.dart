import 'package:flutter/material.dart';
import 'app_theme.dart';

/// High-performance theme transition utilities
class ThemeTransitionUtils {
  /// Pre-compute and cache theme color map for instant access
  static final Map<String, Color> _colorCache = {};
  
  /// Initialize color cache on app start for instant theme switch
  static void initializeColorCache() {
    // Dark theme colors
    _colorCache['bg_dark'] = AppColors.bgDark;
    _colorCache['surface_dark'] = AppColors.surfaceDark;
    _colorCache['text_primary_dark'] = AppColors.textPrimaryDark;
    _colorCache['text_secondary_dark'] = AppColors.textSecDark;
    _colorCache['border_dark'] = AppColors.borderDark;
    _colorCache['accent_dark'] = AppColors.accentDark;
    
    // Light theme colors
    _colorCache['bg_light'] = AppColors.bgLight;
    _colorCache['surface_light'] = AppColors.surfaceLight;
    _colorCache['text_primary_light'] = AppColors.textPrimaryLight;
    _colorCache['text_secondary_light'] = AppColors.textSecLight;
    _colorCache['border_light'] = AppColors.borderLight;
    _colorCache['accent_light'] = AppColors.accentLight;
  }

  /// Get cached color instantly
  static Color getCachedColor(String key, {Color fallback = const Color(0xFF000000)}) {
    return _colorCache[key] ?? fallback;
  }

  /// Smooth color lerp with GPU optimization
  static Color smoothColorLerp(Color a, Color b, double t) {
    return Color.lerp(a, b, t) ?? a;
  }
}

/// AnimatedColorContainer — Smooth color transitions without rebuilds
class AnimatedColorContainer extends StatefulWidget {
  final Widget child;
  final Color startColor;
  final Color endColor;
  final Duration duration;
  final Curve curve;
  final bool animate;

  const AnimatedColorContainer({
    super.key,
    required this.child,
    required this.startColor,
    required this.endColor,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
    this.animate = true,
  });

  @override
  State<AnimatedColorContainer> createState() => _AnimatedColorContainerState();
}

class _AnimatedColorContainerState extends State<AnimatedColorContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _setupAnimation();
  }

  void _setupAnimation() {
    _colorAnimation = ColorTween(
      begin: widget.startColor,
      end: widget.endColor,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedColorContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startColor != widget.startColor ||
        oldWidget.endColor != widget.endColor) {
      _controller.reset();
      _setupAnimation();
      if (widget.animate) _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, _) {
        return Container(
          color: _colorAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// SmoothThemeScaffold — Scaffold with smooth theme transitions
class SmoothThemeScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBody;
  final Duration transitionDuration;

  const SmoothThemeScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBody = false,
    this.transitionDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: isDark ? 1.0 : 0.0),
      duration: transitionDuration,
      curve: Curves.easeOutCubic,
      builder: (context, themeT, child) {
        return Scaffold(
          backgroundColor: Color.lerp(
            AppColors.bgLight,
            AppColors.bgDark,
            themeT,
          ),
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          extendBody: extendBody,
        );
      },
    );
  }
}

/// Extension for smooth Theme data transitions
extension ThemeTransitionExtension on ThemeData {
  /// Create a smoothly transitioned theme
  static ThemeData createTransitioned({
    required bool isDark,
    required Duration duration,
  }) {
    return isDark ? AppTheme.dark() : AppTheme.light();
  }
}
