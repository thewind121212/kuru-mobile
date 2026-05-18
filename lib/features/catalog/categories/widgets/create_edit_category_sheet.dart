// TablerIcons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/input/k_select.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/input/k_textarea.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
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
/// successful save, `null` on cancel / dismiss.
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
  final formKey = GlobalKey<_CreateEditBodyState>();
  return showKModalSheet<bool>(
    context: context,
    title: title,
    confirmLabel: l.categorySaveCta,
    onConfirm: () async {
      final state = formKey.currentState;
      if (state == null) return false;
      return state._submit();
    },
    builder: (ctx) => _CreateEditBody(key: formKey, mode: mode),
  );
}

class _CreateEditBody extends ConsumerStatefulWidget {
  const _CreateEditBody({required this.mode, super.key});
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

  /// Returns true on success (sheet closes), false on failure (stays open).
  Future<bool> _submit() async {
    setState(() => _nameError = null);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(
        () => _nameError = AppLocalizations.of(context).validationNameRequired,
      );
      return false;
    }
    final m = widget.mode;
    final repo = ref.read(categoryRepositoryProvider);

    // Derive parentId + layer from mode.
    const nilUuid = '00000000-0000-0000-0000-000000000000';
    final (parentId, layer) = switch (m) {
      CreateRoot() => (nilUuid, '1'),
      CreateNested(:final parentId, :final parentLayer) => (
        parentId,
        (int.parse(parentLayer) + 1).toString(),
      ),
      EditCategory(:final category) => (
        category.parentId ?? nilUuid,
        category.layer ?? '1',
      ),
    };

    final desc = _descriptionController.text.trim();
    final req = gen.CreateCategoryRequest(
      (b) => b
        ..name = name
        ..parentId = parentId
        ..layer = layer
        ..status = _status
        ..colorSettings = _colorId
        ..icon = _iconName
        ..description = desc.isEmpty ? null : desc,
    );

    switch (m) {
      case CreateRoot() || CreateNested():
        final result = await repo.create(req);
        return _handleResult(result, m);
      case EditCategory(:final category):
        final result = await repo.update(
          categoryId: category.categoryId!,
          update: req,
        );
        return _handleResult(result, m);
    }
  }

  bool _handleResult(ApiResult<Object?> result, CreateEditMode m) {
    if (!mounted) return false;
    switch (result) {
      case ApiSuccess<Object?>():
        // Invalidate per spec §3.4.
        ref.invalidate(categoryOverviewProvider);
        if (m is CreateNested) {
          ref.invalidate(categoryByIdProvider(m.parentId));
        } else if (m is EditCategory) {
          ref.invalidate(categoryByIdProvider(m.category.categoryId!));
        }
        return true;
      case ApiFailure<Object?>(:final err):
        _surfaceError(err);
        return false;
    }
  }

  void _surfaceError(ApiException err) {
    final l = AppLocalizations.of(context);
    switch (err) {
      case BadRequestException():
        // 400 — surface verbatim on the Name field. Most BE validation
        // messages we see in practice are name-related; later we can
        // route to the right field based on err.code.
        setState(() => _nameError = err.message);
      case ForbiddenException():
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.categoryNotifyForbidden)));
      case UnauthorizedException():
        // 401 — defer to caller; the dio interceptor stack already
        // routes through the auth redirect. Just close the sheet.
        break;
      case NetworkException():
      case TimeoutException():
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.categoryNotifyNetwork)));
      case ServerException():
      case UnknownException():
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.categoryNotifyServer)));
    }
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
