import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DiagonalStripedBackgroundPainter extends CustomPainter {
  final Color stripeColor;
  final double stripeWidth;
  final double spacing;

  DiagonalStripedBackgroundPainter({
    required this.stripeColor,
    this.stripeWidth = 1.0,
    this.spacing = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = stripeColor
      ..strokeWidth = stripeWidth
      ..isAntiAlias = true;

    final diagonal = size.width + size.height;

    for (double i = -diagonal; i < diagonal; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DiagonalStripedBackgroundPainter oldDelegate) {
    return stripeColor != oldDelegate.stripeColor ||
        stripeWidth != oldDelegate.stripeWidth ||
        spacing != oldDelegate.spacing;
  }
}

class StripedBackground extends StatelessWidget {
  final Widget child;

  const StripedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DiagonalStripedBackgroundPainter(
        stripeColor: AppColors.surfaceBorder.withOpacity(0.3),
        spacing: 6.0,
      ),
      child: child,
    );
  }
}
