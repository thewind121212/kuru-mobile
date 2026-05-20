// (flutter_tabler_icons uses snake_case symbols)
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/text/search_normalize.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

/// Value object for one row in [CategoryBrandPickerSheetBody].
class PickerItem {
  const PickerItem({required this.id, required this.name, this.subtitle});

  final String id;
  final String name;
  final String? subtitle;
}

/// Opens a bottom sheet that lets the user pick (or clear) a category/brand.
///
/// Result semantics:
/// - returns `null` when the user taps the "Bỏ chọn" row (clear selection),
/// - returns the picked item id `String` when the user taps a row,
/// - returns `null` on dismissal as well — callers can distinguish by tracking
///   whether they expected a pop (e.g. check the future completed via tap).
///
/// Because "Bỏ chọn" and "dismiss" both resolve with `null`, prefer using
/// distinct UI for the two cases at the call site if needed (e.g. always
/// reflecting the popped value as the new selection).
Future<String?> showCategoryBrandPickerSheet({
  required BuildContext context,
  required String title,
  required List<PickerItem> items,
  required String? selectedId,
}) {
  return showKModalSheet<String?>(
    context: context,
    title: title,
    builder: (ctx) => CategoryBrandPickerSheetBody(
      title: title,
      items: items,
      selectedId: selectedId,
    ),
  );
}

/// Searchable list body used inside [showCategoryBrandPickerSheet]. Exposed
/// so widget tests can pump it directly without wrestling the bottom sheet.
class CategoryBrandPickerSheetBody extends StatefulWidget {
  const CategoryBrandPickerSheetBody({
    required this.title,
    required this.items,
    required this.selectedId,
    super.key,
  });

  final String title;
  final List<PickerItem> items;
  final String? selectedId;

  @override
  State<CategoryBrandPickerSheetBody> createState() =>
      _CategoryBrandPickerSheetBodyState();
}

class _CategoryBrandPickerSheetBodyState
    extends State<CategoryBrandPickerSheetBody> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() => _query = _ctrl.text));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<PickerItem> get _filtered {
    if (_query.trim().isEmpty) return widget.items;
    final n = normalizeForSearch(_query);
    return widget.items
        .where((i) => normalizeForSearch(i.name).contains(n))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final filtered = _filtered;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: TextField(
            controller: _ctrl,
            decoration: InputDecoration(
              hintText: 'Tìm…',
              prefixIcon: const Icon(TablerIcons.search),
              filled: true,
              fillColor: c.pageBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: Icon(TablerIcons.x, color: c.danger),
                title: Text('Bỏ chọn', style: TextStyle(color: c.danger)),
                onTap: () => Navigator.of(context).pop<String?>(),
              ),
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Không tìm thấy',
                      style: TextStyle(color: c.textMuted),
                    ),
                  ),
                )
              else
                ...filtered.map(
                  (i) => ListTile(
                    leading: Icon(TablerIcons.folder, color: c.primary),
                    title: Text(i.name),
                    subtitle: i.subtitle == null ? null : Text(i.subtitle!),
                    trailing: i.id == widget.selectedId
                        ? Icon(TablerIcons.check, color: c.success)
                        : Icon(TablerIcons.chevron_right, color: c.textMuted),
                    onTap: () => Navigator.of(context).pop<String?>(i.id),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
