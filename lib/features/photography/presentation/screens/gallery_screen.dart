import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shared_widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const _images = [
    'assets/images/aabes.jpeg',
    'assets/images/abesss.jpeg',
    'assets/images/caat.jpeg',
    'assets/images/cafe.jpeg',
    'assets/images/cat.jpeg',
    'assets/images/flower.jpeg',
    'assets/images/flow.jpeg',
    'assets/images/mount.jpeg',
    'assets/images/shiv.jpeg',
    'assets/images/sq.jpeg',
    'assets/images/abessss.jpg',
    'assets/images/flower.jpg',
    'assets/images/sunshine.jpg',
    'assets/images/fire.jpg', 
  ];

  @override
  Widget build(BuildContext context) {
    final padding = AppSpacing.horizontalPadding(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return GridBackground(
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              // Header Section
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: AppSpacing.xl),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  '[ 05 ]',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: accent, letterSpacing: 1.5),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'SHORTS & GALLERY',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: textSec, letterSpacing: 2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Back Button
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                LucideIcons.x,
                                color: textSec,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Bits of life.",
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
                      Text(
                        'Moments captured through the lens, random shots, and videos.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: textSec, height: 1.65),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const DashedDivider(),
                    ],
                  ),
                ),
              ),
              
              // Grid Section
              SliverPadding(
                padding: EdgeInsets.fromLTRB(padding, 0, padding, AppSpacing.xl + 40),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.crossAxisExtent < AppSpacing.mobileMax;
                    final isTablet =
                        constraints.crossAxisExtent >= AppSpacing.mobileMax &&
                            constraints.crossAxisExtent < AppSpacing.tabletMax;
  
                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: isMobile
                            ? 220
                            : isTablet
                                ? 250
                                : 300,
                        mainAxisSpacing: isMobile ? 12 : 16,
                        crossAxisSpacing: isMobile ? 12 : 16,
                        childAspectRatio: isMobile ? 0.74 : 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _GalleryImageCard(imagePath: _images[index])
                              .animate()
                              .fade(
                                duration: 400.ms,
                                delay: Duration(milliseconds: 50 * index),
                              )
                              .slideY(
                                begin: 0.05,
                                end: 0,
                                duration: 400.ms,
                                delay: Duration(milliseconds: 50 * index),
                                curve: Curves.easeOutCubic,
                              );
                        },
                        childCount: _images.length,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryImageCard extends StatefulWidget {
  final String imagePath;
  const _GalleryImageCard({required this.imagePath});

  @override
  State<_GalleryImageCard> createState() => _GalleryImageCardState();
}

class _GalleryImageCardState extends State<_GalleryImageCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _hovered = true),
        onTapUp: (_) => setState(() => _hovered = false),
        onTapCancel: () => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: _hovered ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: border, width: 1),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Base colorful image
                _SkeletonAssetImage(
                  assetPath: widget.imagePath,
                  fit: BoxFit.cover,
                  cacheWidth: 450,
                  skeletonColor: isDark
                      ? AppColors.surfaceElevDark
                      : AppColors.surfaceElevLight,
                  errorWidget: const Center(child: Icon(LucideIcons.imageOff)),
                ),
                // Black and white filter fading out on hover
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
                      child: _SkeletonAssetImage(
                        assetPath: widget.imagePath,
                        fit: BoxFit.cover,
                        cacheWidth: 450,
                        skeletonColor: isDark
                            ? AppColors.surfaceElevDark
                            : AppColors.surfaceElevLight,
                        errorWidget:
                            const Center(child: Icon(LucideIcons.imageOff)),
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

class _SkeletonAssetImage extends StatefulWidget {
  final String assetPath;
  final BoxFit fit;
  final Color skeletonColor;
  final Widget errorWidget;
  final int? cacheWidth;

  const _SkeletonAssetImage({
    required this.assetPath,
    required this.fit,
    required this.skeletonColor,
    required this.errorWidget,
    this.cacheWidth,
  });

  @override
  State<_SkeletonAssetImage> createState() => _SkeletonAssetImageState();
}

class _SkeletonAssetImageState extends State<_SkeletonAssetImage> {
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Force the skeleton to display for 0.5s minimum when showcasing
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _showContent = true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.assetPath,
      fit: widget.fit,
      cacheWidth: widget.cacheWidth,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (_showContent && (wasSynchronouslyLoaded || frame != null)) {
          return child.animate().fadeIn(duration: 400.ms, curve: Curves.easeOut);
        }
        return Container(color: widget.skeletonColor)
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1200.ms, color: Colors.white24, angle: 1.0);
      },
      errorBuilder: (_, __, ___) => widget.errorWidget,
    );
  }
}
