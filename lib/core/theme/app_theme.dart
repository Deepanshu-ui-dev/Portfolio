import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// COLORS
// Design language: "Obsidian & Citron"
//
// Dark  → True-black obsidian base. Zero blue tint. Warm stone text.
//          Citron yellow-green accent — electric but not gaudy.
// Light → Antique parchment base. Warm cream surfaces.
//          Deep forest-ink accent — ink-on-paper editorial feel.
//
// Palette philosophy:
//  • Every shade is hand-tuned — no algorithmic generation.
//  • Surfaces step by exactly +8 lightness (perceptual) per elevation level.
//  • Text ramp: 4 stops, each ~40% of previous opacity — clean hierarchy.
//  • Accent is never diluted — it appears only where it matters.
//  • Semantic colors (error/warning/success) are warm-shifted to match the
//    overall temperature, avoiding jarring cold-blue-adjacent hues.
// ─────────────────────────────────────────────────────────────────────────────

class AppColors {
  // ════════════════════════════════════════════════════════════════
  // DARK THEME — Obsidian + Citron
  // ════════════════════════════════════════════════════════════════

  // Backgrounds — true warm black, stepping up in +6-7L increments
  static const Color bgDark           = Color(0xFF080807); // True obsidian
  static const Color surfaceDark      = Color(0xFF111110); // First step up
  static const Color surfaceElevDark  = Color(0xFF222220); // Raised card — boosted
  static const Color surfacePopDark   = Color(0xFF2A2A27); // Popover/sheet
  static const Color surfaceHoverDark = Color(0xFF323230); // Hover state — boosted

  // Borders — warm, never blue-gray
  static const Color borderDark       = Color(0xFF282825); // Default separator
  static const Color border2Dark      = Color(0xFF383835); // Emphasis
  static const Color borderFocusDark  = Color(0xFF706E66); // Focus ring

  // Text — warm stone ramp, 4-stop hierarchy
  static const Color textPrimaryDark  = Color(0xFFF0EDE6); // Near-white ivory
  static const Color textSecDark      = Color(0xFFB0AEA0); // Boosted for readability
  static const Color textTerDark      = Color(0xFF7A7870); // Boosted for readability
  static const Color textMutedDark    = Color(0xFF504E48); // Boosted for readability
  static const Color textDisabledDark = Color(0xFF2D2B26); // Disabled

  // Accent — Citron (yellow-green, 550nm territory)
  // Named for its specificity: not lime, not yellow, but the exact
  // shade of a Meyer lemon rind under warm light.
  static const Color accentDark       = Color(0xFFBEE33A); // Citron core
  static const Color accentDimDark    = Color(0xFF9AB82E); // Pressed / active
  static const Color accentGlowDark   = Color(0xFFD4F055); // Hover highlight
  static const Color accentSubtleDark = Color(0xFF1A2500); // Accent-tinted bg
  static const Color accentTintDark   = Color(0xFF243300); // Accent hover bg
  static const Color accentInkDark    = Color(0xFFE8F7A8); // Text on accent bg

  // Semantic — warm-shifted to match temperature
  static const Color errorDark        = Color(0xFFFF6B6B); // Warm coral red
  static const Color errorSubtleDark  = Color(0xFF2C0A0A); // Red-tinted bg
  static const Color warningDark      = Color(0xFFFFAA33); // Warm amber
  static const Color warnSubtleDark   = Color(0xFF2A1800); // Amber-tinted bg
  static const Color successDark      = Color(0xFF4ECC8A); // Mint green
  static const Color successSubtleDark= Color(0xFF042215); // Green-tinted bg
  static const Color infoDark         = Color(0xFF60B8E8); // Sky, desaturated
  static const Color infoSubtleDark   = Color(0xFF041A28); // Blue-tinted bg

  // ════════════════════════════════════════════════════════════════
  // LIGHT THEME — Parchment + Forest Ink
  // ════════════════════════════════════════════════════════════════

  // Backgrounds — antique parchment, warm cream
  static const Color bgLight          = Color(0xFFF5F2EB); // Parchment base
  static const Color surfaceLight     = Color(0xFFEEEBE2); // Vellum
  static const Color surfaceElevLight = Color(0xFFE5E2D8); // Linen card
  static const Color surfacePopLight  = Color(0xFFFBF9F4); // Bright cream popover
  static const Color surfaceHoverLight= Color(0xFFDDDAD0); // Hover

