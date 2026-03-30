import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../features/github/data/github_repository.dart';

class ContributionGraph extends StatefulWidget {
  final List<ContributionDay> contributions;

  const ContributionGraph({super.key, required this.contributions});

  @override
  State<ContributionGraph> createState() => _ContributionGraphState();
}

class _ContributionGraphState extends State<ContributionGraph> {
  ContributionDay? _hoveredDay;
  final ScrollController _scrollController = ScrollController();

  // We'll compute cell size dynamically to fill available width.
  // These are the constraints we work within:
  static const int _rows = 7; // days of week
  static const double _minCellSize = 8.0;
  static const double _maxCellSize = 14.0;
  static const double _cellGap = 3.0;

  @override
  void initState() {
    super.initState();
    // Scroll to end (latest date) after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Group contributions into weeks ────────────────────────────────────

  List<List<ContributionDay?>> _buildWeeks() {
    final days = widget.contributions;
    if (days.isEmpty) return [];

    final weeks = <List<ContributionDay?>>[];
    // Sun=0 in our grid (Dart weekday: Mon=1…Sun=7, so Sun = 7%7 = 0)
    final firstWeekday = days.first.date.weekday % 7;

    var current = List<ContributionDay?>.filled(7, null);
    int wIdx = firstWeekday;

    for (final day in days) {
      current[wIdx] = day;
      wIdx++;
      if (wIdx == 7) {
        weeks.add(List.from(current));
        current = List.filled(7, null);
        wIdx = 0;
      }
    }
    if (wIdx > 0) weeks.add(List.from(current));
    return weeks;
  }

  // ─── Month labels ────────────────────────────────────────────────────────

  Map<int, String> _buildMonthLabels(List<List<ContributionDay?>> weeks) {
    final labels = <int, String>{};
    final seen = <String>{};
    for (int w = 0; w < weeks.length; w++) {
      for (final day in weeks[w]) {
        if (day == null) continue;
        if (day.date.day <= 7) {
          final key = '${day.date.year}-${day.date.month}';
          if (seen.add(key)) labels[w] = _monthAbbr(day.date.month);
        }
      }
    }
    return labels;
  }

  // ─── Colour ──────────────────────────────────────────────────────────────

  Color _colorForLevel(int level, bool isDark) {
    if (isDark) {
      switch (level) {
        case 0: return AppColors.contrib0Dark;
        case 1: return AppColors.contrib1Dark;
        case 2: return AppColors.contrib2Dark;
        case 3: return AppColors.contrib3Dark;
        default: return AppColors.contrib4Dark;
      }
    } else {
      switch (level) {
        case 0: return AppColors.contrib0Light;
        case 1: return AppColors.contrib1Light;
        case 2: return AppColors.contrib2Light;
        case 3: return AppColors.contrib3Light;
        default: return AppColors.contrib4Light;
      }
    }
  }

  String _monthAbbr(int m) => const [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m - 1];

  String _formatDate(DateTime d) =>
      '${_monthAbbr(d.month)} ${d.day}, ${d.year}';

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weeks = _buildWeeks();
    if (weeks.isEmpty) return const SizedBox(height: 80);

    final monthLabels = _buildMonthLabels(weeks);
    final labelColor = isDark ? AppColors.textTerDark : AppColors.textTerLight;
    final dayLabelColor =
        isDark ? AppColors.textTerDark : AppColors.textTerLight;

    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth;

      // ── Compute cell size to fill available width ──
      // availableWidth = weekCount * (cellSize + gap) - gap + dayLabelWidth
      // We reserve 24px on the left for day-of-week labels (S M T W T F S)
      const dayLabelWidth = 20.0;
      final gridWidth = availableWidth - dayLabelWidth;
      final weekCount = weeks.length;

      // cellSize that fills exactly: gridWidth = weekCount*(cellSize+gap) - gap
      double cellSize = (gridWidth + _cellGap) / weekCount - _cellGap;
      cellSize = cellSize.clamp(_minCellSize, _maxCellSize);

      final weekStep = cellSize + _cellGap;
      final totalGridWidth = weekCount * weekStep - _cellGap;

      // Label row height
      const labelRowHeight = 16.0;
      const labelRowGap = 6.0;
      final rowStep = cellSize + _cellGap;
      final gridHeight = _rows * rowStep - _cellGap;

      return SizedBox(
        width: availableWidth,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Day-of-week labels (S M T W T F S) ──────────────────────
            Padding(
              padding: const EdgeInsets.only(
                  top: labelRowHeight + labelRowGap + 1),
              child: SizedBox(
                width: dayLabelWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_rows, (i) {
                    const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                    // Only show M, W, F to avoid clutter
                    final show = i == 1 || i == 3 || i == 5;
                    return SizedBox(
                      height: rowStep,
                      child: show
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                labels[i],
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 8,
                                  color: dayLabelColor,
                                  letterSpacing: 0,
                                ),
                              ),
                            )
                          : null,
                    );
                  }),
                ),
              ),
            ),

            // ── Graph ────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: totalGridWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Month labels ────────────────────────────────
                      SizedBox(
                        height: labelRowHeight,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: monthLabels.entries.map((e) {
                            return Positioned(
                              left: e.key * weekStep,
                              top: 0,
                              child: Text(
                                e.value,
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 9,
                                  color: labelColor,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // ── Cell grid ───────────────────────────────────
                      SizedBox(
                        height: gridHeight,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: weeks.asMap().entries.map((weekEntry) {
                            final wIdx = weekEntry.key;
                            final week = weekEntry.value;
                            final isLastWeek = wIdx == weeks.length - 1;

                            return Padding(
                              padding: EdgeInsets.only(
                                  right: isLastWeek ? 0 : _cellGap),
                              child: SizedBox(
                                width: cellSize,
                                height: gridHeight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: List.generate(_rows, (d) {
                                    final day = week[d];
                                    final isLast = d == _rows - 1;

                                    if (day == null) {
                                      return SizedBox(
                                        width: cellSize,
                                        height: cellSize +
                                            (isLast ? 0 : _cellGap),
                                      );
                                    }

                                    final color =
                                        _colorForLevel(day.level, isDark);
                                    final isHovered = _hoveredDay == day;

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: isLast ? 0 : _cellGap),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.basic,
                                        onEnter: (_) => setState(
                                            () => _hoveredDay = day),
                                        onExit: (_) =>
                                            setState(() => _hoveredDay =
                                                null),
                                        child: Tooltip(
                                          message:
                                              '${_formatDate(day.date)} · ${day.count} contribution${day.count == 1 ? '' : 's'}',
                                          preferBelow: false,
                                          waitDuration: Duration.zero,
                                          textStyle: TextStyle(
                                            fontFamily: 'JetBrainsMono',
                                            fontSize: 10,
                                            color: isDark
                                                ? AppColors.textPrimaryDark
                                                : AppColors
                                                    .textPrimaryLight,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? AppColors.surfaceElevDark
                                                : AppColors.surfaceElevLight,
                                            border: Border.all(
                                              color: isDark
                                                  ? AppColors.borderDark
                                                  : AppColors.borderLight,
                                            ),
                                          ),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 100),
                                            width: cellSize,
                                            height: cellSize,
                                            decoration: BoxDecoration(
                                              color: isHovered
                                                  ? (isDark
                                                      ? Colors.white
                                                          .withValues(
                                                              alpha: 0.9)
                                                      : Colors.black
                                                          .withValues(
                                                              alpha: 0.7))
                                                  : color,
                                              // Subtle border on non-zero cells
                                              border: day.level > 0
                                                  ? Border.all(
                                                      color: color
                                                          .withValues(
                                                              alpha: 0.4),
                                                      width: 0.5,
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}