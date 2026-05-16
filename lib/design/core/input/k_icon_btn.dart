import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Square icon-only button. Ghost background (transparent → surfaceHover
/// on hover/press). Used for header action slots, list-row trailing
/// actions, and similar single-icon affordances.
class KIconBtn extends StatelessWidget {
  const KIconBtn({
    required this.icon,
    super.key,
    this.onPressed,
    this.tooltip,
    this.size = 48, // Material 3 minimum tap target
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final disabled = onPressed == null;

    Widget button = SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: disabled ? null : onPressed,
          customBorder: const CircleBorder(),
          hoverColor: c.surfaceHover,
          splashColor: c.surfaceHover,
          child: Center(
            child: IconTheme(
              data: IconThemeData(
                color: disabled ? c.textMuted : c.textPrimary,
                size: 20,
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );

    final t = tooltip;
    if (t != null) {
      button = Tooltip(message: t, child: button);
    }
    return button;
  }
}
