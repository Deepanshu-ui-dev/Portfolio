import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/portfolio_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../github/data/github_repository.dart';
import '../../../photography/presentation/screens/gallery_screen.dart';
import '../widgets/contribution_graph.dart';
import '../widgets/hero_section.dart';

// ─────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = AppSpacing.horizontalPadding(context);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                  horizontal: padding, vertical: AppSpacing.xl),
              sliver: SliverList.list(
                children: const [
                  HeroSection(),
                  SizedBox(height: AppSpacing.xxl),
                  DashedDivider(),
                  SizedBox(height: AppSpacing.xxl),
                  _HomeHeatmapSection(),
                  SizedBox(height: AppSpacing.xxl),
                  DashedDivider(),
                  SizedBox(height: AppSpacing.xxl),
                  _ExperienceSection(),
                  SizedBox(height: AppSpacing.xxl),
                  DashedDivider(),
                  SizedBox(height: AppSpacing.xxl),
                  _EducationSection(),
                  SizedBox(height: AppSpacing.xxl),
                  DashedDivider(),
                  SizedBox(height: AppSpacing.xxl),
                  _ProjectsSection(),
                  SizedBox(height: AppSpacing.xxl),
                  DashedDivider(),
                  SizedBox(height: AppSpacing.xxl),
                  _AchievementsSection(),
                  SizedBox(height: AppSpacing.xxl),
                  DashedDivider(),
                  SizedBox(height: AppSpacing.xxl),
                  _LeadershipSection(),
                  SizedBox(height: AppSpacing.xxl),
                  DashedDivider(),
                  SizedBox(height: AppSpacing.xxl),
                  _PhotographySection(),
                  SizedBox(height: AppSpacing.xl),
                  DashedDivider(),
                  SizedBox(height: AppSpacing.xxl),
                  _HobbiesSection(),
                  SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HEATMAP SECTION
// ─────────────────────────────────────────────

class _HomeHeatmapSection extends ConsumerWidget {
  const _HomeHeatmapSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats =
        ref.watch(gitHubStatsProvider(PortfolioConfig.githubUsername));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        stats.when(
          loading: () => const _HeatmapShell(
            child: SizedBox(
              height: 100,
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ),
              ),
            ),
          ),
          error: (e, _) => _HeatmapShell(
            child: SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'Could not load GitHub activity',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
          data: (data) => _HeatmapShell(
            child: _ResponsiveHeatmap(data: data),
          ),
        ),
      ],
    );
  }
}

class _HeatmapShell extends StatelessWidget {
  final Widget child;
  const _HeatmapShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceElev = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceElev.withOpacity(0.3),
        border: Border.all(color: border),
      ),
      child: child,
    );
  }
}

class _ResponsiveHeatmap extends StatelessWidget {
  final dynamic data;
  const _ResponsiveHeatmap({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContributionGraph(contributions: data.contributions),
            const SizedBox(height: 10),
            _HeatmapMeta(
              totalContributions: data.totalContributions,
              isDark: isDark,
              compact: constraints.maxWidth < 420,
            ),
          ],
        ),
      );
    });
  }
}

class _HeatmapMeta extends StatelessWidget {
  final int totalContributions;
  final bool isDark;
  final bool compact;
  const _HeatmapMeta({
    required this.totalContributions,
    required this.isDark,
    required this.compact,
  });

  Color _c(Color dark, Color light) => isDark ? dark : light;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 9,
          color: AppColors.textSecondary,
        );

    final legend = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Less', style: labelStyle),
        const SizedBox(width: 4),
        for (final pair in [
          [AppColors.contrib0Dark, AppColors.contrib0Light],
          [AppColors.contrib1Dark, AppColors.contrib1Light],
          [AppColors.contrib2Dark, AppColors.contrib2Light],
          [AppColors.contrib3Dark, AppColors.contrib3Light],
          [AppColors.contrib4Dark, AppColors.contrib4Light],
        ])
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(left: 2),
            color: _c(pair[0], pair[1]),
          ),
        const SizedBox(width: 4),
        Text('More', style: labelStyle),
      ],
    );

    final countLabel = Text(
      '$totalContributions activities in the last year',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
          ),
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [countLabel, const SizedBox(height: 6), legend],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [countLabel, legend],
    );
  }
}

