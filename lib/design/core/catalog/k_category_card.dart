import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// A single stat shown in a [KCategoryCard].
@immutable
class KCategoryCardStat {
  const KCategoryCardStat({required this.label, required this.value});

  final String label;
  final String value;
}

/// A grid-view card for a catalog category.
///
/// Soft iOS-native look matching
/// `docs/superpowers/specs/2026-05-20-ui-style-guide.md`: 18-radius
/// surface, no outer border, 40-rounded-square icon tile (color glyph on
/// a tinted background), inset stat boxes with no border.
class KCategoryCard extends StatelessWidget {
  const KCategoryCard({
    required this.icon,
    required this.iconBg,
    required this.name,
    required this.stats,
    super.key,
    this.lowStockBadge,
    this.trailingAction,
    this.menu,
    this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final String name;
  final List<KCategoryCardStat> stats;
  final Widget? lowStockBadge;
  final Widget? trailingAction;
  final Widget? menu;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBg.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, size: 20, color: iconBg),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  if (menu != null) menu!,
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  for (var i = 0; i < stats.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(child: _statBox(c, stats[i])),
                  ],
                ],
              ),
              if (lowStockBadge != null || trailingAction != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (lowStockBadge != null) lowStockBadge!,
                    const Spacer(),
                    if (trailingAction != null) trailingAction!,
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox(KuruColors c, KCategoryCardStat stat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: c.surfaceHover,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(stat.label, style: TextStyle(fontSize: 12, color: c.textMuted)),
          const SizedBox(height: 2),
          Text(
            stat.value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