  // Borders — warm tan, zero cool-gray contamination
  static const Color borderLight      = Color(0xFFD5D2C6); // Warm separator
  static const Color border2Light     = Color(0xFFBCB9AC); // Emphasis
  static const Color borderFocusLight = Color(0xFF1E1E1A); // Near-black focus

  // Text — dark ink ramp, warm-shifted
  static const Color textPrimaryLight = Color(0xFF0C0C0A); // Near-black ink
  static const Color textSecLight     = Color(0xFF3A3936); // Dark warm gray
  static const Color textTerLight     = Color(0xFF6E6C64); // Medium stone
  static const Color textMutedLight   = Color(0xFF9E9C94); // Faded stone
  static const Color textDisabledLight= Color(0xFFBCBAB2); // Disabled

  // Accent — Forest Ink (deep botanical green)
  // The same visual weight as a fountain-pen mark on cream paper.
  static const Color accentLight      = Color(0xFF2E5E00); // Forest ink
  static const Color accentDimLight   = Color(0xFF224600); // Pressed
  static const Color accentGlowLight  = Color(0xFF3E7800); // Hover
  static const Color accentSubtleLight= Color(0xFFDFF0B8); // Accent-tinted bg
  static const Color accentTintLight  = Color(0xFFCCE89E); // Accent hover bg
  static const Color accentInkLight   = Color(0xFF1A3800); // Text on accent bg

  // Semantic
  static const Color errorLight       = Color(0xFFB81C1C); // Deep warm red
  static const Color errorSubtleLight = Color(0xFFFFF0F0); // Red-50
  static const Color warningLight     = Color(0xFF924800); // Burnt sienna
  static const Color warnSubtleLight  = Color(0xFFFFF4E0); // Amber-50
  static const Color successLight     = Color(0xFF1E6B3C); // Forest green
  static const Color successSubtleLight=Color(0xFFEAF7EE); // Green-50
  static const Color infoLight        = Color(0xFF1A5E8C); // Ink blue
  static const Color infoSubtleLight  = Color(0xFFEBF4FC); // Blue-50

  // ════════════════════════════════════════════════════════════════
  // CONTRIBUTION HEATMAP
  // ════════════════════════════════════════════════════════════════

  // Dark — Citron ramp (5 steps, perceptually even)
  static const Color contrib0Dark     = Color(0xFF181816); // Empty — warm void
  static const Color contrib1Dark     = Color(0xFF1C2A00); // Faint sprout
  static const Color contrib2Dark     = Color(0xFF304600); // Low growth
  static const Color contrib3Dark     = Color(0xFF527800); // Mid growth
  static const Color contrib4Dark     = Color(0xFF8AB800); // Strong
  static const Color contrib5Dark     = Color(0xFFBEE33A); // Peak — accent

  // Light — Forest ramp
  static const Color contrib0Light    = Color(0xFFE2DFD6); // Empty
  static const Color contrib1Light    = Color(0xFFCCE898); // Faint
  static const Color contrib2Light    = Color(0xFF9DC84A); // Low
  static const Color contrib3Light    = Color(0xFF6A9E18); // Mid
  static const Color contrib4Light    = Color(0xFF427800); // Strong
  static const Color contrib5Light    = Color(0xFF2E5E00); // Peak — accent

  // ════════════════════════════════════════════════════════════════
  // THEME FLAG & DYNAMIC ACCESSORS
  // ════════════════════════════════════════════════════════════════

  static bool isDarkMode = true;

  // Surfaces
  static Color get bg             => isDarkMode ? bgDark             : bgLight;
  static Color get background     => bg;
  static Color get surface        => isDarkMode ? surfaceDark        : surfaceLight;
  static Color get surfaceElev    => isDarkMode ? surfaceElevDark    : surfaceElevLight;
  static Color get surfacePop     => isDarkMode ? surfacePopDark     : surfacePopLight;
  static Color get surfaceHover   => isDarkMode ? surfaceHoverDark   : surfaceHoverLight;

  // Borders
  static Color get border         => isDarkMode ? borderDark         : borderLight;
  static Color get surfaceBorder  => border;
  static Color get border2        => isDarkMode ? border2Dark        : border2Light;
  static Color get borderFocus    => isDarkMode ? borderFocusDark    : borderFocusLight;

