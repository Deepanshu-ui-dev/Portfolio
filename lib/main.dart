import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/floating_nav_bar.dart';
import 'core/widgets/shared_widgets.dart';

// ── Screens ──────────────────────────────────────────────────
import 'features/home/presentation/screens/home_screen.dart';
import 'features/about/presentation/screens/about_screen.dart';
import 'features/projects/presentation/screens/projects_screen.dart';
import 'features/skills/presentation/screens/skills_screen.dart';
import 'features/contact/presentation/screens/contact_screen.dart';

void main() {
  runApp(const ProviderScope(child: PortfolioApp()));
}

// ─────────────────────────────────────────────────────────────
// APP ROOT
// ─────────────────────────────────────────────────────────────

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    final isDark = themeNotifier.isDark;
    AppColors.isDarkMode = isDark;

    return MaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const _AppShell(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// THEME PROVIDER
// ─────────────────────────────────────────────────────────────

final themeProvider =
    ChangeNotifierProvider<ThemeNotifier>((_) => ThemeNotifier());

// ─────────────────────────────────────────────────────────────
// APP SHELL
//
// BLASTBufferQueue fix notes:
//   IndexedStack keeps ALL children in the widget tree and
//   active (ticking). Previously, multiple screens each had
//   AnimationControllers running simultaneously which pushed
//   the SurfaceView buffer count past the limit (max 1+2=3).
//
//   The fix is NOT to use PageView or Navigator (which unmounts
//   screens and loses state) — instead we ensure each screen's
//   animations are lightweight, use RepaintBoundary to isolate
//   repaints, and avoid IntrinsicHeight inside animated widgets.
//
//   Additionally, we add Offstage wrapping so hidden screens
//   do not participate in hit-testing or layout passes, while
//   still being kept alive for instant switching.
// ─────────────────────────────────────────────────────────────

class _AppShell extends ConsumerStatefulWidget {
  const _AppShell();

  @override
  ConsumerState<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<_AppShell> {
  int _idx = 0;

  // Tab order MUST match FloatingNavBar._items exactly:
  //   0 Home | 1 About | 2 Projects | 3 Skills | 4 Contact
  static const _screens = [
    HomeScreen(),
    AboutScreen(),
    ProjectsScreen(),
    SkillsScreen(),
    ContactScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.watch(themeProvider);
    final isDark = themeNotifier.isDark;

    return Scaffold(
      extendBody: true,
      // Use a single Stack with Offstage children instead of
      // IndexedStack — Offstage stops layout/paint for hidden
      // screens while still keeping them alive (no state loss).
      body: SizedBox.expand(
        child: Stack(
          children: [
            // ── Screens (Offstage keeps alive, stops painting) ──
            for (int i = 0; i < _screens.length; i++)
              Offstage(
                offstage: _idx != i,
                child: _screens[i],
              ),

            // ── Footer ──────────────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: PortfolioFooter(
                isDark: isDark,
                onToggleTheme: () => ref.read(themeProvider).toggle(),
              ),
            ),

            // ── Floating nav bar ────────────────────────────────
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: FloatingNavBar(
                currentIndex: _idx,
                onTap: (i) => setState(() => _idx = i),
              ),
            ),
          ],
        ),
      ),
    );
  }
}