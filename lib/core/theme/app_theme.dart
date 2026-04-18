import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────

class AppColors {
  // ── Dark theme ─────────────────────────────────────────
  static const Color bgDark          = Color(0xFF0A0A0C); // Zinc-950
  static const Color surfaceDark     = Color(0xFF111113); // Warmer lift
  static const Color surfaceElevDark = Color(0xFF1A1A1E); // Clean step above surface
  static const Color surfacePopDark  = Color(0xFF222226); // Popovers/dropdowns
  static const Color borderDark      = Color(0xFF27272A); // Zinc-800
  static const Color border2Dark     = Color(0xFF3F3F46); // Zinc-700 — emphasis borders
  static const Color borderFocusDark = Color(0xFF71717A); // Zinc-500 — focus rings
  static const Color textPrimaryDark = Color(0xFFF5F5F5); // Zinc-100
  static const Color textSecDark     = Color(0xFF9E9EA8); // Zinc-400
  static const Color textTerDark     = Color(0xFF6E6E78); // Zinc-500
  static const Color textMutedDark   = Color(0xFF505058); // Zinc-600
  static const Color textDisabledDark= Color(0xFF3C3C44); // Zinc-700
  static const Color accentDark      = Color(0xFF0FE5A8); // Cyan-Emerald — designer accent
  static const Color accentHoverDark = Color(0xFF38F0C0); // Brighter hover
  static const Color accentSubtleDark= Color(0xFF053D2E); // Deep tinted bg
  static const Color accentMutedDark = Color(0xFF065F46); // Hover tint
  static const Color accentTextDark  = Color(0xFFD1FAE5); // Highlighted body text
  static const Color errorDark       = Color(0xFFF87171); // Red-400
  static const Color errorSubtleDark = Color(0xFF450A0A); // Red-950
  static const Color warningDark     = Color(0xFFFBBF24); // Amber-400
  static const Color successDark     = Color(0xFF34D399); // Emerald-400

  // ── Light theme ────────────────────────────────────────
  // Warm bone-white family. Every surface step is clearly distinct.
  // Text steps all pass WCAG AA on their respective backgrounds.
  static const Color bgLight          = Color(0xFFFBFBF9); // Warm bone white
  static const Color surfaceLight     = Color(0xFFF5F5F2); // Cream — cleaner separation
  static const Color surfaceElevLight = Color(0xFFECECE9); // Linen
  static const Color surfacePopLight  = Color(0xFFFFFFFF); // Pure white — popovers pop
  static const Color borderLight      = Color(0xFFDADAD6); // Stone-300 — visible, not harsh
  static const Color border2Light     = Color(0xFFC4C4BF); // Stone-400 — emphasis
  static const Color borderFocusLight = Color(0xFF3F3F46); // Zinc-700 — focus rings
  static const Color textPrimaryLight = Color(0xFF0C0C0E); // Near-black — warmer
  static const Color textSecLight     = Color(0xFF44444C); // Zinc-700 — better contrast ✓ AA
  static const Color textTerLight     = Color(0xFF6E6E78); // Zinc-500 — 4.8:1 ✓ AA
  static const Color textMutedLight   = Color(0xFF9E9EA8); // Zinc-400 — decorative only
  static const Color textDisabledLight= Color(0xFFC0C0BC); // Stone-400
  static const Color accentLight      = Color(0xFF036B4C); // Deeper emerald — AAA contrast
  static const Color accentHoverLight = Color(0xFF024D37); // Darker hover
  static const Color accentSubtleLight= Color(0xFFD1FAE5); // Emerald-100 — tinted bg
  static const Color accentMutedLight = Color(0xFFA7F3D0); // Emerald-200 — hover tint
  static const Color accentTextLight  = Color(0xFF014D38); // Highlighted body text
  static const Color errorLight       = Color(0xFFDC2626); // Red-600
  static const Color errorSubtleLight = Color(0xFFFEF2F2); // Red-50
  static const Color warningLight     = Color(0xFFD97706); // Amber-600
  static const Color successLight     = Color(0xFF047857); // Emerald-700

  // ── Contribution heatmap — Dark ────────────────────────
  // 6 levels. Each step is visually distinct. Uses accent ramp.
  static const Color contrib0Dark = Color(0xFF1C1C1F); // surfaceElev — empty cell
  static const Color contrib1Dark = Color(0xFF064E3B); // Emerald-900
  static const Color contrib2Dark = Color(0xFF065F46); // Emerald-800
  static const Color contrib3Dark = Color(0xFF059669); // Emerald-600
  static const Color contrib4Dark = Color(0xFF0FE5A8); // Cyan-Emerald
  static const Color contrib5Dark = Color(0xFF38F0C0); // Peak — matches accent

