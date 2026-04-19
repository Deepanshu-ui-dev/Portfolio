import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GridBackground extends StatelessWidget {
  final Widget child;
  const GridBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RepaintBoundary(
      child: CustomPaint(
        painter: _GridPainter(isDark: isDark),
        child: child,
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final bool isDark;
  const _GridPainter({required this.isDark});

  // Pre-resolved dot colors pulled from the Obsidian & Citron tokens.
  static Color get _dotDark  => AppColors.surfaceElevDark;
  static Color get _dotLight => AppColors.border2Light;

  @override
  void paint(Canvas canvas, Size size) {
    // ── 1. Background fill ──────────────────────────────────────────────
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = Color.lerp(AppColors.background, AppColors.surface, 0.5)!
        ..style = PaintingStyle.fill,
    );

    // ── 2. Dot grid ─────────────────────────────────────────────────────
    // No MaskFilter/blur — it costs GPU time and turns crisp 0.85px dots
    // into fuzzy 3px blobs that read as "noise" rather than "grid".
    //
    // Radial fade: dots at the center are fully opaque; dots at the edges
    // fade to transparent. Using pow(t, 1.6) gives a tighter, more focused
    // halo rather than a perfectly linear fade.
    //
    // Spacing 20px feels open at typical mobile densities (logical pixels).
    // Drop to 16px for a denser look if needed.

    const spacing    = 20.0;
    const dotRadius  = 0.85;
    const maxAlphaDark  = 0.90;
    const maxAlphaLight = 0.70;

    final baseColor = isDark ? _dotDark : _dotLight;
    final maxAlpha  = isDark ? maxAlphaDark : maxAlphaLight;

    final cx      = size.width  / 2;
    final cy      = size.height / 2;
    final maxDist = math.sqrt(cx * cx + cy * cy);

    final dotPaint = Paint()..isAntiAlias = true;

    for (double x = spacing / 2; x < size.width;  x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        final dx    = x - cx;
        final dy    = y - cy;
        final t     = 1.0 - math.sqrt(dx * dx + dy * dy) / maxDist;
        final alpha = math.pow(t, 1.6).toDouble() * maxAlpha;
        if (alpha < 0.015) continue;

        dotPaint.color = baseColor.withValues(alpha: alpha);
        canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.isDark != isDark;
}