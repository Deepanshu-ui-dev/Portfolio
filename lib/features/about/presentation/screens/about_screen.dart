import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../blog/presentation/screens/blog_detail_screen.dart';
import 'volunteer_detail_screen.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
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
    final padding = AppSpacing.horizontalPadding(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;

    return FadeTransition(
      opacity: _fade,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: padding, vertical: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── 01 / Header ──
                _SectionLabel(index: '01', label: 'THE PERSON BEHIND THE PIXELS'),
                const SizedBox(height: 14),
                Text(
                  "My personal digital space.",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -2,
                        height: 1.0,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No corporate jargon. Just a quiet corner of the internet where I dump my thoughts, track my life goals, and share the vibes I\'m currently listening to.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: textSec, height: 1.65),
                ),

                const SizedBox(height: AppSpacing.xxl),
                const DashedDivider(),
                const SizedBox(height: AppSpacing.xxl),

                // ── 02 / Bucket List ──
                _SectionLabel(index: '02', label: 'BUCKET LIST'),
                const SizedBox(height: 16),
                const _BucketListSection(),

                const SizedBox(height: AppSpacing.xxl),
                const DashedDivider(),
                const SizedBox(height: AppSpacing.xxl),

                // ── 04 / Volunteer Experience ──
                _SectionLabel(index: '03', label: 'COMMUNITY CONTRIBUTIONS'),
                const SizedBox(height: 6),
                Text(
                  'Communities I\'ve helped build and grown in.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: textSec, height: 1.5),
                ),
                const SizedBox(height: 20),
                const _VolunteerExperienceFeed(),

                const SizedBox(height: AppSpacing.xxl),
                const DashedDivider(),
                const SizedBox(height: AppSpacing.xxl),

                // ── 05 / Brain Dumps ──
                _SectionLabel(index: '04', label: 'BRAIN DUMPS'),
                const SizedBox(height: 16),
                const _JournalFeed(),

                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHARED SECTION LABEL
// ─────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String index;
  final String label;
  const _SectionLabel({required this.index, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Row(children: [
      Text('[ $index ]',
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: accent, letterSpacing: 1.5)),
      const SizedBox(width: 10),
      Expanded(
        child: Text(label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: textSec, letterSpacing: 2)),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
// BUCKET LIST SECTION
// ─────────────────────────────────────────────

class _BucketListSection extends StatelessWidget {
  const _BucketListSection();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceElev =
        isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceElev.withOpacity(0.3),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Life Goals & Quirks',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600, color: textPri)),
          const SizedBox(height: 6),
          Text('Things I\'m working towards.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: textSec, fontSize: 13)),
          const SizedBox(height: 20),
          const _BucketItem(text: 'Land my first Intern', isDone: true),
          const _BucketItem(text: 'Drive Car', isDone: true),
          const _BucketItem(text: 'Conduct a 24-hour hackathon', isDone: true),
          const _BucketItem(text: 'Solo Trip', isDone: false),
          const _BucketItem(
              text: 'Build a scalable full-stack application', isDone: false),
          const _BucketItem(text: 'Visit Kedarnath', isDone: false),
          const _BucketItem(
              text: 'Land my first full-time tech job', isDone: false),
          const _BucketItem(
              text: 'Earn my first salary and do something memorable',
              isDone: false),
          const _BucketItem(
              text: 'Go on a long road trip with good music', isDone: false),
          const _BucketItem(
              text: 'Build a product people genuinely use', isDone: false),
        ],
      ),
    );
  }
}

class _BucketItem extends StatefulWidget {
  final String text;
  final bool isDone;
  const _BucketItem({required this.text, required this.isDone});

  @override
  State<_BucketItem> createState() => _BucketItemState();
}

class _BucketItemState extends State<_BucketItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPri =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 3, right: 12),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                border: Border.all(
                    color: widget.isDone
                        ? accent
                        : textSec.withOpacity(0.4)),
                color: widget.isDone
                    ? accent.withOpacity(0.15)
                    : Colors.transparent,
              ),
              child: widget.isDone
                  ? Icon(Icons.check, size: 10, color: accent)
                  : null,
            ),
            Expanded(
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: widget.isDone ? textSec : textPri,
                      decoration: widget.isDone
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: textSec.withOpacity(0.5),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// VOLUNTEER EXPERIENCE FEED
// ─────────────────────────────────────────────

class _VolunteerExperienceFeed extends StatelessWidget {
  const _VolunteerExperienceFeed();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 500;

          const gdg = _MomentCard(
            title: 'Google Developer Group',
            role: 'Co-Organizer',
            period: '2025 – Present',
            tagline: 'From curious attendee to co-organizer.',
            imageAsset: 'assets/images/gdg1.jpeg',
            childImages: [
              'assets/images/gdg2.jpeg',
              'assets/images/gdg3.jpeg'
            ],
            paragraphs: [
              '### The Spark',
              'My journey with GDG On Campus ABESEC started with pure curiosity. I walked into an event called "Mind the Gap", a simple UI/UX session that introduced me to Figma and felt more like discovering a superpower than attending a workshop.',
              'I left thinking, "Wow... this is fun." That spark pulled me deeper into the GDG world.',
              'By my second year, curiosity became passion, and I joined GDG as a Design Coordinator, not just attending events, but designing them and helping others feel the same spark I did on day one.',
              '### Community Impact',
              'Founded in 2019, GDG On Campus ABESEC has grown into a vibrant tech community of 1,500+ developers, designers, and innovators. We bridge the gap between classroom learning and real-world tech through workshops, hackathons, and hands-on experiences.',
              'We\'ve hosted 670+ attendees, featured industry leaders like Love Babbar and Arsh Goyal, and organized flagship events such as:\n\n* **Mind the Gap** - fun, interactive UI/UX foundations\n* **HackHaven** - a 24-hour hackathon powered by teamwork\n* **Innovate Workshop** - AR/VR gaming & web development\n* **Git & Solana Workshop** - version control meets blockchain',
              '### Current Role',
              'Today, as a Co-Organizer, I help lead the community I once joined as a curious attendee. GDG isn\'t just a club for me anymore, it\'s where I grew, designed, learned, and got inspired to create things that matter.',
            ],
          );

          const codeChef = _MomentCard(
            title: 'CodeChef ABESEC',
            role: 'Graphics Lead',
            period: '2024 – Present',
            tagline: 'One contest changed everything.',
            imageAsset: 'assets/images/cc1.jpeg',
            isSecondary: false,
            childImages: [
              'assets/images/cc2.jpeg',
              'assets/images/cc3.jpeg'
            ],
            paragraphs: [
              '### A Community of Problem Solvers',
              'Founded in 2018, CodeChef ABESEC Chapter has grown into a supportive and driven community centered around competitive programming and strong problem-solving culture.',
              'With 750+ active learners, the chapter regularly conducts coding contests, DSA workshops, and learning programs that help students sharpen logic, consistency, and technical depth. Over the years, it has hosted impactful events like Clash of Coders, 75 Days of DSA, Once Upon a Crime, and many other immersive competitive programming experiences.',
              '### First Steps into CP',
              'My story with CodeChef ABESEC began with one event, T-Error. It was the first contest I ever participated in, and I had no idea it would spark such a deep interest in CP and DSA.',
              'That one challenge pushed me into the world of logic-building, patterns, and structured thinking, and it quickly became a place where I wanted to learn more and grow.',
              '### Design & Identity',
              'Today, I proudly serve as the Graphics Lead, shaping the chapter\'s visual identity and contributing to the same community that once introduced me to the world of CP.',
            ],
          );

          if (isWide) {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: gdg),
                  const SizedBox(width: 12),
                  Expanded(child: codeChef),
                ],
              ),
            );
          }
          return Column(
            children: [
              gdg,
              const SizedBox(height: 12),
              codeChef,
            ],
          );
        }),
      ],
    );
  }
}

