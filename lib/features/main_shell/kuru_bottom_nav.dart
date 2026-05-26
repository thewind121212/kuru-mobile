import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// One destination in [KuruBottomNav].
class KuruBottomNavItem {
  const KuruBottomNavItem({required this.icon, required this.label});

  /// Tabler icon rendered in the pill. Labels are not painted but are kept
  /// for tooltips + semantics.
  final IconData icon;
  final String label;
}

/// Floating liquid-glass bottom nav.
///
/// - Pill floats with 16px side margins + 12px bottom margin from the
///   safe-area edge. Uses [BackdropFilter] for a Gaussian blur of the
///   content behind it; the Scaffold must set `extendBody: true` for
///   the blur to have anything to sample.
/// - Four regular tabs sit around an optional centered action slot. The
///   action is rendered inside the pill, not over a reserved hole, so the
///   center reads as one intentional control.
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
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final String? actionTooltip;

  // Tunables. Icon + label needs more vertical room than an icon-only bar.
  static const double _pillHeight = 68;
  static const double _pillRadius = 32;
  static const double _actionSize = 48;
  static const double _sideMargin = 16;
  // Total clearance from the screen bottom edge to the pill. iOS reserves
  // ~34dp for the home indicator via MediaQuery.viewPadding.bottom; that
  // SafeArea inset (when used) is too generous and pushes the pill far
  // above the indicator line. 12dp is a tight visual gap that still
  // clears the indicator's interactive zone.
  static const double _bottomGap = 12;
  static const double _blurSigma = 20;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _sideMargin,
        0,
        _sideMargin,
        _bottomGap,
      ),
      child: SizedBox(
        height: _pillHeight,
        child: _GlassPill(
          tabs: tabs,
          currentIndex: currentIndex,
          onTabChanged: onTabChanged,
          actionIcon: actionIcon,
          actionTooltip: actionTooltip,
          onActionPressed: onActionPressed,
        ),
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    this.actionIcon,
    this.actionTooltip,
    this.onActionPressed,
  });

  final List<KuruBottomNavItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final IconData? actionIcon;
  final String? actionTooltip;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final splitIndex = tabs.length ~/ 2;
    final hasAction = actionIcon != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // The fill is the theme's surfaceElev tinted with alpha — gives the
    // backdrop blur a tone to layer over (pure transparent + blur reads
    // as a smudge; this reads as glass).
    final fill = c.surfaceElev.withValues(alpha: isDark ? 0.55 : 0.7);
    return ClipRRect(
      borderRadius: BorderRadius.circular(KuruBottomNav._pillRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: KuruBottomNav._blurSigma,
          sigmaY: KuruBottomNav._blurSigma,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(KuruBottomNav._pillRadius),
            // Border removed per design feedback — the glass blur +
            // shadow already separates the pill from the body content.
            // Subtle drop shadow to make the pill read as elevated above
            // the body content below.
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SizedBox(
            height: KuruBottomNav._pillHeight,
            child: Row(
              children: [
                for (var i = 0; i < tabs.length; i++) ...[
                  if (i == splitIndex && hasAction)
                    Expanded(
                      child: _ActionSlot(
                        icon: actionIcon!,
                        tooltip: actionTooltip,
                        onPressed: onActionPressed,
                      ),
                    ),
                  Expanded(
                    child: _Tab(
                      item: tabs[i],
                      isActive: i == currentIndex,
                      onTap: () => onTabChanged(i),
                    ),
                  ),
                ],
              ],
            ),
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
    final tone = isActive ? c.accent600 : c.textMuted;
    return Semantics(
      label: item.label,
      button: true,
      selected: isActive,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: SizedBox(
          height: KuruBottomNav._pillHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Active state is conveyed via icon + label tint and weight
              // alone — the 3dp top-indicator bar was reading as a stray
              // top border on the pill and was dropped per design
              // feedback.
              Icon(item.icon, size: 24, color: tone),
              const SizedBox(height: 4),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: tone,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionSlot extends StatelessWidget {
  const _ActionSlot({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: KuruBottomNav._pillHeight,
      child: Center(
        child: _ActionCircle(
          icon: icon,
          tooltip: tooltip,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  const _ActionCircle({
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final button = SizedBox(
      width: KuruBottomNav._actionSize,
      height: KuruBottomNav._actionSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.accent600,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: c.accent600.withValues(alpha: isDark ? 0.22 : 0.16),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Center(child: Icon(icon, size: 26, color: Colors.white)),
          ),
        ),
      ),
    );
    final t = tooltip;
    if (t == null) return button;
    return Tooltip(message: t, child: button);
  }
}
