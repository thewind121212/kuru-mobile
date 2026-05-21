// `showKConfirmDialog` is a top-level function and conventionally uses
// lower_camelCase; the `K` prefix mirrors our K* widget vocabulary.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';

enum KConfirmDialogTone { destructive, info }

/// Shows a centered Material AlertDialog used for confirm/cancel flows
/// (delete, sign out, discard changes). Returns `true` on confirm,
/// `null` on cancel/dismiss.
///
/// If [onConfirm] is provided, the confirm button shows a spinner and
/// the dialog stays open (barrier non-dismissible) while the future
/// resolves — matches kuru-web ConfirmModal `isLoading={isDeleting}`.
/// On exception, the dialog closes resolving `null` (caller surfaces
/// the error toast).
Future<bool?> showKConfirmDialog({
  required BuildContext context,
  required String title,
  String? subtitle,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  KConfirmDialogTone tone = KConfirmDialogTone.destructive,
  Future<void> Function()? onConfirm,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: onConfirm == null, // lock during async work
    builder: (ctx) => _KConfirmDialog(
      title: title,
      subtitle: subtitle,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      tone: tone,
      onConfirm: onConfirm,
    ),
  );
}

class _KConfirmDialog extends StatefulWidget {
  const _KConfirmDialog({
    required this.title,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.tone,
    this.subtitle,
    this.onConfirm,
  });

  final String title;
  final String? subtitle;
  final String confirmLabel;
  final String cancelLabel;
  final KConfirmDialogTone tone;
  final Future<void> Function()? onConfirm;

  @override
  State<_KConfirmDialog> createState() => _KConfirmDialogState();
}

class _KConfirmDialogState extends State<_KConfirmDialog> {
  bool _busy = false;

  Future<void> _handleConfirm() async {
    if (widget.onConfirm == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _busy = true);
    try {
      await widget.onConfirm!();
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on Object catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop(); // null — caller toasts error
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final isDestructive = widget.tone == KConfirmDialogTone.destructive;
    final iconBg = isDestructive ? c.dangerSoft : c.accent50;
    final iconColor = isDestructive ? c.danger : c.accent600;
    final icon = isDestructive
        ? TablerIcons.alert_triangle
        : TablerIcons.info_circle;

    return Dialog(
      backgroundColor: c.surfaceElev,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: iconColor),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: c.textMuted, fontSize: 14),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: KSecondaryBtn(
                      label: widget.cancelLabel,
                      size: KBtnSize.md,
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _busy ? null : _handleConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDestructive
                              ? c.danger
                              : c.accent600,
                          disabledBackgroundColor:
                              (isDestructive ? c.danger : c.accent600)
                                  .withValues(alpha: 0.5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _busy
                            ? const KSpinner(color: Colors.white)
                            : Text(
                                widget.confirmLabel,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
