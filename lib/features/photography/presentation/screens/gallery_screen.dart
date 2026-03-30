import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shared_widgets.dart';

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

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: AppSpacing.xl),
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
                            Icons.close,
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
            
            // Grid Section
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < AppSpacing.mobileMax;
                  final isTablet =
                      constraints.maxWidth >= AppSpacing.mobileMax &&
                          constraints.maxWidth < AppSpacing.tabletMax;

                  return GridView.builder(
                    padding:
                        EdgeInsets.fromLTRB(padding, 0, padding, AppSpacing.xl + 40),
                    physics: const BouncingScrollPhysics(),
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
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return _GalleryImageCard(imagePath: _images[index]);
                    },
                  );
                },
              ),
            ),
          ],
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
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: border, width: 1),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Base colorful image
            Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image_outlined)),
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
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image_outlined)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
