/// Interactive lamp-based theme switcher with physics simulation
///
/// Features a draggable rope connected to a bulb that toggles theme mode
/// when pulled down. Includes realistic physics simulation with gravity,
/// friction, and constraint satisfaction for smooth animations.
///
/// Performance optimized for 60fps with:
/// - Reduced physics iterations (4 vs 10)
/// - Efficient motion detection with debouncing
/// - GPU-accelerated rendering
/// - Minimal memory allocations per frame
library theme_switcher;

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import 'circular_reveal_transition.dart';

/// Interactive lamp theme switcher widget
///
/// Displays an interactive rope-and-bulb interface for toggling dark/light theme.
/// The user can drag the bulb down to trigger a theme switch with smooth animation.
///
/// Usage:
/// ```dart
/// const LampThemeSwitcher()
/// ```
///
/// Features:
/// - Physics-based rope animation
/// - Smooth color transitions
/// - Haptic feedback on toggle
/// - Responsive to mouse hover on desktop
class LampThemeSwitcher extends ConsumerStatefulWidget {
  /// Create a new LampThemeSwitcher
  const LampThemeSwitcher({super.key});

  @override
  ConsumerState<LampThemeSwitcher> createState() => _LampThemeSwitcherState();
}

/// State management for lamp theme switcher
///
/// Handles physics simulation, user interaction, and animation timing
class _LampThemeSwitcherState extends ConsumerState<LampThemeSwitcher>
    with TickerProviderStateMixin {

  // ───────────────────────────────────────────────────────────────────
  // Physics Configuration Constants
  // ───────────────────────────────────────────────────────────────────
  
  /// Number of points in the rope chain
  static const int    _pointCount      = 14;
  
  /// Distance between each rope point
  static const double _stickLength     = 9.0;
  
  /// Gravity acceleration (units per frame squared)
  static const double _gravity         = 0.45;
  
  /// Velocity damping factor (0-1, lower = more friction)
  static const double _friction        = 0.92;
  
  /// Total rope length (calculated)
  static const double _ropeLength      = _pointCount * _stickLength;
  
  /// Distance threshold to trigger theme toggle
  static const double _toggleThreshold = 28.0;
  
  /// Maximum reach distance for rope end
  static const double _maxReach        = _ropeLength * 1.7;
  
  /// Number of physics constraint iterations per frame
  static const int    _physicsIter     = 4;

  // ───────────────────────────────────────────────────────────────────
  // Physics State
  // ───────────────────────────────────────────────────────────────────

  /// Rope chain points with position and velocity
  final List<_Point> _points = [];
  
  /// Rope segment constraints
  final List<_Stick> _sticks = [];

  // ───────────────────────────────────────────────────────────────────
  // Interaction State
  // ───────────────────────────────────────────────────────────────────

  /// Current mouse position when dragging
  Offset? _mousePos;
  
  /// Current mouse position during hover
  Offset? _hoverPos;
  
  /// Whether user is currently dragging the rope
  bool    _isDragging = false;
  
  /// Whether theme toggle has occurred during current drag
  bool    _hasToggled = false;
  
  /// Whether mouse is hovering over the widget
  bool    _isHovering = false;
  
  /// Timer for debouncing motion stop detection
  Timer? _motionStopTimer;

  // ───────────────────────────────────────────────────────────────────
  // Animation Controllers
  // ───────────────────────────────────────────────────────────────────

  /// Main animation loop for physics simulation
  late AnimationController _loopController;
  
  /// Bloom glow effect animation
  late AnimationController _bloomController;
  
  /// Bloom animation with easing curve
  late Animation<double>   _bloomAnim;

  @override
  void initState() {
    super.initState();
    _initPhysics();
    
    // Physics simulation loop (16ms per frame ≈ 60fps)
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_onFrame);

    // Bloom effect animation (fast, punchy feedback)
    _bloomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _bloomAnim = CurvedAnimation(
      parent: _bloomController,
      curve: Curves.easeOut,
    );
  }

  /// Initialize rope physics simulation
  ///
  /// Creates a chain of points connected by constraints,
  /// with the first point fixed at the top
  void _initPhysics() {
    _points.clear();
    _sticks.clear();
    
    // Fixed anchor point at top
    _points.add(_Point(50, 0, isFixed: true));
    
    // Rope chain points
    for (int i = 1; i < _pointCount; i++) {
      _points.add(_Point(50, i * _stickLength));
      _sticks.add(_Stick(_points[i - 1], _points[i], _stickLength));
    }
  }

  /// Start the physics simulation loop
  void _startLoop() {
    _motionStopTimer?.cancel();
    if (!_loopController.isAnimating) _loopController.repeat();
  }

  /// Stop the physics simulation loop
  void _stopLoop() {
    if (_loopController.isAnimating) _loopController.stop();
  }

  /// Physics frame callback - called every 16ms
  ///
  /// Updates physics, detects motion stopping, and triggers repaints
  void _onFrame() {
    if (!mounted) return;
    _runPhysics();

    // Check if motion has stopped
    if (!_isDragging && !_isHovering && !_bloomController.isAnimating) {
      double maxV = 0;
      for (final p in _points) {
        if (p.isFixed) continue;
        maxV = math.max(maxV, (p.x - p.oldX).abs());
        maxV = math.max(maxV, (p.y - p.oldY).abs());
      }
      // Debounce stop detection to prevent loop thrashing
      if (maxV < 0.05) {
        _motionStopTimer?.cancel();
        _motionStopTimer = Timer(const Duration(milliseconds: 200), _stopLoop);
      }
    }

    setState(() {});
  }

  /// Execute one frame of physics simulation
  ///
  /// Handles:
  /// 1. Gravity and friction on all points
  /// 2. Hover force field
  /// 3. User drag interaction
  /// 4. Constraint satisfaction (rope tension)
  void _runPhysics() {
    // Apply forces: gravity, friction, hover force
    for (final p in _points) {
      if (p.isFixed) continue;
      final vx = (p.x - p.oldX) * _friction;
      final vy = (p.y - p.oldY) * _friction;
      p.oldX = p.x;
      p.oldY = p.y;
      p.x += vx;
      p.y += vy + _gravity;

      // Hover force field (repel rope when mouse nearby)
      if (_hoverPos != null && !_isDragging) {
        final dx   = p.x - _hoverPos!.dx;
        final dy   = p.y - _hoverPos!.dy;
        final dist = math.sqrt(dx * dx + dy * dy);
        if (dist < 60 && dist > 0) {
          final force = (60 - dist) / 60 * 0.05;
          p.x -= dx / dist * force;
          p.y -= dy / dist * force;
        }
      }
    }

    // User drag interaction
    if (_isDragging && _mousePos != null) {
      final last   = _points.last;
      final anchor = Offset(_points[0].x, _points[0].y);
      final delta  = _mousePos! - anchor;
      final Offset target = delta.distance > _maxReach
          ? anchor + Offset.fromDirection(delta.direction, _maxReach)
          : _mousePos!;
      last.x = target.dx;
      last.y = target.dy;

      // Check if threshold crossed for theme toggle
      if (last.y > _ropeLength + _toggleThreshold && !_hasToggled) {
        _hasToggled = true;
        _bloomController.forward(from: 0.0);
        _startLoop();

        // Get global position for circular reveal origin
        final rb        = context.findRenderObject() as RenderBox?;
        final globalPos = rb?.localToGlobal(Offset(last.x, last.y))
            ?? Offset(last.x, last.y);

        // Trigger theme transition animation
        ref.read(transitionProvider.notifier).start(globalPos);
        
        // Minimal delay ensures snapshot captures OLD theme before toggle
        Future.delayed(const Duration(milliseconds: 16), () {
          if (mounted) ref.read(themeModeProvider.notifier).toggle();
        });
        
        // Haptic feedback for user confirmation
        HapticFeedback.mediumImpact();
      }
    }

    // Satisfy rope length constraints (10 iterations optimal)
    for (int iter = 0; iter < _physicsIter; iter++) {
      for (final s in _sticks) {
        final dx   = s.p1.x - s.p2.x;
        final dy   = s.p1.y - s.p2.y;
        final dist = math.sqrt(dx * dx + dy * dy);
        if (dist == 0) continue;
        final pct = (s.length - dist) / dist * 0.5;
        final ox  = dx * pct;
        final oy  = dy * pct;
        if (!s.p1.isFixed) { s.p1.x += ox; s.p1.y += oy; }
        if (!s.p2.isFixed) { s.p2.x -= ox; s.p2.y -= oy; }
      }
    }
  }

  @override
  void dispose() {
    _motionStopTimer?.cancel();
    _loopController.dispose();
    _bloomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(effectiveThemeProvider) == Brightness.dark;

    return RepaintBoundary(
      child: SizedBox(
        width:  100,
        height: 300,
        child: MouseRegion(
          onHover: (e) {
            _hoverPos   = e.localPosition;
            _isHovering = true;
            _startLoop();
          },
          onExit: (_) {
            _hoverPos   = null;
            _isHovering = false;
            setState(() {});
          },
          cursor: _isDragging
              ? SystemMouseCursors.grabbing
              : SystemMouseCursors.grab,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (d) {
              final last = _points.last;
              final dist = (d.localPosition - Offset(last.x, last.y)).distance;
              if (dist < 56) {
                _isDragging = true;
                _mousePos   = d.localPosition;
                _hasToggled = false;
                _startLoop();
              }
            },
            onPanUpdate: (d) {
              if (_isDragging) _mousePos = d.localPosition;
            },
            onPanEnd: (_) {
              _points.last.x = 50;
              _points.last.y = _ropeLength;
              _isDragging    = false;
              _mousePos      = null;
              _hasToggled    = false;
              _startLoop();
              setState(() {});
            },
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: isDark ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutQuart,
              builder: (context, t, _) {
                final textMuted = Color.lerp(
                  AppColors.textMutedLight,
                  AppColors.textMutedDark,
                  t,
                )!;
                final border2 = Color.lerp(
                  AppColors.border2Light,
                  AppColors.border2Dark,
                  t,
                )!;

                return CustomPaint(
                  painter: _LampPainter(
                    snapshots:  _points.map((p) => _Snap(p.x, p.y)).toList(),
                    isDark:     t > 0.5,
                    isDragging: _isDragging,
                    textMuted:  textMuted,
                    border2:    border2,
                    themeT:     t,
                    bloomT:     _bloomAnim.value,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// PHYSICS DATA STRUCTURES
// ──────────────────────────────────────────────────────────────────────────

/// A point in the rope chain with position and velocity
///
/// Stores current and previous position for velocity calculation using Verlet integration
class _Point {
  /// Current X position
  double x;
  
  /// Current Y position
  double y;
  
  /// Previous X position (for velocity)
  double oldX;
  
  /// Previous Y position (for velocity)
  double oldY;
  
  /// Whether this point is fixed (anchor)
  final bool isFixed;

  /// Create a new physics point
  _Point(this.x, this.y, {this.isFixed = false}) : oldX = x, oldY = y;
}

/// A rope segment connecting two points
///
/// Represents the constraint that two points should maintain a specific distance
class _Stick {
  /// First point in the constraint
  final _Point p1;
  
  /// Second point in the constraint
  final _Point p2;
  
  /// Target distance between points
  final double length;

  /// Create a new rope segment
  _Stick(this.p1, this.p2, this.length);
}

/// Snapshot of point position for rendering
///
/// Immutable data for efficient painting
class _Snap {
  /// X coordinate
  final double x;
  
  /// Y coordinate
  final double y;

  /// Create a new snapshot
  const _Snap(this.x, this.y);
}

// ──────────────────────────────────────────────────────────────────────────
// RENDERING - CUSTOM PAINTER
// ──────────────────────────────────────────────────────────────────────────

/// Custom painter for the lamp visual
///
/// Renders:
/// - Ceiling fixture
/// - Rope with shadow
/// - Glass bulb with highlight
/// - Metal cap
/// - Filament (dark mode)
/// - Light bloom effect
class _LampPainter extends CustomPainter {
  /// Current rope point positions
  final List<_Snap> snapshots;
  
  /// Whether in dark mode
  final bool        isDark;
  
  /// Whether currently dragging
  final bool        isDragging;
  
  /// Rope color (muted text)
  final Color       textMuted;
  
  /// Border color (accent)
  final Color       border2;

  /// Theme transition progress (0-1)
  final double      themeT;
  
  /// Bloom effect intensity (0-1)
  final double      bloomT;

  /// Create a new lamp painter
  const _LampPainter({
    required this.snapshots,
    required this.isDark,
    required this.isDragging,
    required this.textMuted,
    required this.border2,
    required this.themeT,
    required this.bloomT,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawFixture(canvas);
    _drawRope(canvas);
    _drawBulb(canvas);
  }

  /// Draw the ceiling fixture
  void _drawFixture(Canvas canvas) {
    final x = snapshots[0].x;
    final p = Paint()..color = border2..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x - 10, 0, 20, 4),
        const Radius.circular(2),
      ),
      p,
    );
    canvas.drawCircle(Offset(x, 4), 3, p);
  }

  /// Draw the rope with shadow and main stroke
  void _drawRope(Canvas canvas) {
    if (snapshots.length < 2) return;
    
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.28)
        : Colors.black.withValues(alpha: 0.07);
    final ropeColor = isDark
        ? textMuted.withValues(alpha: 0.60)
        : textMuted.withValues(alpha: 0.55);
    
    // Shadow layer (offset slightly)
    canvas.drawPath(
      _buildPath(offsetY: 0.6),
      Paint()
        ..color       = shadowColor
        ..strokeWidth = 1.8
        ..strokeCap   = StrokeCap.round
        ..style       = PaintingStyle.stroke,
    );
    
    // Main rope
    canvas.drawPath(
      _buildPath(offsetY: 0.0),
      Paint()
        ..color       = ropeColor
        ..strokeWidth = 1.2
        ..strokeCap   = StrokeCap.round
        ..style       = PaintingStyle.stroke,
    );
  }

  /// Build smooth cubic path through rope points
  Path _buildPath({double offsetY = 0}) {
    final s    = snapshots;
    final path = Path()..moveTo(s[0].x, s[0].y + offsetY);
    for (int i = 1; i < s.length; i++) {
      final prev  = s[i > 1 ? i - 2 : 0];
      final cur   = s[i - 1];
      final next  = s[i];
      final after = s[i < s.length - 1 ? i + 1 : i];
      path.cubicTo(
        cur.x  + (next.x  - prev.x) / 6,
        cur.y  + (next.y  - prev.y) / 6 + offsetY,
        next.x - (after.x - cur.x)  / 6,
        next.y - (after.y - cur.y)  / 6 + offsetY,
        next.x, next.y + offsetY,
      );
    }
    return path;
  }

  /// Draw the light bulb
  void _drawBulb(Canvas canvas) {
    if (snapshots.length < 2) return;

    final last   = snapshots.last;
    final second = snapshots[snapshots.length - 2];
    final angle  = math.atan2(last.y - second.y, last.x - second.x) - math.pi / 2;

    canvas.save();
    canvas.translate(last.x, last.y);
    canvas.rotate(angle);

    // Glass dome color (cool daylight → warm tungsten)
    final bulbColor = Color.lerp(
      const Color(0xFFE8E8E4),
      const Color(0xFFD4C89A),
      themeT,
    )!;
    final bulbPath  = Path()
      ..moveTo(-6, 0)
      ..cubicTo(-9, 4, -9, 10, 0, 14)
      ..cubicTo( 9, 10, 9,  4, 6,  0)
      ..close();

    // Bulb fill
    canvas.drawPath(
      bulbPath,
      Paint()
        ..color = isDragging
            ? bulbColor.withValues(alpha: 0.95)
            : bulbColor.withValues(alpha: isDark ? 0.50 : 0.70)
        ..style = PaintingStyle.fill,
    );
    
    // Bulb outline
    canvas.drawPath(
      bulbPath,
      Paint()
        ..color       = isDark
            ? Colors.white.withValues(alpha: 0.20 * themeT.clamp(0.5, 1.0))
            : Colors.black.withValues(alpha: 0.12 * (1.0 - themeT).clamp(0.5, 1.0))
        ..strokeWidth = 0.8
        ..style       = PaintingStyle.stroke,
    );

    // Metal cap
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-4, -5, 8, 6),
        const Radius.circular(1),
      ),
      Paint()..color = border2..style = PaintingStyle.fill,
    );

    // Filament glow (dark mode only)
    if (isDark) {
      final filamentAlpha = (isDragging ? 0.95 : 0.40) + (bloomT * 0.5);
      canvas.drawPath(
        Path()
          ..moveTo(-2, 3)
          ..cubicTo(-3, 6,  3, 6, 2, 9)
          ..cubicTo( 3, 6, -3, 6, -2, 3),
        Paint()
          ..color       = const Color(0xFFD4C89A).withValues(alpha: filamentAlpha.clamp(0.0, 1.0))
          ..strokeWidth = 0.7 + (bloomT * 0.3)
          ..strokeCap   = StrokeCap.round
          ..style       = PaintingStyle.stroke,
      );
    }

    // Specular highlight
    canvas.drawCircle(
      const Offset(-2.5, 3.5),
      1.1 + (bloomT * 0.5),
      Paint()
        ..color = Colors.white.withValues(alpha: (isDark ? 0.40 : 0.60) + (bloomT * 0.3).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill,
    );

    // Light bloom effect (radial glow)
    if (bloomT > 0.01) {
      canvas.drawCircle(
        Offset.zero,
        18.0 * bloomT,
        Paint()
          ..shader = ui.Gradient.radial(
            Offset.zero,
            20.0,
            [
              const Color(0xFFD4C89A).withValues(alpha: bloomT * 0.3),
              const Color(0xFFD4C89A).withValues(alpha: 0.0),
            ],
          )
          ..blendMode = BlendMode.screen,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LampPainter old) {
    if (old.themeT != themeT) return true;
    if (old.bloomT != bloomT) return true;
    if (old.isDark != isDark) return true;
    if (old.isDragging != isDragging) return true;
    if (old.snapshots.length != snapshots.length) return true;
    for (int i = 0; i < snapshots.length; i++) {
      if (old.snapshots[i].x != snapshots[i].x ||
          old.snapshots[i].y != snapshots[i].y) {
        return true;
      }
    }
    return false;
  }
}
