// `showKIconPicker` is a top-level function and conventionally uses
// lower_camelCase; the `K` prefix mirrors our K* widget vocabulary.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';
import 'package:kuru_mobile/design/core/modal/icon_mapping.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

/// Shows the curated icon picker as a bottom sheet. Tapping an icon closes
/// the sheet immediately and resolves the future with the picked icon
/// name — matching kuru-web's behavior. Returns null on dismissal.
Future<String?> showKIconPicker({
  required BuildContext context,
  required String selected,
}) {
  return showKModalSheet<String>(
    context: context,
    title: 'Pick icon',
    showCancel: false,
    confirmLabel: 'Done',
    builder: (_) => _KIconPickerBody(initialSelected: selected),
  );
}

class _KIconPickerBody extends StatefulWidget {
  const _KIconPickerBody({required this.initialSelected});

  final String initialSelected;

  @override
  State<_KIconPickerBody> createState() => _KIconPickerBodyState();
}

class _KIconPickerBodyState extends State<_KIconPickerBody> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final results = searchIconsByName(_query);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        KSearchBar(
          hint: 'Search icons...',
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [for (final entry in results) _iconButton(c, entry)],
        ),
      ],
    );
  }

  Widget _iconButton(KuruColors c, KCuratedIcon entry) {
    final isSelected = entry.name == widget.initialSelected;
    return Semantics(
      label: entry.name,
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected ? c.accent600 : c.surfaceHover,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.of(context).pop(entry.name),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            child: Icon(
              entry.icon,
              size: 24,
              color: isSelected ? Colors.white : c.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
