import 'package:flutter/material.dart';

/// A wrapper that plays a fade + slide-up animation the first time
/// its child is built in the widget tree.
///
/// Uses a lightweight approach: after the first frame it triggers
/// the entrance animation with an optional [delay], making it easy
/// to stagger siblings by incrementing delay.
///
/// Curve: `Cubic(0.16, 1.0, 0.3, 1.0)` — an easeOutExpo approximation
/// that feels snappy and premium without being jarring.
class ScrollFadeIn extends StatefulWidget {
  final Widget child;

  /// Extra delay before the animation starts (for staggering siblings).
  final Duration delay;

  /// Total animation duration.
  final Duration duration;

  /// How far the widget slides up from (fraction of its own height).
  final double slideBegin;

  const ScrollFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 420),
    this.slideBegin = 0.04,
  });

  @override
  State<ScrollFadeIn> createState() => _ScrollFadeInState();
}

// easeOutExpo approximation — snappy deceleration, premium feel.
const _kExpoOut = Cubic(0.16, 1.0, 0.3, 1.0);

class _ScrollFadeInState extends State<ScrollFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _offset = Tween<Offset>(
      begin: Offset(0, widget.slideBegin),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: _kExpoOut));

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndAnimate());
  }

  void _checkAndAnimate() {
    if (_triggered || !mounted) return;
    _triggered = true;

    if (widget.delay == Duration.zero) {
      _ctrl.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}
