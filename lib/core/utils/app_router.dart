import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/about/presentation/screens/about_screen.dart';
import '../../features/projects/presentation/screens/projects_screen.dart';
import '../../features/github/presentation/screens/github_screen.dart';
import '../../features/blog/presentation/screens/blog_list_screen.dart';
import '../../features/blog/presentation/screens/blog_detail_screen.dart';
import '../../features/skills/presentation/screens/skills_screen.dart';
import '../../features/contact/presentation/screens/contact_screen.dart';
import '../widgets/scaffold_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          ScaffoldShell(child: child, currentPath: state.uri.path),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
        GoRoute(path: '/projects', builder: (_, __) => const ProjectsScreen()),
        GoRoute(path: '/github', builder: (_, __) => const GitHubScreen()),
        GoRoute(path: '/blog', builder: (_, __) => const BlogScreen()),
        GoRoute(
          path: '/blog/:slug',
          builder: (_, state) =>
              BlogDetailScreen(slug: state.pathParameters['slug']!),
        ),
        GoRoute(path: '/skills', builder: (_, __) => const SkillsScreen()),
        GoRoute(path: '/contact', builder: (_, __) => const ContactScreen()),
      ],
    ),
  ],
);
