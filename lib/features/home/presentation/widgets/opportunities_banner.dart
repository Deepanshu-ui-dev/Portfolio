import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class OpportunitiesBanner extends StatefulWidget {
  const OpportunitiesBanner({super.key});

  @override
  State<OpportunitiesBanner> createState() => _OpportunitiesBannerState();
}

class _OpportunitiesBannerState extends State<OpportunitiesBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _pingCtrl;
  late Animation<double> _pingAnim;
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _now = DateTime.now());
    });
    _pingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _pingAnim = CurvedAnimation(parent: _pingCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _pingCtrl.dispose();
    _timer.cancel();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    final months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    final days = [
      'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'
    ];
    final dayName = days[dt.weekday - 1];
    final monthName = months[dt.month - 1];
    final day = dt.day.toString().padLeft(2, '0');
    return '$dayName, $monthName $day';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '${dt.year} // $h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.border;
    final dimColor = AppColors.textTer;
    final detailColor = AppColors.textSecondary;
    final accentColor = AppColors.accent;

    return Stack(
      children: [
        // ── Corner brackets ──────────────────────
        Positioned(top: 0,    left: 0,  child: _CornerBracket(corner: Corner.topLeft,     color: borderColor)),
        Positioned(top: 0,    right: 0, child: _CornerBracket(corner: Corner.topRight,    color: borderColor)),
        Positioned(bottom: 0, left: 0,  child: _CornerBracket(corner: Corner.bottomLeft,  color: borderColor)),
        Positioned(bottom: 0, right: 0, child: _CornerBracket(corner: Corner.bottomRight, color: borderColor)),

        // ── Content ──────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: dot + labels
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Pulsing dot
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _pingAnim,
                            builder: (context, child) => Transform.scale(
                              scale: 1.0 + _pingAnim.value * 1.6,
                              child: Opacity(
                                opacity: (1.0 - _pingAnim.value) * 0.35,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Text column
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatDate(_now),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: accentColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.04,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatTime(_now),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: detailColor,
                                  fontSize: 10,
                                  letterSpacing: 1.0,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Right: version label
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'STATUS // 00',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: dimColor,
                          fontSize: 9,
                          letterSpacing: 0.14,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'v2026',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: borderColor,
                          fontSize: 8,
                          letterSpacing: 0.1,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Top & bottom dashed lines ─────────────
        Positioned(top: 0,    left: 0, right: 0, child: _DashedLine(color: borderColor)),
        Positioned(bottom: 0, left: 0, right: 0, child: _DashedLine(color: borderColor)),
      ],
    );
  }
}

// ── Helpers ──────────────────────────────────────

class _DashedLine extends StatelessWidget {
  final Color color;
  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      const dashW = 6.0, gapW = 4.0;
      final count = (constraints.maxWidth / (dashW + gapW)).floor();
      return Row(
        children: List.generate(
          count,
          (_) => Row(children: [
            Container(width: dashW, height: 1, color: color),
            SizedBox(width: gapW),
          ]),
        ),
      );
    });
  }
}

enum Corner { topLeft, topRight, bottomLeft, bottomRight }

class _CornerBracket extends StatelessWidget {
  final Corner corner;
  final Color color;
  const _CornerBracket({required this.corner, required this.color});

  @override
  Widget build(BuildContext context) {
    final top  = corner == Corner.topLeft  || corner == Corner.topRight;
    final left = corner == Corner.topLeft  || corner == Corner.bottomLeft;
    return SizedBox(
      width: 10,
      height: 10,
      child: CustomPaint(
        painter: _BracketPainter(top: top, left: left, color: color),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  final bool top, left;
  final Color color;
  const _BracketPainter(
      {required this.top, required this.left, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    final x  = left ? 0.0        : size.width;
    final y  = top  ? 0.0        : size.height;
    final dx = left ? size.width  : -size.width;
    final dy = top  ? size.height : -size.height;
    canvas.drawLine(Offset(x, y), Offset(x + dx, y), paint);
    canvas.drawLine(Offset(x, y), Offset(x, y + dy), paint);
  }

  @override
  bool shouldRepaint(_BracketPainter old) =>
      old.top != top || old.left != left || old.color != color;
}