// Stats data class
class _VolunteerStat {
  final String value;
  final String label;
  const _VolunteerStat({required this.value, required this.label});
}

class _MomentCard extends StatefulWidget {
  final String title;
  final String role;
  final String period;
  final String tagline;
  final String imageAsset;
  final bool isSecondary;
  final List<String> paragraphs;
  final List<String> childImages;
  final List<_VolunteerStat> stats;

  const _MomentCard({
    required this.title,
    required this.role,
    required this.period,
    required this.tagline,
    required this.imageAsset,
    this.isSecondary = false,
    this.paragraphs = const [],
    this.childImages = const [],
    this.stats = const [],
  });

  @override
  State<_MomentCard> createState() => _MomentCardState();
}

class _MomentCardState extends State<_MomentCard> {
  bool _hovered = false;

  void _openDetails(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => VolunteerDetailScreen(
                  title: widget.title,
                  role: widget.role,
                  paragraphs: widget.paragraphs,
                  childImages: widget.childImages,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final surfaceElev =
        isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final textPri =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _openDetails(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _hovered
                ? surfaceElev.withOpacity(0.5)
                : Colors.transparent,
            border: Border.all(color: _hovered ? border2 : border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Cover image (Black & White) ──
              AspectRatio(
                aspectRatio: widget.isSecondary ? 4 / 3 : 16 / 9,
                child: ClipRect(
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0,      0,      0,      1, 0,
                    ]),
                    child: SizedBox.expand(
                      child: Image.asset(
                        widget.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: isDark
                              ? const Color(0xFF1A1A1A)
                              : const Color(0xFFDDDDDD),
                          child: Center(
                            child: Icon(
                              Icons.photo_camera_back_outlined,
                              color: textSec.withOpacity(0.3),
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Card body ──
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Role pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        border: Border.all(color: accent.withOpacity(0.4)),
                        color: accent.withOpacity(0.06),
                      ),
                      child: Text(
                        widget.role.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                                color: accent,
                                fontSize: 9,
                                letterSpacing: 1.5),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Title
                    Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textPri,
                              fontSize: 15,
                              height: 1.2),
                    ),
                    const SizedBox(height: 4),

                    // Period
                    Text(
                      widget.period,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                              color: textSec.withOpacity(0.6),
                              fontSize: 11),
                    ),
                    const SizedBox(height: 10),

                    // Tagline
                    Text(
                      widget.tagline,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                              color: textSec, fontSize: 13, height: 1.5),
                    ),

                    // Stats row
                    if (widget.stats.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: widget.stats
                            .map((s) => Expanded(
                                  child: _StatCell(
                                    value: s.value,
                                    label: s.label,
                                  ),
                                ))
                            .toList(),
                      ),
                    ],

                    const SizedBox(height: 14),

                    // Read more
                    Row(
                      children: [
                        Text(
                          'READ MORE',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: _hovered ? textPri : textSec,
                                  letterSpacing: 1.5,
                                  fontSize: 9),
                        ),
                        const SizedBox(width: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(
                              _hovered ? 3 : 0, 0, 0),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: _hovered ? textPri : textSec,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  const _StatCell({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPri =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: textPri,
                  fontSize: 15)),
          const SizedBox(height: 2),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: textSec, fontSize: 10)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// JOURNAL FEED (THOUGHTS & BLOGS)
// ─────────────────────────────────────────────

class _JournalFeed extends StatelessWidget {
  const _JournalFeed();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _JournalItem(
          date: 'MAR 2026',
          title: 'Why I prefer Flutter over React Native',
          excerpt:
              'A deep dive into cross-platform development, performance metrics, and why Flutter\'s rendering engine wins the developer experience battle.',
          isThought: false,
          url:
              'https://medium.com/@Deepanshu25u/why-i-prefer-flutter-over-react-native-9b202291df0c',
        ),
        SizedBox(height: 12),
        _JournalItem(
          date: 'JAN 2026',
          title: 'A Random Thought on Fluid UIs',
          excerpt:
              'I really believe UI should feel alive. A button isn\'t just a rectangle; it\'s a surface that reacts to intent. Micro-animations are deeply underrated.',
          isThought: true,
        ),
      ],
    );
  }
}

class _JournalItem extends StatefulWidget {
  final String date;
  final String title;
  final String excerpt;
  final bool isThought;
  final String? url;