  // Text
  static Color get textPrimary    => isDarkMode ? textPrimaryDark    : textPrimaryLight;
  static Color get textSecondary  => isDarkMode ? textSecDark        : textSecLight;
  static Color get textTertiary   => isDarkMode ? textTerDark        : textTerLight;
  static Color get textTer        => textTertiary;
  static Color get textMuted      => isDarkMode ? textMutedDark      : textMutedLight;
  static Color get textDisabled   => isDarkMode ? textDisabledDark   : textDisabledLight;

  // Accent
  static Color get accent         => isDarkMode ? accentDark         : accentLight;
  static Color get accentDim      => isDarkMode ? accentDimDark      : accentDimLight;
  static Color get accentGlow     => isDarkMode ? accentGlowDark     : accentGlowLight;
  static Color get accentSubtle   => isDarkMode ? accentSubtleDark   : accentSubtleLight;
  static Color get accentMuted    => accentSubtle; // alias
  static Color get accentTint     => isDarkMode ? accentTintDark     : accentTintLight;
  static Color get accentText     => isDarkMode ? accentInkDark      : accentInkLight;
  // Legacy alias
  static Color get accentHover    => accentGlow;

  // Semantic
  static Color get error          => isDarkMode ? errorDark          : errorLight;
  static Color get errorSubtle    => isDarkMode ? errorSubtleDark    : errorSubtleLight;
  static Color get warning        => isDarkMode ? warningDark        : warningLight;
  static Color get warnSubtle     => isDarkMode ? warnSubtleDark     : warnSubtleLight;
  static Color get success        => isDarkMode ? successDark        : successLight;
  static Color get successSubtle  => isDarkMode ? successSubtleDark  : successSubtleLight;
  static Color get info           => isDarkMode ? infoDark           : infoLight;
  static Color get infoSubtle     => isDarkMode ? infoSubtleDark     : infoSubtleLight;

  // Heatmap
  static Color get contrib0       => isDarkMode ? contrib0Dark       : contrib0Light;
  static Color get contrib1       => isDarkMode ? contrib1Dark       : contrib1Light;
  static Color get contrib2       => isDarkMode ? contrib2Dark       : contrib2Light;
  static Color get contrib3       => isDarkMode ? contrib3Dark       : contrib3Light;
  static Color get contrib4       => isDarkMode ? contrib4Dark       : contrib4Light;
  static Color get contrib5       => isDarkMode ? contrib5Dark       : contrib5Light;

  static Color contribForLevel(int level) {
    switch (level.clamp(0, 5)) {
      case 0:  return contrib0;
      case 1:  return contrib1;
      case 2:  return contrib2;
      case 3:  return contrib3;
      case 4:  return contrib4;
      default: return contrib5;
    }
  }

  // Grid dot — very subtle, theme-aware
  static Color get gridDotColor => isDarkMode
      ? Colors.white.withValues(alpha: 0.03)
      : Colors.black.withValues(alpha: 0.03);
}

// ─────────────────────────────────────────────────────────────────────────────
// SPACING
// 8-pt grid throughout. Named scale communicates intent, not raw numbers.
// ─────────────────────────────────────────────────────────────────────────────

class AppSpacing {
  // Breakpoints
  static const double mobileMax       = 650;
  static const double tabletMax       = 1100;
  static const double maxContentWidth = 1080;

  // Scale — strict 8-pt grid
  static const double xxs   = 2;   // hairline / icon nudge
  static const double xs    = 4;   // tight inline gap
  static const double sm    = 8;   // default inline gap
  static const double md    = 12;  // component internal padding
  static const double base  = 16;  // base unit
  static const double lg    = 24;  // section internal gap
  static const double xl    = 32;  // card padding / section gap
  static const double xxl   = 48;  // major section separation
  static const double xxxl  = 64;  // hero / above-fold spacing
  static const double section= 96; // between page sections

  // Breakpoint helpers
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= mobileMax && w < tabletMax;
  }

  static bool isLaptop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletMax;

  // Responsive horizontal padding — fluid ramp
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1400)      return (w - maxContentWidth) / 2;
    if (w >= tabletMax) return 60;
    if (w >= mobileMax) return 40;
    if (w >= 400)       return 30;
    return 20;
  }

  // Responsive headline sizing
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

