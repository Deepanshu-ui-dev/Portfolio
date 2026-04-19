import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';
import 'package:redacted/redacted.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/portfolio_config.dart';
import '../theme/app_theme.dart';
export 'skeleton_loaders.dart';
export 'magnet.dart';
export 'grid_background.dart';

/// ── Dashed Divider ──────────────────────────────────────────
class DashedDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double dashWidth;
  final double dashGap;
  final Color? color;

  const DashedDivider({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.dashWidth = 4,
    this.dashGap = 4,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? Theme.of(context).dividerTheme.color ?? AppColors.border;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _DashedLinePainter(
            color: effectiveColor,
            thickness: thickness,
            dashWidth: dashWidth,
            dashGap: dashGap,
          ),
        ),
      ),
    );
  }
}

class DashedVerticalDivider extends StatelessWidget {
  final double width;
  final double thickness;
  final double dashWidth;
  final double dashGap;
  final Color? color;

  const DashedVerticalDivider({
    super.key,
    this.width = 1,
    this.thickness = 1,
    this.dashWidth = 4,
    this.dashGap = 4,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? Theme.of(context).dividerTheme.color ?? AppColors.border;

    return Container(
      width: width,
      height: double.infinity,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: effectiveColor,
          thickness: thickness,
          dashWidth: dashWidth,
          dashGap: dashGap,
          isHorizontal: false,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double dashWidth;
  final double dashGap;
  final bool isHorizontal;

  _DashedLinePainter({
    required this.color,
    this.thickness = 1,
    this.dashWidth = 4,
    this.dashGap = 4,
    this.isHorizontal = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    if (isHorizontal) {
      double startX = 0;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2),
          paint,
        );
        startX += dashWidth + dashGap;
      }
    } else {
      double startY = 0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(size.width / 2, startY),
          Offset(size.width / 2, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.thickness != thickness ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.dashGap != dashGap ||
      oldDelegate.isHorizontal != isHorizontal;
}

/// ── Simple Section Divider ──────────────────────────────────
// ─── Dashed Border Container ──────────────────────────
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
    final c = color ?? AppColors.border;
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

// ─── Corners & Boxes ──────────────────────────────────
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
    final c = color ?? AppColors.border2;
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
  final String? index; // e.g. '01' → renders [ 01 ] eyebrow style
  const SectionHeader(this.title, {super.key, this.index});

  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accent;
    final textSec = AppColors.textSecondary;

    // ── Numbered eyebrow style [ 01 ] TITLE ─────────────────────────────
    if (widget.index != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 8),
        child: Row(children: [
          Text(
            '[ ${widget.index} ]',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: accent, letterSpacing: 1.5),
          ),
          const SizedBox(width: 10),
          Text(
            widget.title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: textSec, letterSpacing: 2),
          ),
        ]),
      );
    }

    // ── Bar style (original, for sections that don't have an index) ──────
    const kCurve = Cubic(0.33, 1.0, 0.68, 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 8),
        child: Row(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 6.0, end: _hovered ? 22.0 : 6.0),
              duration: const Duration(milliseconds: 220),
              curve: kCurve,
              builder: (_, w, __) => Container(
                width: w,
                height: 6,
                color: accent,
              ),
            ),
            const SizedBox(width: 10),
            AnimatedSlide(
              offset: _hovered ? const Offset(0.012, 0) : Offset.zero,
              duration: const Duration(milliseconds: 220),
              curve: kCurve,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                curve: kCurve,
                style: (Theme.of(context).textTheme.labelLarge ?? const TextStyle()).copyWith(
                  color: _hovered ? accent : AppColors.textPrimary,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
                child: Text(widget.title.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Collapsible Card ─────────────────────────────────
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

  // easeOutQuint approximation — smooth, premium expand feel
  static const _kExpandCurve = Cubic(0.22, 1.0, 0.36, 1.0);

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160), // Snappier
      value: _expanded ? 1.0 : 0.0,
    );
    _heightAnim = CurvedAnimation(parent: _ctrl, curve: _kExpandCurve);
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
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final surface  = isDark ? AppColors.surfaceDark    : AppColors.surfaceLight;
    final surfaceEl= isDark ? AppColors.surfaceElevDark: AppColors.surfaceElevLight;
    final border   = isDark ? AppColors.borderDark     : AppColors.borderLight;
    final textSec  = isDark ? AppColors.textSecDark    : AppColors.textSecLight;
    final tagBg    = isDark ? AppColors.surfaceElevDark: AppColors.surfaceElevLight;
    final accent   = isDark ? AppColors.accentDark     : AppColors.accentLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 2),
        transform: Matrix4.translationValues(0, _hovered ? -1.5 : 0.0, 0),
        decoration: BoxDecoration(
          color: _hovered ? surfaceEl : surface,
          borderRadius: BorderRadius.zero,
          border: Border(
            left: BorderSide(
              color: (_hovered || _expanded) ? accent : border,
              width: (_hovered || _expanded) ? 2 : 1,
            ),
            top: BorderSide(color: border, width: 1),
            bottom: BorderSide(color: border, width: 1),
            right: BorderSide(color: border, width: 1),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
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
                scale: _isPressed ? 0.985 : 1.0,
                duration: const Duration(milliseconds: 120),
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
                            Text(widget.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                            if (widget.subtitle != null) ...[
                              const SizedBox(height: 4),
                              Text(widget.subtitle!,
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: textSec.withValues(alpha: 0.7),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                      )),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(widget.rightLabel,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: textSec.withValues(alpha: 0.6),
                                fontSize: 9,
                              )),
                      const SizedBox(width: 10),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 160),
                        curve: _kExpandCurve,
                        child: Icon(LucideIcons.chevronDown, size: 14, color: _expanded ? accent : textSec),
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
                      padding: EdgeInsets.only(
                        left: AppSpacing.isMobile(context) ? 20 : 64,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...widget.bullets.map((b) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, right: 12),
                                      child: Container(
                                        width: 4, 
                                        height: 4, 
                                        decoration: BoxDecoration(
                                          color: (_hovered || _expanded) ? accent : textSec,
                                          borderRadius: BorderRadius.circular(1),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(b,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: textSec,
                                                height: 1.65,
                                              )),
                                    ),
                                  ],
                                ),
                              )),
                          if (widget.tags.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: widget.tags
                                  .map((t) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: tagBg,
                                          border: Border.all(color: border, width: 1),
                                          borderRadius: AppRadius.subtle,
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

// ─── Typewriter Line ──────────────────────────────────
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

// ─── Portfolio Footer ─────────────────────────────────
class PortfolioFooter extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isTransitioning;

  const PortfolioFooter({
    super.key,
    required this.onToggleTheme,
    this.isTransitioning = false,
  });

  @override
  State<PortfolioFooter> createState() => _PortfolioFooterState();
}

class _PortfolioFooterState extends State<PortfolioFooter> {
  bool _creditHovered = false;
  int _visitCount = 0;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadAndIncrementVisitCount();
    // Refresh count every 60 seconds for "real-time" feel
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) => _refreshVisitCount());
  }

  Future<void> _refreshVisitCount() async {
    try {
      final response = await http.get(Uri.parse(PortfolioConfig.visitorApiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final count = data['count'] as int;
        if (mounted) setState(() => _visitCount = count);
      }
    } catch (_) {}
  }

  Future<void> _loadAndIncrementVisitCount() async {
    try {
      const key = 'portfolio_visit_count';
      final prefs = await _getPrefs();
      
      // Increment and fetch global count from API
      final response = await http.get(Uri.parse('${PortfolioConfig.visitorApiUrl}/up'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final count = data['count'] as int;
        
        if (mounted) setState(() => _visitCount = count);
        // Update local cache for offline/fallback
        await prefs?.setInt(key, count);
      } else {
        // API failed, fallback to local increment
        final count = (prefs?.getInt(key) ?? 0) + 1;
        await prefs?.setInt(key, count);
        if (mounted) setState(() => _visitCount = count);
      }
    } catch (_) {
      // Network error, fallback to local increment
      try {
        final prefs = await _getPrefs();
        final count = (prefs?.getInt('portfolio_visit_count') ?? 0) + 1;
        await prefs?.setInt('portfolio_visit_count', count);
        if (mounted) setState(() => _visitCount = count);
      } catch (e) {
        // Fatal shared_prefs error, ignore
      }
    }
  }

  dynamic _prefsInstance;
  Future<dynamic> _getPrefs() async {
    try {
      if (_prefsInstance != null) return _prefsInstance;
      final prefs = await _SharedPrefsHelper.getInstance();
      _prefsInstance = prefs;
      return prefs;
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark       = Theme.of(context).brightness == Brightness.dark;
    final bgColor      = isDark ? AppColors.bgDark      : AppColors.bgLight;
    final borderColor  = isDark ? AppColors.borderDark  : AppColors.borderLight;
    final textTerColor = isDark ? AppColors.textTerDark  : AppColors.textTerLight;
    final accentColor  = isDark ? AppColors.accentDark   : AppColors.accentLight;
    final textSecColor = isDark ? AppColors.textSecDark  : AppColors.textSecLight;
    final creditColor  = _creditHovered ? accentColor : textSecColor;
    final isMobile = AppSpacing.isMobile(context);

    return Container(
      color: bgColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FadeRuleDivider(borderColor: borderColor),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.horizontalPadding(context),
              vertical: isMobile ? 24 : 18,
            ),
            child: isMobile
                ? _MobileFooterContent(
                    visitCount: _visitCount,
                    accentColor: accentColor,
                    textTerColor: textTerColor,
                    creditColor: creditColor,
                    onCreditHover: (v) => setState(() => _creditHovered = v),
                  )
                : _DesktopFooterContent(
                    visitCount: _visitCount,
                    accentColor: accentColor,
                    textTerColor: textTerColor,
                    creditColor: creditColor,
                    onCreditHover: (v) => setState(() => _creditHovered = v),
                  ),
          ),
        ],
      ),
    );
  }
}

