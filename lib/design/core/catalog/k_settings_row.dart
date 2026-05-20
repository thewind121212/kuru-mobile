import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

class KSettingsRow extends StatelessWidget {
  const KSettingsRow({
    required this.leadingIcon,
    required this.iconBackground,
    required this.iconColor,
    required this.label,
    super.key,
    this.trailingText,
    this.trailingBadge,
    this.labelColor,
    this.showChevron = true,
    this.onTap,
  });

  final IconData leadingIcon;
  final Color iconBackground;
  final Color iconColor;
  final String label;
  final String? trailingText;
  final Widget? trailingBadge;
  final Color? labelColor;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(leadingIcon, size: 19, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: labelColor ?? c.textPrimary,
                  ),
                ),
              ),
              if (trailingBadge != null) ...[
                trailingBadge!,
                const SizedBox(width: 6),
              ],
              if (trailingText != null) ...[
                Text(
                  trailingText!,
                  style: TextStyle(fontSize: 14, color: c.textMuted),
                ),
                const SizedBox(width: 4),
              ],
              if (showChevron)
                Icon(Icons.chevron_right, size: 20, color: c.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
