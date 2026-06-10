import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// One destination in [KuruBottomNav].
class KuruBottomNavItem {
  const KuruBottomNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Floating wallet-style bottom nav.
class KuruBottomNav extends StatelessWidget {
  const KuruBottomNav({
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    super.key,
    this.actionIcon,
    this.actionLabel,
    this.onActionPressed,
    this.actionTooltip,
  });

  final List<KuruBottomNavItem> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final IconData? actionIcon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final String? actionTooltip;

  @override
  Widget build(BuildContext context) {
    final splitIndex = tabs.length ~/ 2;
    final hasAction = actionIcon != null;

    return KuruBottomBarFrame(
      action: hasAction
          ? Icon(actionIcon, size: 31, color: Colors.white)
          : null,
      actionTooltip: actionTooltip,
      onActionPressed: onActionPressed,
      reserveActionSpace: false,
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i == splitIndex && hasAction)
              Expanded(
                child: _ActionSlot(
                  label: actionLabel,
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
    );
  }
}

class KuruBottomBarFrame extends StatelessWidget {
  const KuruBottomBarFrame({
    required this.child,
    super.key,
    this.action,
    this.actionTooltip,
    this.onActionPressed,
    this.reserveActionSpace = true,
  });

  final Widget child;
  final Widget? action;
  final String? actionTooltip;
  final VoidCallback? onActionPressed;
  final bool reserveActionSpace;

  static const double pillHeight = 76;
  static const double pillRadius = 34;
  static const double actionSize = 64;
  static const double notchRadius = 38;
  static const double notchCenterY = 8;
  static const double actionTopInset = actionSize / 2;
  static const double compactHeight = pillHeight - notchCenterY;
  static const double height = pillHeight + actionTopInset - notchCenterY;
  static const double sideMargin = 16;
  static const double bottomGap = 12;
  static const double blurSigma = 18;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final hasAction = action != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = isDark
        ? c.surfaceElev.withValues(alpha: 0.82)
        : Colors.white.withValues(alpha: 0.88);
    final shadowColor = isDark ? Colors.black : c.accent700;

    return Padding(
      padding: const EdgeInsets.fromLTRB(sideMargin, 0, sideMargin, bottomGap),
      child: SizedBox(
        height: reserveActionSpace ? height : compactHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: pillHeight,
              child: CustomPaint(
                painter: _NotchedPillShadowPainter(
                  color: shadowColor.withValues(alpha: isDark ? 0.34 : 0.16),
                  radius: pillRadius,
                  notchRadius: notchRadius,
                  notchCenterY: notchCenterY,
                ),
                child: ClipPath(
                  clipper: const _NotchedPillClipper(
                    radius: pillRadius,
                    notchRadius: notchRadius,
                    notchCenterY: notchCenterY,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurSigma,
                      sigmaY: blurSigma,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: fill),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
            if (hasAction)
              Positioned(
                top: reserveActionSpace ? 0 : -actionTopInset,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: _ActionCircle(
                    tooltip: actionTooltip,
                    onPressed: onActionPressed,
                    child: action!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotchedPillClipper extends CustomClipper<Path> {
  const _NotchedPillClipper({
    required this.radius,
    required this.notchRadius,
    required this.notchCenterY,
  });

  final double radius;
  final double notchRadius;
  final double notchCenterY;

  @override
  Path getClip(Size size) {
    return _notchedPillPath(
      size,
      radius: radius,
      notchRadius: notchRadius,
      notchCenterY: notchCenterY,
    );
  }

  @override
  bool shouldReclip(_NotchedPillClipper oldClipper) {
    return radius != oldClipper.radius ||
        notchRadius != oldClipper.notchRadius ||
        notchCenterY != oldClipper.notchCenterY;
  }
}

class _NotchedPillShadowPainter extends CustomPainter {
  const _NotchedPillShadowPainter({
    required this.color,
    required this.radius,
    required this.notchRadius,
    required this.notchCenterY,
  });

  final Color color;
  final double radius;
  final double notchRadius;
  final double notchCenterY;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _notchedPillPath(
      size,
      radius: radius,
      notchRadius: notchRadius,
      notchCenterY: notchCenterY,
    );
    canvas
      ..drawShadow(path.shift(const Offset(0, 3)), Colors.black26, 8, true)
      ..drawShadow(path.shift(const Offset(0, 8)), color, 18, true);
  }

  @override
  bool shouldRepaint(_NotchedPillShadowPainter oldDelegate) {
    return color != oldDelegate.color ||
        radius != oldDelegate.radius ||
        notchRadius != oldDelegate.notchRadius ||
        notchCenterY != oldDelegate.notchCenterY;
  }
}

Path _notchedPillPath(
  Size size, {
  required double radius,
  required double notchRadius,
  required double notchCenterY,
}) {
  return Path()
    ..fillType = PathFillType.evenOdd
    ..addRRect(
      RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
    )
    ..addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, notchCenterY),
        radius: notchRadius,
      ),
    );
}

class _Tab extends StatelessWidget {
  const _Tab({required this.item, required this.isActive, required this.onTap});

  final KuruBottomNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tone = isActive ? c.accent600 : c.textMuted;
    final activeFill = isDark
        ? c.accent600.withValues(alpha: 0.18)
        : c.accent50.withValues(alpha: 0.9);

    return Semantics(
      label: item.label,
      button: true,
      selected: isActive,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 7),
        child: Material(
          color: isActive ? activeFill : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(32),
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 25, color: tone),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: tone,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionSlot extends StatelessWidget {
  const _ActionSlot({required this.onPressed, this.label, this.tooltip});

  final String? label;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final text = label;
    return Semantics(
      label: tooltip ?? label,
      button: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(32),
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 3, right: 3),
          child: Center(
            child: text == null
                ? const SizedBox.shrink()
                : Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: c.accent600,
                      height: 1.1,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  const _ActionCircle({
    required this.child,
    required this.onPressed,
    this.tooltip,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final button = SizedBox(
      width: KuruBottomBarFrame.actionSize,
      height: KuruBottomBarFrame.actionSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.accent600,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: c.accent600.withValues(alpha: isDark ? 0.36 : 0.34),
              blurRadius: 24,
              offset: const Offset(0, 12),
              spreadRadius: -6,
            ),
            BoxShadow(
              color: c.accent600.withValues(alpha: isDark ? 0.22 : 0.18),
              blurRadius: 42,
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
            child: Center(child: child),
          ),
        ),
      ),
    );
    final t = tooltip;
    if (t == null) return button;
    return Tooltip(message: t, child: button);
  }
}