// ─────────────────────────────────────────────────────────────────────────────
// RADIUS
// Deliberately minimal — sharp corners convey the editorial/utilitarian tone.
// Only use rounding where it reduces visual tension (pills, avatars, badges).
// ─────────────────────────────────────────────────────────────────────────────

class AppRadius {
  static const double none  = 0;
  static const double xs    = 2;   // Subtle — input corners
  static const double sm    = 4;   // Tags / chips
  static const double md    = 6;   // Buttons / small cards
  static const double lg    = 8;   // Standard cards
  static const double xl    = 12;  // Large cards / modals
  static const double xxl   = 16;  // Sheet / bottom drawer
  static const double pill  = 999; // Badges / toggles

  static const BorderRadius zero    = BorderRadius.zero;
  static const BorderRadius subtle  = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius card    = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius dialog  = BorderRadius.all(Radius.circular(md));
  static const BorderRadius button  = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chip    = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius avatar  = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius sheet   = BorderRadius.vertical(top: Radius.circular(xxl));
  
  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(sm));

  // Helpers for legacy / specific widget structures
  static const double cardValue = sm;
  static BorderRadius top(double radius) => BorderRadius.vertical(top: Radius.circular(radius));
}

// ─────────────────────────────────────────────────────────────────────────────
// THEME DATA
// ─────────────────────────────────────────────────────────────────────────────

class AppTheme {
  static ThemeData dark()  => _build(isDark: true);
  static ThemeData light() => _build(isDark: false);

