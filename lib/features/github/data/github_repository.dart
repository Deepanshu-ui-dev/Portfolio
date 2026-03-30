import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────

class GitHubRepo {
  final String name;
  final String? description;
  final String url;
  final int stars;
  final int forks;
  final String? language;
  final bool isForked;

  const GitHubRepo({
    required this.name,
    this.description,
    required this.url,
    required this.stars,
    required this.forks,
    this.language,
    required this.isForked,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) => GitHubRepo(
        name: json['name'] as String,
        description: json['description'] as String?,
        url: json['html_url'] as String,
        stars: json['stargazers_count'] as int? ?? 0,
        forks: json['forks_count'] as int? ?? 0,
        language: json['language'] as String?,
        isForked: json['fork'] as bool? ?? false,
      );
}

class ContributionDay {
  final DateTime date;
  final int count;
  final int level;

  const ContributionDay({
    required this.date,
    required this.count,
    required this.level,
  });
}

class GitHubStats {
  final List<GitHubRepo> pinnedRepos;
  final List<ContributionDay> contributions;
  final int totalContributions;
  final String? avatarUrl;
  final int followers;
  final int following;
  final int publicRepos;

  const GitHubStats({
    required this.pinnedRepos,
    required this.contributions,
    required this.totalContributions,
    this.avatarUrl,
    required this.followers,
    required this.following,
    required this.publicRepos,
  });
}

// ─────────────────────────────────────────────
// REPOSITORY
// ─────────────────────────────────────────────

class GitHubRepository {
  static const _base = 'https://api.github.com';

  Future<GitHubStats> fetchStats(String username) async {
    try {
      // ───────── USER + REPOS (parallel fetch) ─────────
      final results = await Future.wait([
        http.get(
          Uri.parse('$_base/users/$username'),
          headers: {'Accept': 'application/vnd.github.v3+json'},
        ),
        http.get(
          Uri.parse(
              '$_base/users/$username/repos?sort=stars&per_page=6&type=owner'),
          headers: {'Accept': 'application/vnd.github.v3+json'},
        ),
        http.get(
          Uri.parse('https://github.com/users/$username/contributions'),
          headers: {
            'User-Agent':
                'Mozilla/5.0 (compatible; portfolio-app/1.0)',
            'Accept': 'text/html,application/xhtml+xml',
            'Accept-Language': 'en-US,en;q=0.9',
          },
        ),
      ]);

      final userRes = results[0];
      final reposRes = results[1];
      final heatmapRes = results[2];

      // ───────── PARSE USER ─────────
      Map<String, dynamic> user = {};
      if (userRes.statusCode == 200) {
        user = jsonDecode(userRes.body) as Map<String, dynamic>;
      }

      // ───────── PARSE REPOS ─────────
      List<GitHubRepo> repos = [];
      if (reposRes.statusCode == 200) {
        final list = jsonDecode(reposRes.body) as List<dynamic>;
        repos = list
            .map((e) => GitHubRepo.fromJson(e as Map<String, dynamic>))
            .where((r) => !r.isForked)
            .take(4)
            .toList();
      }

      // ───────── PARSE CONTRIBUTIONS ─────────
      List<ContributionDay> contributions = [];
      int totalContributions = 0;

      if (heatmapRes.statusCode == 200) {
        final parsed = _parseContributions(heatmapRes.body);
        contributions = parsed.$1;
        totalContributions = parsed.$2;
      }

      // Fallback to mock data if parsing yielded nothing
      if (contributions.isEmpty) {
        contributions = _generateMockContributions();
        totalContributions =
            contributions.fold(0, (sum, d) => sum + d.count);
      }

      return GitHubStats(
        pinnedRepos: repos,
        contributions: contributions,
        totalContributions: totalContributions,
        avatarUrl: user['avatar_url'] as String?,
        followers: user['followers'] as int? ?? 0,
        following: user['following'] as int? ?? 0,
        publicRepos: user['public_repos'] as int? ?? 0,
      );
    } catch (_) {
      final mock = _generateMockContributions();
      return GitHubStats(
        pinnedRepos: const [],
        contributions: mock,
        totalContributions: mock.fold(0, (sum, d) => sum + d.count),
        followers: 0,
        following: 0,
        publicRepos: 0,
      );
    }
  }

  // ─────────────────────────────────────────────
  // HTML PARSING
  // Returns (contributions list, total count)
  // ─────────────────────────────────────────────

