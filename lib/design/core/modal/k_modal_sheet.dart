// `showKModalSheet` is a top-level function and conventionally uses
// lower_camelCase; the `K` prefix mirrors our K* widget vocabulary.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';

enum KConfirmTone { primary, danger }

/// Opens a Material 3 bottom sheet with a consistent K header/footer.
///
/// - [title] / [subtitle] render in the header.
/// - [builder] supplies the body (gets a [BuildContext] so it can pop the
///   sheet itself with `Navigator.of(ctx).pop(value)`).
/// - If [confirmLabel] is non-null, a footer with Cancel + Confirm renders.
///   [onConfirm] returns `true` to close the sheet (resolving the returned
///   future with `true`), or `false` to keep it open (validation failure).
/// - Returns whatever the body pops (or `true` from a confirm flow, or `null`
///   on dismissal).
Future<T?> showKModalSheet<T>({
  required BuildContext context,
  required String title,
  required WidgetBuilder builder,
  String? subtitle,
  String? confirmLabel,
  String cancelLabel = 'Cancel',
  Future<bool> Function()? onConfirm,
  KConfirmTone confirmTone = KConfirmTone.primary,
  bool isDismissible = true,
  bool enableDrag = true,
  bool disableConfirm = false,
  bool showCancel = true,
  Widget? loadingBody,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (ctx) => _KModalSheet<T>(
      title: title,
      subtitle: subtitle,
      builder: builder,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      confirmTone: confirmTone,
      disableConfirm: disableConfirm,
      showCancel: showCancel,
      loadingBody: loadingBody,
    ),
  );
}

class _KModalSheet<T> extends StatefulWidget {
  const _KModalSheet({
    required this.title,
    required this.builder,
    this.subtitle,
    this.confirmLabel,
    this.cancelLabel = 'Cancel',
    this.onConfirm,
    this.confirmTone = KConfirmTone.primary,
    this.disableConfirm = false,
    this.showCancel = true,
    this.loadingBody,
  });

  final String title;
  final String? subtitle;
  final WidgetBuilder builder;
  final String? confirmLabel;
  final String cancelLabel;
  final Future<bool> Function()? onConfirm;
  final KConfirmTone confirmTone;
  final bool disableConfirm;
  final bool showCancel;
  final Widget? loadingBody;

  @override
  State<_KModalSheet<T>> createState() => _KModalSheetState<T>();
}

class _KModalSheetState<T> extends State<_KModalSheet<T>> {
  bool _busy = false;

  Future<void> _handleConfirm() async {
    if (widget.onConfirm == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _busy = true);
    final shouldClose = await widget.onConfirm!();
    if (!mounted) return;
    setState(() => _busy = false);
    if (shouldClose) {
      // Cast is intentional: callers using onConfirm typically use T = bool
      // or T = void. Body-driven flows pop their own typed result inside
      // builder via Navigator.of(ctx).pop(value).
      Navigator.of(context).pop(true as T?);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final insets = MediaQuery.of(context).viewInsets;

    return AnimatedPadding(
      padding: insets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(c),
              _buildHeader(c),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: widget.loadingBody ?? Builder(builder: widget.builder),
                ),
              ),
              if (widget.confirmLabel != null) _buildFooter(c),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle(KuruColors c) => Container(
    margin: const EdgeInsets.only(top: 8),
    width: 40,
    height: 4,
    decoration: BoxDecoration(
      color: c.surfaceHover,
      borderRadius: BorderRadius.circular(999),
    ),
  );

  Widget _buildHeader(KuruColors c) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  widget.subtitle!,
                  style: TextStyle(color: c.textMuted, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        Semantics(
          label: 'Close',
          button: true,
          child: IconButton(
            icon: Icon(TablerIcons.x, color: c.textMuted, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    ),
  );

  Widget _buildFooter(KuruColors c) => Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: c.borderSoft)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.showCancel) ...[
          KSecondaryBtn(
            label: widget.cancelLabel,
            size: KBtnSize.md,
            fullWidth: false,
            onPressed: _busy ? null : () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
        ],
        _buildConfirmButton(c),
      ],
    ),
  );

  Widget _buildConfirmButton(KuruColors c) {
    final bg = widget.confirmTone == KConfirmTone.danger
        ? c.danger
        : c.accent600;
    final disabled = _busy || widget.disableConfirm;
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: disabled ? null : _handleConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          disabledBackgroundColor: bg.withValues(alpha: 0.5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 0,
        ),
        child: _busy
            ? const KSpinner(color: Colors.white)
            : Text(
                widget.confirmLabel!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