  // ── Contribution heatmap — Light ───────────────────────
  // Inverted: empty = light gray, peak = very dark green.
  // Every step distinguishable at a glance.
  static const Color contrib0Light = Color(0xFFEAEAE7); // surfaceElev — empty cell
  static const Color contrib1Light = Color(0xFFA7F3D0); // Emerald-200
  static const Color contrib2Light = Color(0xFF34D399); // Emerald-400
  static const Color contrib3Light = Color(0xFF059669); // Emerald-600
  static const Color contrib4Light = Color(0xFF065F46); // Emerald-800
  static const Color contrib5Light = Color(0xFF022C22); // Emerald-950 — peak

  // ── Theme flag ────────────────────────────────────────
  static bool isDarkMode = true;

  // ── Dynamic accessors — surfaces ──────────────────────
  static Color get bg             => isDarkMode ? bgDark             : bgLight;
  static Color get background     => bg;
  static Color get surface        => isDarkMode ? surfaceDark        : surfaceLight;
  static Color get surfaceElev    => isDarkMode ? surfaceElevDark    : surfaceElevLight;
  static Color get surfacePop     => isDarkMode ? surfacePopDark     : surfacePopLight;
  static Color get border         => isDarkMode ? borderDark         : borderLight;
  static Color get surfaceBorder  => border;
  static Color get border2        => isDarkMode ? border2Dark        : border2Light;
  static Color get borderFocus    => isDarkMode ? borderFocusDark    : borderFocusLight;

  // ── Dynamic accessors — text ──────────────────────────
  static Color get textPrimary    => isDarkMode ? textPrimaryDark    : textPrimaryLight;
  static Color get textSecondary  => isDarkMode ? textSecDark        : textSecLight;
  static Color get textTertiary   => isDarkMode ? textTerDark        : textTerLight;
  static Color get textTer        => textTertiary;
  static Color get textMuted      => isDarkMode ? textMutedDark      : textMutedLight;
  static Color get textDisabled   => isDarkMode ? textDisabledDark   : textDisabledLight;

  // ── Dynamic accessors — accent ────────────────────────
  static Color get accent         => isDarkMode ? accentDark         : accentLight;
  static Color get accentHover    => isDarkMode ? accentHoverDark    : accentHoverLight;
  static Color get accentSubtle   => isDarkMode ? accentSubtleDark   : accentSubtleLight;
  static Color get accentMuted    => isDarkMode ? accentMutedDark    : accentMutedLight;
  static Color get accentText     => isDarkMode ? accentTextDark     : accentTextLight;

  // ── Dynamic accessors — semantic ──────────────────────
  static Color get error          => isDarkMode ? errorDark          : errorLight;
  static Color get errorSubtle    => isDarkMode ? errorSubtleDark    : errorSubtleLight;
  static Color get warning        => isDarkMode ? warningDark        : warningLight;
  static Color get success        => isDarkMode ? successDark        : successLight;

  // ── Dynamic accessors — heatmap ───────────────────────
  static Color get contrib0       => isDarkMode ? contrib0Dark       : contrib0Light;
  static Color get contrib1       => isDarkMode ? contrib1Dark       : contrib1Light;
  static Color get contrib2       => isDarkMode ? contrib2Dark       : contrib2Light;
  static Color get contrib3       => isDarkMode ? contrib3Dark       : contrib3Light;
  static Color get contrib4       => isDarkMode ? contrib4Dark       : contrib4Light;
  static Color get contrib5       => isDarkMode ? contrib5Dark       : contrib5Light;

  // ── Heatmap helper ────────────────────────────────────
  // Pass a 0–5 integer (or normalized 0.0–1.0 * 5) to get the right cell color.
  static Color contribForLevel(int level) {
    switch (level.clamp(0, 5)) {
      case 0: return contrib0;
      case 1: return contrib1;
      case 2: return contrib2;
      case 3: return contrib3;
      case 4: return contrib4;
      default: return contrib5;
    }
  }

