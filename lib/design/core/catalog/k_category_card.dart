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
/// Shows a coloured icon, the category name, a row of stat boxes
/// (e.g. Items / Value), and optional footer bits: a low-stock badge,
/// a trailing action (typically a text link), and a context menu.
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
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: c.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: c.surfaceElev, width: 2),
                    ),
                    child: Icon(icon, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  if (menu != null) menu!,
                ],
              ),
              const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: c.surfaceHover,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stat.label,
            style: TextStyle(fontSize: 12, color: c.textMuted),
          ),
          const SizedBox(height: 2),
          Text(
            stat.value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
