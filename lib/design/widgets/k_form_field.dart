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
    this.errorText,
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

  /// Field-level error microcopy. When non-null:
  /// - The KGlass border switches to the danger tone (1.5px).
  /// - A red 11px text appears below the field in a reserved slot — when
  ///   null the slot is collapsed, so the field's own height stays compact.
  /// Use this for credential errors (wrong password, taken email) instead
  /// of a separate banner that shoves the form down.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        KGlass(
          borderRadius: BorderRadius.circular(14),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          borderColor: hasError ? c.danger : null,
          borderWidth: hasError ? 1.5 : null,
          child: Row(
            children: [
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: hasError ? c.danger : c.textMuted,
                    size: 18,
                  ),
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
                        color: hasError ? c.danger : c.textMuted,
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
        ),
        // Helper slot — animates between 0 and ~20px so the layout doesn't
        // jolt when the error appears.
        AnimatedSize(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          alignment: Alignment.topLeft,
          child: hasError
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(6, 4, 6, 0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 12,
                        color: c.danger,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          errorText!,
                          style: TextStyle(
                            fontSize: 11,
                            color: c.danger,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
