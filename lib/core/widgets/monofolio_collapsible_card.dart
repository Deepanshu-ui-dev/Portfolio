// monofolio_collapsible_card.dart
//
// NOTE: The canonical CollapsibleCard is now in shared_widgets.dart.
// This file re-exports it so existing imports don't break, and keeps
// the legacy MonofolioCollapsibleCard for any screens that still use it.

export '../widgets/shared_widgets.dart' show CollapsibleCard;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────
// LEGACY: MonofolioCollapsibleCard
// Kept for backward-compat. Prefer CollapsibleCard from shared_widgets.
// ─────────────────────────────────────────────

class MonofolioCollapsibleCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String rightLabel;
  final List<String> bullets;
  final List<String> tags;
  final bool initiallyExpanded;

  const MonofolioCollapsibleCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.rightLabel,
    required this.bullets,
    required this.tags,
    this.initiallyExpanded = false,
  });

  @override
  State<MonofolioCollapsibleCard> createState() =>
      _MonofolioCollapsibleCardState();
}

class _MonofolioCollapsibleCardState
    extends State<MonofolioCollapsibleCard>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: _expanded ? 1.0 : 0.0,
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border =
        isDark ? AppColors.borderDark : AppColors.borderLight;
    final textSec =
        isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final tagBg =
        isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────
          InkWell(
            onTap: _toggle,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icon in bordered box
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        border: Border.all(color: border, width: 1)),
                    child: Icon(widget.icon, size: 13, color: textSec),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 3),
                          Text(widget.subtitle!,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: textSec)),
                        ],
                      ],
                    ),
                  ),
                  Text(widget.rightLabel,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: textSec)),
                  const SizedBox(width: 10),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(Icons.keyboard_arrow_down,
                        size: 14, color: textSec),
                  ),
                ],
              ),
            ),
          ),

          // ── Expandable body ─────────────────
          SizeTransition(
            sizeFactor: _anim,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 58, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.bullets.map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, right: 10),
                              child: Container(
                                  width: 4,
                                  height: 4,
                                  color: textSec),
                            ),
                            Expanded(
                              child: Text(b,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: tagBg,
                                  border: Border.all(
                                      color: border, width: 1),
                                ),
                                child: Text(t,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          letterSpacing: 0.3,
                                          color: textSec,
                                        )),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MONOFOLIO SECTION HEADER  (legacy alias)
// ─────────────────────────────────────────────

class MonofolioSectionHeader extends StatelessWidget {
  final String title;
  final bool allCaps;

  const MonofolioSectionHeader({
    super.key,
    required this.title,
    this.allCaps = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dotColor =
        isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18, top: 4),
      child: Row(
        children: [
          Container(width: 6, height: 6, color: dotColor),
          const SizedBox(width: 10),
          Text(
            allCaps ? title.toUpperCase() : title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: textColor,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}