import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// 6-digit OTP entry shown as 6 themed boxes. Paste support (pasted text
/// with 6 digits fills all boxes); `onChanged` fires with the current value
/// every keystroke; `onCompleted` fires once when length hits [length].
///
/// Visual state has three flavours via [status]:
/// - `idle`      → neutral border
/// - `success`   → success-green border (briefly, before navigating away)
/// - `error`     → danger-red border + microcopy below
class KOtpInput extends StatefulWidget {
  const KOtpInput({
    required this.onChanged,
    super.key,
    this.onCompleted,
    this.length = 6,
    this.status = KOtpStatus.idle,
    this.errorText,
    this.enabled = true,
  });

  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final int length;
  final KOtpStatus status;
  final String? errorText;
  final bool enabled;

  @override
  State<KOtpInput> createState() => _KOtpInputState();
}

enum KOtpStatus { idle, success, error }

class _KOtpInputState extends State<KOtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String _value() => _controllers.map((c) => c.text).join();

  void _onCharChanged(int index, String value) {
    if (value.length > 1) {
      // Paste path — distribute digits across boxes from index onwards.
      final digits = value.replaceAll(RegExp(r'\D'), '').characters.toList();
      for (var i = 0; i < digits.length && index + i < widget.length; i++) {
        _controllers[index + i].text = digits[i];
      }
      final next = (index + digits.length).clamp(0, widget.length - 1);
      _focusNodes[next].requestFocus();
    } else if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    final current = _value();
    widget.onChanged(current);
    if (current.length == widget.length && !current.contains(' ')) {
      widget.onCompleted?.call(current);
    }
  }

  KeyEventResult _onKey(int index, FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      widget.onChanged(_value());
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /// Public: parent can clear all boxes (called after a wrong-code attempt).
  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
    widget.onChanged('');
  }

  Color _borderFor(KuruColors c) => switch (widget.status) {
    KOtpStatus.idle => c.border,
    KOtpStatus.success => c.success,
    KOtpStatus.error => c.danger,
  };

  Color _textFor(KuruColors c) => switch (widget.status) {
    KOtpStatus.idle => c.textPrimary,
    KOtpStatus.success => c.success,
    KOtpStatus.error => c.danger,
  };

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final borderColor = _borderFor(c);
    final textColor = _textFor(c);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(widget.length, (i) {
            return Focus(
              onKeyEvent: (node, evt) => _onKey(i, node, evt),
              child: Container(
                width: 48,
                height: 56,
                margin: EdgeInsets.symmetric(
                  horizontal: i == 0 || i == widget.length - 1 ? 0 : 4,
                ),
                decoration: BoxDecoration(
                  color: c.surfaceElev,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  enabled: widget.enabled,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: i == widget.length - 1
                      ? TextInputAction.done
                      : TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    height: 1,
                    letterSpacing: -0.4,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (v) => _onCharChanged(i, v),
                ),
              ),
            );
          }),
        ),
        // Reserved error slot — animates in/out without shifting siblings.
        AnimatedSize(
          duration: const Duration(milliseconds: 160),
          alignment: Alignment.topCenter,
          child: widget.errorText == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 14, color: c.danger),
                      const SizedBox(width: 4),
                      Text(
                        widget.errorText!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: c.danger,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
