import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/portfolio_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/scroll_fade_in.dart';

// ─────────────────────────────────────────────
// HERO SECTION
// ─────────────────────────────────────────────

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
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
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            RepaintBoundary(child: _IdentityBlock()),
            SizedBox(height: AppSpacing.xl),
            RepaintBoundary(child: _AboutBlock()),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// IDENTITY BLOCK (Corner Accents + Profile Details)
// ─────────────────────────────────────────────

class _IdentityBlock extends StatelessWidget {
  const _IdentityBlock();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FIG.01 // IDENTITY',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: textSec, letterSpacing: 2.5, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 420;
          final sectionGap = isMobile ? AppSpacing.lg : AppSpacing.xxl;
          final isMobileDevice = AppSpacing.isMobile(context);
          
          final avatar = Magnet(
            displacement: isMobileDevice ? 0.0 : 0.1,
            child: MonofolioCornersBox(
              padding: const EdgeInsets.all(4),
              child: Container(
                width: isMobile ? double.infinity : 160,
                height: isMobile ? 320 : 200, // Slightly taller on mobile for impact
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight,
                  border: Border.all(color: border),
                ),
                child: RepaintBoundary(
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      0.33, 0.33, 0.33, 0, 0,
                      0.33, 0.33, 0.33, 0, 0,
                      0.33, 0.33, 0.33, 0, 0,
                      0,    0,    0,    1, 0,
                    ]),
                    child: _LazySkeletonAssetImage(
                      assetPath: 'assets/images/profile.png',
                      fit: isMobile ? BoxFit.cover : BoxFit.cover,
                      width: isMobile ? double.infinity : null,
                      cacheWidth: 800, // Higher res for profile
                      skeletonColor: isDark
                          ? AppColors.surfaceElevDark
                          : AppColors.surfaceElevLight,
                      errorIconColor: textSec.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          );

          Widget details = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DashedDivider(),
              ScrollFadeIn(
                delay: const Duration(milliseconds: 0),
                duration: const Duration(milliseconds: 480),
                child: const _DetailRow(index: '00', label: 'NAME', value: PortfolioConfig.name),
              ),
              DashedDivider(),
              ScrollFadeIn(
                delay: const Duration(milliseconds: 60),
                duration: const Duration(milliseconds: 480),
                child: const _DetailRow(index: '01', label: 'BASED', value: PortfolioConfig.location),
              ),
              DashedDivider(),
              ScrollFadeIn(
                delay: const Duration(milliseconds: 120),
                duration: const Duration(milliseconds: 480),
                child: const _DetailRow(index: '02', label: 'ROLE', value: 'UI/UX \u0026 Flutter Dev', isImportant: true),
              ),
              DashedDivider(),
              ScrollFadeIn(
                delay: const Duration(milliseconds: 180),
                duration: const Duration(milliseconds: 480),
                child: const _DetailRow(index: '03', label: 'STATUS', value: 'Open to Work', isStatus: true),
              ),
              DashedDivider(),
            ],
          );

          if (isMobile) {
            return Column(
              children: [
                avatar,
                const SizedBox(height: AppSpacing.xl),
                details,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: (constraints.maxWidth * 0.35).clamp(120.0, 160.0),
                child: avatar,
              ),
              SizedBox(width: sectionGap),
              Expanded(child: details),
            ],
          );
        }),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String index;
  final String label;
  final String value;
  final bool isStatus;
  final bool isImportant;

  const _DetailRow({
    required this.index,
    required this.label,
    required this.value,
    this.isStatus = false,
    this.isImportant = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.sizeOf(context).width < 430;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(index, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: textSec)),
          ),
          SizedBox(
            width: isCompact ? 64 : 80,
            child: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: textSec, letterSpacing: 2.0)),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isStatus) ...[
                  Container(
                    width: 7,
                    height: 7,
                    color: accent,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textPri,
                          fontWeight: (isStatus || isImportant || label == 'NAME') ? FontWeight.w700 : FontWeight.w400,
                        ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LazySkeletonAssetImage extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final double? width;
  final int? cacheWidth;
  final Color skeletonColor;
  final Color errorIconColor;

  const _LazySkeletonAssetImage({
    required this.assetPath,
    required this.fit,
    required this.skeletonColor,
    required this.errorIconColor,
    this.width,
    this.cacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      cacheWidth: cacheWidth,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        final loaded = wasSynchronouslyLoaded || frame != null;
        if (loaded) return child;

        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 180),
          child: _PulseSkeletonBox(color: skeletonColor),
        );
      },
      errorBuilder: (context, error, stackTrace) => Center(
        child: Icon(Icons.person_outline, size: 48, color: errorIconColor),
      ),
    );
  }
}

