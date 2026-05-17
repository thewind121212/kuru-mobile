// TablerIcons exports snake_case names used in const widget trees.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// One destination in [KuruBottomNav].
class KuruBottomNavItem {
  const KuruBottomNavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

/// Custom bottom navigation matching the kuru reference design 1:1:
///
/// - Flat surfaceElev bar with a thin top border (no Material 3 pill or
///   inkwell behind the active icon).
/// - Active tab has a 3px accent indicator pinned to the very top, an
///   accent-coloured icon, and an accent label below — Material's default
///   NavigationBar visually buries the active state under a pill, which
///   doesn't match the reference.
/// - Inactive tabs use textMuted across icon + label.
/// - An optional circular "+" action button sits inside the bar to the
///   right of all tabs (intended for POS — a global, always-visible action
///   on every tab). It is NOT a Material FloatingActionButton because we
///   want it docked into the bar rather than floating above the body.
class KuruBottomNav extends StatelessWidget {
  const KuruBottomNav({
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    super.key,
    this.actionIcon,
    this.onActionPressed,
    this.actionTooltip,
  });

  final List<KuruBottomNavItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  /// Icon for the trailing circular action button (e.g. POS `+`). When
  /// null, no action button is rendered.
  final IconData? actionIcon;

  /// Callback for the trailing action button. Required if [actionIcon]
  /// is provided.
  final VoidCallback? onActionPressed;

  /// Tooltip shown on long-press of the action button.
  final String? actionTooltip;

  static const double _height = 72;
  static const double _actionSize = 44;
  static const double _indicatorWidth = 28;
  static const double _indicatorHeight = 3;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surfaceElev,
      child: SafeArea(
        top: false,
        child: Container(
          height: _height,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: c.border, width: 0.5)),
          ),
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                Expanded(
                  child: _Tab(
                    item: tabs[i],
                    isActive: i == currentIndex,
                    onTap: () => onTabChanged(i),
                  ),
                ),
              if (actionIcon != null)
                _ActionButton(
                  icon: actionIcon!,
                  tooltip: actionTooltip,
                  onPressed: onActionPressed,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.item, required this.isActive, required this.onTap});

  final KuruBottomNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final color = isActive ? c.accent600 : c.textMuted;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: KuruBottomNav._height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 3px top indicator pinned to the very top of the tab. Reserve
            // the slot for inactive tabs too so the icon doesn't shift
            // vertically when the active tab changes.
            Container(
              height: KuruBottomNav._indicatorHeight,
              width: KuruBottomNav._indicatorWidth,
              decoration: BoxDecoration(
                color: isActive ? c.accent600 : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(2),
                ),
              ),
            ),
            const Spacer(),
            Icon(item.icon, size: 24, color: color),
            const SizedBox(height: 2),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final button = Padding(
      padding: const EdgeInsets.only(right: 16, left: 8),
      child: SizedBox(
        width: KuruBottomNav._actionSize,
        height: KuruBottomNav._actionSize,
        child: Material(
          color: c.accent600,
          shape: const CircleBorder(),
          elevation: 2,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: const Center(
              child: Icon(TablerIcons.plus, size: 24, color: Colors.white),
            ),
          ),
        ),
      ),
    );
    final t = tooltip;
    if (t == null) return button;
    return Tooltip(message: t, child: button);
  }
}
