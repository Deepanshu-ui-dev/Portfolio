import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AnimatedRoleText extends StatefulWidget {
  final List<String> roles;
  
  const AnimatedRoleText({
    super.key,
    this.roles = const [
      "UI/UX Designer",
      "Flutter Developer",
      "Problem Solver",
      "Photographer"
    ],
  });

  @override
  State<AnimatedRoleText> createState() => _AnimatedRoleTextState();
}

class _AnimatedRoleTextState extends State<AnimatedRoleText> {
  int _currentIndex = 0;
  String _currentText = "";
  late Timer _timer;
  bool _isDeleting = false;
  
  // Timings
  final int _typingSpeed = 80;
  final int _deletingSpeed = 40;
  final int _pauseDuration = 2000;
  
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer(Duration(milliseconds: _typingSpeed), _tick);
  }

  void _tick() {
    if (!mounted) return;
    final targetText = widget.roles[_currentIndex];

    setState(() {
      if (_isDeleting) {
        if (_currentText.isNotEmpty) {
          _currentText = targetText.substring(0, _currentText.length - 1);
        }
      } else {
        if (_currentText.length < targetText.length) {
          // Normal typing effect
          _currentText = targetText.substring(0, _currentText.length + 1);
        }
      }
    });

    int nextTick = _isDeleting ? _deletingSpeed : _typingSpeed;

    if (!_isDeleting && _currentText.length == targetText.length) {
      // Reached the end of typing, pause before deleting
      _isDeleting = true;
      nextTick = _pauseDuration;
    } else if (_isDeleting && _currentText.isEmpty) {
      // Reached the end of deleting, move to next role
      _isDeleting = false;
      _currentIndex = (_currentIndex + 1) % widget.roles.length;
      nextTick = 500; // Small pause before typing next
    }

    // Add some randomness to typing for realism
    if (!_isDeleting && nextTick == _typingSpeed) {
      nextTick += _random.nextInt(40) - 20; 
    }

    _timer = Timer(Duration(milliseconds: nextTick), _tick);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _currentText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        _BlinkingCursor(),
      ],
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 16,
        margin: const EdgeInsets.only(left: 2),
        color: AppColors.textSecondary,
      ),
    );
  }
}
