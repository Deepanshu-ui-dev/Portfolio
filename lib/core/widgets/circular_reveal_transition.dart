import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transitionProvider =
    StateNotifierProvider<TransitionNotifier, TransitionState>((ref) {
  return TransitionNotifier();
});

class TransitionState {
  final Offset? center;
  final bool isAnimating;

  const TransitionState({this.center, this.isAnimating = false});

  TransitionState copyWith({Offset? center, bool? isAnimating}) {
    return TransitionState(
      center: center ?? this.center,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}

class TransitionNotifier extends StateNotifier<TransitionState> {
  TransitionNotifier() : super(const TransitionState());

  void start(Offset center) {
    state = TransitionState(center: center, isAnimating: true);
  }

  void end() {
    state = const TransitionState();
  }
}

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250), // Faster transition
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

    // Use pixelRatio: 1.0 for ultra-fast snapshotting and lower memory pressure
    final image = await boundary.toImage(
      pixelRatio: 1.0,
    );
    if (mounted) {
      setState(() {
        _snapshot = image;
      });
      _controller.forward();
    } else {
      image.dispose();
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
    final maxRadius = math.sqrt(
          math.pow(math.max(_center.dx, screenSize.width - _center.dx), 2) +
          math.pow(math.max(_center.dy, screenSize.height - _center.dy), 2),
        ) + 10;

    return RepaintBoundary(
      key: _boundaryKey,
      child: Stack(
        children: [
          // New Theme (underneath)
          widget.child,

          // Old Theme (snapshot) being clipped away
          if (_snapshot != null)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                final radius = (1.0 - _animation.value) * maxRadius;
                return ClipPath(
                  clipper: _CircleClipper(center: _center, radius: radius),
                  child: RawImage(
                    image: _snapshot,
                    width: screenSize.width,
                    height: screenSize.height,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.none, // Maximum performance
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _CircleClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  const _CircleClipper({required this.center, required this.radius});

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: math.max(0.0, radius)));
  }

  @override
  bool shouldReclip(covariant _CircleClipper old) =>
      old.radius != radius || old.center != center;
}