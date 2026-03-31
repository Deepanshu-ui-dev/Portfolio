import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────

class AppColors {
  // ── Dark theme ────────────────────────────
  static const Color bgDark           = Color(0xFF0C0C0C); // near-black body
  static const Color surfaceDark      = Color(0xFF111111); // card bg
  static const Color surfaceElevDark  = Color(0xFF181818); // hover / elevated
  static const Color borderDark       = Color(0xFF222222); // default border
  static const Color border2Dark      = Color(0xFF333333); // hover border
  static const Color textPrimaryDark  = Color(0xFFEEEEEE); // primary text
  static const Color textSecDark      = Color(0xFF5A5A5A); // muted labels
  static const Color textTerDark      = Color(0xFF3E3E3E); // very muted
  static const Color textMutedDark    = Color(0xFF383838);
  static const Color accentDark       = Color(0xFF5FBF8F); // green accent

  // ── Light theme ───────────────────────────
  static const Color bgLight          = Color(0xFFF5F5F2);
  static const Color surfaceLight     = Color(0xFFEEEEEB);
  static const Color surfaceElevLight = Color(0xFFE5E5E2);
  static const Color borderLight      = Color(0xFFD8D8D4);
  static const Color border2Light     = Color(0xFFC6C6C2);
  static const Color textPrimaryLight = Color(0xFF0F0F0F);
  static const Color textSecLight     = Color(0xFF888888);
  static const Color textTerLight     = Color(0xFFAAAAAA);
  static const Color textMutedLight   = Color(0xFFC4C4C0);
  static const Color accentLight      = Color(0xFF1D9E75);

  // ── Contribution graph ────────────────────
  static const Color contrib0Dark = Color(0xFF161616);
  static const Color contrib1Dark = Color(0xFF1B3828);
  static const Color contrib2Dark = Color(0xFF24613F);
  static const Color contrib3Dark = Color(0xFF2D9B5F);
  static const Color contrib4Dark = Color(0xFF5FBF8F);

  static const Color contrib0Light = Color(0xFFE4E4E0);
  static const Color contrib1Light = Color(0xFFB2D9C4);
  static const Color contrib2Light = Color(0xFF79C4A2);
  static const Color contrib3Light = Color(0xFF40AE80);
  static const Color contrib4Light = Color(0xFF1D9E75);

  // ── Static theme flag (set by ThemeNotifier) ──
  static bool isDarkMode = true;

  // ── Dynamic accessors ──────────────────────
  static Color get bg           => isDarkMode ? bgDark           : bgLight;
  static Color get background   => bg;
  static Color get surface      => isDarkMode ? surfaceDark      : surfaceLight;
  static Color get surfaceElev  => isDarkMode ? surfaceElevDark  : surfaceElevLight;
  static Color get border       => isDarkMode ? borderDark       : borderLight;
  static Color get surfaceBorder=> border;
  static Color get border2      => isDarkMode ? border2Dark      : border2Light;
  static Color get textPrimary  => isDarkMode ? textPrimaryDark  : textPrimaryLight;
  static Color get textSecondary=> isDarkMode ? textSecDark      : textSecLight;
  static Color get textTertiary => isDarkMode ? textTerDark      : textTerLight;
  static Color get textTer      => isDarkMode ? textTerDark      : textTerLight;
  static Color get textMuted    => isDarkMode ? textMutedDark    : textMutedLight;
  static Color get accent       => isDarkMode ? accentDark       : accentLight;

  static Color get contrib0 => isDarkMode ? contrib0Dark : contrib0Light;
  static Color get contrib1 => isDarkMode ? contrib1Dark : contrib1Light;
  static Color get contrib2 => isDarkMode ? contrib2Dark : contrib2Light;
  static Color get contrib3 => isDarkMode ? contrib3Dark : contrib3Light;
  static Color get contrib4 => isDarkMode ? contrib4Dark : contrib4Light;
}

// ─────────────────────────────────────────────
// THEME NOTIFIER
// ─────────────────────────────────────────────

class ThemeNotifier extends ChangeNotifier {
  bool _isDark = true;
  bool get isDark => _isDark;

