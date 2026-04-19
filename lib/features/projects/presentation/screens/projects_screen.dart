import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/portfolio_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/scroll_fade_in.dart';
import '../../../../core/widgets/shared_widgets.dart';

// ─────────────────────────────────────────────────────────────
// PROJECTS SCREEN
// ─────────────────────────────────────────────────────────────

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  String? _activeFilter;
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  static const _filterTags = ['UI/UX', 'Flutter', 'CLI', 'Web', 'Open Source'];

  List<ProjectItem> get _filtered {
    final all = PortfolioConfig.projects;
    if (_activeFilter == null) return all;
    return all
        .where((p) =>
            p.tags.any((t) => t.toLowerCase() == _activeFilter!.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = AppSpacing.horizontalPadding(context);
    final filtered = _filtered;

    return FadeTransition(
      opacity: _fade,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                  horizontal: pad, vertical: AppSpacing.xl),
              sliver: SliverList.list(
                children: [
                  // ── HERO ─────────────────────────────────────────
                  ScrollFadeIn(
                    child: _ProjectsHero(count: filtered.length),
                  ),

                   // Filter section with simple spacing
                  ScrollFadeIn(
                    delay: const Duration(milliseconds: 100),
                    child: _FilterSection(
                      tags: _filterTags,
                      active: _activeFilter,
                      onSelect: (t) => setState(
                          () => _activeFilter = _activeFilter == t ? null : t),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ── GRID / EMPTY ──────────────────────────────────
                  if (filtered.isEmpty)
                    const _EmptyState()
                  else
                    _ProjectGrid(projects: filtered),

                  const SizedBox(height: 64),
                  
                  // ── OPEN SOURCE CALLOUT ───────────────────────────
                  ScrollFadeIn(
                    delay: const Duration(milliseconds: 200),
                    child: const _OpenSourceSection(),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HERO HEADER
// Matches ContactScreen eyebrow pattern [XX] LABEL,
// then uses the same large headline + ghost count as HomeScreen.
// ─────────────────────────────────────────────────────────────

class _ProjectsHero extends StatelessWidget {
  final int count;
  const _ProjectsHero({required this.count});

  @override
  Widget build(BuildContext context) {
    final textSec = AppColors.textSecondary;
    final accent = AppColors.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eyebrow — ContactScreen pattern
        Row(children: [
          Text(
            '[ 02 ]',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: accent, letterSpacing: 1.5),
          ),
          const SizedBox(width: 10),
          Text(
            'PROJECTS',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: textSec, letterSpacing: 2),
          ),
        ]),
        const SizedBox(height: 14),

        Text(
          "Selected Projects.",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: AppSpacing.headlineSize(
                  context,
                  mobile: 30,
                  tablet: 38,
                  laptop: 44,
                ),
                fontWeight: FontWeight.w800,
                letterSpacing: -2,
                height: 1.0,
              ),
        ),
        const SizedBox(height: 16),

        // Tagline — HomeScreen sub-row with dash
        Row(children: [
          Expanded(
            child: Text(
              'Open source experiments & production software. Built with intent. Shipped with care.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: textSec, height: 1.65),
            ),
          ),
        ]),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FILTER SECTION
// ─────────────────────────────────────────────────────────────

class _FilterSection extends StatelessWidget {
  final List<String> tags;
  final String? active;
  final ValueChanged<String> onSelect;

  const _FilterSection({
    required this.tags,
    required this.active,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final textSec = AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 18, height: 1, color: textSec),
            const SizedBox(width: 8),
            Text(
              'FILTER BY TYPE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: textSec, letterSpacing: 3, fontSize: 9),
            ),
          ]),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _FilterChip(
                label: 'All',
                isActive: active == null,
                onTap: () => onSelect('__all__'),
              ),
              ...tags.map((t) => _FilterChip(
                    label: t,
                    isActive: active == t,
                    onTap: () => onSelect(t),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accent;
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final textSec  = isDark ? AppColors.textSecDark     : AppColors.textSecLight;
    final surface  = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final bg       = isDark ? AppColors.bgDark          : AppColors.bgLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isActive
                ? accent
                : _hov
                    ? textSec
                    : surface,
            borderRadius: BorderRadius.zero,
          ),
          child: Text(
            widget.label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.5,
                  fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isActive
                      ? (isDark ? AppColors.bgDark : Colors.white)
                      : _hov
                          ? (isDark ? AppColors.bgDark : Colors.white)
                          : textSec,
                ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PROJECT GRID  — responsive Wrap, overflow-safe widths
// ─────────────────────────────────────────────────────────────

class _ProjectGrid extends StatelessWidget {
  final List<ProjectItem> projects;
  const _ProjectGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const spacing = 12.0;
      final isWide = constraints.maxWidth > AppSpacing.mobileMax;

      final List<Widget> children = [];
      for (int i = 0; i < projects.length; i++) {
        final child = _ProjectCard(project: projects[i])
            .animate()
            .fade(
              duration: 400.ms,
              delay: Duration(milliseconds: 100 + i * 60),
            )
            .slideY(
              begin: 0.05,
              end: 0,
              duration: 400.ms,
              delay: Duration(milliseconds: 100 + i * 60),
              curve: Curves.easeOut,
            );

        if (isWide) {
          if (i + 1 < projects.length) {
            final nextChild = _ProjectCard(project: projects[i + 1])
                .animate()
                .fade(
                  duration: 400.ms,
                  delay: Duration(milliseconds: 120 + (i + 1) * 70),
                )
                .slideY(
                  begin: 0.05,
                  end: 0,
                  duration: 400.ms,
                  delay: Duration(milliseconds: 120 + (i + 1) * 70),
                  curve: Curves.easeOut,
                );
            children.add(
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: child),
                    SizedBox(width: spacing),
                    Expanded(child: nextChild),
                  ],
                ),
              ),
            );
            i++; // Skip next element because it is handled
          } else {
            children.add(
              Row(
                children: [
                  Expanded(child: child),
                  SizedBox(width: spacing),
                  const Spacer(),
                ],
              ),
            );
          }
          if (i < projects.length - 1) {
            children.add(SizedBox(height: spacing));
          }
        } else {
          children.add(child);
          if (i < projects.length - 1) {
            children.add(SizedBox(height: spacing));
          }
        }
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
    });
  }
}

// ─────────────────────────────────────────────────────────────
// PROJECT CARD
// ─────────────────────────────────────────────────────────────

class _ProjectCard extends StatefulWidget {
  final ProjectItem project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final border   = isDark ? AppColors.borderDark  : AppColors.borderLight;
    final border2  = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final surface  = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final surfaceEl= isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent   = isDark ? AppColors.accentDark  : AppColors.accentLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(0.0, _hovered ? -4.0 : 0.0, 0.0)
          ..scale(_hovered ? 1.015 : 1.0, _hovered ? 1.015 : 1.0, 1.0),
        decoration: BoxDecoration(
          color: _hovered ? surfaceEl : surface,
          border: Border.all(color: _hovered ? border2 : border, width: 1),
          // SHARP CORNERS — unified with Home screen for editorial look
          borderRadius: BorderRadius.zero,
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _BrowserMock(),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row — CrossAxisAlignment.start prevents badge from
                  // stretching when title wraps to a second line.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.project.name,
                          style: Theme.of(context).textTheme.headlineLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      if (widget.project.badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: accent),
                            borderRadius: AppRadius.borderRadiusXs,
                          ),
                          child: Text(
                            widget.project.badge!,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: accent, letterSpacing: 0.4),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.project.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1.7),
                  ),
                  if (widget.project.tags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: widget.project.tags
                          .map((t) {
                            final isUiUx = t == 'UI/UX';
                            return MouseRegion(
                              cursor: isUiUx ? SystemMouseCursors.click : SystemMouseCursors.basic,
                              child: GestureDetector(
                                onTap: isUiUx ? () => launchUrl(Uri.parse('https://deepanshui.framer.website/')) : null,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceElev,
                                    borderRadius: AppRadius.subtle,
                                  ),
                                  child: Text(
                                    t,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: isUiUx ? accent : textSec,
                                          decoration: isUiUx ? TextDecoration.underline : null,
                                          decorationColor: accent,
                                        ),
                                  ),
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 14),
                  _ProjectLinkRow(
                    githubUrl: widget.project.githubUrl,
                    liveUrl: widget.project.liveUrl,
                    figmaUrl: widget.project.figmaUrl,
                    installUrl: widget.project.installUrl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BROWSER MOCK
// ─────────────────────────────────────────────────────────────

class _BrowserMock extends StatelessWidget {
  const _BrowserMock();

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final border   = isDark ? AppColors.borderDark  : AppColors.borderLight;
    final surface  = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final blockA   = isDark
        ? AppColors.surfaceElevDark.withValues(alpha: 0.6)
        : AppColors.surfaceElevLight;
    final blockB   = isDark
        ? AppColors.surfaceElevDark.withValues(alpha: 0.35)
        : AppColors.borderLight;

    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: surface,
        border: Border(bottom: BorderSide(color: border, width: 1)),
      ),
      child: Column(children: [
        Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: border, width: 1))),
          child: Row(children: [
            // macOS traffic-light dots
            Container(width: 7, height: 7,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF5F57))),
            const SizedBox(width: 5),
            Container(width: 7, height: 7,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFBD2E))),
            const SizedBox(width: 5),
            Container(width: 7, height: 7,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF28C840))),
            const SizedBox(width: 10),
            Expanded(child: Container(height: 10, color: blockA)),
          ]),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 7, width: 100, color: blockA),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: Container(height: 42, color: blockB)),
                  const SizedBox(width: 8),
                  Expanded(child: Container(height: 42, color: blockB)),
                ]),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PROJECT LINK ROW
