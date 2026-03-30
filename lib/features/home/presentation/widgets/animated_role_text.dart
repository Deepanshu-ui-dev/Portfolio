import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Drop-in animated role typer with a blinking cursor.
/// Cycles through [roles] with a typewriter + delete effect.
class AnimatedRoleText extends StatefulWidget {
  const AnimatedRoleText({super.key});

  @override
  State<AnimatedRoleText> createState() => _AnimatedRoleTextState();
}

class _AnimatedRoleTextState extends State<AnimatedRoleText>
    with SingleTickerProviderStateMixin {
  // ── Roles list ──────────────────────────────────────────────────────────
  static const _roles = [
    'UI/UX Designer',
    'Flutter Developer',
    'Problem Solver',
    'Photographer',
    'Student',
    'Freelancer',
    'Human Being',
  ];

  // ── Typer state ─────────────────────────────────────────────────────────
  int _roleIndex = 0;
  int _charIndex = 0;
  bool _deleting = false;
  String _displayed = '';

  // ── Cursor blink ────────────────────────────────────────────────────────
  late final AnimationController _cursorCtrl;
  late final Animation<double> _cursorOpacity;

  @override
  void initState() {
    super.initState();

    _cursorCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _cursorOpacity =
        CurvedAnimation(parent: _cursorCtrl, curve: Curves.easeInOut);

    // Kick off the typer
    _scheduleNext(const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _cursorCtrl.dispose();
    super.dispose();
  }

  // ── Scheduling ──────────────────────────────────────────────────────────

  void _scheduleNext(Duration delay) {
    Future.delayed(delay, _tick);
  }

  void _tick() {
    if (!mounted) return;
    final current = _roles[_roleIndex];

    setState(() {
      if (!_deleting) {
        // Typing forward
        _charIndex = (_charIndex + 1).clamp(0, current.length);
        _displayed = current.substring(0, _charIndex);
      } else {
        // Deleting backward
        _charIndex = (_charIndex - 1).clamp(0, current.length);
        _displayed = current.substring(0, _charIndex);
      }
    });

    if (!_deleting && _charIndex == current.length) {
      // Finished typing → pause then start deleting
      _deleting = true;
      _scheduleNext(const Duration(milliseconds: 1800));
      return;
    }

    if (_deleting && _charIndex == 0) {
      // Finished deleting → move to next role
      _deleting = false;
      _roleIndex = (_roleIndex + 1) % _roles.length;
      _scheduleNext(const Duration(milliseconds: 250));
      return;
    }

    _scheduleNext(
      _deleting
          ? const Duration(milliseconds: 38)
          : _typingDelay(),
    );
  }

  /// Slight random variation in typing speed for a natural feel.
  Duration _typingDelay() {
    // Range: 55ms–90ms
    final base = 55 + (_charIndex % 4) * 10;
    return Duration(milliseconds: base);
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final comment = isDark
        ? AppColors.textSecDark.withValues(alpha: 0.45)
        : AppColors.textSecLight.withValues(alpha: 0.45);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Comment prefix
        Text(
          '// ',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: comment,
                letterSpacing: 0.02,
              ),
        ),

        // Typed text
        Text(
          _displayed,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.04,
              ),
        ),

        // Blinking block cursor
        FadeTransition(
          opacity: _cursorOpacity,
          child: Container(
            width: 2,
            height: 13,
            margin: const EdgeInsets.only(left: 1.5),
            color: accent,
          ),
        ),
      ],
    );
  }
}