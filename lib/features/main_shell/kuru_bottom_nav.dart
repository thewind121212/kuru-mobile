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

/// Floating liquid-glass bottom nav matching the iOS 26 reference design.
///
/// - Pill floats with 16px side margins + 12px bottom margin from the
///   safe-area edge. Uses [BackdropFilter] for a Gaussian blur of the
///   content behind it; the Scaffold must set `extendBody: true` for
///   the blur to have anything to sample.
/// - Icon-only tabs. The active tab gets a soft accent-tinted pill behind
///   its icon (Material 3 indicator style, but smaller and glass-friendly).
///   Labels are kept in [KuruBottomNavItem] for tooltips/semantics but
///   never painted.
/// - Optional trailing `+` action button rendered as a SEPARATE floating
///   accent circle (not docked inside the pill) — preserves the visual
///   separation in the reference screenshot.
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
  static const double _actionSize = 56;
  static const double _sideMargin = 16;
  static const double _indicatorWidth = 24;
  static const double _indicatorHeight = 3;
  // No explicit gap above the home indicator. SafeArea already adds the
  // system inset (~34dp on iPhones with a home bar) — that's clearance
  // enough. Stacking another margin on top wastes scrollable height on
  // shorter screens.
  static const double _bottomMargin = 0;
  static const double _gapBeforeAction = 10;
  static const double _blurSigma = 20;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          _sideMargin,
          0,
          _sideMargin,
          _bottomMargin,
        ),
        child: Row(
          children: [
            Expanded(
              child: _GlassPill(
                tabs: tabs,
                currentIndex: currentIndex,
                onTabChanged: onTabChanged,
              ),
            ),
            if (actionIcon != null) ...[
              const SizedBox(width: _gapBeforeAction),
              _ActionCircle(
                icon: actionIcon!,
                tooltip: actionTooltip,
                onPressed: onActionPressed,
              ),
            ],
          ],
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
  });

  final List<KuruBottomNavItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
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
            border: Border.all(color: c.border.withValues(alpha: 0.6)),
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
                for (var i = 0; i < tabs.length; i++)
                  Expanded(
                    child: _Tab(
                      item: tabs[i],
                      isActive: i == currentIndex,
                      onTap: () => onTabChanged(i),
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
              // 3px top indicator pinned just above the icon, accent when
              // active. Reserves the slot for inactive tabs too so the icon
              // doesn't shift vertically as the active tab changes.
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                height: KuruBottomNav._indicatorHeight,
                width: KuruBottomNav._indicatorWidth,
                decoration: BoxDecoration(
                  color: isActive ? c.accent600 : Colors.transparent,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Icon(item.icon, size: 22, color: tone),
              const SizedBox(height: 2),
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
              color: c.accent600.withValues(alpha: isDark ? 0.4 : 0.32),
              blurRadius: 14,
              offset: const Offset(0, 4),
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
