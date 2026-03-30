import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/portfolio_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../data/github_repository.dart';
import '../../../home/presentation/widgets/contribution_graph.dart';

class GitHubScreen extends ConsumerWidget {
  const GitHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = AppSpacing.horizontalPadding(context);
    final stats =
        ref.watch(gitHubStatsProvider(PortfolioConfig.githubUsername));

    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: padding, vertical: AppSpacing.xxl),
        child: stats.when(
          loading: () => const SizedBox(height: 400, child: MonoLoader()),
          error: (e, _) => Center(
            child: Text(
              'Failed to load GitHub data',
              style: TextStyle(
                fontFamily: 'monospace',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeSlideIn(child: const SectionHeader('GitHub')),
              const StripeBand(),
              FadeSlideIn(delay: 100, child: _StatsRow(data: data)),
              const SizedBox(height: AppSpacing.xl),
              FadeSlideIn(
                delay: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contribution Graph',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        letterSpacing: 0.5,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ContributionGraph(contributions: data.contributions),
                    const SizedBox(height: 8),
                    Text(
                      '${data.totalContributions} contributions in ${DateTime.now().year}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const StripeBand(),
              FadeSlideIn(
                  delay: 300,
                  child: const SectionHeader('Repositories')),
              if (data.pinnedRepos.isEmpty)
                FadeSlideIn(
                  delay: 350,
                  child: Text(
                    'No public repositories found.',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else
                ...data.pinnedRepos.asMap().entries.map((e) => FadeSlideIn(
                      delay: 350 + e.key * 60,
                      child: _RepoCard(repo: e.value),
                    )),
              const SizedBox(height: AppSpacing.section),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final GitHubStats data;
  const _StatsRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        _StatBox(label: 'Repos', value: data.publicRepos.toString()),
        _StatBox(label: 'Followers', value: data.followers.toString()),
        _StatBox(label: 'Following', value: data.following.toString()),
        _StatBox(
            label: 'Contributions', value: data.totalContributions.toString()),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _RepoCard extends StatefulWidget {
  final GitHubRepo repo;
  const _RepoCard({required this.repo});

  @override
  State<_RepoCard> createState() => _RepoCardState();
}

class _RepoCardState extends State<_RepoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.repo.url)),
        child: AnimatedContainer(
          duration: 200.ms,
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hovered
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
                  : Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
            color: _hovered
                ? Theme.of(context).colorScheme.surfaceContainerHighest
                : Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.repo.name,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    if (widget.repo.description != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        widget.repo.description!,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        if (widget.repo.language != null) ...[
                          _LangDot(lang: widget.repo.language!),
                          const SizedBox(width: 14),
                        ],
                        Icon(Icons.star_border,
                            size: 12,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 3),
                        Text(
                          widget.repo.stars.toString(),
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.fork_right,
                            size: 12,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 3),
                        Text(
                          widget.repo.forks.toString(),
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: 16,
                color: _hovered
                    ? Theme.of(context).colorScheme.onSurface
                    : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangDot extends StatelessWidget {
  final String lang;
  const _LangDot({required this.lang});

  static const Map<String, Color> _colors = {
    'TypeScript': Color(0xFF3178C6),
    'JavaScript': Color(0xFFF1E05A),
    'Dart': Color(0xFF00B4AB),
    'Go': Color(0xFF00ACD7),
    'Rust': Color(0xFFDEA584),
    'Python': Color(0xFF3572A5),
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[lang] ?? const Color(0xFF888888);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          lang,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class MonoLoader extends StatelessWidget {
  const MonoLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'LOADING...',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              letterSpacing: 2,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ).animate(onPlay: (ctrl) => ctrl.repeat(reverse: true)).fade(duration: 800.ms),
        ],
      ),
    );
  }
}

class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int delay;

  const FadeSlideIn({super.key, required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fade(duration: 500.ms, delay: delay.ms)
        .slideY(begin: 0.05, end: 0, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}
