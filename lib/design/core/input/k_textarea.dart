import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Flat-aesthetic multi-line text input. Same chrome as `KTextField`
/// but expands vertically. Optional character counter when `maxLength`
/// is set. Used for description / notes fields.
class KTextarea extends StatefulWidget {
  const KTextarea({
    required this.label,
    required this.controller,
    super.key,
    this.errorText,
    this.placeholder,
    this.minLines = 3,
    this.maxLines = 6,
    this.maxLength,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final String? errorText;
  final String? placeholder;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final bool enabled;

  @override
  State<KTextarea> createState() => _KTextareaState();
}

class _KTextareaState extends State<KTextarea> {
  @override
  void initState() {
    super.initState();
    if (widget.maxLength != null) {
      widget.controller.addListener(_onText);
    }
  }

  void _onText() => setState(() {});

  @override
  void dispose() {
    if (widget.maxLength != null) {
      widget.controller.removeListener(_onText);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final hasError = widget.errorText != null;
    final borderWidth = hasError ? 1.5 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.placeholder,
            hintStyle: TextStyle(color: c.textMuted, fontSize: 14),
            labelStyle: TextStyle(
              color: hasError ? c.danger : c.textMuted,
              fontSize: 14,
            ),
            floatingLabelStyle: TextStyle(
              color: hasError ? c.danger : c.accent500,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            alignLabelWithHint: true,
            filled: true,
            fillColor: c.surfaceElev,
            counterText: '', // we render our own counter below
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: hasError
                    ? Text(
                        widget.errorText!,
                        style: TextStyle(
                          color: c.danger,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              if (widget.maxLength != null)
                Text(
                  '${widget.controller.text.length}/${widget.maxLength}',
                  style: TextStyle(color: c.textMuted, fontSize: 11),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