// ─────────────────────────────────────────────────────────────

class _ProjectLinkRow extends StatelessWidget {
  final String? githubUrl;
  final String? liveUrl;
  final String? figmaUrl;
  final String? installUrl;
  const _ProjectLinkRow({this.githubUrl, this.liveUrl, this.figmaUrl, this.installUrl});

  @override
  Widget build(BuildContext context) {
    if (githubUrl == null && liveUrl == null && figmaUrl == null && installUrl == null) return const SizedBox.shrink();
    return Wrap(spacing: 16, runSpacing: 8, children: [
      if (githubUrl != null)
        _LinkBtn(icon: LucideIcons.code2, label: 'GitHub', url: githubUrl!),
      if (liveUrl != null)
        _LinkBtn(icon: LucideIcons.arrowUpRight, label: 'Live', url: liveUrl!),
      if (installUrl != null)
        _LinkBtn(icon: LucideIcons.download, label: 'Install', url: installUrl!),
      if (figmaUrl != null)
        _LinkBtn(icon: LucideIcons.palette, label: 'Figma', url: figmaUrl!),
    ]);
  }
}

class _LinkBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  const _LinkBtn({required this.icon, required this.label, required this.url});

  @override
  State<_LinkBtn> createState() => _LinkBtnState();
}

class _LinkBtnState extends State<_LinkBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accent;
    final textPri = AppColors.textPrimary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _hovered = true),
        onTapUp: (_) => setState(() => _hovered = false),
        onTapCancel: () => setState(() => _hovered = false),
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        },
        child: AnimatedScale(
          scale: _hovered ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: accent),
              borderRadius: AppRadius.subtle,
              color: _hovered ? accent.withValues(alpha: 0.12) : Colors.transparent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 14, color: _hovered ? accent : textPri),
                const SizedBox(width: 8),
                Text(
                  widget.label.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _hovered ? accent : textPri, letterSpacing: 1.2, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// OPEN SOURCE SECTION  — numbered rows, same as Achievements
// ─────────────────────────────────────────────────────────────

class _OpenSourceSection extends StatelessWidget {
  const _OpenSourceSection();

  static const _items = [
    _OSItem(
        number: '01',
        text:
            'All projects are open source — fork, star, and contribute on GitHub.'),
    _OSItem(
        number: '02',
        text:
            'Each ships with a detailed README, clear architecture, and production-ready structure.'),
    _OSItem(
        number: '03',
        text:
            'Built in public — commits, issues, and pull requests are all visible and documented.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Open Source Contributions', index: '03'),
        ..._items.map((item) => _OSRow(item: item)),
      ],
    );
  }
}

class _OSItem {
  final String number;
  final String text;
  const _OSItem({required this.number, required this.text});
}

class _OSRow extends StatefulWidget {
  final _OSItem item;
  const _OSRow({required this.item});

  @override
  State<_OSRow> createState() => _OSRowState();
}

class _OSRowState extends State<_OSRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: _hovered ? accent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(_hovered ? 10 : 0, 13, 14, 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: (Theme.of(context).textTheme.labelMedium ?? const TextStyle())
                    .copyWith(color: _hovered ? accent : accent),
                child: Text(widget.item.number),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.item.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 1.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final border = AppColors.border;
    final textSec = AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 56),
      decoration: BoxDecoration(border: Border.all(color: border)),
      child: Column(children: [
        Icon(Icons.folder_off_outlined, size: 24, color: border),
        const SizedBox(height: 10),
        Text(
          'NO MATCHING PROJECTS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: textSec, letterSpacing: 2),
        ),
      ]),
    );
  }
}