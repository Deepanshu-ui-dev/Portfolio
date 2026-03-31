import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────
// DASHED BORDER CONTAINER
// ─────────────────────────────────────────────

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  const DashedBorderContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? (isDark ? AppColors.borderDark : AppColors.borderLight);
    return CustomPaint(
      painter: _DashedBorderPainter(color: c),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  const _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dash = 4.0;
    const gap = 4.0;

    void drawDashed(Offset a, Offset b) {
      final dx = b.dx - a.dx;
      final dy = b.dy - a.dy;
      final len = sqrt(dx * dx + dy * dy);
      final nx = dx / len;
      final ny = dy / len;
      double d = 0;
      bool drawing = true;
      while (d < len) {
        final end = min(d + (drawing ? dash : gap), len);
        if (drawing) {
          canvas.drawLine(
            Offset(a.dx + nx * d, a.dy + ny * d),
            Offset(a.dx + nx * end, a.dy + ny * end),
            paint,
          );
        }
        d = end;
        drawing = !drawing;
      }
    }

    drawDashed(Offset.zero, Offset(size.width, 0));
    drawDashed(Offset(size.width, 0), Offset(size.width, size.height));
    drawDashed(Offset(size.width, size.height), Offset(0, size.height));
    drawDashed(Offset(0, size.height), Offset.zero);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) => old.color != color;
}

// ─────────────────────────────────────────────
// DASHED DIVIDERS
// ─────────────────────────────────────────────

class DashedDivider extends StatelessWidget {
  final double height;
  final Color? color;
  const DashedDivider({super.key, this.height = 1, this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? (isDark ? AppColors.borderDark : AppColors.borderLight);
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _DashedLinePainter(color: c, isHorizontal: true)),
    );
  }
}

class DashedVerticalDivider extends StatelessWidget {
  final double width;
  final Color? color;
  const DashedVerticalDivider({super.key, this.width = 1, this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? (isDark ? AppColors.borderDark : AppColors.borderLight);
    return SizedBox(
      height: double.infinity,
      width: width,
      child: CustomPaint(painter: _DashedLinePainter(color: c, isHorizontal: false)),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final bool isHorizontal;
  const _DashedLinePainter({required this.color, required this.isHorizontal});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dash = 4.0;
    const gap = 4.0;
    double d = 0;
    bool drawing = true;
    final len = isHorizontal ? size.width : size.height;

    while (d < len) {
      final end = min(d + (drawing ? dash : gap), len);
      if (drawing) {
        if (isHorizontal) {
          canvas.drawLine(Offset(d, 0), Offset(end, 0), paint);
        } else {
          canvas.drawLine(Offset(0, d), Offset(0, end), paint);
        }
      }
      d = end;
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter old) =>
      old.color != color || old.isHorizontal != isHorizontal;
}

// ─────────────────────────────────────────────
// MONOFOLIO CORNER  (L-shaped bracket)
// ─────────────────────────────────────────────

class MonofolioCorner extends StatelessWidget {
  final bool isTop;
  final bool isLeft;
  final Color? color;

  const MonofolioCorner({
    super.key,
    required this.isTop,
    required this.isLeft,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? (isDark ? AppColors.border2Dark : AppColors.border2Light);
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? BorderSide(color: c, width: 1.5) : BorderSide.none,
          bottom: !isTop ? BorderSide(color: c, width: 1.5) : BorderSide.none,
          left: isLeft ? BorderSide(color: c, width: 1.5) : BorderSide.none,
          right: !isLeft ? BorderSide(color: c, width: 1.5) : BorderSide.none,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MONOFOLIO CORNERS BOX
// ─────────────────────────────────────────────

class MonofolioCornersBox extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;

  const MonofolioCornersBox({
    super.key,
    required this.child,
    this.color,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(padding: padding, child: child),
        Positioned(top: 0, left: 0, child: MonofolioCorner(isTop: true, isLeft: true, color: color)),
        Positioned(top: 0, right: 0, child: MonofolioCorner(isTop: true, isLeft: false, color: color)),
        Positioned(bottom: 0, left: 0, child: MonofolioCorner(isTop: false, isLeft: true, color: color)),
        Positioned(bottom: 0, right: 0, child: MonofolioCorner(isTop: false, isLeft: false, color: color)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// STRIPE BAND  (diagonal hatching separator)
// ─────────────────────────────────────────────

class StripeBand extends StatelessWidget {
  final double height;
  const StripeBand({super.key, this.height = 18});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark
        ? Colors.white.withValues(alpha: 0.035)
        : Colors.black.withValues(alpha: 0.045);
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _StripePainter(color: color)),
    );
  }
}

class _StripePainter extends CustomPainter {
  final Color color;
  const _StripePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = -size.height; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StripePainter old) => old.color != color;
}

// ─────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────

class SectionHeader extends StatefulWidget {
  final String title;
  const SectionHeader(this.title, {super.key});

  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dotColor = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18, top: 4),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _hovered ? 12 : 6,
              height: 6,
              color: _hovered ? accent : dotColor,
            ),
            const SizedBox(width: 10),
            AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(left: _hovered ? 6 : 0),
              child: Text(
                widget.title.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: textColor,
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// COLLAPSIBLE CARD
// ─────────────────────────────────────────────

class CollapsibleCard extends StatefulWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final String rightLabel;
  final bool initiallyExpanded;
  final List<String> bullets;
  final List<String> tags;

  const CollapsibleCard({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    required this.rightLabel,
    this.initiallyExpanded = false,
    this.bullets = const [],
    this.tags = const [],
  });

  @override
  State<CollapsibleCard> createState() => _CollapsibleCardState();
}

class _CollapsibleCardState extends State<CollapsibleCard>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _ctrl;
  late Animation<double> _heightAnim;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
      value: _expanded ? 1.0 : 0.0,
    );
    _heightAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final surfaceEl = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final tagBg = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 2),
        transform: Matrix4.translationValues(0, _hovered ? -2.0 : 0.0, 0),
        decoration: BoxDecoration(
          color: _hovered ? surfaceEl : surface,
          border: Border.all(color: border, width: 1),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: _toggle,
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: AnimatedScale(
                scale: _isPressed ? 0.98 : 1.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutCubic,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      widget.leading,
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.title, style: Theme.of(context).textTheme.headlineMedium),
                            if (widget.subtitle != null) ...[
                              const SizedBox(height: 3),
                              Text(widget.subtitle!,
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: textSec)),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(widget.rightLabel,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: textSec)),
                      const SizedBox(width: 10),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 220),
                        child: Icon(LucideIcons.chevronDown, size: 14, color: textSec),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: _heightAnim,
              child: (widget.bullets.isNotEmpty || widget.tags.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 58, right: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...widget.bullets.map((b) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, right: 10),
                                      child: Container(width: 4, height: 4, color: textSec),
                                    ),
                                    Expanded(
                                      child: Text(b,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: textSec,
                                                height: 1.75,
                                              )),
                                    ),
                                  ],
                                ),
                              )),
                          if (widget.tags.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: widget.tags
                                  .map((t) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: tagBg,
                                          border: Border.all(color: border, width: 1),
                                        ),
                                        child: Text(t,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(letterSpacing: 0.3, color: textSec)),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TYPEWRITER LINE  — cycles through phrases
// ─────────────────────────────────────────────

class _TypewriterLine extends StatefulWidget {
  final List<String> phrases;

  const _TypewriterLine({required this.phrases});

  @override
  State<_TypewriterLine> createState() => _TypewriterLineState();
}

class _TypewriterLineState extends State<_TypewriterLine> {
  int _phraseIndex = 0;
  String _displayed = '';
  bool _deleting = false;
  Timer? _timer;

  static const _typeSpeed   = Duration(milliseconds: 60);
  static const _deleteSpeed = Duration(milliseconds: 35);
  static const _pauseFull   = Duration(milliseconds: 1800);
  static const _pauseEmpty  = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _schedule(_typeSpeed);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _schedule(Duration delay) {
    _timer = Timer(delay, _tick);
  }

  void _tick() {
    final full = widget.phrases[_phraseIndex];

    if (!_deleting) {
      if (_displayed.length < full.length) {
        setState(() => _displayed = full.substring(0, _displayed.length + 1));
        _schedule(_typeSpeed);
      } else {
        _deleting = true;
        _schedule(_pauseFull);
      }
    } else {
      if (_displayed.isNotEmpty) {
        setState(() => _displayed = _displayed.substring(0, _displayed.length - 1));
        _schedule(_deleteSpeed);
      } else {
        _deleting = false;
        _phraseIndex = (_phraseIndex + 1) % widget.phrases.length;
        _schedule(_pauseEmpty);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(_displayed, style: style),
        _Cursor(style: style),
      ],
    );
  }
}

// Blinking block cursor
class _Cursor extends StatefulWidget {
  final TextStyle? style;
  const _Cursor({this.style});

  @override
  State<_Cursor> createState() => _CursorState();
}

class _CursorState extends State<_Cursor> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 530))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _ctrl.value > 0.5 ? 1.0 : 0.0,
        child: Text('▌', style: widget.style),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PORTFOLIO FOOTER  — dark, compact, single line
