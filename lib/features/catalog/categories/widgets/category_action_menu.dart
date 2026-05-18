// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';

/// Which action the user picked from the category action sheet.
enum CategoryAction { edit, delete, addSubcategory }

/// Opens the Edit / Add-subcategory / Delete action sheet for the given
/// [category]. Returns the picked action, or null on dismiss.
///
/// Plan 1 stubbed [KPopupMenu] (super_context_menu crashes on iOS 26);
/// this helper is the bottom-sheet fallback that Plan 2 uses for both
/// the kebab tap and the long-press handler on category cards.
///
/// [canAddSubcategory] — pass `false` when the category is already at
/// MAX_LAYER (5). The sheet still renders the item but disables it so
/// the affordance stays predictable.
Future<CategoryAction?> showCategoryActionMenu({
  required BuildContext context,
  required gen.CategoryResponse category,
  required bool canAddSubcategory,
}) async {
  final l = AppLocalizations.of(context);
  return showKActionSheet<CategoryAction>(
    context: context,
    title: category.name ?? '',
    actions: [
      KActionItem<CategoryAction>(
        id: CategoryAction.edit,
        label: l.categoryActionEdit,
        icon: TablerIcons.edit,
      ),
      KActionItem<CategoryAction>(
        id: CategoryAction.addSubcategory,
        label: l.categoryActionAddSubcategory,
        icon: TablerIcons.plus,
        enabled: canAddSubcategory,
      ),
      KActionItem<CategoryAction>(
        id: CategoryAction.delete,
        label: l.categoryActionDelete,
        icon: TablerIcons.trash,
        danger: true,
      ),
    ],
  );
}
