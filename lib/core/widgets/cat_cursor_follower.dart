import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../theme/app_theme.dart';

/// CatCursorFollower
///
/// Desktop: follows mouse cursor continuously.
/// Mobile : chases tap/long-press locations, reacts to swipes,
///          and returns home after inactivity.
class CatCursorFollower extends StatefulWidget {
  final Widget child;

  const CatCursorFollower({
    super.key,
    required this.child,
  });

  @override
  State<CatCursorFollower> createState() => _CatCursorFollowerState();
}

enum _CatMode { idle, alerting, following, returningHome }

class _CatCursorFollowerState extends State<CatCursorFollower>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  // ── Sprite ──────────────────────────────────────────────────────────────────
  List<int> _currentSprite = _spriteSets['sleeping']![0];
  int _frameCount = 0;

  // ── Idle animation ──────────────────────────────────────────────────────────
  String? _idleAnimation = 'sleeping';
  int _idleAnimationFrame = 10;
  int _idleTime = 0;
  int _idleCooldown = 0;

  // ── Alert hold ──────────────────────────────────────────────────────────────
  int _alertFramesLeft = 0;

  // ── Exclamation mark (tap reaction) ─────────────────────────────────────────
  bool _showExclamation = false;
  int _exclamationFrames = 0;

  // ── Position ─────────────────────────────────────────────────────────────────
  double _nekoPosX = 0;
  double _nekoPosY = 0;
  double _homeX = 0;
  double _homeY = 0;
  double _targetX = 0;
  double _targetY = 0;

  // ── Mode & timing ────────────────────────────────────────────────────────────
  _CatMode _mode = _CatMode.idle;
  static const double _returnIdleSeconds = 5 * 60.0;
  static const double _baseSpeed = 9.0;
  static const double _topSpeed  = 18.0;
  static const double _arriveRadius = 40.0;

  Duration _lastTickTime  = Duration.zero;
  Duration _lastInteract  = Duration.zero;
  bool _initialized = false;

  // ── Mobile: swipe tracking ───────────────────────────────────────────────────
  Offset? _swipeStart;
  Offset? _lastTouchPos;

  // ── Sprite sheet ─────────────────────────────────────────────────────────────
  static const Map<String, List<List<int>>> _spriteSets = {
    'idle'        : [[-3, -3]],
    'alert'       : [[-7, -3]],
    'scratchSelf' : [[-5, 0], [-6, 0], [-7, 0]],
    'scratchWallN': [[0, 0], [0, -1]],
    'scratchWallS': [[-7, -1], [-6, -2]],
    'scratchWallE': [[-2, -2], [-2, -3]],
    'scratchWallW': [[-4, 0], [-4, -1]],
    'tired'       : [[-3, -2]],
    'sleeping'    : [[-2, 0], [-2, -1]],
    'N' : [[-1, -2], [-1, -3]],
    'NE': [[0, -2], [0, -3]],
    'E' : [[-3, 0], [-3, -1]],
    'SE': [[-5, -1], [-5, -2]],
    'S' : [[-6, -3], [-7, -2]],
    'SW': [[-5, -3], [-6, -1]],
    'W' : [[-4, -2], [-4, -3]],
    'NW': [[-1, 0], [-1, -1]],
  };

  // ── Lifecycle ────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final size = MediaQuery.sizeOf(context);
      _homeX = size.width  - 65.0;  // away from right edge
      _homeY = size.height - 65.0; // above the footer + nav bar
      _nekoPosX = _homeX;
      _nekoPosY = _homeY;
      _targetX  = _homeX;
      _targetY  = _homeY;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  // ── Tick ─────────────────────────────────────────────────────────────────────
  void _onTick(Duration elapsed) {
    if ((elapsed - _lastTickTime).inMilliseconds < 100) return;
    _lastTickTime = elapsed;
    _frameCount++;

    if (_mode == _CatMode.following) {
      final sinceInteract = (elapsed - _lastInteract).inMilliseconds / 1000.0;
      if (sinceInteract > _returnIdleSeconds) _startReturnHome();
    }

    if (_exclamationFrames > 0) _exclamationFrames--;
    if (_exclamationFrames == 0 && _showExclamation) {
      setState(() => _showExclamation = false);
    }

    _step(elapsed);
  }

  void _startReturnHome() {
    _mode = _CatMode.returningHome;
    _targetX = _homeX;
    _targetY = _homeY;
    _idleAnimation = null;
    _idleAnimationFrame = 0;
    _idleTime = 0;
  }

  // ── Per-frame logic ──────────────────────────────────────────────────────────
  void _step(Duration elapsed) {
    final diffX = _nekoPosX - _targetX;
    final diffY = _nekoPosY - _targetY;
    final dist  = sqrt(diffX * diffX + diffY * diffY);

    if (dist < _arriveRadius) {
      if (_mode == _CatMode.returningHome) {
        _mode = _CatMode.idle;
        setState(() {
          _nekoPosX = _homeX;
          _nekoPosY = _homeY;
        });
      } else if (_mode == _CatMode.alerting) {
        _mode = _CatMode.idle;
      }
      _runIdle();
      return;
    }

    if (_mode == _CatMode.alerting) {
      _setSprite('alert', 0);
      _alertFramesLeft--;
      if (_alertFramesLeft <= 0) _mode = _CatMode.following;
      return;
    }

    _idleAnimation = null;
    _idleAnimationFrame = 0;
    _idleTime = 0;
    if (_idleCooldown > 0) _idleCooldown--;

    final t     = (dist / 200.0).clamp(0.0, 1.0);
    final speed = _baseSpeed + (_topSpeed - _baseSpeed) * t;

    _setSprite(_directionSprite(diffX, diffY, dist), _frameCount);

    setState(() {
      _nekoPosX -= (diffX / dist) * speed;
      _nekoPosY -= (diffY / dist) * speed;
      final size = MediaQuery.sizeOf(context);
      _nekoPosX = _nekoPosX.clamp(16.0, size.width  - 16.0);
      _nekoPosY = _nekoPosY.clamp(16.0, size.height - 16.0);
    });
  }

  // ── Idle ─────────────────────────────────────────────────────────────────────
  void _runIdle() {
    _idleTime++;
    if (_idleCooldown > 0) _idleCooldown--;

    if (_idleAnimation == null && _idleTime > 10 && _idleCooldown == 0) {
      if (Random().nextInt(200) == 0) {
        _idleAnimation = _pickIdleAnimation();
        _idleAnimationFrame = 0;
        _idleCooldown = 80;
      }
    }

    switch (_idleAnimation) {
      case 'sleeping':
        if (_idleAnimationFrame < 8) {
          _setSprite('tired', 0);
        } else {
          _setSprite('sleeping', _idleAnimationFrame ~/ 4);
          if (_idleAnimationFrame > 192) _clearIdleAnimation();
        }
        _idleAnimationFrame++;
        break;
      case 'scratchSelf':
      case 'scratchWallN':
      case 'scratchWallS':
      case 'scratchWallE':
      case 'scratchWallW':
        _setSprite(_idleAnimation!, _idleAnimationFrame++);
        if (_idleAnimationFrame > 9) _clearIdleAnimation();
        break;
      default:
        _setSprite('idle', 0);
    }
  }

  String _pickIdleAnimation() {
    final choices = <String>['sleeping', 'scratchSelf'];
    if (!mounted) return 'sleeping';
    final size = MediaQuery.sizeOf(context);
    if (_nekoPosX < 32)               choices.add('scratchWallW');
    if (_nekoPosY < 32)               choices.add('scratchWallN');
    if (_nekoPosX > size.width  - 32) choices.add('scratchWallE');
    if (_nekoPosY > size.height - 32) choices.add('scratchWallS');
    return choices[Random().nextInt(choices.length)];
  }

  void _clearIdleAnimation() {
    _idleAnimation = null;
    _idleAnimationFrame = 0;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────
  String _directionSprite(double dx, double dy, double dist) {
    String d = '';
    if (dy / dist >  0.5) d += 'N';
    if (dy / dist < -0.5) d += 'S';
    if (dx / dist >  0.5) d += 'W';
    if (dx / dist < -0.5) d += 'E';
    return d.isEmpty ? 'idle' : d;
  }

  void _setSprite(String name, int frame) {
    final list = _spriteSets[name];
    if (list == null) return;
    final next = list[frame % list.length];
    if (_currentSprite[0] != next[0] || _currentSprite[1] != next[1]) {
      setState(() => _currentSprite = next);
    }
  }

  // ── Shared wake-up ───────────────────────────────────────────────────────────
  void _wakeUp(Offset position) {
    _targetX = position.dx;
    _targetY = position.dy;
    _lastInteract = _lastTickTime;

    if (_mode != _CatMode.following && _mode != _CatMode.alerting) {
      _mode = _CatMode.alerting;
      _alertFramesLeft = 3;
      _idleAnimation = null;
      _idleAnimationFrame = 0;
      _idleTime = 0;
    }
  }

  // ── Desktop: pointer hover/move ──────────────────────────────────────────────
  void _onPointerEvent(PointerEvent e) {
    final dx = (_targetX - e.position.dx).abs();
    final dy = (_targetY - e.position.dy).abs();
    if (dx < 1 && dy < 1) return;
    _wakeUp(e.position);
  }

  // ── Mobile: tap ──────────────────────────────────────────────────────────────
  void _onTap(TapUpDetails details) {
    setState(() => _showExclamation = true);
    _exclamationFrames = 5;
    _wakeUp(details.globalPosition);
  }

  // ── Mobile: double-tap (cat spins/dances at current pos briefly) ─────────────
  void _onDoubleTap() {
    // Jitter the target a tiny bit so the cat does a quick turn-in-place.
    final rand = Random();
    setState(() {
      _targetX = _nekoPosX + (rand.nextDouble() - 0.5) * 60;
      _targetY = _nekoPosY + (rand.nextDouble() - 0.5) * 60;
      _showExclamation = true;
    });
    _exclamationFrames = 8;
    _lastInteract = _lastTickTime;
    if (_mode == _CatMode.idle) {
      _mode = _CatMode.alerting;
      _alertFramesLeft = 2;
    }
  }

  // ── Mobile: long-press (cat comes directly to your finger) ───────────────────
  void _onLongPressStart(LongPressStartDetails details) {
    setState(() => _showExclamation = true);
    _exclamationFrames = 6;
    _wakeUp(details.globalPosition);
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    _wakeUp(details.globalPosition);
  }

  // ── Mobile: swipe (cat chases the swipe endpoint) ────────────────────────────
  void _onPanStart(DragStartDetails details) {
    _swipeStart = details.globalPosition;
    _lastTouchPos = details.globalPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _lastTouchPos = details.globalPosition;
    // While dragging, update target continuously so cat chases the finger.
    _wakeUp(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    if (_swipeStart != null && _lastTouchPos != null) {
      // Project the cat toward the swipe direction beyond the finger lift point.
      final dx = _lastTouchPos!.dx - _swipeStart!.dx;
      final dy = _lastTouchPos!.dy - _swipeStart!.dy;
      final len = sqrt(dx * dx + dy * dy);
      if (len > 10) {
        final size = MediaQuery.sizeOf(context);
        final overshootX = (_lastTouchPos!.dx + (dx / len) * 80)
            .clamp(16.0, size.width  - 16.0);
        final overshootY = (_lastTouchPos!.dy + (dy / len) * 80)
            .clamp(16.0, size.height - 16.0);
        _wakeUp(Offset(overshootX, overshootY));
      }
    }
    _swipeStart = null;
    _lastTouchPos = null;
  }

  // ── Build ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp:                _onTap,
      onDoubleTap:            _onDoubleTap,
      onLongPressStart:       _onLongPressStart,
      onLongPressMoveUpdate:  _onLongPressMoveUpdate,
      onPanStart:             _onPanStart,
      onPanUpdate:            _onPanUpdate,
      onPanEnd:               _onPanEnd,
      child: Listener(
        onPointerHover: _onPointerEvent,
        onPointerMove:  _onPointerEvent,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            widget.child,

            // ── Cat sprite ────────────────────────────────────────────────────
            Positioned(
              left: _nekoPosX - 16,
              top:  _nekoPosY - 16,
              child: IgnorePointer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Exclamation mark bubble on tap/long-press
                    AnimatedOpacity(
                      opacity: _showExclamation ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 150),
                      child: const Text(
                        '!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          height: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: ClipRect(
                        child: Stack(
                          children: [
                            Positioned(
                              left: _currentSprite[0] * 32.0,
                              top:  _currentSprite[1] * 32.0,
                              child: Image.asset(
                                'assets/images/oneko.gif',
                                width:  256,
                                height: 128,
                                fit: BoxFit.fill,
                                filterQuality: FilterQuality.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}