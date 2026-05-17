import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Pulsing placeholder block used to indicate loading state for list rows,
/// cards, and other content surfaces. Animates a single `surfaceHover` box
/// opacity between 0.5 and 1.0 with a 1.2s cycle (reversed each iteration).
///
/// Use the default constructor for rectangular skeletons (text lines,
/// thumbnails, badges). Use [KSkeleton.circle] for avatar placeholders.
class KSkeleton extends StatefulWidget {
  const KSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 8,
  });

  /// Square block sized [diameter]×[diameter] with full corner radius.
  /// Used in place of avatar / category-icon circles while loading.
  const KSkeleton.circle(double diameter, {super.key})
      : width = diameter,
        height = diameter,
        radius = diameter / 2;

  final double? width;
  final double height;
  final double radius;

  @override
  State<KSkeleton> createState() => _KSkeletonState();
}

class _KSkeletonState extends State<KSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return AnimatedBuilder(
      animation: _ctl,
      builder: (context, _) {
        final t = _ctl.value; // 0..1
        final opacity = 0.5 + t * 0.5; // 0.5..1.0
        return Opacity(
          opacity: opacity,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: c.surfaceHover,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          ),
        );
      },
    );
  }
}