  static ThemeData _build({required bool isDark}) {
    const mono = 'JetBrainsMono';

    // Resolve raw color values for this mode
    final bg           = isDark ? AppColors.bgDark           : AppColors.bgLight;
    final surface      = isDark ? AppColors.surfaceDark      : AppColors.surfaceLight;
    final surfaceElev  = isDark ? AppColors.surfaceElevDark  : AppColors.surfaceElevLight;
    final surfacePop   = isDark ? AppColors.surfacePopDark   : AppColors.surfacePopLight;
    final border       = isDark ? AppColors.borderDark       : AppColors.borderLight;
    final border2      = isDark ? AppColors.border2Dark      : AppColors.border2Light;
    final borderFocus  = isDark ? AppColors.borderFocusDark  : AppColors.borderFocusLight;
    final textPrimary  = isDark ? AppColors.textPrimaryDark  : AppColors.textPrimaryLight;
    final textSec      = isDark ? AppColors.textSecDark      : AppColors.textSecLight;
    final textTer      = isDark ? AppColors.textTerDark      : AppColors.textTerLight;
    final textMuted    = isDark ? AppColors.textMutedDark    : AppColors.textMutedLight;
    final accent       = isDark ? AppColors.accentDark       : AppColors.accentLight;
    final accentSubtle = isDark ? AppColors.accentSubtleDark : AppColors.accentSubtleLight;
    final accentInk    = isDark ? AppColors.accentInkDark    : AppColors.accentInkLight;
    final error        = isDark ? AppColors.errorDark        : AppColors.errorLight;
    final warning      = isDark ? AppColors.warningDark      : AppColors.warningLight;
    final success      = isDark ? AppColors.successDark      : AppColors.successLight;

    final colorScheme = ColorScheme.fromSeed(
      seedColor:  accent,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ).copyWith(
      primary:           accent,
      onPrimary:         isDark ? AppColors.bgDark : Colors.white,
      primaryContainer:  accentSubtle,
      onPrimaryContainer:accentInk,
      secondary:         accent,
      onSecondary:       isDark ? AppColors.bgDark : Colors.white,
      surface:           surface,
      onSurface:         textPrimary,
      surfaceContainer:  surfaceElev,
      surfaceContainerHigh: isDark ? AppColors.surfaceHoverDark : AppColors.surfaceHoverLight,
      outline:           border,
      outlineVariant:    border2,
      tertiary:          textTer,
      onTertiary:        bg,
      error:             error,
      onError:           isDark ? AppColors.bgDark : Colors.white,
    );

    return ThemeData(
      useMaterial3:             true,
      brightness:               isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor:  Colors.transparent,
      splashFactory:            NoSplash.splashFactory,
      highlightColor:           Colors.transparent,
      hoverColor:               Colors.transparent,
      colorScheme:              colorScheme,
      fontFamily:               mono,

      // ── Text theme ─────────────────────────────────────────────────────────
      // Scale: Display → Headline → Body → Label
      // Weight range: 400–700 only (no 800 — too heavy for mono)
      // Letter-spacing: negative on large sizes, 0 on body, slight positive on labels
      textTheme: TextTheme(

        // Display — hero-level text
        displayLarge: TextStyle(
          fontFamily: mono, fontSize: 40, fontWeight: FontWeight.w700,
          color: textPrimary, letterSpacing: -2.0, height: 1.05,
        ),
        displayMedium: TextStyle(
          fontFamily: mono, fontSize: 28, fontWeight: FontWeight.w700,
          color: textPrimary, letterSpacing: -1.2, height: 1.1,
        ),
        displaySmall: TextStyle(
          fontFamily: mono, fontSize: 22, fontWeight: FontWeight.w600,
          color: textPrimary, letterSpacing: -0.8, height: 1.15,
        ),

        // Headline — section and card titles
        headlineLarge: TextStyle(
          fontFamily: mono, fontSize: 16, fontWeight: FontWeight.w600,
          color: textPrimary, letterSpacing: -0.4, height: 1.4,
        ),
        headlineMedium: TextStyle(
          fontFamily: mono, fontSize: 14, fontWeight: FontWeight.w600,
          color: textPrimary, letterSpacing: -0.2, height: 1.4,
        ),
        headlineSmall: TextStyle(
          fontFamily: mono, fontSize: 12, fontWeight: FontWeight.w600,
          color: textPrimary, letterSpacing: 0, height: 1.4,
        ),

        // Body — prose and UI content
        bodyLarge: TextStyle(
          fontFamily: mono, fontSize: 14, fontWeight: FontWeight.w400,
          color: textPrimary, height: 1.75, letterSpacing: 0,
        ),
        bodyMedium: TextStyle(
          fontFamily: mono, fontSize: 13, fontWeight: FontWeight.w400,
          color: textSec, height: 1.75, letterSpacing: 0,
        ),
        bodySmall: TextStyle(
          fontFamily: mono, fontSize: 11.5, fontWeight: FontWeight.w400,
          color: textSec, height: 1.65, letterSpacing: 0,
        ),

        // Label — metadata, tags, eyebrow text
        labelLarge: TextStyle(
          fontFamily: mono, fontSize: 11, fontWeight: FontWeight.w500,
          color: textPrimary, letterSpacing: 1.2,
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

      // ── Inputs ─────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hoverColor: surfaceElev,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        border: OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: BorderSide(color: borderFocus, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: BorderSide(color: error, width: 1.5),
        ),
        hintStyle: TextStyle(
          fontFamily: mono, fontSize: 12,
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
        ),
        labelStyle:         TextStyle(fontFamily: mono, fontSize: 11, color: textTer),
        floatingLabelStyle: TextStyle(fontFamily: mono, fontSize: 10, color: accent),
      ),

      // ── Elevated / Filled buttons — accent-colored ──────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:    accent,
          foregroundColor:    isDark ? AppColors.bgDark : Colors.white,
          disabledBackgroundColor: isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight,
          disabledForegroundColor: isDark ? AppColors.textMutedDark  : AppColors.textMutedLight,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          textStyle: TextStyle(
            fontFamily: mono, fontSize: 12, fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // ── Outlined buttons — ghost style ─────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border2),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          textStyle: TextStyle(
            fontFamily: mono, fontSize: 12, fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ── Text buttons ────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: TextStyle(
            fontFamily: mono, fontSize: 12, fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ── Cards ───────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surfaceElev,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
        margin: EdgeInsets.zero,
      ),

      // ── Dialogs ─────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: surfacePop,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.dialog),
      ),

      // ── Bottom sheet ────────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfacePop,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheet),
        dragHandleColor: border2,
        dragHandleSize: const Size(36, 4),
      ),

      // ── Dividers ────────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      // ── Scrollbar ───────────────────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.hovered) ? border2 : border),
        thickness: WidgetStateProperty.all(3),
        radius: const Radius.circular(AppRadius.xs),
        interactive: true,
        mainAxisMargin: 2,
        crossAxisMargin: 2,
      ),

