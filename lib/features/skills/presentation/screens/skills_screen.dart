import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/scroll_fade_in.dart';
import '../../../../core/widgets/shared_widgets.dart';

// ─────────────────────────────────────────────────────────────
// SKILLS SCREEN
// ─────────────────────────────────────────────────────────────

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

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

  // ── All skill sections ────────────────────────────────────
  static const _sections = [
    _SkillSectionData(
      index: '01',
      title: 'Design & UI/UX',
      subtitle: 'Tools I use to craft beautiful, intuitive interfaces.',
      skills: [
        _Skill(label: 'Figma',     icon: 'figma',                 hex: 'F24E1E', highlight: true),
        _Skill(label: 'Framer',    icon: 'framer',                hex: '0055FF'),
        _Skill(label: 'Sketch',    icon: 'sketch',                hex: 'F7B500'),
        _Skill(label: 'Adobe XD',  icon: 'adobexd',               hex: 'FF61F6'),
        _Skill(label: 'Photoshop', icon: 'adobephotoshop',        hex: '31A8FF'),
        _Skill(label: 'Canva',     icon: 'canva',                 hex: '00C4CC'),
      ],
    ),
    _SkillSectionData(
      index: '02',
      title: 'Languages',
      subtitle: 'The foundation of my engineering.',
      skills: [
        _Skill(label: 'Dart',       icon: 'dart',          hex: '0175C2', highlight: true),
        _Skill(label: 'C++',        icon: 'cplusplus',     hex: '00599C'),
        _Skill(label: 'C',          icon: 'c',             hex: 'A8B9CC'),
        _Skill(label: 'HTML5',      icon: 'html5',         hex: 'E34F26'),
        _Skill(label: 'CSS3',       icon: 'css3',          hex: '1572B6'),
        _Skill(label: 'JavaScript', icon: 'javascript',    hex: 'F7DF1E'),
      ],
    ),
    _SkillSectionData(
      index: '03',
      title: 'Frameworks',
      subtitle: 'Core libraries and state management.',
      skills: [
        _Skill(label: 'Flutter',    icon: 'flutter',       hex: '02569B', highlight: true),
        _Skill(label: 'Riverpod',   icon: 'dart',          hex: '5B63FE', sublabel: 'State Mgmt'),
        _Skill(label: 'Provider',   icon: 'dart',          hex: '0175C2', sublabel: 'State Mgmt'),
        _Skill(label: 'Tailwind',   icon: 'tailwindcss',   hex: '06B6D4'),
      ],
    ),
    _SkillSectionData(
      index: '04',
      title: 'Database & Cloud',
      subtitle: 'Backends, data layers, and deployment.',
      skills: [
        _Skill(label: 'Firebase',   icon: 'firebase',      hex: 'FFCA28'),
        _Skill(label: 'Supabase',   icon: 'supabase',      hex: '3ECF8E'),
        _Skill(label: 'MySQL',      icon: 'mysql',         hex: '4479A1'),
        _Skill(label: 'GCP',        icon: 'googlecloud',   hex: '4285F4'),
        _Skill(label: 'AWS',        icon: 'amazonaws',     hex: '232F3E'),
        _Skill(label: 'Linux',      icon: 'linux',         hex: 'FCC624'),
      ],
    ),
    _SkillSectionData(
      index: '05',
      title: 'Tools',
      subtitle: 'Workflow and version control.',
      skills: [
        _Skill(label: 'Git',        icon: 'git',           hex: 'F05032'),
        _Skill(label: 'Docker',     icon: 'docker',        hex: '2496ED'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final padding = AppSpacing.horizontalPadding(context);

    return FadeTransition(
      opacity: _fade,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                  horizontal: padding, vertical: AppSpacing.xl),
              sliver: SliverList.list(
                children: [
                  // ── HERO ──────────────────────────────────────────
                  const ScrollFadeIn(
                    child: _SkillsHero(),
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                  const DashedDivider(),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── SKILL SECTIONS ────────────────────────────────
                  for (int i = 0; i < _sections.length; i++) ...[
                    ScrollFadeIn(
                      delay: Duration(milliseconds: 100 + i * 80),
                      child: _SkillSection(data: _sections[i]),
                    ),
                    if (i < _sections.length - 1) ...[
                      const SizedBox(height: AppSpacing.xxl),
                      const DashedDivider(),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ],

                  const SizedBox(height: AppSpacing.xxl),
                  const DashedDivider(),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── CALLOUT ROW ───────────────────────────────────
                  ScrollFadeIn(
                    delay: Duration(milliseconds: 100 + _sections.length * 80),
                    child: const _PhilosophyCallout(),
                  ),

                  const SizedBox(height: AppSpacing.xl),
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
// DATA MODELS
// ─────────────────────────────────────────────────────────────

class _SkillSectionData {
  final String index;
  final String title;
  final String subtitle;
  final List<_Skill> skills;

  const _SkillSectionData({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.skills,
  });
}

class _Skill {
  final String label;
  final String icon;
  final String hex;
  final String? sublabel;
  final bool highlight;

  const _Skill({
    required this.label,
    required this.icon,
    required this.hex,
    this.sublabel,
    this.highlight = false,
  });
}

// ─────────────────────────────────────────────────────────────
// HERO HEADER  — same [XX] eyebrow + large headline pattern
// used across ContactScreen, ProjectsScreen
// ─────────────────────────────────────────────────────────────

class _SkillsHero extends StatelessWidget {
  const _SkillsHero();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Eyebrow — ContactScreen / ProjectsScreen pattern ──
        Row(children: [
          Text(
            '[ 03 ]',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: accent, letterSpacing: 1.5),
          ),
          const SizedBox(width: 10),
          Text(
            'SKILLS',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: textSec, letterSpacing: 2),
          ),
        ]),
        const SizedBox(height: 14),

        Text(
          "Tools of the trade.",
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

        // ── Tagline with leading dash — HomeScreen sub-row ──
        Row(children: [
          Expanded(
            child: Text(
              'Design-first developer. Comfortable across the full product stack.',
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
// INFO BLOCK  — left-border quote block, same as AboutScreen bio
// ─────────────────────────────────────────────────────────────


// ─────────────────────────────────────────────────────────────
// SKILL SECTION
// Uses SectionHeader (same widget as Experience, Education, etc.)
// plus an indexed subtitle in the same [ XX ] pattern as ContactScreen
// ─────────────────────────────────────────────────────────────

class _SkillSection extends StatelessWidget {
  final _SkillSectionData data;
  const _SkillSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section label row — same pattern as ContactScreen sections ──
        Row(children: [
          Text(
            '[ ${data.index} ]',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: accent, letterSpacing: 1.5),
          ),
          const SizedBox(width: 10),
          Text(
            data.title.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: textSec, letterSpacing: 2),
          ),
        ]),
        const SizedBox(height: 6),

        // ── Section heading — SectionHeader widget ──
        SectionHeader(data.title),

        // ── Subtitle ──
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            data.subtitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: textSec, height: 1.6),
          ),
        ),

        // ── Skill card grid ──
        LayoutBuilder(builder: (context, constraints) {
          final cols =
              (constraints.maxWidth / 130).floor().clamp(3, 5);
          final w = constraints.maxWidth / cols;
          return Wrap(
            spacing: 0,
            runSpacing: 0,
            children: data.skills
                .map((s) => SizedBox(
                      width: w,
                      child: _SkillCard(key: ValueKey(s.label), skill: s),
                    ))
                .toList(),
          );
        }),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SKILL CARD
// AnimatedOpacity-only (no AnimationController) to avoid
// late/null init issues. Corner brackets animate with border.
// ─────────────────────────────────────────────────────────────

class _SkillCard extends StatefulWidget {
  final _Skill skill;
  const _SkillCard({required super.key, required this.skill});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _hovered = false;

  Color _hex(String h) {
    try {
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final surfaceEl =
        isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final brand = _hex(widget.skill.hex);

    final greySlug = isDark ? '666666' : '888888';
    
    // Force ALL icons to use the exact same pack layout natively from Iconify
    // This perfectly matches the "use same icon pack not a different one for all" requirement.
    final String greyUrl = 'https://api.iconify.design/simple-icons/${widget.skill.icon}.svg?color=%23$greySlug';
    final String colorUrl = 'https://api.iconify.design/simple-icons/${widget.skill.icon}.svg?color=%23${widget.skill.hex}';
    
    final bracketColor = _hovered ? border2 : border;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _hovered = true),
        onTapUp: (_) => setState(() => _hovered = false),
        onTapCancel: () => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: _hovered ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: _hovered
                  ? (widget.skill.highlight
                      ? (isDark
                          ? const Color(0xFF1A2A1A)
                          : const Color(0xFFE8F5E9))
                      : surfaceEl)
                  : Colors.transparent,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
              // Corner brackets
              _Bracket(top: true, left: true, color: bracketColor),
              _Bracket(top: true, left: false, color: bracketColor),
              _Bracket(top: false, left: true, color: bracketColor),
              _Bracket(top: false, left: false, color: bracketColor),

              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 24, 12, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon crossfade greyscale → color
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedOpacity(
                            opacity: _hovered ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: SvgPicture.network(
                              greyUrl,
                              width: 34,
                              height: 34,
                              fit: BoxFit.contain,
                              placeholderBuilder: (_) => _Fallback(
                                  label: widget.skill.label, color: textSec),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: _hovered ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: SvgPicture.network(
                              colorUrl,
                              width: 34,
                              height: 34,
                              fit: BoxFit.contain,
                              placeholderBuilder: (_) => _Fallback(
                                  label: widget.skill.label, color: brand),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Label
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 160),
                      style:
                          (Theme.of(context).textTheme.labelSmall ?? const TextStyle())
                              .copyWith(
                        color: _hovered
                            ? (widget.skill.highlight ? accent : textPri)
                            : textSec,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        fontSize: 9,
                      ),
                      child: Text(
                        widget.skill.label.toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    if (widget.skill.sublabel != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        widget.skill.sublabel!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: textSec.withValues(alpha: 0.55),
                              fontSize: 8,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// L-SHAPED CORNER BRACKET
// ─────────────────────────────────────────────────────────────

class _Bracket extends StatelessWidget {
  final bool top;
  final bool left;
  final Color color;

  const _Bracket(
      {required this.top, required this.left, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: left ? 0 : null,
      right: left ? null : 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          border: Border(
            top: top
                ? BorderSide(color: color, width: 1)
                : BorderSide.none,
            bottom:
                top ? BorderSide.none : BorderSide(color: color, width: 1),
            left: left
                ? BorderSide(color: color, width: 1)
                : BorderSide.none,
            right:
                left ? BorderSide.none : BorderSide(color: color, width: 1),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FALLBACK INITIALS ICON
// ─────────────────────────────────────────────────────────────

class _Fallback extends StatelessWidget {
  final String label;
  final Color color;

  const _Fallback({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final initials = label.length >= 2
        ? label.substring(0, 2).toUpperCase()
        : label.toUpperCase();
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: color,
          fontFamily: 'Courier',
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PHILOSOPHY CALLOUT  — numbered rows, same as _AchievementsSection
// in HomeScreen and _OpenSourceSection in ProjectsScreen
// ─────────────────────────────────────────────────────────────

class _PhilosophyCallout extends StatelessWidget {
  const _PhilosophyCallout();

  static const _items = [
    _PhiloItem(
        number: '01',
        text:
            'Design and code are the same discipline — the best products come from people who do both.'),
    _PhiloItem(
        number: '02',
        text:
            'Every tool here has been used in a shipped product, not just a tutorial project.'),
    _PhiloItem(
        number: '03',
        text:
            'Always learning — the stack evolves, the standards stay: clean, fast, intentional.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Philosophy'),
        ..._items.map((item) => _PhiloRow(item: item)),
      ],
    );
  }
}

class _PhiloItem {
  final String number;
  final String text;
  const _PhiloItem({required this.number, required this.text});
}

class _PhiloRow extends StatefulWidget {
  final _PhiloItem item;
  const _PhiloRow({required this.item});

  @override
  State<_PhiloRow> createState() => _PhiloRowState();
}

class _PhiloRowState extends State<_PhiloRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final surfaceEl =
        isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: _hovered ? surfaceEl : Colors.transparent,
          border: Border.all(
              color: _hovered ? border : Colors.transparent, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.number,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: accent),
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
    );
  }
}