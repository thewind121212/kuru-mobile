import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/widgets/k_glass.dart';

class KFormField extends StatefulWidget {
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

  /// When true, a show/hide eye toggle is rendered on the right and the
  /// field starts obscured. Callers don't manage the reveal state — it lives
  /// privately inside this widget. The semantics of [obscureText] itself
  /// (initial = obscured) are unchanged from the v0.2.0 API.
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
  State<KFormField> createState() => _KFormFieldState();
}

class _KFormFieldState extends State<KFormField> {
  late bool _revealed;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _revealed = false;
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final hasError = widget.errorText != null;
    final showEye = widget.obscureText;
    final effectivelyObscured = widget.obscureText && !_revealed;
    final l = showEye ? AppLocalizations.of(context) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Wrapping the field with a translucent GestureDetector lets a tap
        // on the icon, label, or whitespace focus the TextField — the
        // TextField still wins taps in its own bounds (cursor positioning
        // preserved), and the eye IconButton wins its own area too.
        GestureDetector(
          onTap: _focusNode.requestFocus,
          behavior: HitTestBehavior.translucent,
          child: KGlass(
            borderRadius: BorderRadius.circular(14),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            borderColor: hasError ? c.danger : null,
            borderWidth: hasError ? 1.5 : null,
            child: Row(
              children: [
                if (widget.icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      color: hasError ? c.danger : c.textMuted,
                      size: 18,
                    ),
                    child: widget.icon!,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: hasError ? c.danger : c.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      TextField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        obscureText: effectivelyObscured,
                        keyboardType: widget.keyboardType,
                        autofillHints: widget.autofillHints,
                        textInputAction: widget.textInputAction,
                        onSubmitted: widget.onSubmitted,
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
                if (showEye) ...[
                  const SizedBox(width: 6),
                  IconButton(
                    tooltip: _revealed
                        ? l!.fieldPasswordHide
                        : l!.fieldPasswordShow,
                    onPressed: () => setState(() => _revealed = !_revealed),
                    icon: Icon(
                      _revealed
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: c.textMuted,
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints.tightFor(
                      width: 32,
                      height: 32,
                    ),
                  ),
                ],
              ],
            ),
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
                      Icon(Icons.error_outline, size: 12, color: c.danger),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          widget.errorText!,
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
