import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────
// BLOG SCREEN
// ─────────────────────────────────────────────

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  static const _articles = [
    _ArticleData(
      date: 'December 20, 2025',
      title: 'Time Is Short: Memento Mori',
      excerpt:
          'Memento mori is not about fear. It is a practical way to use your limited time with clarity and intention.',
      url: 'https://example.com/memento-mori',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final padding = AppSpacing.horizontalPadding(context);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: AppSpacing.xl),
          sliver: SliverList.list(
            children: [
              // Page title
              Text(
                'Articles',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),

              const SizedBox(height: 16),

              // Disclaimer
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.8,
                        fontSize: 11,
                      ),
                  children: [
                    TextSpan(
                      text: 'Disclaimer',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.textSecondary,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ': I write about the tech I build and my experiences in development. I am not a professional writer, so if I write something inaccurate, please feel free to ',
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: _InlineLink(
                        label: 'email me',
                        url: 'mailto:bilal@example.com',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Article list
              ..._articles.map((a) => _ArticleRow(data: a)),

              const SizedBox(height: AppSpacing.xxxl),

              // Footer
              const _FooterWidget(),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// ARTICLE ROW
// ─────────────────────────────────────────────

class _ArticleData {
  final String date;
  final String title;
  final String excerpt;
  final String url;

  const _ArticleData({
    required this.date,
    required this.title,
    required this.excerpt,
    required this.url,
  });
}

class _ArticleRow extends StatefulWidget {
  final _ArticleData data;
  const _ArticleRow({required this.data});

  @override
  State<_ArticleRow> createState() => _ArticleRowState();
}

class _ArticleRowState extends State<_ArticleRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _hovered = true),
        onTapUp: (_) => setState(() => _hovered = false),
        onTapCancel: () => setState(() => _hovered = false),
        onTap: () => launchUrl(Uri.parse(widget.data.url)),
        child: AnimatedScale(
          scale: _hovered ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.surface.withValues(alpha: 0.4)
                  : Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Text(
                  widget.data.date,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                ),

                const SizedBox(height: 6),

                // Title
                Text(
                  widget.data.title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),

                const SizedBox(height: 8),

                // Excerpt
                Text(
                  widget.data.excerpt,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.7,
                        fontSize: 11,
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
// INLINE LINK
// ─────────────────────────────────────────────

class _InlineLink extends StatefulWidget {
  final String label;
  final String url;
  const _InlineLink({required this.label, required this.url});

  @override
  State<_InlineLink> createState() => _InlineLinkState();
}

class _InlineLinkState extends State<_InlineLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 11,
            color: _hovered ? AppColors.textPrimary : AppColors.textSecondary,
            decoration: TextDecoration.underline,
            decorationColor:
                _hovered ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────

class _FooterWidget extends StatelessWidget {
  const _FooterWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.surfaceBorder, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.surfaceBorder, width: 1),
                ),
                child: Icon(LucideIcons.layoutGrid,
                    size: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DESIGN & BUILD',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 1.2,
                          )),
                  Text('© 2026 — Bilal',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          )),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(LucideIcons.sun,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Icon(LucideIcons.moon,
                  size: 14, color: AppColors.textPrimary),
            ],
          ),
        ],
      ),
    );
  }
}