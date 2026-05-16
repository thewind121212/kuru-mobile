import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Compact step indicator — current step is a wide pill, others are 6×6 dots.
/// Animates the width transition on change. Pass `onTap` to make each dot
/// tappable (e.g. for jumping to a specific page in an onboarding carousel).
class KStepDots extends StatelessWidget {
  const KStepDots({
    required this.count,
    required this.current,
    super.key,
    this.onTap,
  });

  final int count;
  final int current;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == current;
        final dot = AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: 6,
          width: active ? 24 : 6,
          decoration: BoxDecoration(
            color: active
                ? c.primary
                : Color.alphaBlend(
                    c.textMuted.withValues(alpha: 0.26),
                    Colors.transparent,
                  ),
            borderRadius: BorderRadius.circular(99),
          ),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: onTap == null
              ? dot
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap!(i),
                  // Expand the hit target without changing visual layout.
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: dot,
                  ),
                ),
        );
      }),
    );
  }
}
