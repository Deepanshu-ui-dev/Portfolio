import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import 'circular_reveal_transition.dart';

class LampThemeSwitcher extends ConsumerStatefulWidget {
  const LampThemeSwitcher({super.key});

  @override
  ConsumerState<LampThemeSwitcher> createState() => _LampThemeSwitcherState();
}

class _LampThemeSwitcherState extends ConsumerState<LampThemeSwitcher>
    with TickerProviderStateMixin {

  static const int    _pointCount      = 14;
  static const double _stickLength     = 9.0;
  static const double _gravity         = 0.45;
  static const double _friction        = 0.92; // Slightly higher for smoother settling
  static const double _ropeLength      = _pointCount * _stickLength;
  static const double _toggleThreshold = 28.0;
  static const double _maxReach        = _ropeLength * 1.7;
  static const int    _physicsIter     = 4; // Reduced from 10 for better FPS

  final List<_Point> _points = [];
  final List<_Stick> _sticks = [];

  Offset? _mousePos;
  Offset? _hoverPos;
  bool    _isDragging = false;
  bool    _hasToggled = false;
  bool    _isHovering = false;
  Timer? _motionStopTimer;

  late AnimationController _loopController;
  late AnimationController _bloomController;
  late Animation<double>   _bloomAnim;

  @override
  void initState() {
    super.initState();
    _initPhysics();
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_onFrame);

    _bloomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Faster bloom
    );
    _bloomAnim = CurvedAnimation(
      parent: _bloomController,
      curve: Curves.easeOut,
    );
  }

  void _initPhysics() {
    _points.clear();
    _sticks.clear();
    _points.add(_Point(50, 0, isFixed: true));
    for (int i = 1; i < _pointCount; i++) {
      _points.add(_Point(50, i * _stickLength));
      _sticks.add(_Stick(_points[i - 1], _points[i], _stickLength));
    }
  }

  void _startLoop() {
    _motionStopTimer?.cancel();
    if (!_loopController.isAnimating) _loopController.repeat();
  }

  void _stopLoop() {
    if (_loopController.isAnimating) _loopController.stop();
  }

  void _onFrame() {
    if (!mounted) return;
    _runPhysics();

    if (!_isDragging && !_isHovering && !_bloomController.isAnimating) {
      double maxV = 0;
      for (final p in _points) {
        if (p.isFixed) continue;
        maxV = math.max(maxV, (p.x - p.oldX).abs());
        maxV = math.max(maxV, (p.y - p.oldY).abs());
      }
      if (maxV < 0.05) {
        _motionStopTimer?.cancel();
        _motionStopTimer = Timer(const Duration(milliseconds: 200), _stopLoop);
      }
    }

    setState(() {});
  }

  void _runPhysics() {
    for (final p in _points) {
      if (p.isFixed) continue;
      final vx = (p.x - p.oldX) * _friction;
      final vy = (p.y - p.oldY) * _friction;
      p.oldX = p.x;
      p.oldY = p.y;
      p.x += vx;
      p.y += vy + _gravity;

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

    if (_isDragging && _mousePos != null) {
      final last   = _points.last;
      final anchor = Offset(_points[0].x, _points[0].y);
      final delta  = _mousePos! - anchor;
      final Offset target = delta.distance > _maxReach
          ? anchor + Offset.fromDirection(delta.direction, _maxReach)
          : _mousePos!;
      last.x = target.dx;
      last.y = target.dy;

      if (last.y > _ropeLength + _toggleThreshold && !_hasToggled) {
        _hasToggled = true;
        _bloomController.forward(from: 0.0);
        _startLoop(); // Ensure loop is active for bloom frames

        final rb        = context.findRenderObject() as RenderBox?;
        final globalPos = rb?.localToGlobal(Offset(last.x, last.y))
            ?? Offset(last.x, last.y);

        ref.read(transitionProvider.notifier).start(globalPos);
        // Minimal delay to ensure snapshot captures OLD theme before build triggers
        Future.delayed(const Duration(milliseconds: 16), () {
          if (mounted) ref.read(themeModeProvider.notifier).toggle();
        });
        HapticFeedback.mediumImpact();
      }
    }

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
              duration: const Duration(milliseconds: 350), // Faster blend
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

// ── Data ──────────────────────────────────────────────────────────────────────

class _Point {
  double x, y, oldX, oldY;
  final bool isFixed;
  _Point(this.x, this.y, {this.isFixed = false}) : oldX = x, oldY = y;
}

class _Stick {
  final _Point p1, p2;
  final double length;
  _Stick(this.p1, this.p2, this.length);
}

class _Snap {
  final double x, y;
  const _Snap(this.x, this.y);
}

// ── Painter ───────────────────────────────────────────────────────────────────

class _LampPainter extends CustomPainter {
  final List<_Snap> snapshots;
  final bool        isDark;
  final bool        isDragging;
  final Color       textMuted;
  final Color       border2;

  final double      themeT;
  final double      bloomT;

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

  void _drawRope(Canvas canvas) {
    if (snapshots.length < 2) return;
    
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.28)
        : Colors.black.withValues(alpha: 0.07);
    final ropeColor = isDark
        ? textMuted.withValues(alpha: 0.60)
        : textMuted.withValues(alpha: 0.55);
    
    // Shadow layer
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

  void _drawBulb(Canvas canvas) {
    if (snapshots.length < 2) return;

    final last   = snapshots.last;
    final second = snapshots[snapshots.length - 2];
    final angle  = math.atan2(last.y - second.y, last.x - second.x) - math.pi / 2;

    canvas.save();
    canvas.translate(last.x, last.y);
    canvas.rotate(angle);

    // Glass dome: y = 0 (top) → y = 14 (bottom)
    final bulbColor = Color.lerp(
      const Color(0xFFE8E8E4), // cool daylight (light)
      const Color(0xFFD4C89A), // warm tungsten (dark)
      themeT,
    )!;
    final bulbPath  = Path()
      ..moveTo(-6, 0)
      ..cubicTo(-9, 4, -9, 10, 0, 14)
      ..cubicTo( 9, 10, 9,  4, 6,  0)
      ..close();

    canvas.drawPath(
      bulbPath,
      Paint()
        ..color = isDragging
            ? bulbColor.withValues(alpha: 0.95)
            : bulbColor.withValues(alpha: isDark ? 0.50 : 0.70)
        ..style = PaintingStyle.fill,
    );
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

    // Filament (dark mode only)
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

    // Light bloom effect (radial glow behind bulb)
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
    if (old.themeT != themeT) {
      return true;
    }
    if (old.bloomT != bloomT) {
      return true;
    }
    if (old.isDark != isDark) {
      return true;
    }
    if (old.isDragging != isDragging) {
      return true;
    }
    if (old.snapshots.length != snapshots.length) {
      return true;
    }
    for (int i = 0; i < snapshots.length; i++) {
      if (old.snapshots[i].x != snapshots[i].x ||
          old.snapshots[i].y != snapshots[i].y) {
        return true;
      }
    }
    return false;
  }
}