import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Small filled checkbox that matches the design's "purple filled" look.
/// Used for Login.remember and Register.terms.
///
/// When [hasError] is true and the checkbox is unchecked, the border switches
/// to the danger tone — same pattern as KFormField's error state. Once the
/// user ticks the box the fill takes over and the error tint is naturally
/// hidden.
class KCheckbox extends StatelessWidget {
  const KCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.size = 18,
    this.hasError = false,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final showError = hasError && !value;
    return InkResponse(
      onTap: () => onChanged(!value),
      radius: size,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? c.primary : Colors.transparent,
          border: Border.all(
            color: value
                ? c.primary
                : showError
                ? c.danger
                : c.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: value
            ? Icon(Icons.check, size: size * 0.7, color: c.textInverse)
            : null,
      ),
    );
  }
}
