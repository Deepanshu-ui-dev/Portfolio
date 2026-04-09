import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

const _kThemeKey = 'theme_mode';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

// Derived provider: Watch theme mode and compute effective brightness
final effectiveThemeProvider = Provider<Brightness>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  final platformBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  if (themeMode == ThemeMode.system) {
    return platformBrightness;
  } else if (themeMode == ThemeMode.dark) {
    return Brightness.dark;
  } else {
    return Brightness.light;
  }
});

// Watch for theme changes and sync AppColors globally
final themeSyncProvider = Provider<void>((ref) {
  final brightness = ref.watch(effectiveThemeProvider);
  AppColors.isDarkMode = brightness == Brightness.dark;
});

// Cache for theme persistence
class _ThemeCache {
  static SharedPreferences? _instance;
  static Future<SharedPreferences> get instance async {
    _instance ??= await SharedPreferences.getInstance();
    return _instance!;
  }
}

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await _ThemeCache.instance;
      final stored = prefs.getString(_kThemeKey);
      if (stored == 'light') {
        state = ThemeMode.light;
      } else if (stored == 'system') {
        state = ThemeMode.system;
      } else {
        state = ThemeMode.dark;
      }
    } catch (_) {
      state = ThemeMode.dark;
    }
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    try {
      final prefs = await _ThemeCache.instance;
      await prefs.setString(
          _kThemeKey, next == ThemeMode.light ? 'light' : 'dark');
    } catch (_) {}
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await _ThemeCache.instance;
      await prefs.setString(_kThemeKey, mode.name);
    } catch (_) {}
  }
}
