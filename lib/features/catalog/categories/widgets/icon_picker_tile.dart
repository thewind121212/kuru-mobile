// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/modal/icon_mapping.dart';
import 'package:kuru_mobile/design/core/modal/k_icon_picker.dart';

/// Tappable preview tile that opens [showKIconPicker]. Falls back to
/// [TablerIcons.layout_grid] when the persisted icon name is not in
/// our curated set (per spec §5.4).
class IconPickerTile extends StatelessWidget {
  const IconPickerTile({
    required this.label,
    required this.valueName,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String? valueName;
  final ValueChanged<String> onChanged;

  IconData get _resolvedIcon {
    final name = valueName;
    if (name == null || name.isEmpty) return TablerIcons.layout_grid;
    return resolveIconName(name) ?? TablerIcons.layout_grid;
  }

  Future<void> _open(BuildContext context) async {
    // showKIconPicker requires a non-nullable selected; fall back to
    // 'layout-grid' when valueName is null so the picker pre-selects the
    // default icon.
    final picked = await showKIconPicker(
      context: context,
      selected: valueName ?? 'layout-grid',
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
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
                  Icon(_resolvedIcon, size: 22, color: c.textPrimary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      valueName ?? 'layout-grid',
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
