import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

class KSwitchRow extends StatelessWidget {
  const KSwitchRow({
    required this.leadingIcon,
    required this.iconBackground,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
  });

  final IconData leadingIcon;
  final Color iconBackground;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(leadingIcon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      subtitle!,
                      style: TextStyle(fontSize: 12, color: c.textSecondary),
                    ),
                  ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
