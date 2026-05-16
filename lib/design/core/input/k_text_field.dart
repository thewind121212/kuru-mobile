import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Flat-aesthetic single-line text field. Mirrors web's `CommonInput`
/// with floating label, leading icon, and error slot. Use this for
/// content screens (Catalog/Settings/Home); the existing glass-aesthetic
/// `KFormField` stays in `lib/design/widgets/` for auth/onboarding.
class KTextField extends StatelessWidget {
  const KTextField({
    required this.label,
    required this.controller,
    super.key,
    this.errorText,
    this.leadingIcon,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.obscureText = false,
    this.enabled = true,
    this.maxLength,
    this.autofillHints,
  });

  final String label;
  final TextEditingController controller;
  final String? errorText;
  final Widget? leadingIcon;
  final String? placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final bool enabled;
  final int? maxLength;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final hasError = errorText != null;
    final accent = hasError ? c.danger : c.accent500;
    final borderWidth = hasError ? 1.5 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          maxLength: maxLength,
          autofillHints: autofillHints,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: label,
            hintText: placeholder,
            hintStyle: TextStyle(color: c.textMuted, fontSize: 14),
            labelStyle: TextStyle(
              color: hasError ? c.danger : c.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            floatingLabelStyle: TextStyle(
              color: hasError ? c.danger : accent,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            prefixIcon: leadingIcon == null
                ? null
                : IconTheme(
                    data: IconThemeData(
                      color: hasError ? c.danger : c.textMuted,
                      size: 18,
                    ),
                    child: leadingIcon!,
                  ),
            filled: true,
            fillColor: c.surfaceElev,
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? c.danger : c.border,
                width: borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? c.danger : c.accent500,
                width: borderWidth,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: c.borderSoft),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: hasError
              ? Padding(
                  key: const ValueKey('err'),
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    errorText!,
                    style: TextStyle(
                      color: c.danger,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : const SizedBox(key: ValueKey('ok'), height: 0),
        ),
      ],
    );
  }
}
