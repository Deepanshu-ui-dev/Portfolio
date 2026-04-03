import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A wrapper that plays a fade + slide-up animation the first time
/// its child becomes visible in the viewport.
///
/// Uses a lightweight approach: on first layout, it checks if the
/// widget is within the scroll viewport, and if not yet animated,
/// triggers the entrance animation with an optional [delay].
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
    this.duration = const Duration(milliseconds: 500),
    this.slideBegin = 0.04,
  });

  @override
  State<ScrollFadeIn> createState() => _ScrollFadeInState();
}

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
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    // Schedule visibility check after the first frame.
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