class _PulseSkeletonBox extends StatefulWidget {
  final Color color;
  const _PulseSkeletonBox({required this.color});

  @override
  State<_PulseSkeletonBox> createState() => _PulseSkeletonBoxState();
}

class _PulseSkeletonBoxState extends State<_PulseSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(color: widget.color),
    );
  }
}

// ─── About Block ──────────────────────────────────────

class _AboutBlock extends StatelessWidget {
  const _AboutBlock();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final pad = AppSpacing.isMobile(context) ? 16.0 : 24.0;

    return MonofolioCornersBox(
      padding: EdgeInsets.all(pad),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 560;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isCompact) ...[
                const SectionHeader('I love what I do.'),
                const SizedBox(height: 8),
                const _ResumePulsingButton(),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(child: SectionHeader('I love what I do.')),
                    const SizedBox(width: 16),
                    const _ResumePulsingButton(),
                  ],
                ),
          const SizedBox(height: 8),
          Text(
            'Simple as that. I enjoy building things that look good and work even better. If you vibe with my work or just want to chat about tech, I\'m always open.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textSec,
                  height: 1.8,
                ),
          ),
          const SizedBox(height: 24),
          const DashedDivider(),
          const SizedBox(height: 24),
          Text(
            'QUICK REACH OUT',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: textSec, letterSpacing: 1.5),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, constraints) {
            final isShort = constraints.maxWidth < 400;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _SocialLink(
                  svgAsset: 'assets/icons/github.svg',
                  label: 'GitHub',
                  url: PortfolioConfig.githubUrl,
                  isFullWidth: isShort,
                ),
                _SocialLink(
                  svgAsset: 'assets/icons/linkedin.svg',
                  label: 'LinkedIn',
                  url: PortfolioConfig.linkedinUrl,
                  isFullWidth: isShort,
                ),
                _SocialLink(
                  svgAsset: 'assets/icons/x.svg',
                  label: 'X / Twitter',
                  url: PortfolioConfig.twitterUrl,
                  isFullWidth: isShort,
                ),
              ],
            );
          }),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SOCIAL LINK
// ─────────────────────────────────────────────

class _SocialLink extends StatefulWidget {
  final String svgAsset;
  final String label;
  final String url;
  final bool isFullWidth;

  const _SocialLink({
    required this.svgAsset,
    required this.label,
    required this.url,
    this.isFullWidth = false,
  });

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final active = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final idle   = isDark ? AppColors.textSecDark     : AppColors.textSecLight;
    final border = isDark ? AppColors.borderDark      : AppColors.borderLight;
    final hoverBg= isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    // easeOutCubic — snappy hover response
    const kCurve = Cubic(0.33, 1.0, 0.68, 1.0);
    const kDur   = Duration(milliseconds: 160);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: kDur,
          curve: kCurve,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? hoverBg : Colors.transparent,
            border: Border.all(
              color: _hovered ? active : border,
              width: _hovered ? 1 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                widget.svgAsset,
                width: 14,
                height: 14,
                colorFilter: ColorFilter.mode(
                  _hovered ? active : idle,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 10),
              AnimatedDefaultTextStyle(
                duration: kDur,
                curve: kCurve,
                style: (Theme.of(context).textTheme.labelMedium ?? const TextStyle()).copyWith(
                  color: _hovered ? active : idle,
                  letterSpacing: 1.2,
                ),
                child: Text(widget.label),
              ),
              const SizedBox(width: 6),
              // Stable-width arrow to prevent layout shifts
              AnimatedOpacity(
                opacity: _hovered ? 1.0 : 0.0,
                duration: kDur,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 12,
                  color: idle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RESUME PULSING BUTTON
// ─────────────────────────────────────────────

class _ResumePulsingButton extends StatefulWidget {
  const _ResumePulsingButton();

  @override
  State<_ResumePulsingButton> createState() => _ResumePulsingButtonState();
}

class _ResumePulsingButtonState extends State<_ResumePulsingButton> with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.6, end: 1.2).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(PortfolioConfig.resumeUrl), mode: LaunchMode.externalApplication),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: _hovered ? 1.0 : 0.7,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2), // Small padding to match typical header line-height
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scale,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'RESUME',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: textPri,
                        letterSpacing: 2.0,
                        fontSize: 11,
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