// ─────────────────────────────────────────────

class PortfolioFooter extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const PortfolioFooter({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  static const Color _bg       = Color(0xFF0A0A09);
  static const Color _border   = Color(0x12FFFFFF);
  static const Color _text2    = Color(0xFF7A7870);
  static const Color _text3    = Color(0xFF4A4845);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bg,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DashedRule(color: _border),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.horizontalPadding(context),
              vertical: 20,
            ),
            // ── Always a single Row: copyright left, Built with right ──
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '© 2026 — Deepanshu',
                  style: const TextStyle(
                    color: _text3,
                    fontFamily: 'monospace',
                    fontSize: 10,
                    letterSpacing: 0.4,
                  ),
                ),
                const Text(
                  'Built with 🤍',
                  style: TextStyle(
                    color: _text2,
                    fontFamily: 'monospace',
                    fontSize: 10,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Theme toggle (kept for external use) ─────────────────────────────────

class _ThemeToggle extends StatefulWidget {
  final VoidCallback onTap;
  const _ThemeToggle({required this.onTap});

  @override
  State<_ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<_ThemeToggle> {
  bool _hovered = false;

  static const Color _border   = Color(0x12FFFFFF);
  static const Color _borderHi = Color(0x24FFFFFF);
  static const Color _text1    = Color(0xFFE8E6DF);
  static const Color _text2    = Color(0xFF7A7870);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hovered ? _borderHi : _border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.moon,
                  size: 13,
                  color: _hovered
                      ? _text1
                      : _text2),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tiny dashed rule helper ───────────────────────────────────────────────

class _DashedRule extends StatelessWidget {
  final Color color;
  const _DashedRule({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(
        painter: _DashedLinePainter(color: color, isHorizontal: true),
      ),
    );
  }
}