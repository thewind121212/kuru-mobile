import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

class KTabItem<T> {
  const KTabItem({required this.id, required this.label, this.icon});
  final T id;
  final String label;
  final IconData? icon;
}

enum KTabSize { sm, md }

/// Horizontally scrollable pill-tab strip. Active tab uses surfaceElev BG
/// + textPrimary text + a soft shadow on top of the surfaceHover track —
/// mirrors kuru-web's `bg-white shadow-sm` selected-tab pattern. Inactive
/// tabs are transparent + textMuted.
class KTabNav<T> extends StatelessWidget {
  const KTabNav({
    required this.tabs,
    required this.active,
    required this.onChange,
    super.key,
    this.size = KTabSize.md,
  });

  final List<KTabItem<T>> tabs;
  final T active;
  final ValueChanged<T> onChange;
  final KTabSize size;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final isSm = size == KTabSize.sm;
    final hPad = isSm ? 8.0 : 16.0;
    final vPad = isSm ? 6.0 : 8.0;
    final fontSize = isSm ? 12.0 : 14.0;
    final iconSize = isSm ? 13.0 : 15.0;

    return Container(
      decoration: BoxDecoration(
        color: c.surfaceHover,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final tab in tabs) ...[
              _tabButton(c, tab, hPad, vPad, fontSize, iconSize),
              const SizedBox(width: 4),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tabButton(
    KuruColors c,
    KTabItem<T> tab,
    double hPad,
    double vPad,
    double fontSize,
    double iconSize,
  ) {
    final isActive = tab.id == active;
    final activeColor = c.textPrimary;
    final inactiveColor = c.textMuted;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isActive ? c.surfaceElev : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: () => onChange(tab.id),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tab.icon != null) ...[
                  Icon(
                    tab.icon,
                    size: iconSize,
                    color: isActive ? activeColor : inactiveColor,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  tab.label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? activeColor : inactiveColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
