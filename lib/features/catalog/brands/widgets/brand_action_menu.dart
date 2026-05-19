// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';

enum BrandAction { edit, delete }

/// Shows the Edit / Delete action sheet for a brand row. Returns the chosen
/// action, or `null` if the user dismissed without picking.
Future<BrandAction?> showBrandActionMenu({
  required BuildContext context,
  required String brandName,
}) {
  final l = AppLocalizations.of(context);
  return showKActionSheet<BrandAction>(
    context: context,
    title: brandName,
    actions: [
      KActionItem(
        id: BrandAction.edit,
        label: l.brandActionEdit,
        icon: TablerIcons.edit,
      ),
      KActionItem(
        id: BrandAction.delete,
        label: l.brandActionDelete,
        icon: TablerIcons.trash,
        danger: true,
      ),
    ],
  );
}
