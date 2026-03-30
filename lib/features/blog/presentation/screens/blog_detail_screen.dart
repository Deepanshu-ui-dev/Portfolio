import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../../data/blog_repository.dart';
import '../../../../core/theme/app_theme.dart';

class BlogDetailScreen extends StatelessWidget {
  final String slug;
  const BlogDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final repo = BlogRepository();
    final post = repo.getPost(slug);
    final padding = AppSpacing.horizontalPadding(context);

    if (post == null) {
      return Center(
        child: Text(
          'Post not found.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: AppSpacing.xxxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => context.go('/blog'),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, color: AppColors.textSecondary, size: 16),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'BACK TO LOGS',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 2,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              post.title,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              post.date,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiary,
                    fontFamily: 'monospace',
                  ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.surfaceBorder,
            ),
            const SizedBox(height: AppSpacing.xxl),
            MarkdownBody(
              data: post.content,
              styleSheet: MarkdownStyleSheet(
                h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                h3: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.8,
                    ),
                strong: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                em: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textTertiary,
                    ),
                code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      backgroundColor: Colors.transparent,
                      color: AppColors.textPrimary,
                    ),
                codeblockPadding: const EdgeInsets.all(AppSpacing.lg),
                codeblockDecoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(
                    color: AppColors.surfaceBorder,
                    width: 1,
                  ),
                ),
                blockquoteDecoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppColors.surfaceBorder,
                      width: 2,
                    ),
                  ),
                ),
                blockquotePadding: const EdgeInsets.only(left: 20, top: 4, bottom: 4),
                blockquote: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textTertiary,
                      height: 1.8,
                    ),
                horizontalRuleDecoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.surfaceBorder,
                      width: 1,
                    ),
                  ),
                ),
                h1Padding: const EdgeInsets.only(top: 32, bottom: 16),
                h2Padding: const EdgeInsets.only(top: 28, bottom: 12),
                h3Padding: const EdgeInsets.only(top: 24, bottom: 8),
                pPadding: const EdgeInsets.only(bottom: 20),
                listBullet: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                listIndent: 24,
              ),
            ),
            const SizedBox(height: AppSpacing.section),
          ],
        ),
      ),
    );
  }
}
