/// Deepanshu Kaushik's Interactive Portfolio Application
///
/// A high-performance Flutter portfolio showcasing:
/// - Smooth theme switching with circular reveal transition
/// - Responsive design across mobile, tablet, and web platforms
/// - Optimized animations and transitions
/// - SEO-friendly web presence
///
/// Entry point configuration:
/// - Initializes theme color cache for instant color access
/// - Sets up Riverpod provider scope for state management
/// - Configures MaterialApp with theme and navigation
library portfolio;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/theme_extensions.dart';
import 'core/widgets/floating_nav_bar.dart';
import 'core/widgets/shared_widgets.dart';
import 'core/widgets/lamp_theme_switcher.dart';
import 'core/widgets/circular_reveal_transition.dart';
import 'core/widgets/cat_cursor_follower.dart';

// ── Screens ──────────────────────────────────────────────────
import 'features/home/presentation/screens/home_screen.dart';
import 'features/about/presentation/screens/about_screen.dart';
import 'features/projects/presentation/screens/projects_screen.dart';
import 'features/skills/presentation/screens/skills_screen.dart';
import 'features/contact/presentation/screens/contact_screen.dart';

/// Application entry point
/// 
/// Initializes:
/// - Theme color cache for optimal performance
/// - Riverpod provider scope
/// - Root MaterialApp widget
void main() {
  // Pre-compute and cache all theme colors for instant access during theme switching
  ThemeTransitionUtils.initializeColorCache();
  runApp(const ProviderScope(child: PortfolioApp()));
}

// ─────────────────────────────────────────────────────────────
// APP ROOT — Material App Configuration
// ─────────────────────────────────────────────────────────────

/// Root Material application widget
///
/// Responsibilities:
/// - Provides theme (light/dark mode support)
/// - Initializes navigation
/// - Watches theme state changes via Riverpod
/// 
/// SEO Note: Title and description are indexable by search engines
class PortfolioApp extends ConsumerWidget {
  /// Create a new PortfolioApp instance
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    // Sync app colors globally whenever theme changes
    ref.watch(themeSyncProvider);

    return MaterialApp(
      title: 'Deepanshu Kaushik — Flutter Developer & UI/UX Designer | Portfolio 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const _AppShell(),
    );
  }
}

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

class _AppShellState extends ConsumerState<_AppShell>
    with SingleTickerProviderStateMixin {
  int _idx = 0;

  // Lazily created and cached tabs.
  // Tab order MUST match FloatingNavBar._items exactly:
  //   0 Home | 1 About | 2 Projects | 3 Skills | 4 Contact
  late final List<Widget?> _screens = List<Widget?>.filled(5, null)
    ..[0] = const HomeScreen();

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const AboutScreen();
      case 2:
        return const ProjectsScreen();
      case 3:
        return const SkillsScreen();
      case 4:
        return const ContactScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  void _openTab(int index) {
    // Re-tap on active tab → scroll to top
    if (index == _idx) {
      _tryScrollToTop(index);
      return;
    }
    if (_screens[index] == null) {
      _screens[index] = _buildScreen(index);
    }
    setState(() {
      _idx = index;
    });
  }

  void _tryScrollToTop(int index) {
    // Find the primary scroll controller for the active screen
    try {
      final context = _screenKeys[index].currentContext;
      if (context == null) return;
      final scrollable = Scrollable.maybeOf(context);
      final controller = scrollable?.widget.controller ??
          PrimaryScrollController.maybeOf(context);
      if (controller != null && controller.hasClients) {
        controller.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    } catch (_) {}
  }

  // Keys to access screen contexts for scroll-to-top
  final List<GlobalKey> _screenKeys = List.generate(5, (_) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    ref.watch(themeSyncProvider); // Sync global AppColors state

    return CatCursorFollower(
      child: GridBackground(
        child: Scaffold(
          body: RepaintBoundary(
            child: Stack(
              children: [
                Column(
                  children: [
                    // ── Main Content Area ───────────────────────────
                    Expanded(
                      child: CircularRevealTransition(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onHorizontalDragEnd: (details) {
                                if (details.primaryVelocity == null) return;
                                if (details.primaryVelocity! < -500) {
                                  if (_idx < _screens.length - 1) _openTab(_idx + 1);
                                } else if (details.primaryVelocity! > 500) {
                                  if (_idx > 0) _openTab(_idx - 1);
                                }
                              },
                              child: Stack(
                                children: [
                                  for (int i = 0; i < _screens.length; i++)
                                    if (_screens[i] != null)
                                      Offstage(
                                        offstage: _idx != i,
                                        child: TickerMode(
                                          enabled: _idx == i,
                                          child: RepaintBoundary(
                                            child: AnimatedScale(
                                              scale: _idx == i ? 1.0 : 0.98,
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.easeOutCubic,
                                              child: AnimatedOpacity(
                                                key: _screenKeys[i],
                                                opacity: _idx == i ? 1.0 : 0.0,
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeOutCubic,
                                                child: AnimatedSlide(
                                                  offset: _idx == i
                                                      ? Offset.zero
                                                      : const Offset(0, 0.02),
                                                  duration: const Duration(milliseconds: 300),
                                                  curve: Curves.easeOutCubic,
                                                  child: _screens[i]!,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),

                            // ── Floating Nav Bar ───────────────────────────
                            Positioned(
                              bottom: 24,
                              left: 0,
                              right: 0,
                              child: RepaintBoundary(
                                child: FloatingNavBar(
                                  currentIndex: _idx,
                                  onTap: _openTab,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Footer ──────────────────────────────────────
                    PortfolioFooter(
                      onToggleTheme: () =>
                          ref.read(themeModeProvider.notifier).toggle(),
                    ),
                  ],
                ),
                // ── Standalone Lamp ───────────────────────────
                const Positioned(
                  top: 0,
                  right: 20,
                  child: LampThemeSwitcher(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
