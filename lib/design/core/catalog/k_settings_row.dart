import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/catalog/k_list_row.dart';

class KSettingsRow extends StatelessWidget {
  const KSettingsRow({
    required this.leadingIcon,
    required this.iconBackground,
    required this.iconColor,
    required this.label,
    super.key,
    this.trailingText,
    this.labelColor,
    this.showChevron = true,
    this.onTap,
  });

  final IconData leadingIcon;
  final Color iconBackground;
  final Color iconColor;
  final String label;
  final String? trailingText;
  final Color? labelColor;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return KListRow(
      leading: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: iconBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(leadingIcon, size: 16, color: iconColor),
      ),
      title: label,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(
              trailingText!,
              style: TextStyle(fontSize: 12, color: c.textMuted),
            ),
            const SizedBox(width: 4),
          ],
          if (showChevron) Icon(Icons.chevron_right, size: 18, color: c.border),
        ],
      ),
      onTap: onTap,
    );
  }
}
