// `showKActionSheet` is a top-level function and conventionally uses
// lower_camelCase; the `K` prefix mirrors our K* widget vocabulary.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// One row in the action sheet. `danger=true` renders text + icon in
/// the danger tone (red) — used for destructive options like "Delete".
class KActionItem<T> {
  const KActionItem({
    required this.id,
    required this.label,
    this.icon,
    this.danger = false,
    this.enabled = true,
  });

  final T id;
  final String label;
  final IconData? icon;
  final bool danger;

  /// Disabled items render at 40% opacity and are untappable. Use this
  /// as the lightweight mobile equivalent of web's `<PermissionGate>` —
  /// feature code computes `enabled: hasPermission`.
  final bool enabled;
}

/// Shows a bottom-up action sheet — Material 3 idiomatic replacement
/// for a 3-dot dropdown menu. Returns the id of the tapped action,
/// or null if the user dismissed.
Future<T?> showKActionSheet<T>({
  required BuildContext context,
  required List<KActionItem<T>> actions,
  String? title,
  bool enableDrag = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _KActionSheet<T>(actions: actions, title: title),
  );
}

class _KActionSheet<T> extends StatelessWidget {
  const _KActionSheet({required this.actions, this.title});

  final List<KActionItem<T>> actions;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: c.surfaceHover,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title!,
                    style: TextStyle(
                      color: c.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            for (final action in actions) _row(context, c, action),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, KuruColors c, KActionItem<T> a) {
    final color = a.danger ? c.danger : c.textPrimary;
    return Opacity(
      opacity: a.enabled ? 1.0 : 0.4,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: a.enabled ? () => Navigator.of(context).pop(a.id) : null,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (a.icon != null) ...[
                  Icon(a.icon, size: 20, color: color),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Text(
                    a.label,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