// ─────────────────────────────────────────────
// EXPERIENCE SECTION
// ─────────────────────────────────────────────

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final iconColor = isDark ? AppColors.textSecDark : AppColors.textSecLight;

    Widget iconBox(IconData icon) => Container(
          width: 28,
          height: 28,
          decoration:
              BoxDecoration(border: Border.all(color: border, width: 1)),
          child: Icon(icon, size: 13, color: iconColor),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Where I\'ve Worked'),
        CollapsibleCard(
          leading: iconBox(LucideIcons.layers),
          title: 'Layerance',
          subtitle: 'UI/UX Intern — Founding Designer',
          rightLabel: '2026 — Present',
          initiallyExpanded: true,
          bullets: const [
            'Designed the core product interface and visual identity as the founding designer for an early-stage startup.',
            'Built a scalable design system in Figma, ensuring UI consistency across all product screens and accelerating development workflow.',
            'Collaborated closely with engineers to translate high-fidelity prototypes into pixel-perfect production interfaces.',
          ],
          tags: const ['Figma', 'Framer', 'Design Systems', 'Prototyping'],
        ),
        SizedBox(height: 8), 
        CollapsibleCard(
          leading: iconBox(LucideIcons.box),
          title: 'Freelance UI/UX Designer',
          subtitle: 'Self-Employed',
          rightLabel: 'May 2025 — Present',
          initiallyExpanded: true,
          bullets: const [
            'Delivered end-to-end UI/UX solutions for web and mobile apps — user flows, wireframes, and high-fidelity prototypes.',
            'Designed responsive dashboards and product interfaces with focus on usability, accessibility, and clean visual hierarchy.',
            'Created reusable design systems and component libraries using Figma and Framer for multiple client projects.',
            'Collaborated with developers and stakeholders to translate design concepts into functional interfaces across platforms.',
          ],
          tags: const [
            'Figma', 'Framer', 'Adobe XD', 'Flutter', 'Dart',
            'Tailwind CSS', 'JavaScript',
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// EDUCATION SECTION
// ─────────────────────────────────────────────

class _EducationSection extends StatelessWidget {
  const _EducationSection();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Academic Background'),
        CollapsibleCard(
          leading: Container(
            width: 28,
            height: 28,
            decoration:
                BoxDecoration(border: Border.all(color: border, width: 1)),
            child: Icon(LucideIcons.graduationCap,
                size: 13,
                color: isDark
                    ? AppColors.textSecDark
                    : AppColors.textSecLight),
          ),
          title: PortfolioConfig.college,
          subtitle: PortfolioConfig.degree,
          rightLabel: PortfolioConfig.eduPeriod,
          initiallyExpanded: false,
          bullets: const [
            'Relevant coursework: Data Structures, Algorithm Analysis, Database Management, Artificial Intelligence, Internet Technology, Software Engineering.',
          ],
          tags: const ['C++', 'C', 'Python', 'DSA', 'DBMS', 'AI'],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PROJECTS SECTION
// ─────────────────────────────────────────────

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection();

  @override
  Widget build(BuildContext context) {
    final projects = PortfolioConfig.projects.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Featured Work'),
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 520) {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _ProjectCard(data: projects[0])),
                  const SizedBox(width: 12),
                  Expanded(child: _ProjectCard(data: projects[1])),
                ],
              ),
            );
          }
          return Column(
            children: projects
                .map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ProjectCard(data: p),
                    ))
                .toList(),
          );
        }),
      ],
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectItem data;
  const _ProjectCard({required this.data});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final surfaceEl =
        isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: _hovered ? surfaceEl : surface,
          border: Border.all(color: _hovered ? border2 : border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BrowserMock(isDark: isDark),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(widget.data.name,
                            style:
                                Theme.of(context).textTheme.headlineLarge),
                      ),
                      if (widget.data.badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: accent, width: 1),
                          ),
                          child: Text(
                            widget.data.badge!,
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
                    widget.data.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1.7),
                  ),
                  if (widget.data.tags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: widget.data.tags
                          .map((t) {
                            final isUiUx = t == 'UI/UX';
                            return MouseRegion(
                              cursor: isUiUx ? SystemMouseCursors.click : SystemMouseCursors.basic,
                              child: GestureDetector(
                                onTap: isUiUx ? () => launchUrl(Uri.parse('https://deepanshui.framer.website/')) : null,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 3),
                                  color: isDark
                                      ? AppColors.surfaceElevDark
                                      : AppColors.surfaceElevLight,
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
                  const SizedBox(height: 12),
                  _ProjectLinkRow(
                    githubUrl: widget.data.githubUrl,
                    liveUrl: widget.data.liveUrl,
                    installUrl: widget.data.installUrl,
                    figmaUrl: widget.data.figmaUrl,
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

class _BrowserMock extends StatelessWidget {
  final bool isDark;
  const _BrowserMock({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final blockA = isDark
        ? AppColors.surfaceElevDark.withValues(alpha: 0.6)
        : AppColors.surfaceElevLight;
    final blockB = isDark
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
            border: Border(bottom: BorderSide(color: border, width: 1)),
          ),
          child: Row(children: [
            ...List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: border),
                ),
              ),
            ),
            const SizedBox(width: 8),
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
      if (installUrl != null)
        _LinkBtn(icon: LucideIcons.download, label: 'Install', url: installUrl!),
      if (liveUrl != null)
        _LinkBtn(icon: LucideIcons.arrowUpRight, label: 'Live', url: liveUrl!),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final textPri =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

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
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: accent),
              color: _hovered ? accent.withOpacity(0.15) : Colors.transparent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 14, color: _hovered ? accent : textPri),
                const SizedBox(width: 8),
                Text(
                  widget.label.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _hovered ? accent : textPri,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ACHIEVEMENTS SECTION
// ─────────────────────────────────────────────

class _AchievementsSection extends StatelessWidget {
  const _AchievementsSection();

  static const _items = [
    {
      'number': '01',
      'title': '450+ problems solved on LeetCode',
      'subtitle': 'Consistent practice in Data Structures & Algorithms.'
    },
    {
      'number': '02',
      'title': 'Core team member of Elixir Tech Community',
      'subtitle': 'Contributing to events and technical initiatives for 1,500+ members.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Milestones & Impact'),
        ..._items.map(
              (e) => _AchievementRow(
                number: e['number']!,
                title: e['title']!,
                subtitle: e['subtitle']!,
              ),
            ),
      ],
    );
  }
}

class _AchievementRow extends StatefulWidget {
  final String number;
  final String title;
  final String subtitle;
  const _AchievementRow(
      {required this.number, required this.title, required this.subtitle});

  @override
  State<_AchievementRow> createState() => _AchievementRowState();
}

class _AchievementRowState extends State<_AchievementRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(_hovered ? 4.0 : 0.0, 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.number,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: textSec, fontWeight: FontWeight.w600)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: textPri, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(widget.subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: textSec, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LEADERSHIP SECTION
// ─────────────────────────────────────────────

class _LeadershipSection extends StatelessWidget {
  const _LeadershipSection();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Community Leadership'),
        CollapsibleCard(
          leading: Container(
            width: 28,
            height: 28,
            decoration:
                BoxDecoration(border: Border.all(color: border, width: 1)),
            child: Icon(Icons.groups_outlined,
                size: 13,
                color: isDark
                    ? AppColors.textSecDark
                    : AppColors.textSecLight),
          ),
          title: 'Google Developer Group on Campus',
          subtitle: 'Co-Organiser — ABES Engineering College',
          rightLabel: 'Aug 2025 — Present',
          initiallyExpanded: false,
          bullets: const [
            'Led a 40-member organizing team to plan and execute technical workshops, events, and hackathons.',
            'Organised a 36-hour offline hackathon with participation from 750+ students.',
            'Helped grow the campus developer community to over 1,100 active members.',
          ],
          tags: const [
            'Event Management',
            'Community Building',
            'Technical Leadership',
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PHOTOGRAPHY SECTION
// ─────────────────────────────────────────────

class _PhotoCategory {
  final String label;
  final String subtitle;
  final String imagePath;

  const _PhotoCategory({
    required this.label,
    required this.subtitle,
    required this.imagePath,
  });
}

class _PhotographySection extends StatelessWidget {
  const _PhotographySection();

 static const _categories = [
  _PhotoCategory(
    label: 'Moments',
    subtitle: 'Campus Life',
    imagePath: 'assets/images/aabes.jpeg',
  ),
  _PhotoCategory(
    label: 'Casual',
    subtitle: 'Cafe Vibes',
    imagePath: 'assets/images/cafe.jpeg',
  ),
  _PhotoCategory(
    label: 'Nature',
    subtitle: 'Mountain Escapes',
    imagePath: 'assets/images/mount.jpeg',
  ),
  _PhotoCategory(
    label: 'Details',
    subtitle: 'Floral Close-ups',
    imagePath: 'assets/images/flower.jpeg',
  ),
  _PhotoCategory(
    label: 'Cutie',
    subtitle: 'Adorable Moments',
    imagePath: 'assets/images/cat.jpeg',
  ),
  _PhotoCategory(
    label: 'Lunch',
    subtitle: 'Food Stories',
    imagePath: 'assets/images/sq.jpeg',
  ),
  _PhotoCategory(
    label: 'Heat',
    subtitle: 'Fire & Energy',
    imagePath: 'assets/images/fire.jpg',
  ),
];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textTer = isDark ? AppColors.textTerDark : AppColors.textTerLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Photography'),

        // Intro text
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'When I\'m not pushing pixels, I\'m chasing light through a viewfinder.\n'
            'Photography taught me to see before I design — composition, light, and the space between things.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textSec,
                  height: 1.75,
                ),
          ),
        ),

        // Horizontal scrollable row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: _categories.asMap().entries.map((entry) {
              final idx = entry.key;
              final cat = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  right: idx == _categories.length - 1 ? 0 : 12.0,
                ),
                child: _PhotoCard(
                  category: cat,
                  size: 160,
                  isDark: isDark,
                  accent: accent,
                  border: border,
                  border2: border2,
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Footer row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '// capturing bits of life',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: textTer, fontSize: 10),
            ),
            _ViewAllButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryScreen()),
                );
              },
              isDark: isDark,
              border: border,
              border2: border2,
              textSec: textSec,
            ),
          ],
        ),
      ],
    );
  }
}