  // ── Grid dot ─────────────────────────────────────────
  // Not used in GridBackground anymore (painter uses hard-coded
  // surfaceElev/border2 tokens directly), but kept for custom use.
  static Color get gridDotColor => isDarkMode
      ? Colors.white.withValues(alpha: 0.04)
      : Colors.black.withValues(alpha: 0.04);
}

// ─────────────────────────────────────────────
// SPACING
// ─────────────────────────────────────────────

class AppSpacing {
  static const double mobileMax      = 650;
  static const double tabletMax      = 1100;

  static const double xs             = 4;
  static const double sm             = 8;
  static const double md             = 12;
  static const double base           = 16;
  static const double lg             = 20;
  static const double xl             = 28;
  static const double xxl            = 40;
  static const double xxxl           = 56;
  static const double section        = 72;
  static const double maxContentWidth= 1080;

  // ── Breakpoint helpers ───────────────────────────────
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= mobileMax && w < tabletMax;
  }

  static bool isLaptop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletMax;

  // ── Responsive horizontal padding ────────────────────
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1400)    return (w - maxContentWidth) / 2;
    if (w >= tabletMax) return 64;
    if (w >= 900)     return 48;
    if (w >= mobileMax) return 32;
    if (w >= 390)     return 24;
    if (w >= 350)     return 20;
    return 16;
  }

  // ── Responsive headline font size ────────────────────
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
// RADIUS
// ─────────────────────────────────────────────

class AppRadius {
  static const double none   = 0;
  static const double xs     = 2;
  static const double sm     = 4;
  static const double md     = 6;
  static const double lg     = 8;
  static const double xl     = 12;
  static const double xxl    = 20;
  static const double pill   = 999;

  static const BorderRadius zero    = BorderRadius.zero;
  static const BorderRadius card    = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius dialog  = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chip    = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius nav     = BorderRadius.all(Radius.circular(xxl));
}

// ─────────────────────────────────────────────
// THEME DATA
// ─────────────────────────────────────────────

class AppTheme {
  static ThemeData dark()  => _build(isDark: true);
  static ThemeData light() => _build(isDark: false);

  static ThemeData _build({required bool isDark}) {
    const mono = 'JetBrainsMono';

    final bg          = isDark ? AppColors.bgDark          : AppColors.bgLight;
    final surface     = isDark ? AppColors.surfaceDark     : AppColors.surfaceLight;
    final surfaceElev = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final border      = isDark ? AppColors.borderDark      : AppColors.borderLight;
    final border2     = isDark ? AppColors.border2Dark     : AppColors.border2Light;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSec     = isDark ? AppColors.textSecDark     : AppColors.textSecLight;
    final textTer     = isDark ? AppColors.textTerDark     : AppColors.textTerLight;
    final textMuted   = isDark ? AppColors.textMutedDark   : AppColors.textMutedLight;
    final accent      = isDark ? AppColors.accentDark      : AppColors.accentLight;
    final error       = isDark ? AppColors.errorDark       : AppColors.errorLight;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ).copyWith(
      primary:          accent,
      onPrimary:        isDark ? Colors.black : Colors.white,
      secondary:        accent,
      onSecondary:      isDark ? Colors.black : Colors.white,
      surface:          surface,
      onSurface:        textPrimary,
      surfaceContainer: surfaceElev,
      outline:          border,
      outlineVariant:   border2,
      tertiary:         textTer,
      onTertiary:       bg,
      error:            error,
      onError:          isDark ? Colors.black : Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness:               isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor:  Colors.transparent,
      splashFactory:            NoSplash.splashFactory,
      highlightColor:           Colors.transparent,
      colorScheme:              colorScheme,
      fontFamily:               mono,

      // ── Text theme ──────────────────────────────────
      textTheme: TextTheme(
        // Hero / page name
        displayLarge: TextStyle(
          fontFamily: mono, 
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: textPrimary, letterSpacing: -1.8, height: 1.06,
        ),
        // Sub-hero / tagline
        displayMedium: TextStyle(
          fontFamily: mono, fontSize: 24, fontWeight: FontWeight.w700,
          color: textPrimary, letterSpacing: -1.0, height: 1.1,
        ),
        // Section headings
        displaySmall: TextStyle(
          fontFamily: mono, fontSize: 20, fontWeight: FontWeight.w700,
          color: textPrimary, letterSpacing: -0.8, height: 1.2,
        ),
        // Card / entry titles
        headlineLarge: TextStyle(
          fontFamily: mono, fontSize: 14, fontWeight: FontWeight.w600,
          color: textPrimary, letterSpacing: -0.6, height: 1.4,
        ),
        headlineMedium: TextStyle(
          fontFamily: mono, fontSize: 12, fontWeight: FontWeight.w600,
          color: textPrimary, letterSpacing: -0.1, height: 1.4,
        ),
        headlineSmall: TextStyle(
          fontFamily: mono, fontSize: 11, fontWeight: FontWeight.w600,
          color: textPrimary, letterSpacing: 0, height: 1.4,
        ),
        // Body
        bodyLarge: TextStyle(
          fontFamily: mono, fontSize: 14, fontWeight: FontWeight.w400,
          color: textPrimary, height: 1.8,
        ),
        bodyMedium: TextStyle(
          fontFamily: mono, fontSize: 13, fontWeight: FontWeight.w400,
          color: textSec, height: 1.8,
        ),
        bodySmall: TextStyle(
          fontFamily: mono, fontSize: 11.5, fontWeight: FontWeight.w400,
          color: textSec, height: 1.7,
        ),
        // Labels / tags / captions
        labelLarge: TextStyle(
          fontFamily: mono, fontSize: 11, fontWeight: FontWeight.w500,
          color: textPrimary, letterSpacing: 1.5,
        ),
        labelMedium: TextStyle(
          fontFamily: mono, fontSize: 10, fontWeight: FontWeight.w400,
          color: textSec, letterSpacing: 0.8,
        ),
        labelSmall: TextStyle(
          fontFamily: mono, fontSize: 9, fontWeight: FontWeight.w400,
          color: textMuted, letterSpacing: 1.0,
        ),
      ),

      // ── Inputs ──────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hoverColor: surfaceElev,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppRadius.zero,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.zero,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.zero,
          borderSide: BorderSide(
            color: isDark ? AppColors.borderFocusDark : AppColors.borderFocusLight,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.zero,
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.zero,
          borderSide: BorderSide(color: error, width: 1.5),
        ),
        hintStyle: TextStyle(
          fontFamily: mono, fontSize: 12,
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
        ),
        labelStyle: TextStyle(fontFamily: mono, fontSize: 11, color: textTer),
        floatingLabelStyle: TextStyle(fontFamily: mono, fontSize: 10, color: accent),
      ),

