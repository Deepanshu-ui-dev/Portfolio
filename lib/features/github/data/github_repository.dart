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

  // Optional: flutter build web --dart-define=GH_TOKEN=ghp_xxx
  // Not required — contributions use a token-free public proxy.
  // Adding a token only increases REST rate limit (60 → 5000 req/hr).
  static const _token = String.fromEnvironment('GH_TOKEN', defaultValue: '');

  Future<GitHubStats> fetchStats(String username) async {
    try {
      final authHeaders = _token.isNotEmpty
          ? {'Authorization': 'bearer $_token'}
          : <String, String>{};

      // ── Parallel fetch ──────────────────────────────────────────────
      final results = await Future.wait([
        // 1. User profile (REST — works unauthenticated, CORS-safe)
        http.get(
          Uri.parse('$_base/users/$username'),
          headers: {
            'Accept': 'application/vnd.github.v3+json',
            ...authHeaders,
          },
        ),

        // 2. Public repos (REST — works unauthenticated, CORS-safe)
        http.get(
          Uri.parse(
              '$_base/users/$username/repos?sort=stars&per_page=6&type=owner'),
          headers: {
            'Accept': 'application/vnd.github.v3+json',
            ...authHeaders,
          },
        ),

        // 3. Contributions via jogruber's public proxy
        //    • No token needed
        //    • Returns CORS headers — works from Flutter Web
        //    • Response: { "total": {...}, "contributions": [...] }
        //    • ?y=last  → last 12 months only
        http.get(
          Uri.parse(
              'https://github-contributions-api.jogruber.de/v4/$username?y=last'),
          headers: {'Accept': 'application/json'},
        ),
      ]);

      final userRes          = results[0];
      final reposRes         = results[1];
      final contributionsRes = results[2];

      // ── Parse user ──────────────────────────────────────────────────
      Map<String, dynamic> user = {};
      if (userRes.statusCode == 200) {
        user = jsonDecode(userRes.body) as Map<String, dynamic>;
      }

      // ── Parse repos ─────────────────────────────────────────────────
      List<GitHubRepo> repos = [];
      if (reposRes.statusCode == 200) {
        final list = jsonDecode(reposRes.body) as List<dynamic>;
        repos = list
            .map((e) => GitHubRepo.fromJson(e as Map<String, dynamic>))
            .where((r) => !r.isForked)
            .take(4)
            .toList();
      }

      // ── Parse contributions ──────────────────────────────────────────
      List<ContributionDay> contributions = [];
      int totalContributions = 0;

      if (contributionsRes.statusCode == 200) {
        final parsed = _parseContributionsProxy(contributionsRes.body);
        contributions = parsed.$1;
        totalContributions = parsed.$2;
      }

      // Fallback to mock data only if proxy failed
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
  // PARSER — github-contributions-api.jogruber.de
  //
  // Response shape:
  // {
  //   "total": { "2025": 312, "2024": 198 },
  //   "contributions": [
  //     { "date": "2024-04-01", "count": 3, "level": 2 },
  //     ...
  //   ]
  // }
  // ─────────────────────────────────────────────

  (List<ContributionDay>, int) _parseContributionsProxy(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;

      // Sum total across all years in the response
      int total = 0;
      final totalMap = json['total'] as Map<String, dynamic>?;
      if (totalMap != null) {
        for (final v in totalMap.values) {
          total += (v as int? ?? 0);
        }
      }

      final rawDays = json['contributions'] as List<dynamic>? ?? [];
      final days = <ContributionDay>[];

      for (final item in rawDays) {
        final map     = item as Map<String, dynamic>;
        final dateStr = map['date'] as String?;
        final count   = map['count'] as int? ?? 0;
        final level   = map['level'] as int? ?? 0;

        if (dateStr == null) continue;
        final date = DateTime.tryParse(dateStr);
        if (date == null) continue;

        days.add(ContributionDay(date: date, count: count, level: level));
      }

      // Sort chronologically just in case
      days.sort((a, b) => a.date.compareTo(b.date));

      // Compute total from days if not present in response
      if (total == 0 && days.isNotEmpty) {
        total = days.fold(0, (sum, d) => sum + d.count);
      }

      return (days, total);
    } catch (_) {
      return (<ContributionDay>[], 0);
    }
  }

  // ─────────────────────────────────────────────
  // MOCK DATA — shown when token is missing or
  // GraphQL call fails (e.g. during local dev
  // without --dart-define=GH_TOKEN)
  // ─────────────────────────────────────────────

  static List<ContributionDay> _generateMockContributions() {
    final days = <ContributionDay>[];
    final now  = DateTime.now();
    const pattern = [
      0, 0, 1, 2, 0, 3, 0, 1, 5, 2,
      0, 0, 7, 3, 1, 0, 4, 2, 8, 0,
    ];

    for (int i = 365; i >= 0; i--) {
      final date  = now.subtract(Duration(days: i));
      final base  = pattern[(i + date.weekday) % pattern.length];
      final noise = (i * 7 + date.day) % 5;
      final count = (base + (noise > 3 ? noise - 2 : 0)).clamp(0, 12);
      days.add(ContributionDay(
        date:  date,
        count: count,
        level: (count / 2).clamp(0, 5).toInt(),
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