class _PhotoCard extends StatefulWidget {
  final _PhotoCategory category;
  final double size;
  final bool isDark;
  final Color accent;
  final Color border;
  final Color border2;

  const _PhotoCard({
    required this.category,
    required this.size,
    required this.isDark,
    required this.accent,
    required this.border,
    required this.border2,
  });

  @override
  State<_PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<_PhotoCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _overlayCtrl;
  late Animation<double> _overlayAnim;

  @override
  void initState() {
    super.initState();
    _overlayCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _overlayAnim =
        CurvedAnimation(parent: _overlayCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _overlayCtrl.dispose();
    super.dispose();
  }

  void _onHover(bool hovered) {
    setState(() => _hovered = hovered);
    if (hovered) {
      _overlayCtrl.forward();
    } else {
      _overlayCtrl.reverse();
    }
  }

  static const _bgColors = [
    Color(0xFF0a1a0e),
    Color(0xFF0d1520),
    Color(0xFF1a0f0a),
    Color(0xFF080e1a),
    Color(0xFF0f0f0f),
    Color(0xFF0e1a0c),
  ];

  @override
  Widget build(BuildContext context) {
    final idx = _PhotographySection._categories.indexOf(widget.category);
    final bgColor = _bgColors[idx % _bgColors.length];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GalleryScreen()),
          );
        },
        child: MonofolioCornersBox(
          padding: const EdgeInsets.all(4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(0, _hovered ? -4.0 : 0.0, 0),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(
                color: _hovered ? widget.border2 : widget.border,
                width: 1,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Base colored image
                Image.asset(
                  widget.category.imagePath,
                  fit: BoxFit.cover,
                  cacheWidth: 320,
                  errorBuilder: (ctx, err, stack) => const SizedBox(),
                ),
                // Grayscale overlay that smoothly fades out on hover
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _hovered ? 0.0 : 1.0,
                  child: RepaintBoundary(
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.matrix(<double>[
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0,      0,      0,      1, 0,
                      ]),
                      child: Image.asset(
                        widget.category.imagePath,
                        fit: BoxFit.cover,
                        cacheWidth: 320,
                        errorBuilder: (ctx, err, stack) => const SizedBox(),
                      ),
                    ),
                  ),
                ),
                // Base content
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.collections_outlined,
                        size: 22,
                        color: Colors.white54,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.category.label.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          letterSpacing: 0.12,
                          color: Colors.white.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              // Hover overlay
              FadeTransition(
                opacity: _overlayAnim,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.72),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: widget.accent, width: 1),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 12,
                            color: widget.accent,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.category.label,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: widget.accent,
                            letterSpacing: 0.08,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.category.subtitle,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            color: Colors.white.withValues(alpha: 0.45),
                            letterSpacing: 0.04,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class _ViewAllButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isDark;
  final Color border;
  final Color border2;
  final Color textSec;

  const _ViewAllButton({
    required this.onTap,
    required this.isDark,
    required this.border,
    required this.border2,
    required this.textSec,
  });

  @override
  State<_ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<_ViewAllButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPri =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hovered ? widget.border2 : widget.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View all shots',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: _hovered ? textPri : widget.textSec,
                    ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_outward,
                size: 10,
                color: _hovered ? textPri : widget.textSec,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────
// HOBBIES & INTERESTS
// ─────────────────────────────────────────────

class _HobbiesSection extends StatelessWidget {
  const _HobbiesSection();

  static const _hobbies = [
    _HobbyItem(
      title: 'Photography',
      description:
          'Chasing light through a viewfinder — street, architecture and golden-hour frames.',
    ),
    _HobbyItem(
      title: 'Open Source',
      description:
          'Contributing to tools and communities that push the ecosystem forward.',
    ),
    _HobbyItem(
      title: 'Learning New Tech',
      description:
          'Constantly staying ahead of the curve with emerging design and dev tools.',
    ),
    _HobbyItem(
      title: 'UI Collecting',
      description:
          'Obsessively saving references — interfaces, typography, and spatial compositions.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Hobbies'),
        const SizedBox(height: 20),
        ..._hobbies.asMap().entries.map((e) {
          final num = '0${e.key + 1}';
          final item = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  child: Text(num,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: textSec)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(item.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: textSec)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _HobbyItem {
  final String title;
  final String description;
  const _HobbyItem({required this.title, required this.description});
}