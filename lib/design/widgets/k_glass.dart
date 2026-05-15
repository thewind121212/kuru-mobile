import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Liquid Glass surface — semi-transparent + heavy blur + saturation.
/// Direct port of the .k-glass CSS rule from kuru-theme.js.
class KGlass extends StatelessWidget {
  const KGlass({
    required this.child,
    super.key,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.padding = EdgeInsets.zero,
    this.solid = false,
    this.blur = 22,
  });

  final Widget child;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final bool solid;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final tint = solid
        ? Color.alphaBlend(
            c.surfaceElev.withValues(alpha: 0.82),
            Colors.transparent,
          )
        : c.glassTint;
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: borderRadius,
            border: Border.all(
              color: c.textPrimary.withValues(alpha: 0.12),
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
