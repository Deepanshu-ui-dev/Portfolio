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
  late List<List<ContributionDay?>> _weeks;
  late Map<int, String> _monthLabels;

  static const int _rows = 7;
  static const double _cellGap = 2.5;

  @override
  void initState() {
    super.initState();
    _weeks = _buildWeeks();
    _monthLabels = _buildMonthLabels(_weeks);
  }

  @override
  void didUpdateWidget(ContributionGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.contributions != oldWidget.contributions) {
      _weeks = _buildWeeks();
      _monthLabels = _buildMonthLabels(_weeks);
    }
  }

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

  Color _colorForLevel(int level) {
    switch (level) {
      case 0: return AppColors.contrib0;
      case 1: return AppColors.contrib1;
      case 2: return AppColors.contrib2;
      case 3: return AppColors.contrib3;
      case 4: return AppColors.contrib4;
      case 5: return AppColors.contrib5;
      default: return AppColors.contrib5;
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
    if (_weeks.isEmpty) return const SizedBox(height: 80);

    final labelColor = AppColors.textSecondary;

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;

      // ── Responsive: show fewer weeks on narrow screens ──
      final showDayLabels = width >= 300;
      final dayLabelWidth = showDayLabels ? 18.0 : 0.0;
      final gridWidth = width - dayLabelWidth;

      // Calculate how many weeks we can fit at a minimum cell size of 7px
      final maxWeeks = ((gridWidth + _cellGap) / (7.0 + _cellGap)).floor();
      final weeksToShow = maxWeeks.clamp(20, _weeks.length).toInt();

      // Use the most recent weeks
      final weeks = _weeks.length > weeksToShow
          ? _weeks.sublist(_weeks.length - weeksToShow)
          : _weeks;

      final weekCount = weeks.length;

      // ── Compute cell size to perfectly fill the grid width ──
      // gridWidth = weekCount * (cellSize + gap) - gap
      double cellSize = (gridWidth + _cellGap) / weekCount - _cellGap;
      cellSize = cellSize.clamp(5.0, 15.0);

      final weekStep = cellSize + _cellGap;
      final rowStep = cellSize + _cellGap;
      final gridHeight = _rows * rowStep - _cellGap;

      // Month labels need to be re-filtered based on 'weeks' sublist
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

          const SizedBox(height: labelGap),

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
  final Color Function(int level) colorForLevel;
  final ContributionDay? hoveredDay;
  final ValueChanged<ContributionDay?> onHover;
  final VoidCallback onExit;
  final String Function(DateTime) formatDate;

  const _HeatmapGrid({
    required this.weeks,
    required this.cellSize,
    required this.cellGap,
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
                        color: colorForLevel(weeks[w][d]!.level),
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
  final Color color;
  final bool isHovered;
  final ValueChanged<ContributionDay?> onHover;
  final String Function(DateTime) formatDate;

  const _HeatmapCell({
    required this.day,
    required this.size,
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
          color: AppColors.textPrimary,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceElev,
          border: Border.all(
            color: AppColors.border,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: () {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return !isDark && day.level == 0
                  ? Border.all(color: AppColors.border.withValues(alpha: 0.5), width: 0.5)
                  : null;
            }(),
            color: isHovered
                ? () {
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    return isDark
                        ? Colors.white.withValues(alpha: 0.85)
                        : Colors.black.withValues(alpha: 0.6);
                  }()
                : color,
          ),
        ),
      ),
    );
  }
}