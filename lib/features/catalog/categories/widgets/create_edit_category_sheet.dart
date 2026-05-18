// TablerIcons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/input/k_select.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/input/k_textarea.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/color_picker_tile.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/icon_picker_tile.dart';

/// Which of the three flows the sheet should run.
///
/// - [CreateRoot] — top-level category. parentId=NIL_UUID, layer="1".
/// - [CreateNested] — child of an existing parent. layer = parent.layer + 1.
/// - [EditCategory] — modify an existing category. parentId/layer untouched.
sealed class CreateEditMode {
  const CreateEditMode();
}

class CreateRoot extends CreateEditMode {
  const CreateRoot();
}

class CreateNested extends CreateEditMode {
  const CreateNested({
    required this.parentId,
    required this.parentName,
    required this.parentLayer,
  });
  final String parentId;
  final String parentName;
  final String parentLayer;
}

class EditCategory extends CreateEditMode {
  const EditCategory({required this.category});
  final gen.CategoryResponse category;
}

/// Shows the Create/Edit category sheet. Returns `true` after a
/// successful save, `null` on cancel / dismiss. Task 6 (this task)
/// ships the form structure with a no-op onConfirm; Task 7 wires the
/// actual save.
Future<bool?> showCreateEditCategorySheet({
  required BuildContext context,
  required CreateEditMode mode,
}) {
  final l = AppLocalizations.of(context);
  final title = switch (mode) {
    CreateRoot() => l.categoryCreateTitle,
    CreateNested() => l.categoryCreateSubcategoryTitle,
    EditCategory() => l.categoryEditTitle,
  };
  return showKModalSheet<bool>(
    context: context,
    title: title,
    confirmLabel: l.categorySaveCta,
    onConfirm: () async {
      // Task 7 replaces this with the real submit. Returning false
      // keeps the sheet open so this scaffold doesn't pretend to save.
      return false;
    },
    builder: (ctx) => _CreateEditBody(mode: mode),
  );
}

class _CreateEditBody extends ConsumerStatefulWidget {
  const _CreateEditBody({required this.mode});
  final CreateEditMode mode;

  @override
  ConsumerState<_CreateEditBody> createState() => _CreateEditBodyState();
}

class _CreateEditBodyState extends ConsumerState<_CreateEditBody> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _status; // "ACTIVE" | "INACTIVE" | "ARCHIVED"
  late String _colorId;
  late String? _iconName;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    final m = widget.mode;
    final cat = m is EditCategory ? m.category : null;
    _nameController = TextEditingController(text: cat?.name ?? '');
    _descriptionController = TextEditingController(
      text: cat?.description ?? '',
    );
    _status = cat?.status ?? 'ACTIVE';
    _colorId = cat?.colorSettings ?? 'slate-400';
    _iconName = cat?.icon ?? 'layout-grid';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final m = widget.mode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KTextField(
            label: l.categoryFieldName,
            controller: _nameController,
            placeholder: l.categoryFieldNameHint,
            errorText: _nameError,
          ),
          const SizedBox(height: 12),
          KSelect<String>(
            label: l.categoryFieldStatus,
            value: _status,
            options: [
              KSelectOption(value: 'ACTIVE', label: l.categoryStatusActive),
              KSelectOption(value: 'INACTIVE', label: l.categoryStatusInactive),
              KSelectOption(value: 'ARCHIVED', label: l.categoryStatusArchived),
            ],
            onChanged: (v) => setState(() => _status = v),
          ),
          const SizedBox(height: 12),
          KTextarea(
            label: l.categoryFieldDescription,
            controller: _descriptionController,
            placeholder: l.categoryFieldDescriptionHint,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: IconPickerTile(
                  label: l.categoryFieldIcon,
                  valueName: _iconName,
                  onChanged: (v) => setState(() => _iconName = v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ColorPickerTile(
                  label: l.categoryFieldColor,
                  valueId: _colorId,
                  onChanged: (v) => setState(() => _colorId = v),
                ),
              ),
            ],
          ),
          if (m is CreateNested) ...[
            const SizedBox(height: 12),
            Text(
              '${l.categoryFieldParent}: ${m.parentName}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
          if (m is EditCategory &&
              (m.category.parentName ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '${l.categoryFieldParent}: ${m.category.parentName}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }
}
