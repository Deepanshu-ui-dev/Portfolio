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
  OverlayEntry? _tooltipEntry;
  final ScrollController _scrollController = ScrollController();

  // Fixed cell dimensions
  static const double _cellSize = 10.0;
  static const double _cellGap = 3.0;
  static const double _weekWidth = _cellSize + _cellGap;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _tooltipEntry?.remove();
    _tooltipEntry = null;
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Build week groups ───────────────────────────────────────────────────

  List<List<ContributionDay?>> _buildWeeks() {
    final days = widget.contributions;
    final weeks = <List<ContributionDay?>>[];
    if (days.isEmpty) return weeks;

    // In Dart, DateTime.weekday: Mon=1 … Sun=7. We want Sun=0.
    final firstWeekday = days.first.date.weekday % 7; // Sun=0, Mon=1 …

    List<ContributionDay?> currentWeek = List.filled(7, null);

    // Pad the first week
    int wIdx = firstWeekday;
    for (final day in days) {
      currentWeek[wIdx] = day;
      wIdx++;
      if (wIdx == 7) {
        weeks.add(List.from(currentWeek));
        currentWeek = List.filled(7, null);
        wIdx = 0;
      }
    }
    if (wIdx > 0) weeks.add(List.from(currentWeek));
    return weeks;
  }

  // ─── Month labels — one per calendar month, placed at the first week
  //     where a day ≤ 7 exists for that month. ───────────────────────────

  Map<int, String> _buildMonthLabels(List<List<ContributionDay?>> weeks) {
    final labels = <int, String>{};
    final seen = <String>{};

    for (int w = 0; w < weeks.length; w++) {
      for (final day in weeks[w]) {
        if (day == null) continue;
        if (day.date.day <= 7) {
          final key = '${day.date.year}-${day.date.month}';
          if (!seen.contains(key)) {
            seen.add(key);
            labels[w] = _monthAbbr(day.date.month);
          }
        }
      }
    }
    return labels;
  }

  // ─── Colour ──────────────────────────────────────────────────────────────

  Color _colorForCount(int count, bool isDark) {
    if (count == 0) return isDark ? AppColors.contrib0Dark : AppColors.contrib0Light;
    if (count == 1) return isDark ? AppColors.contrib1Dark : AppColors.contrib1Light;
    if (count == 2) return isDark ? AppColors.contrib2Dark : AppColors.contrib2Light;
    if (count == 3) return isDark ? AppColors.contrib3Dark : AppColors.contrib3Light;
    return isDark ? AppColors.contrib4Dark : AppColors.contrib4Light;
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weeks = _buildWeeks();
    final monthLabels = _buildMonthLabels(weeks);

    // The total pixel width of the graph — MUST match what the Stack uses.
    final double graphWidth = weeks.length * _weekWidth;

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Month label row ──────────────────────────────────────────────
          // Use a Stack with an explicit width so labels are positioned at
          // exactly weekIndex * _weekWidth and never overlap the cells below.
          SizedBox(
            height: 16,
            width: graphWidth,
            child: Stack(
              clipBehavior: Clip.none,
              children: monthLabels.entries.map((e) {
                return Positioned(
                  left: e.key * _weekWidth,
                  top: 0,
                  child: Text(
                    e.value,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 9,
                      letterSpacing: 0.04,
                      color: isDark
                          ? AppColors.textTerDark
                          : AppColors.textTerLight,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 5),

          // ── Cell grid ───────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: weeks.map((week) {
              return Padding(
                padding: const EdgeInsets.only(right: _cellGap),
                child: Column(
                  children: List.generate(7, (d) {
                    final day = week[d];

                    // Empty slot — invisible placeholder keeps the grid aligned
                    if (day == null) {
                      return const SizedBox(
                        width: _cellSize,
                        height: _cellSize + _cellGap,
                      );
                    }

                    final color = _colorForCount(day.level, isDark);
                    final isHovered = _hoveredDay == day;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: _cellGap),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.basic,
                        onEnter: (_) => setState(() => _hoveredDay = day),
                        onExit: (_) => setState(() => _hoveredDay = null),
                        child: Tooltip(
                          message:
                              '${_formatDate(day.date)} · ${day.count} contribution${day.count == 1 ? '' : 's'}',
                          preferBelow: false,
                          textStyle: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceElevDark
                                : AppColors.surfaceElevLight,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight,
                              width: 1,
                            ),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            width: _cellSize,
                            height: _cellSize,
                            color: isHovered
                                ? (isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight)
                                : color,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  String _monthAbbr(int month) {
    const abbrs = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return abbrs[month - 1];
  }

  String _formatDate(DateTime date) {
    final month = _monthAbbr(date.month);
    return '$month ${date.day}, ${date.year}';
  }
}