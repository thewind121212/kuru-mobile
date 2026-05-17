import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

enum KBadgeTone { neutral, info, success, warning, danger, accent }

enum KBadgeSize { sm, md }

/// Pill-shaped status indicator. 6 tones, 2 sizes. Mirrors
/// `../gen-barcode/fe/src/core-design/badge/Badge.tsx`.
class KBadge extends StatelessWidget {
  const KBadge({
    required this.label,
    super.key,
    this.tone = KBadgeTone.neutral,
    this.size = KBadgeSize.sm,
    this.leadingIcon,
  });

  final String label;
  final KBadgeTone tone;
  final KBadgeSize size;
  final IconData? leadingIcon;

  ({Color bg, Color fg, Color ring}) _palette(KuruColors c) {
    switch (tone) {
      case KBadgeTone.neutral:
        return (bg: c.surfaceHover, fg: c.textSecondary, ring: c.border);
      case KBadgeTone.info:
        return (
          bg: c.secondarySoft,
          fg: c.secondary,
          ring: c.secondary.withValues(alpha: 0.3),
        );
      case KBadgeTone.success:
        return (
          bg: c.successSoft,
          fg: c.success,
          ring: c.success.withValues(alpha: 0.3),
        );
      case KBadgeTone.warning:
        return (
          bg: c.warningSoft,
          fg: c.warning,
          ring: c.warning.withValues(alpha: 0.3),
        );
      case KBadgeTone.danger:
        return (
          bg: c.dangerSoft,
          fg: c.danger,
          ring: c.danger.withValues(alpha: 0.3),
        );
      case KBadgeTone.accent:
        return (bg: c.accent50, fg: c.accent700, ring: c.accent200);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final p = _palette(c);
    final isSm = size == KBadgeSize.sm;
    final hPad = isSm ? 8.0 : 10.0;
    final vPad = isSm ? 2.0 : 4.0;
    final fontSize = isSm ? 11.0 : 12.0;
    final iconSize = isSm ? 12.0 : 14.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: p.ring),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: iconSize, color: p.fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: p.fg,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 16 / fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
