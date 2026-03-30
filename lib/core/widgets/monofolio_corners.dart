import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────
// MONOFOLIO CORNER & BOX
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
    final c = color ?? AppColors.surfaceBorder;
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? BorderSide(color: c, width: 1) : BorderSide.none,
          bottom: !isTop ? BorderSide(color: c, width: 1) : BorderSide.none,
          left: isLeft ? BorderSide(color: c, width: 1) : BorderSide.none,
          right: !isLeft ? BorderSide(color: c, width: 1) : BorderSide.none,
        ),
      ),
    );
  }
}

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
        Padding(
          padding: padding,
          child: child,
        ),
        Positioned(top: 0, left: 0, child: MonofolioCorner(isTop: true, isLeft: true, color: color)),
        Positioned(top: 0, right: 0, child: MonofolioCorner(isTop: true, isLeft: false, color: color)),
        Positioned(bottom: 0, left: 0, child: MonofolioCorner(isTop: false, isLeft: true, color: color)),
        Positioned(bottom: 0, right: 0, child: MonofolioCorner(isTop: false, isLeft: false, color: color)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// MONOFOLIO COLLAPSIBLE CARD
// Matches the new experience/education card style from screenshots
// ─────────────────────────────────────────────

class MonofolioCollapsibleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String rightLabel;
  final List<String> bullets;
  final List<String> tags;
  final bool initiallyExpanded;

  const MonofolioCollapsibleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.rightLabel,
    required this.bullets,
    required this.tags,
    this.initiallyExpanded = false,
  });

  @override
  State<MonofolioCollapsibleCard> createState() =>
      _MonofolioCollapsibleCardState();
}

class _MonofolioCollapsibleCardState extends State<MonofolioCollapsibleCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header (Clickable) ──
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icon in a bordered box
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.surfaceBorder, width: 1),
                    ),
                    child: Icon(widget.icon, size: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  Text(
                    widget.rightLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded Content ──
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.only(left: 58, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bullet points
                  ...widget.bullets.map((bullet) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5, right: 10),
                              child: Container(
                                width: 5,
                                height: 5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                bullet,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                      height: 1.7,
                                      fontSize: 11,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      )),

                  if (widget.tags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    // Tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.tags
                          .map((tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.surfaceBorder, width: 1),
                                ),
                                child: Text(
                                  tag,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 10,
                                      ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MONOFOLIO SECTION HEADER  (■ Title)
// ─────────────────────────────────────────────

class MonofolioSectionHeader extends StatelessWidget {
  final String title;
  final bool allCaps;

  const MonofolioSectionHeader({
    super.key,
    required this.title,
    this.allCaps = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 10),
          Text(
            allCaps ? title.toUpperCase() : title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: allCaps ? 1.5 : 0,
                ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STRIPE BAND  (diagonal lines separator)
// ─────────────────────────────────────────────

class MonofolioStripeBand extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry margin;

  const MonofolioStripeBand({
    super.key,
    this.height = 24,
    this.margin = const EdgeInsets.symmetric(vertical: 0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _DiagonalStripePainter(
          color: AppColors.surfaceBorder.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}

class _DiagonalStripePainter extends CustomPainter {
  final Color color;
  const _DiagonalStripePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = -size.height; x < size.width; x += 8) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DiagonalStripePainter old) =>
      old.color != color;
}

// ─────────────────────────────────────────────
// SHARED FOOTER WIDGET
// ─────────────────────────────────────────────

class MonofolioFooter extends StatelessWidget {
  const MonofolioFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.surfaceBorder, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.surfaceBorder, width: 1),
                ),
                child: Icon(Icons.grid_view,
                    size: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DESIGN & BUILD',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 1.2,
                        ),
                  ),
                  Text(
                    '© 2026 — Bilal',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.wb_sunny_outlined,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Icon(Icons.nightlight_round,
                  size: 14, color: AppColors.textPrimary),
            ],
          ),
        ],
      ),
    );
  }
}