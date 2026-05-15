import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/widgets/k_glass.dart';

class KFormField extends StatelessWidget {
  const KFormField({
    required this.label,
    required this.controller,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final Widget? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return KGlass(
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(color: c.textMuted, size: 18),
              child: icon!,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: c.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                TextField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  autofillHints: autofillHints,
                  textInputAction: textInputAction,
                  onSubmitted: onSubmitted,
                  style: TextStyle(
                    fontSize: 14,
                    color: c.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