      // ── Cards ───────────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.zero),
        margin: EdgeInsets.zero,
      ),

      // ── Dialogs ─────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.surfacePopDark : AppColors.surfacePopLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.zero),
      ),

      // ── Bottom sheet ─────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? AppColors.surfacePopDark : AppColors.surfacePopLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.zero),
      ),

      // ── Dividers ─────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      // ── Scrollbar ────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(border2),
        thickness: WidgetStateProperty.all(3),
        radius: Radius.zero,
        interactive: true,
      ),

      // ── Tooltip ──────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: surfaceElev,
          border: Border.all(color: border),
        ),
        textStyle: TextStyle(fontFamily: mono, fontSize: 10, color: textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        waitDuration: const Duration(milliseconds: 200),
        showDuration: const Duration(seconds: 3),
      ),

      // ── Chips ────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: isDark ? AppColors.accentSubtleDark : AppColors.accentSubtleLight,
        disabledColor: surfaceElev,
        labelStyle: TextStyle(fontFamily: mono, fontSize: 10, color: textSec),
        side: BorderSide(color: border),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.zero),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // ── List tiles ───────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: isDark ? AppColors.accentSubtleDark : AppColors.accentSubtleLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: TextStyle(fontFamily: mono, fontSize: 13, color: textPrimary),
        subtitleTextStyle: TextStyle(fontFamily: mono, fontSize: 11, color: textSec),
      ),

      // ── Switch ───────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? accent : border2),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? (isDark ? AppColors.accentSubtleDark : AppColors.accentSubtleLight)
                : surfaceElev),
        trackOutlineColor: WidgetStateProperty.all(border),
      ),

      // ── Progress indicator ───────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: isDark ? AppColors.accentSubtleDark : AppColors.accentSubtleLight,
        circularTrackColor: Colors.transparent,
      ),

      // ── AppBar ───────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: mono, fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textSec, size: 18),
        actionsIconTheme: IconThemeData(color: textSec, size: 18),
      ),

      // ── Icon ─────────────────────────────────────────
      iconTheme: IconThemeData(color: textSec, size: 18),
      primaryIconTheme: IconThemeData(color: accent, size: 18),
    );
  }
}