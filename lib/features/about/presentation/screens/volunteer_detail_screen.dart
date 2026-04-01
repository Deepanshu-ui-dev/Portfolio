import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shared_widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VolunteerDetailScreen extends StatelessWidget {
  final String title;
  final String role;
  final List<String> paragraphs;
  final List<String> childImages;

  const VolunteerDetailScreen({
    super.key, 
    required this.title, 
    required this.role,
    this.paragraphs = const [],
    this.childImages = const [],
  });

  @override
  Widget build(BuildContext context) {
    final padding = AppSpacing.horizontalPadding(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('[ VOLUNTEER ]', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: accent, letterSpacing: 1.5)),
                      ],
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(Icons.close, color: textSec, size: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: AppSpacing.headlineSize(
                          context,
                          mobile: 30,
                          tablet: 34,
                          laptop: 40,
                        ),
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                        height: 1.1,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  role,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: textPri,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                const DashedDivider(),
                const SizedBox(height: AppSpacing.xxl),
                
                if (childImages.isNotEmpty) ...[
                  SizedBox(
                    height: 280,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: childImages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 24),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 360,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                  ),
                                  child: ColorFiltered(
                                    colorFilter: const ColorFilter.matrix(<double>[
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0,      0,      0,      1, 0,
                                    ]),
                                    child: Image.asset(childImages[index], fit: BoxFit.cover, cacheWidth: 800),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '// figure 1.$index — $title snippet',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: textSec,
                                      letterSpacing: 1.5,
                                    ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],

                // Dynamic paragraphs
                if (paragraphs.isEmpty)
                  _buildSection(context, 'Overview', 'As an active contributor and leader in the $title community, I was heavily involved in organizing events, managing community outreach, and facilitating tech workshops.')
                else
                  for (var i = 0; i < paragraphs.length; i++) ...[
                    MarkdownBody(
                      data: paragraphs[i],
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: textSec,
                              height: 1.8,
                              fontSize: 16,
                            ),
                        h3: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: textPri,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                        listBullet: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: textSec,
                              fontSize: 16,
                            ),
                      ),
                    ),
                    if (i < paragraphs.length - 1) const SizedBox(height: 24),
                  ],
                
                const SizedBox(height: 60),
              ],
            ),
          ).animate().fade(duration: 350.ms).slideY(begin: 0.04, end: 0, duration: 350.ms, curve: Curves.easeOutCubic),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String header, String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: textPri,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textSec,
                height: 1.8,
                fontSize: 16,
              ),
        ),
      ],
    );
  }
}