/// A simple wrapper that accesses SharedPreferences via dynamic invocation
/// to avoid a direct import dependency in shared_widgets.dart
class _SharedPrefsHelper {
  static SharedPreferences? _instance;
  static Future<SharedPreferences?> getInstance() async {
    if (_instance != null) return _instance;
    try {
      final prefs = await _SharedPrefsAccess.get();
      _instance = prefs;
      return prefs;
    } catch (_) {
      return null;
    }
  }
}

class _SharedPrefsAccess {
  static Future<SharedPreferences?> get() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (_) {
      return null;
    }
  }
}

// ─── Desktop Footer Content ─────────────────────────────────
class _DesktopFooterContent extends StatelessWidget {
  final int visitCount;
  final Color accentColor;
  final Color textTerColor;
  final Color creditColor;
  final ValueChanged<bool> onCreditHover;

  const _DesktopFooterContent({
    required this.visitCount,
    required this.accentColor,
    required this.textTerColor,
    required this.creditColor,
    required this.onCreditHover,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Left/Center: Visitor badge ─────────────────────────────
        if (visitCount > 0) _VisitorBadge(
          count: visitCount,
          accentColor: accentColor,
          textTerColor: textTerColor,
        ),
        const Spacer(),
        // ── Right: Copyright + credit ─────────────────────────
        MouseRegion(
          onEnter: (_) => onCreditHover(true),
          onExit:  (_) => onCreditHover(false),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            style: TextStyle(
              color: creditColor,
              fontFamily: 'monospace',
              fontSize: 9,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w500,
            ),
            child: const Text('© 2026 Deepanshu · Built with 🤍'),
          ),
        ),
      ],
    );
  }
}