      // ── Tooltip ─────────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: surfacePop,
          border: Border.all(color: border2),
          borderRadius: AppRadius.card,
        ),
        textStyle: TextStyle(
          fontFamily: mono, fontSize: 10,
          fontWeight: FontWeight.w400, color: textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        waitDuration: const Duration(milliseconds: 300),
        showDuration: const Duration(seconds: 3),
      ),

      // ── Chips ───────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: surfaceElev,
        selectedColor: accentSubtle,
        disabledColor: surface,
        labelStyle: TextStyle(
          fontFamily: mono, fontSize: 10.5,
          fontWeight: FontWeight.w400, color: textSec,
        ),
        side: BorderSide(color: border),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        elevation: 0,
        pressElevation: 0,
      ),

      // ── List tiles ──────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: accentSubtle,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        titleTextStyle: TextStyle(
          fontFamily: mono, fontSize: 13,
          fontWeight: FontWeight.w400, color: textPrimary,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: mono, fontSize: 11,
          fontWeight: FontWeight.w400, color: textSec,
        ),
        iconColor: textTer,
        minLeadingWidth: 20,
      ),

      // ── Switch ──────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? (isDark ? AppColors.bgDark : Colors.white)
                : border2),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? accent : surfaceElev),
        trackOutlineColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? Colors.transparent : border),
      ),

      // ── Checkbox ────────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? accent : Colors.transparent),
        checkColor: WidgetStateProperty.all(
            isDark ? AppColors.bgDark : Colors.white),
        side: BorderSide(color: border2, width: 1.5),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.xs))),
        overlayColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.hovered)
                ? accentSubtle.withValues(alpha: 0.5)
                : Colors.transparent),
      ),

      // ── Radio ───────────────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? accent : border2),
        overlayColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.hovered)
                ? accentSubtle.withValues(alpha: 0.5)
                : Colors.transparent),
      ),

      // ── Slider ──────────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor:   accent,
        inactiveTrackColor: border2,
        thumbColor:         accent,
        overlayColor:       accent.withValues(alpha: 0.12),
        trackHeight: 2,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
      ),

      // ── Progress indicator ──────────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: accentSubtle,
        circularTrackColor: Colors.transparent,
        linearMinHeight: 2,
      ),

      // ── Tab bar ─────────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: accent,
        unselectedLabelColor: textTer,
        indicatorColor: accent,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          fontFamily: mono, fontSize: 11,
          fontWeight: FontWeight.w600, letterSpacing: 0.2,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: mono, fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        dividerColor: border,
      ),

      // ── AppBar ──────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: mono, fontSize: 13,
          fontWeight: FontWeight.w600, color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textSec, size: 18),
        actionsIconTheme: IconThemeData(color: textSec, size: 18),
        toolbarHeight: 52,
      ),

      // ── Navigation bar (bottom) ─────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: accentSubtle,
        labelTextStyle: WidgetStateProperty.resolveWith((s) =>
            TextStyle(
              fontFamily: mono, fontSize: 10,
              fontWeight: s.contains(WidgetState.selected)
                  ? FontWeight.w600 : FontWeight.w400,
              color: s.contains(WidgetState.selected) ? accent : textTer,
            )),
        iconTheme: WidgetStateProperty.resolveWith((s) =>
            IconThemeData(
              color: s.contains(WidgetState.selected) ? accent : textTer,
              size: 20,
            )),
        elevation: 0,
        height: 62,
      ),

      // ── Popup menu ──────────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: surfacePop,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialog,
          side: BorderSide(color: border),
        ),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            fontFamily: mono, fontSize: 12,
            fontWeight: FontWeight.w400, color: textPrimary,
          ),
        ),
      ),

      // ── Snack bar ───────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? AppColors.surfaceHoverDark
            : AppColors.textPrimaryLight,
        contentTextStyle: TextStyle(
          fontFamily: mono, fontSize: 12,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textPrimaryDark : AppColors.bgLight,
        ),
        actionTextColor: accent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // ── Badge ───────────────────────────────────────────────────────────────
      badgeTheme: BadgeThemeData(
        backgroundColor: accent,
        textColor: isDark ? AppColors.bgDark : Colors.white,
        textStyle: TextStyle(
          fontFamily: mono, fontSize: 9, fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        largeSize: 18,
        smallSize: 8,
      ),

      // ── Icons ───────────────────────────────────────────────────────────────
      iconTheme: IconThemeData(color: textSec, size: 18),
      primaryIconTheme: IconThemeData(color: accent, size: 18),
    );
  }
}