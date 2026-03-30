import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MinimalContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final Color? color;

  const MinimalContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.border,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.zero,
        border: border ?? Border.all(color: AppColors.surfaceBorder, width: 1),
      ),
      child: child,
    );
  }
}
