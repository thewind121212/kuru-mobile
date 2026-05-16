// `showKColorPicker` is a top-level function and conventionally uses
// lower_camelCase; the `K` prefix mirrors our K* widget vocabulary.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

/// Shows the 26-color picker as a bottom sheet. Tapping a swatch closes
/// the sheet immediately and resolves the future with the picked id —
/// matching kuru-web's behavior. Returns null on dismissal.
Future<String?> showKColorPicker({
  required BuildContext context,
  required String selected,
}) {
  return showKModalSheet<String>(
    context: context,
    title: 'Pick color',
    showCancel: false,
    confirmLabel: 'Done',
    builder: (_) => _KColorPickerBody(initialSelected: selected),
  );
}

class _KColorPickerBody extends StatefulWidget {
  const _KColorPickerBody({required this.initialSelected});

  final String initialSelected;

  @override
  State<_KColorPickerBody> createState() => _KColorPickerBodyState();
}

class _KColorPickerBodyState extends State<_KColorPickerBody> {
  late final String _current = widget.initialSelected;

  String get _currentLabel => kAllColors.firstWhere(
        (c) => c.id == _current,
        orElse: () => const KColorOption(
          id: '',
          label: 'Custom',
          swatch: Colors.transparent,
        ),
      ).label;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text.rich(
            TextSpan(
              text: 'Selected: ',
              style: TextStyle(color: c.textMuted, fontSize: 14),
              children: [
                TextSpan(
                  text: _currentLabel,
                  style: TextStyle(
                    color: c.accent700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            for (final option in kAllColors) _swatch(option),
          ],
        ),
      ],
    );
  }

  Widget _swatch(KColorOption opt) {
    final isSelected = opt.id == _current;
    // Visible ring uses an outer transparent container with a 4dp colored
    // border around a 2dp gap, mirroring web's `ring-4 ring-offset-2`.
    return Semantics(
      label: opt.label,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: () {
          // Tap inside the picker closes the sheet and passes the id back
          // through the sheet result (parity with kuru-web).
          Navigator.of(context).pop(opt.id);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                isSelected ? Border.all(color: opt.swatch, width: 4) : null,
          ),
          padding: isSelected ? const EdgeInsets.all(2) : EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              color: opt.swatch,
              shape: BoxShape.circle,
            ),
            child: isSelected
                ? const Center(
                    child: Icon(
                      TablerIcons.check,
                      size: 18,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
