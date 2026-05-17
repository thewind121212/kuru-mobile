// (flutter_tabler_icons uses snake_case symbols)
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';

/// One choice in a [KSelect]. `value` is the typed payload returned via
/// `onChanged`; `label` is the user-facing string; `icon` is optional.
class KSelectOption<T> {
  const KSelectOption({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final IconData? icon;
}

/// Button-styled form field that opens a [showKActionSheet] picker on tap.
/// Use when the option set is small (~2-8) and a dropdown wouldn't add
/// value — mirrors web's `<Select>` for short enumerations like status,
/// unit, or role.
class KSelect<T> extends StatelessWidget {
  const KSelect({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
    this.errorText,
    this.placeholder,
    this.enabled = true,
  });

  final String label;
  final T? value;
  final List<KSelectOption<T>> options;
  final ValueChanged<T> onChanged;
  final String? errorText;
  final String? placeholder;
  final bool enabled;

  String? get _displayLabel {
    if (value == null) return null;
    for (final o in options) {
      if (o.value == value) return o.label;
    }
    return null;
  }

  Future<void> _open(BuildContext context) async {
    final picked = await showKActionSheet<T>(
      context: context,
      title: label,
      actions: [
        for (final o in options)
          KActionItem<T>(id: o.value, label: o.label, icon: o.icon),
      ],
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final hasError = errorText != null;
    final borderWidth = hasError ? 1.5 : 1.0;
    final display = _displayLabel;
    final showPlaceholder = display == null;
    final shownText = display ?? placeholder ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: enabled ? () => _open(context) : null,
            child: Opacity(
              opacity: enabled ? 1.0 : 0.5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasError ? c.danger : c.border,
                    width: borderWidth,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              color: hasError ? c.danger : c.textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            shownText,
                            style: TextStyle(
                              color: showPlaceholder
                                  ? c.textMuted
                                  : c.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      TablerIcons.chevron_down,
                      size: 18,
                      color: c.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              errorText!,
              style: TextStyle(
                color: c.danger,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
