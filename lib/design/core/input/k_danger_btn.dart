import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart'
    show KBtnSize;

/// Outlined danger button. Red text + red border + soft red hover. Used
/// for destructive actions outside of confirmation dialogs (e.g. a "Remove
/// brand" inline button on a brand row when the user is already in an
/// edit sheet).
class KDangerBtn extends StatelessWidget {
  const KDangerBtn({
    required this.label,
    super.key,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.size = KBtnSize.lg,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final Widget? icon;
  final KBtnSize size;
  final bool fullWidth;

  ({double height, double fontSize, double spinnerSize}) _metrics() {
    switch (size) {
      case KBtnSize.sm:
        return (height: 28, fontSize: 12, spinnerSize: 14);
      case KBtnSize.md:
        return (height: 40, fontSize: 14, spinnerSize: 16);
      case KBtnSize.lg:
        return (height: 52, fontSize: 14, spinnerSize: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final m = _metrics();
    final disabled = onPressed == null || loading;

    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          KSpinner(size: m.spinnerSize, color: c.danger)
        else if (icon != null) ...[
          IconTheme(
            data: IconThemeData(color: c.danger, size: m.spinnerSize),
            child: icon!,
          ),
          const SizedBox(width: 8),
        ],
        if (!loading)
          Text(
            label,
            style: TextStyle(
              color: c.danger,
              fontSize: m.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Material(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          hoverColor: c.dangerSoft,
          child: Container(
            height: m.height,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: c.danger.withValues(alpha: 0.3),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
