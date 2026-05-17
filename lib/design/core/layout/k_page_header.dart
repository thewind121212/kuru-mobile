import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Inline page header used at the top of content-screen bodies. Holds the
/// page title + optional subtitle on the left, trailing actions on the
/// right. Not a SliverAppBar — sits inside the body as a fixed-height row
/// so it scrolls away with content (mobile-native feel).
class KPageHeader extends StatelessWidget {
  const KPageHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final actionList = actions;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: c.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          if (actionList != null)
            Row(
              children: [
                for (var i = 0; i < actionList.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  actionList[i],
                ],
              ],
            ),
        ],
      ),
    );
  }
}