  const _JournalItem({
    required this.date,
    required this.title,
    required this.excerpt,
    required this.isThought,
    this.url,
  });

  @override
  State<_JournalItem> createState() => _JournalItemState();
}

class _JournalItemState extends State<_JournalItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final surfaceElev =
        isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final textPri =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.isThought
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.isThought
            ? null
            : () {
                if (widget.url != null) {
                  launchUrl(Uri.parse(widget.url!),
                      mode: LaunchMode.externalApplication);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlogDetailScreen(
                              slug: widget.title
                                  .toLowerCase()
                                  .replaceAll(' ', '-'))));
                }
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _hovered && !widget.isThought
                ? surfaceElev
                : Colors.transparent,
            border: Border.all(
                color: _hovered && !widget.isThought ? border2 : border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    widget.isThought
                        ? Icons.format_quote
                        : Icons.article_outlined,
                    size: 13,
                    color: widget.isThought ? accent : textSec,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.date,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: textSec, letterSpacing: 1.5, fontSize: 9),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textPri,
                    fontSize: 17,
                    height: 1.3),
              ),
              const SizedBox(height: 10),
              Text(
                widget.excerpt,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: textSec, height: 1.7),
              ),
              if (!widget.isThought) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      'READ POST',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                              color: _hovered ? textPri : textSec,
                              letterSpacing: 1.5,
                              fontSize: 9),
                    ),
                    const SizedBox(width: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.translationValues(
                          _hovered ? 3 : 0, 0, 0),
                      child: Icon(Icons.arrow_forward,
                          size: 12,
                          color: _hovered ? textPri : textSec),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}