  void toggle() {
    _isDark = !_isDark;
    AppColors.isDarkMode = _isDark;
    notifyListeners();
  }
}

// ─────────────────────────────────────────────
// SPACING
// ─────────────────────────────────────────────

class AppSpacing {
  static const double mobileMax = 650;
  static const double tabletMax = 1100;

  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double base = 16;
  static const double lg   = 20;
  static const double xl   = 28;
  static const double xxl  = 40;
  static const double xxxl = 56;
  static const double section = 80;
  static const double maxContentWidth = 1080;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= mobileMax && w < tabletMax;
  }

  static bool isLaptop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletMax;

  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    if (w >= 1400) {
      return (w - maxContentWidth) / 2;
    }
    if (w >= tabletMax) return 64;
    if (w >= 900) return 48;
    if (w >= mobileMax) return 32;
    if (w >= 390) return 20;
    return 14;
  }

  static double headlineSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double laptop,
  }) {
    if (isLaptop(context)) return laptop;
    if (isTablet(context)) return tablet;
    return mobile;
  }
}

// ─────────────────────────────────────────────
// THEME DATA
// ─────────────────────────────────────────────

class AppTheme {
  static ThemeData dark()  => _build(isDark: true);
  static ThemeData light() => _build(isDark: false);

  static ThemeData _build({required bool isDark}) {
    // Reference uses a proper monospace — JetBrains Mono preferred,
    // falling back to the system monospace.
    const mono = 'JetBrainsMono';

    final bg          = isDark ? AppColors.bgDark          : AppColors.bgLight;
    final surface     = isDark ? AppColors.surfaceDark      : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark  : AppColors.textPrimaryLight;
    final textSec     = isDark ? AppColors.textSecDark      : AppColors.textSecLight;
    final accent      = isDark ? AppColors.accentDark       : AppColors.accentLight;

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: bg,

      // No Material ripple splashes — keep it flat
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,

      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary:    textPrimary,
        onPrimary:  bg,
        secondary:  accent,
        onSecondary: bg,
        surface:    surface,
        onSurface:  textPrimary,
        error:      Colors.redAccent,
        onError:    Colors.white,
      ),

      fontFamily: mono,

      textTheme: TextTheme(
        // ── Hero / page name ──────────────────
        displayLarge: TextStyle(
          fontFamily: mono,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
          height: 1.1,
        ),

        // ── Section headings ──────────────────
        displayMedium: TextStyle(
          fontFamily: mono,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.3,
          height: 1.2,
        ),

        // ── Card / entry titles ───────────────
        headlineLarge: TextStyle(
          fontFamily: mono,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0,
          height: 1.3,
        ),

        headlineMedium: TextStyle(
          fontFamily: mono,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          height: 1.3,
        ),

        // ── Body text ─────────────────────────
        bodyLarge: TextStyle(
          fontFamily: mono,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.75,
        ),

        bodyMedium: TextStyle(
          fontFamily: mono,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSec,
          height: 1.75,
        ),

        bodySmall: TextStyle(
          fontFamily: mono,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: textSec,
          height: 1.6,
        ),

        // ── Labels / tags / captions ──────────
        labelLarge: TextStyle(
          fontFamily: mono,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: 1.2,
        ),

        labelMedium: TextStyle(
          fontFamily: mono,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: textSec,
          letterSpacing: 0.4,
        ),

        labelSmall: TextStyle(
          fontFamily: mono,
          fontSize: 9,
          fontWeight: FontWeight.w400,
          color: textSec,
          letterSpacing: 0.3,
        ),
      ),

      // ── Input / button defaults ─────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: textPrimary, width: 1),
        ),
      ),

      // Flat, sharp-edged cards
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        margin: EdgeInsets.zero,
      ),

      // Sharp-edged dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),

      // Invisible dividers (handled manually)
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.borderDark : AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      // Scrollbar
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
            isDark ? AppColors.border2Dark : AppColors.border2Light),
        thickness: WidgetStateProperty.all(3),
        radius: Radius.zero,
      ),

      // Tooltip — flat monospace
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight,
          border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        textStyle: TextStyle(
          fontFamily: mono,
          fontSize: 10,
          color: textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        waitDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}