  (List<ContributionDay>, int) _parseContributions(String html) {
    final contributions = <ContributionDay>[];
    int total = 0;

    // ── Step 1: Extract the total from the summary text ──
    // GitHub renders something like:
    //   "1,234 contributions in the last year"
    final totalRegex = RegExp(
      r'([\d,]+)\s+contributions?\s+in\s+the\s+last\s+year',
      caseSensitive: false,
    );
    final totalMatch = totalRegex.firstMatch(html);
    if (totalMatch != null) {
      total = int.tryParse(
              totalMatch.group(1)!.replaceAll(RegExp(r'[,\s]'), '')) ??
          0;
    }

    // ── Step 2: Extract per-day data ──
    // GitHub's current HTML uses <td> with data-date and data-level.
    // The count lives in the tooltip text or in the data-count attr
    // (older versions). We try both approaches.

    // Approach A — data-count attribute (present in some GitHub variants)
    final tdWithCountRegex = RegExp(
      r'<td[^>]+data-date="(\d{4}-\d{2}-\d{2})"[^>]*data-level="(\d)"[^>]*data-count="(\d+)"[^>]*/?>',
    );

    for (final m in tdWithCountRegex.allMatches(html)) {
      final date = DateTime.tryParse(m.group(1)!);
      final level = int.tryParse(m.group(2)!) ?? 0;
      final count = int.tryParse(m.group(3)!) ?? 0;
      if (date != null) {
        contributions.add(
            ContributionDay(date: date, count: count, level: level));
      }
    }

    // Approach B — tooltip text (current GitHub structure as of 2024-2025)
    // <rect ... data-date="2024-03-01" data-level="2" />
    // <tool-tip for="contribution-day-component-2024-03-01">
    //   3 contributions on March 1, 2024
    // </tool-tip>
    if (contributions.isEmpty) {
      // Build a date → count map from <tool-tip> elements first
      // Also capture the date embedded in the for="..." attribute
      final tooltipWithDateRegex = RegExp(
        r'<tool-tip[^>]+for="[^"]*(\d{4}-\d{2}-\d{2})[^"]*"[^>]*>\s*([\d,]+|No)[^<]*<\/tool-tip>',
        caseSensitive: false,
      );

      final countByDate = <String, int>{};
      for (final m in tooltipWithDateRegex.allMatches(html)) {
        final dateStr = m.group(1)!;
        final raw = m.group(2)!.toLowerCase();
        final count = raw == 'no'
            ? 0
            : int.tryParse(raw.replaceAll(',', '')) ?? 0;
        countByDate[dateStr] = count;
      }

      // Now match the <rect> / <td> elements for dates + levels
      final cellRegex = RegExp(
        r'data-date="(\d{4}-\d{2}-\d{2})"[^>]*data-level="(\d)"',
      );
      for (final m in cellRegex.allMatches(html)) {
        final dateStr = m.group(1)!;
        final date = DateTime.tryParse(dateStr);
        final level = int.tryParse(m.group(2)!) ?? 0;
        if (date == null) continue;

        // Prefer tooltip count; fall back to level as a proxy
        final count = countByDate[dateStr] ?? level;
        contributions.add(
            ContributionDay(date: date, count: count, level: level));
      }
    }

    // ── Step 3: Deduplicate and sort chronologically ──
    final seen = <String>{};
    final unique = <ContributionDay>[];
    for (final day in contributions) {
      final key = day.date.toIso8601String().substring(0, 10);
      if (seen.add(key)) unique.add(day);
    }
    unique.sort((a, b) => a.date.compareTo(b.date));

    // ── Step 4: If no total was found in the HTML, compute from cells ──
    if (total == 0 && unique.isNotEmpty) {
      total = unique.fold(0, (sum, d) => sum + d.count);
    }

    return (unique, total);
  }

  // ─────────────────────────────────────────────
  // MOCK DATA (SAFE FALLBACK)
  // ─────────────────────────────────────────────

  static List<ContributionDay> _generateMockContributions() {
    final days = <ContributionDay>[];
    final now = DateTime.now();
    const pattern = [0, 0, 1, 2, 0, 3, 0, 1, 5, 2, 0, 0, 7, 3, 1, 0, 4, 2, 8, 0];

    for (int i = 365; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final base = pattern[(i + date.weekday) % pattern.length];
      final noise = (i * 7 + date.day) % 5;
      final count = (base + (noise > 3 ? noise - 2 : 0)).clamp(0, 12);
      days.add(ContributionDay(
        date: date,
        count: count,
        level: (count / 3).clamp(0, 4).toInt(),
      ));
    }
    return days;
  }
}

// ─────────────────────────────────────────────
// PROVIDERS
// ─────────────────────────────────────────────

final gitHubRepositoryProvider = Provider<GitHubRepository>((ref) {
  return GitHubRepository();
});

final gitHubStatsProvider =
    FutureProvider.family<GitHubStats, String>((ref, username) async {
  final repo = ref.watch(gitHubRepositoryProvider);
  return repo.fetchStats(username);
});