// ─── Mobile Footer Content ─────────────────────────────────
class _MobileFooterContent extends StatelessWidget {
  final int visitCount;
  final Color accentColor;
  final Color textTerColor;
  final Color creditColor;
  final ValueChanged<bool> onCreditHover;

  const _MobileFooterContent({
    required this.visitCount,
    required this.accentColor,
    required this.textTerColor,
    required this.creditColor,
    required this.onCreditHover,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (visitCount > 0) ...[
          _VisitorBadge(
            count: visitCount,
            accentColor: accentColor,
            textTerColor: textTerColor,
          ),
        ],
        const Spacer(),
        Text(
          '© 2026 Deepanshu',
          style: TextStyle(
            color: textTerColor,
            fontFamily: 'monospace',
            fontSize: 9,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}



// ─── Visitor Badge ────────────────────────────────────────
class _VisitorBadge extends StatelessWidget {
  final int count;
  final Color accentColor;
  final Color textTerColor;
  const _VisitorBadge({
    required this.count,
    required this.accentColor,
    required this.textTerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: accentColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          '${_formatCount(count)} VISITS',
          style: TextStyle(
            color: textTerColor,
            fontFamily: 'monospace',
            fontSize: 8,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString().padLeft(3, '0');
  }
}


/// Gradient-fade horizontal divider.
/// Rather than a plain dashed line, the border color fades in from the
/// edges and peaks at the center — a subtle editorial touch, no glows.
class _FadeRuleDivider extends StatelessWidget {
  final Color borderColor;
  const _FadeRuleDivider({required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FadeRulePainter(color: borderColor),
      size: const Size(double.infinity, 1),
    );
  }
}

class _FadeRulePainter extends CustomPainter {
  final Color color;
  const _FadeRulePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Solid 1px line that fades out at both edges (transparent → opaque → transparent)
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.8),
          color.withValues(alpha: 0.8),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.18, 0.82, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(_FadeRulePainter old) => old.color != color;
}

// ─────────────────────────────────────────────
// THEME-AWARE REDACTED SKELETON LOADER
// ─────────────────────────────────────────────

class ThemedSkeletonLoader extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Duration animationDuration;

  const ThemedSkeletonLoader({
    super.key,
    required this.child,
    this.isLoading = true,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return child.redacted(
      context: context,
      redact: true,
      configuration: RedactedConfiguration(
        animationDuration: animationDuration,
      ),
    );
  }
}