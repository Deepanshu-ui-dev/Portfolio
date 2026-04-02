import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../features/github/data/github_repository.dart';

// ─────────────────────────────────────────────────────────────
// CONTRIBUTION GRAPH
//
// A clean, fully responsive GitHub-style contribution heatmap.
//
// Key design decisions:
//   • Cell size is computed dynamically to FILL available width
//     — no horizontal scroll needed, no wasted space
//   • On narrow screens (<380px), we show fewer weeks (last 26
//     weeks instead of full year) to keep cells readable
//   • Day-of-week labels hidden on very narrow screens
//   • Month labels are spaced relative to cell size
//   • 2px rounded corners on cells, subtle border on active cells
//   • Hover → inverts to white (dark) / black (light) for clarity
// ─────────────────────────────────────────────────────────────

class ContributionGraph extends StatefulWidget {
  final List<ContributionDay> contributions;

  const ContributionGraph({super.key, required this.contributions});

  @override
  State<ContributionGraph> createState() => _ContributionGraphState();
}

class _ContributionGraphState extends State<ContributionGraph> {
  ContributionDay? _hoveredDay;

  static const int _rows = 7;
  static const double _cellGap = 2.5;

  // ─── Group contributions into weeks ──────────────────────

  List<List<ContributionDay?>> _buildWeeks() {
    final days = widget.contributions;
    if (days.isEmpty) return [];

    final weeks = <List<ContributionDay?>>[];
    final firstWeekday = days.first.date.weekday % 7; // Sun=0

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

  // ─── Month labels ────────────────────────────────────────

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

  // ─── Colour ──────────────────────────────────────────────

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

  // ─── Build ───────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allWeeks = _buildWeeks();
    if (allWeeks.isEmpty) return const SizedBox(height: 80);

    final labelColor = isDark ? AppColors.textTerDark : AppColors.textTerLight;

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;

      // ── Responsive: show fewer weeks on narrow screens ──
      final showDayLabels = width >= 300;
      final dayLabelWidth = showDayLabels ? 18.0 : 0.0;
      final gridWidth = width - dayLabelWidth;

      // Calculate how many weeks we can fit at a minimum cell size of 7px
      final maxWeeks = ((gridWidth + _cellGap) / (7.0 + _cellGap)).floor();
      final weeksToShow = maxWeeks.clamp(20, allWeeks.length);

      // Use the most recent weeks
      final weeks = allWeeks.length > weeksToShow
          ? allWeeks.sublist(allWeeks.length - weeksToShow)
          : allWeeks;

      final weekCount = weeks.length;

      // ── Compute cell size to perfectly fill the grid width ──
      // gridWidth = weekCount * (cellSize + gap) - gap
      double cellSize = (gridWidth + _cellGap) / weekCount - _cellGap;
      cellSize = cellSize.clamp(5.0, 15.0);

      final weekStep = cellSize + _cellGap;
      final rowStep = cellSize + _cellGap;
      final gridHeight = _rows * rowStep - _cellGap;

      final monthLabels = _buildMonthLabels(weeks);

      // Month label row
      const labelRowHeight = 14.0;
      const labelGap = 4.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Month labels ──────────────────────────────────
          SizedBox(
            height: labelRowHeight,
            child: Padding(
              padding: EdgeInsets.only(left: dayLabelWidth),
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
                        fontSize: cellSize < 9 ? 7 : 8,
                        color: labelColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          SizedBox(height: labelGap),

          // ── Grid with optional day labels ─────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day-of-week labels
              if (showDayLabels)
                SizedBox(
                  width: dayLabelWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_rows, (i) {
                      const labels = ['', 'M', '', 'W', '', 'F', ''];
                      return SizedBox(
                        height: rowStep,
                        child: labels[i].isNotEmpty
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  labels[i],
                                  style: TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: cellSize < 9 ? 6 : 7,
                                    color: labelColor,
                                  ),
                                ),
                              )
                            : null,
                      );
                    }),
                  ),
                ),

              // Cell grid — using CustomPaint for performance
              Expanded(
                child: RepaintBoundary(
                  child: SizedBox(
                    height: gridHeight,
                    child: _HeatmapGrid(
                      weeks: weeks,
                      cellSize: cellSize,
                      cellGap: _cellGap,
                      isDark: isDark,
                      colorForLevel: _colorForLevel,
                      hoveredDay: _hoveredDay,
                      onHover: (day) {
                        if (_hoveredDay != day) {
                          setState(() => _hoveredDay = day);
                        }
                      },
                      onExit: () {
                        if (_hoveredDay != null) {
                          setState(() => _hoveredDay = null);
                        }
                      },
                      formatDate: _formatDate,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────
// HEATMAP GRID — Tooltip-aware cell grid
// ─────────────────────────────────────────────────────────────

class _HeatmapGrid extends StatelessWidget {
  final List<List<ContributionDay?>> weeks;
  final double cellSize;
  final double cellGap;
  final bool isDark;
  final Color Function(int level, bool isDark) colorForLevel;
  final ContributionDay? hoveredDay;
  final ValueChanged<ContributionDay?> onHover;
  final VoidCallback onExit;
  final String Function(DateTime) formatDate;

  const _HeatmapGrid({
    required this.weeks,
    required this.cellSize,
    required this.cellGap,
    required this.isDark,
    required this.colorForLevel,
    required this.hoveredDay,
    required this.onHover,
    required this.onExit,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final weekStep = cellSize + cellGap;
    final rowStep = cellSize + cellGap;

    return MouseRegion(
      onExit: (_) => onExit(),
      child: Stack(
        children: [
          for (int w = 0; w < weeks.length; w++)
            for (int d = 0; d < 7; d++)
              Positioned(
                left: w * weekStep,
                top: d * rowStep,
                child: weeks[w][d] != null
                    ? _HeatmapCell(
                        day: weeks[w][d]!,
                        size: cellSize,
                        isDark: isDark,
                        color: colorForLevel(weeks[w][d]!.level, isDark),
                        isHovered: hoveredDay == weeks[w][d],
                        onHover: onHover,
                        formatDate: formatDate,
                      )
                    : SizedBox(width: cellSize, height: cellSize),
              ),
        ],
      ),
    );
  }
}

class _HeatmapCell extends StatelessWidget {
  final ContributionDay day;
  final double size;
  final bool isDark;
  final Color color;
  final bool isHovered;
  final ValueChanged<ContributionDay?> onHover;
  final String Function(DateTime) formatDate;

  const _HeatmapCell({
    required this.day,
    required this.size,
    required this.isDark,
    required this.color,
    required this.isHovered,
    required this.onHover,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(day),
      child: Tooltip(
        message:
            '${formatDate(day.date)} · ${day.count} contribution${day.count == 1 ? '' : 's'}',
        preferBelow: false,
        waitDuration: Duration.zero,
        textStyle: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 10,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: isHovered
                ? (isDark
                    ? Colors.white.withValues(alpha: 0.85)
                    : Colors.black.withValues(alpha: 0.6))
                : color,
          ),
        ),
      ),
    );
  }
}