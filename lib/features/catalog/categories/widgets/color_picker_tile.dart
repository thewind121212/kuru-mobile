// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';
import 'package:kuru_mobile/design/core/modal/k_color_picker.dart';

/// Tappable preview tile that opens [showKColorPicker]. Mirrors the
/// shape of KSelect (label above + value row + chevron) but routes
/// through the dedicated color-picker grid instead of an action sheet.
class ColorPickerTile extends StatelessWidget {
  const ColorPickerTile({
    required this.label,
    required this.valueId,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String valueId;
  final ValueChanged<String> onChanged;

  KColorOption get _resolved {
    for (final co in kAllColors) {
      if (co.id == valueId) return co;
    }
    return kAllColors.first; // slate-400 fallback
  }

  Future<void> _open(BuildContext context) async {
    final picked = await showKColorPicker(context: context, selected: valueId);
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final resolved = _resolved;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: c.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () => _open(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: c.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: resolved.swatch,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      resolved.label,
                      style: TextStyle(fontSize: 14, color: c.textPrimary),
                    ),
                  ),
                  Icon(TablerIcons.chevron_down, color: c.textMuted, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
