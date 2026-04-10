library transitions;

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── State & Providers ────────────────────────────────
final transitionProvider =
    StateNotifierProvider<TransitionNotifier, TransitionState>((ref) {
  return TransitionNotifier();
});

class TransitionState {
  final Offset? center;
  final bool isAnimating;

  const TransitionState({this.center, this.isAnimating = false});

  /// Create a copy with optional field updates
  TransitionState copyWith({Offset? center, bool? isAnimating}) {
    return TransitionState(
      center: center ?? this.center,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}

class TransitionNotifier extends StateNotifier<TransitionState> {
  /// Initialize with idle state
  TransitionNotifier() : super(const TransitionState());

  void start(Offset center) {
    state = TransitionState(center: center, isAnimating: true);
  }

  void end() {
    state = const TransitionState();
  }
}

// ─── Widget Transition ──────────────────────────────────
class CircularRevealTransition extends ConsumerStatefulWidget {
  final Widget child;

  const CircularRevealTransition({super.key, required this.child});

  @override
  ConsumerState<CircularRevealTransition> createState() =>
      _CircularRevealTransitionState();
}

class _CircularRevealTransitionState
    extends ConsumerState<CircularRevealTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final GlobalKey _boundaryKey = GlobalKey();

  ui.Image? _snapshot;
  Offset _center = Offset.zero;
  bool _disposed = false;
  double _cachedMaxRadius = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_disposed) {
        setState(() {
          _snapshot?.dispose();
          _snapshot = null;
        });
        ref.read(transitionProvider.notifier).end();
        _controller.reset();
      }
    });
  }

  Future<void> _captureSnapshot() async {
    final boundary = _boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return;

    try {
      final image = await boundary.toImage(
        pixelRatio: 1.0,
      );
      
      if (mounted && !_disposed) {
        setState(() {
          _snapshot = image;
        });
        // Start animation immediately after snapshot ready
        _controller.forward();
      } else {
        // Clean up if widget unmounted
        image.dispose();
      }
    } catch (e) {
      debugPrint('Error capturing snapshot: $e');
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _snapshot?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transitionProvider);

    if (state.isAnimating && !_controller.isAnimating && _snapshot == null) {
      _center = state.center!;
      WidgetsBinding.instance.addPostFrameCallback((_) => _captureSnapshot());
    }

    final screenSize = MediaQuery.of(context).size;
    
    // Calculate max radius only once per transition
    if (_snapshot != null && _cachedMaxRadius == 0.0) {
      _cachedMaxRadius = math.sqrt(
            math.pow(math.max(_center.dx, screenSize.width - _center.dx), 2) +
            math.pow(math.max(_center.dy, screenSize.height - _center.dy), 2),
          ) + 10;
    }

    return RepaintBoundary(
      key: _boundaryKey,
      child: Stack(
        children: [
          widget.child,

          if (_snapshot != null)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                final radius = (1.0 - _animation.value) * _cachedMaxRadius;
                return ClipPath(
                  clipper: _CircleClipper(center: _center, radius: radius),
                  child: RawImage(
                    image: _snapshot,
                    width: screenSize.width,
                    height: screenSize.height,
                    fit: BoxFit.fill,
                    // No filtering = maximum performance during animation
                    filterQuality: FilterQuality.none,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ─── Clipper ──────────────────────────────────────────
class _CircleClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  const _CircleClipper({required this.center, required this.radius});

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: math.max(0.0, radius)));
  }

  /// Optimize repainting by checking if clip has changed
  ///
  /// Only repaint if radius or center changes
  @override
  bool shouldReclip(covariant _CircleClipper old) =>
      old.radius != radius || old.center != center;
}
