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
        // Outer GestureDetector — translucent so TextField still gets its
        // own tap (caret + IME), but a tap on the icon, label, or any
        // whitespace inside the glass still focuses the field. Replaces
        // the previous per-child GestureDetectors whose 18px hit boxes
        // missed users tapping just outside the icon.
        GestureDetector(
          onTap: _focusNode.requestFocus,
          behavior: HitTestBehavior.translucent,
          child: KGlass(
            borderRadius: BorderRadius.circular(14),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            borderColor: hasError ? c.danger : null,
            borderWidth: hasError ? 1.5 : null,
            child: Row(
              children: [
                if (widget.icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      color: hasError ? c.danger : c.textMuted,
                      size: 20,
                    ),
                    child: widget.icon!,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 11,
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
                          fontSize: 16,
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
                  // Plain GestureDetector instead of IconButton: IconButton's
                  // InkResponse loses the gesture arena to the screen-level
                  // "tap-outside-to-unfocus" GestureDetector in Login /
                  // Register, which then unfocuses the TextField → keyboard
                  // hides → setState rebuild reveals the password → layout
                  // jumps. A bare GestureDetector with opaque behavior
                  // claims the tap cleanly, and `ExcludeFocus` keeps the
                  // TextField's focus intact across the toggle so the IME
                  // stays open and the screen does not re-flow.
                  ExcludeFocus(
                    child: Semantics(
                      label: _revealed
                          ? l!.fieldPasswordHide
                          : l!.fieldPasswordShow,
                      button: true,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _revealed = !_revealed),
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: Icon(
                            _revealed
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: c.textMuted,
                          ),
                        ),
                      ),
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
