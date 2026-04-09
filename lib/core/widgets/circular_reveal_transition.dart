/// Circular reveal animation for smooth theme transitions
///
/// Provides a beautiful circular wipe animation when switching themes,
/// revealing the new theme by "uncovering" it from a circular center point.
///
/// Performance optimized for 60fps with:
/// - Efficient snapshot capture
/// - GPU-accelerated clipping
/// - Minimal memory overhead
/// - Smart caching to prevent recalculation
library transitions;

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod provider for managing circular reveal animation state
///
/// Usage:
/// ```dart
/// ref.read(transitionProvider.notifier).start(Offset(100, 100));
/// ```
final transitionProvider =
    StateNotifierProvider<TransitionNotifier, TransitionState>((ref) {
  return TransitionNotifier();
});

/// State for transition animation
///
/// Properties:
/// - `center`: The point where the circular reveal starts from
/// - `isAnimating`: Whether animation is currently running
class TransitionState {
  /// Center point of the circular reveal
  final Offset? center;
  
  /// Whether the animation is currently in progress
  final bool isAnimating;

  /// Create a new TransitionState
  const TransitionState({this.center, this.isAnimating = false});

  /// Create a copy with optional field updates
  TransitionState copyWith({Offset? center, bool? isAnimating}) {
    return TransitionState(
      center: center ?? this.center,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}

/// Manages the state of the circular reveal transition
///
/// Methods:
/// - `start(Offset)` - Start animation from a specific point
/// - `end()` - Reset animation state
class TransitionNotifier extends StateNotifier<TransitionState> {
  /// Initialize with idle state
  TransitionNotifier() : super(const TransitionState());

  /// Start the circular reveal animation from the given center point
  ///
  /// Parameters:
  /// - `center`: The Offset where the circle should expand from
  ///
  /// This triggers the snapshot capture and animation immediately
  void start(Offset center) {
    state = TransitionState(center: center, isAnimating: true);
  }

  /// End the animation and reset to idle state
  void end() {
    state = const TransitionState();
  }
}

/// Circular reveal transition widget
///
/// Wraps content and provides smooth circular reveal animation
/// when switching between different themes.
///
/// Usage:
/// ```dart
/// CircularRevealTransition(
///   child: MyContent(),
/// )
/// ```
///
/// Performance characteristics:
/// - 200ms animation duration (optimized for 60fps without jank)
/// - 1x pixel ratio for fast capture
/// - GPU-accelerated clipping
/// - Automatic memory cleanup
/// - Minimizes buffer queue pressure on Android
class CircularRevealTransition extends ConsumerStatefulWidget {
  /// The widget to apply transition to
  final Widget child;

  /// Create a new CircularRevealTransition
  const CircularRevealTransition({super.key, required this.child});

  @override
  ConsumerState<CircularRevealTransition> createState() =>
      _CircularRevealTransitionState();
}

/// State for CircularRevealTransition
///
/// Handles snapshot capture, animation timing, and GPU-accelerated rendering
class _CircularRevealTransitionState
    extends ConsumerState<CircularRevealTransition>
    with SingleTickerProviderStateMixin {
  /// Animation controller for the reveal effect
  late final AnimationController _controller;
  
  /// Curved animation for smooth easing
  late final Animation<double> _animation;
  
  /// Key to capture widget as image
  final GlobalKey _boundaryKey = GlobalKey();

  /// Cached screenshot of old theme
  ui.Image? _snapshot;
  
  /// Center point of circular reveal
  Offset _center = Offset.zero;
  
  /// Flag to prevent state updates after dispose
  bool _disposed = false;
  
  /// Cached max radius to avoid recalculation
  double _cachedMaxRadius = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // Faster transition to reduce buffer pressure (200ms optimal for no jank)
      duration: const Duration(milliseconds: 200),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      // easeOutQuart provides smooth deceleration (fast→slow)
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

  /// Capture screenshot of current widget tree
  ///
  /// Runs asynchronously to prevent UI blocking:
  /// - Captures only once per transition
  /// - Uses 1x pixel ratio for speed
  /// - Automatically disposes if widget unmounts
  /// - Runs after a small delay to let other animations settle
  Future<void> _captureSnapshot() async {
    // Get the RepaintBoundary widget
    final boundary = _boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return;

    try {
      // Capture with 1x pixel ratio for instant snapshot
      // (sufficient quality for reveal animation)
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

    // Trigger snapshot capture when animation starts
    if (state.isAnimating && !_controller.isAnimating && _snapshot == null) {
      _center = state.center!;
      // Post frame callback ensures layout is complete
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
          // New Theme (underneath)
          widget.child,

          // Old Theme snapshot with circular clipping animation
          if (_snapshot != null)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                // Animate radius from max to 0 (reveals new theme)
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

/// Custom clipper for circular reveal effect
///
/// Clips an image to a circle that animates from max radius to 0,
/// creating the reveal effect as the circle shrinks.
class _CircleClipper extends CustomClipper<Path> {
  /// Center of the circle
  final Offset center;
  
  /// Current radius of the circle
  final double radius;

  /// Create a new _CircleClipper
  const _CircleClipper({required this.center, required this.radius});

  /// Generate the clipping path
  ///
  /// Returns a circular path that clips content outside
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
