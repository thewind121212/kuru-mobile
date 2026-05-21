// TablerIcons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as brand_gen;
import 'package:kuru_category_api/kuru_category_api.dart' as cat_gen;
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/json_optional.dart';
import 'package:kuru_mobile/design/core/input/k_currency_field.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/input/k_textarea.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/products/data/uoms.dart';
import 'package:kuru_mobile/features/catalog/products/models/create_product_body.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/models/update_product_info_body.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/category_brand_picker_sheet.dart';

/// Opens the Create / Edit product sheet.
///
/// - `initial == null`  → Create mode. Returns the newly-created productId
///   on success (caller is responsible for any post-create navigation, e.g.
///   pushing the detail screen). Returns `null` on cancel or error.
/// - `initial != null`  → Edit mode. Builds an [UpdateProductInfoBody] with
///   only the fields the user actually changed; nullable scalars use
///   [JsonOptional] to distinguish "clear" from "leave unchanged". Returns
///   `null` on success/cancel/error — no navigation hint is propagated.
///
/// Decoupling navigation from the sheet keeps tests free of GoRouter
/// (a plain `MaterialApp` + Navigator is sufficient) and gives each call
/// site control over where the user lands next.
Future<String?> showCreateEditProductSheet(
  BuildContext context, {
  ProductDetail? initial,
}) {
  final title = initial == null ? 'Tạo sản phẩm' : 'Sửa sản phẩm';
  return showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (ctx) =>
        CreateEditProductSheetBody(initial: initial, title: title),
  );
}

/// Stateful body for the create/edit product sheet. Exposed (rather than
/// hidden behind the modal helper) so widget tests can pump it directly
/// without driving the bottom-sheet animation.
class CreateEditProductSheetBody extends ConsumerStatefulWidget {
  const CreateEditProductSheetBody({
    required this.title,
    super.key,
    this.initial,
  });

  final String title;
  final ProductDetail? initial;

  @override
  ConsumerState<CreateEditProductSheetBody> createState() =>
      CreateEditProductSheetBodyState();
}

class CreateEditProductSheetBodyState
    extends ConsumerState<CreateEditProductSheetBody> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _demandStockCtrl;

  // Working form state — all nullable so we can model "no value".
  String? _categoryId;
  String? _categoryName;
  String? _brandId;
  String? _brandName;
  late String _baseUnitCode;
  int? _sellPrice;
  int? _importPrice;
  int? _exportPrice;
  // Edit-only ACTIVE/INACTIVE toggle. Create mode forces ACTIVE (the BE
  // default); ARCHIVED is never set from this sheet — it lives behind the
  // dedicated "Ngừng kinh doanh" dialog.
  bool _isActive = true;

  String? _nameError;
  bool _submitting = false;

  // Baselines for dirty-tracking. In Create mode these stay at "empty
  // defaults"; in Edit mode they snapshot the initial ProductDetail.
  late String _baselineName;
  late String? _baselineCategoryId;
  late String? _baselineBrandId;
  late String _baselineBaseUnitCode;
  late int? _baselineSellPrice;
  late String _baselineDesc;
  late int? _baselineImportPrice;
  late int? _baselineExportPrice;
  late String _baselineDemandStock;
  late bool _baselineIsActive;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _categoryId = p?.categoryId;
    _brandId = p?.brandId;
    _brandName = p?.brandName;
    _baseUnitCode = p?.baseUnitCode ?? 'each';
    _sellPrice = p?.sellPrice.toInt();
    _importPrice = p?.importPrice?.toInt();
    _exportPrice = p?.exportPrice?.toInt();
    // demandStock == 0 is the BE's "unset" sentinel — render as empty.
    final demandSeed = p?.demandStock == null || p!.demandStock == 0
        ? ''
        : p.demandStock.toInt().toString();
    _demandStockCtrl = TextEditingController(text: demandSeed);
    _isActive = p == null || p.status == ProductStatus.active;

    _baselineName = _nameCtrl.text;
    _baselineCategoryId = _categoryId;
    _baselineBrandId = _brandId;
    _baselineBaseUnitCode = _baseUnitCode;
    _baselineSellPrice = _sellPrice;
    _baselineDesc = _descCtrl.text;
    _baselineImportPrice = _importPrice;
    _baselineExportPrice = _exportPrice;
    _baselineDemandStock = _demandStockCtrl.text;
    _baselineIsActive = _isActive;

    _nameCtrl.addListener(_onNameChanged);
    _descCtrl.addListener(_onDescChanged);
    _demandStockCtrl.addListener(_onDemandStockChanged);
  }

  @override
  void dispose() {
    _nameCtrl
      ..removeListener(_onNameChanged)
      ..dispose();
    _descCtrl
      ..removeListener(_onDescChanged)
      ..dispose();
    _demandStockCtrl
      ..removeListener(_onDemandStockChanged)
      ..dispose();
    super.dispose();
  }

  void _onNameChanged() {
    if (!mounted) return;
    setState(() {
      if (_nameError != null) _nameError = null;
    });
  }

  void _onDescChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _onDemandStockChanged() {
    if (!mounted) return;
    setState(() {});
  }

  // ---------------------------------------------------------------------
  // @visibleForTesting setters — let tests poke values that would normally
  // go through nested bottom sheets (KCurrencyField, category picker, etc).
  // ---------------------------------------------------------------------
  @visibleForTesting
  // Setter form would be awkward to call from tests (state._sellPrice = …
  // through a key is verbose); plain method reads cleaner at call sites.
  // ignore: use_setters_to_change_properties
  void debugSetSellPrice(int? v) => setState(() => _sellPrice = v);

  @visibleForTesting
  // Same rationale as [debugSetSellPrice] — avoids driving KCurrencyField's
  // nested num-pad bottom sheet in widget tests.
  // ignore: use_setters_to_change_properties
  void debugSetImportPrice(int? v) => setState(() => _importPrice = v);

  @visibleForTesting
  // Same rationale as [debugSetSellPrice].
  // ignore: use_setters_to_change_properties
  void debugSetExportPrice(int? v) => setState(() => _exportPrice = v);

  @visibleForTesting
  // The status SwitchListTile is the last form row and frequently sits
  // below the 600-pt test viewport — tests use this hook instead of
  // scrolling. A named arg keeps the call site readable + avoids the
  // avoid_positional_boolean_parameters lint.
  // ignore: use_setters_to_change_properties
  void debugSetIsActive({required bool value}) =>
      setState(() => _isActive = value);

  @visibleForTesting
  void debugSetCategory(String? id, String? name) => setState(() {
    _categoryId = id;
    _categoryName = name;
  });

  @visibleForTesting
  void debugSetBrand(String? id, String? name) => setState(() {
    _brandId = id;
    _brandName = name;
  });

  @visibleForTesting
  // Same rationale as [debugSetSellPrice] — a plain method is easier to
  // call than a setter through the inherited `State` API in tests.
  // ignore: use_setters_to_change_properties
  void debugSetUnit(String code) => setState(() => _baseUnitCode = code);

  // ---------------------------------------------------------------------
  // Dirty tracking — Save stays disabled until the user actually changes
  // something AND the required-fields pass.
  // ---------------------------------------------------------------------
  bool get _isDirty {
    if (_nameCtrl.text.trim() != _baselineName.trim()) return true;
    if (_categoryId != _baselineCategoryId) return true;
    if (_brandId != _baselineBrandId) return true;
    if (_baseUnitCode != _baselineBaseUnitCode) return true;
    if (_sellPrice != _baselineSellPrice) return true;
    if (_descCtrl.text.trim() != _baselineDesc.trim()) return true;
    if (_importPrice != _baselineImportPrice) return true;
    if (_exportPrice != _baselineExportPrice) return true;
    if (_demandStockCtrl.text != _baselineDemandStock) return true;
    // Status toggle is edit-only. In create mode the baseline matches the
    // default (ACTIVE) so the comparison is always false; in edit mode it
    // flags when the user flipped the switch.
    if (widget.initial != null && _isActive != _baselineIsActive) return true;
    return false;
  }

  bool get _canSubmit {
    if (_submitting) return false;
    if (!_isDirty) return false;
    if (_nameCtrl.text.trim().isEmpty) return false;
    final sp = _sellPrice;
    if (sp == null || sp < 0) return false;
    return true;
  }

  // ---------------------------------------------------------------------
  // Picker triggers.
  // ---------------------------------------------------------------------
  Future<void> _pickCategory() async {
    final cats = ref.read(categoryOverviewProvider).valueOrNull ?? const [];
    final picked = await showCategoryBrandPickerSheet(
      context: context,
      title: 'Chọn danh mục',
      items: [
        for (final cat_gen.CategoryResponse c in cats)
          PickerItem(id: c.categoryId ?? '', name: c.name ?? ''),
      ],
      selectedId: _categoryId,
    );
    if (!mounted) return;
    setState(() {
      _categoryId = picked;
      if (picked == null) {
        _categoryName = null;
      } else {
        for (final c in cats) {
          if (c.categoryId == picked) {
            _categoryName = c.name;
            break;
          }
        }
      }
    });
  }

  Future<void> _pickBrand() async {
    final brands = ref.read(brandOverviewProvider).valueOrNull ?? const [];
    final picked = await showCategoryBrandPickerSheet(
      context: context,
      title: 'Chọn thương hiệu',
      items: [
        for (final brand_gen.BrandOverviewItem b in brands)
          PickerItem(id: b.id, name: b.name),
      ],
      selectedId: _brandId,
    );
    if (!mounted) return;
    setState(() {
      _brandId = picked;
      if (picked == null) {
        _brandName = null;
      } else {
        for (final b in brands) {
          if (b.id == picked) {
            _brandName = b.name;
            break;
          }
        }
      }
    });
  }

  Future<void> _pickUnit() async {
    // Group by type, then render as a single action sheet with a "section
    // divider" (an icon-less, disabled action whose label is the section
    // header). KActionSheet doesn't have native section dividers — using a
    // disabled non-tappable row is the lightest-weight option for v1.
    final byType = uomsByType();
    const order = ['count', 'pack', 'weight', 'volume', 'length', 'area'];
    final actions = <KActionItem<String>>[];
    for (final type in order) {
      final group = byType[type];
      if (group == null) continue;
      actions.add(
        KActionItem<String>(
          id: '__header_$type',
          label: _typeLabel(type),
          enabled: false,
        ),
      );
      for (final u in group) {
        actions.add(
          KActionItem<String>(
            id: u.code,
            label: '${u.labelVi} (${u.code})',
            icon: u.code == _baseUnitCode ? TablerIcons.check : null,
          ),
        );
      }
    }
    final picked = await showKActionSheet<String>(
      context: context,
      title: 'Chọn đơn vị',
      actions: actions,
    );
    if (!mounted || picked == null || picked.startsWith('__header_')) return;
    setState(() => _baseUnitCode = picked);
  }

  String _typeLabel(String type) => switch (type) {
    'count' => 'Đếm',
    'pack' => 'Đóng gói',
    'weight' => 'Khối lượng',
    'volume' => 'Thể tích',
    'length' => 'Chiều dài',
    'area' => 'Diện tích',
    _ => type,
  };

  // ---------------------------------------------------------------------
  // Submit.
  // ---------------------------------------------------------------------
  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Tên sản phẩm là bắt buộc');
      return;
    }
    if (name.length > 255) {
      setState(() => _nameError = 'Tên sản phẩm tối đa 255 ký tự');
      return;
    }
    final sp = _sellPrice;
    if (sp == null || sp < 0) return;

    setState(() {
      _submitting = true;
      _nameError = null;
    });

    final repo = ref.read(productRepositoryProvider);
    final p = widget.initial;
    if (p == null) {
      final desc = _descCtrl.text.trim();
      final demandText = _demandStockCtrl.text.trim();
      final body = CreateProductBody(
        name: name,
        baseUnitCode: _baseUnitCode,
        sellPrice: sp,
        categoryId: _categoryId,
        brandId: _brandId,
        description: desc.isEmpty ? null : desc,
        importPrice: _importPrice,
        exportPrice: _exportPrice,
        demandStock: demandText.isEmpty ? null : int.tryParse(demandText),
      );
      final result = await repo.create(body);
      if (!mounted) return;
      switch (result) {
        case ApiSuccess<String>(:final data):
          KNotify.success(context, 'Đã tạo sản phẩm');
          ref.invalidate(productListProvider);
          // Return the new productId to the caller — they decide whether
          // to push the detail screen. Keeps the sheet GoRouter-free.
          Navigator.of(context).pop<String?>(data);
        case ApiFailure<String>(:final err):
          _handleError(err);
      }
    } else {
      final body = _buildUpdateBody(p);
      final result = await repo.updateInfo(body);
      if (!mounted) return;
      switch (result) {
        case ApiSuccess<void>():
          KNotify.success(context, 'Đã cập nhật');
          ref.invalidate(productByIdProvider(p.id));
          ref.invalidate(productListProvider);
          Navigator.of(context).pop<String?>();
        case ApiFailure<void>(:final err):
          _handleError(err);
      }
    }
  }

  UpdateProductInfoBody _buildUpdateBody(ProductDetail p) {
    final name = _nameCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final baselineDesc = _baselineDesc.trim();

    // Nullable scalars → JsonOptional:
    //   user cleared → JsonOptional.clear()
    //   user picked  → JsonOptional.set(value)
    //   untouched    → null (key omitted)
    JsonOptional<String>? categoryOpt;
    if (_categoryId != _baselineCategoryId) {
      categoryOpt = _categoryId == null
          ? const JsonOptional.clear()
          : JsonOptional.set(_categoryId!);
    }
    JsonOptional<String>? brandOpt;
    if (_brandId != _baselineBrandId) {
      brandOpt = _brandId == null
          ? const JsonOptional.clear()
          : JsonOptional.set(_brandId!);
    }
    JsonOptional<String>? descOpt;
    if (desc != baselineDesc) {
      descOpt = desc.isEmpty
          ? const JsonOptional.clear()
          : JsonOptional.set(desc);
    }

    JsonOptional<num>? importOpt;
    if (_importPrice != _baselineImportPrice) {
      importOpt = _importPrice == null
          ? const JsonOptional<num>.clear()
          : JsonOptional<num>.set(_importPrice!);
    }
    JsonOptional<num>? exportOpt;
    if (_exportPrice != _baselineExportPrice) {
      exportOpt = _exportPrice == null
          ? const JsonOptional<num>.clear()
          : JsonOptional<num>.set(_exportPrice!);
    }
    JsonOptional<num>? demandOpt;
    final demandText = _demandStockCtrl.text.trim();
    if (_demandStockCtrl.text != _baselineDemandStock) {
      final parsed = int.tryParse(demandText);
      demandOpt = (demandText.isEmpty || parsed == null)
          ? const JsonOptional<num>.clear()
          : JsonOptional<num>.set(parsed);
    }

    // Status is a plain nullable String on the PATCH body — JsonOptional
    // isn't used because the BE never allows "clear status to null". We
    // only send 'ACTIVE' / 'INACTIVE' when the user actually flipped the
    // switch; ARCHIVED never originates from this sheet.
    final statusOut = _isActive != _baselineIsActive
        ? (_isActive ? 'ACTIVE' : 'INACTIVE')
        : null;

    return UpdateProductInfoBody(
      productId: p.id,
      name: name == _baselineName.trim() ? null : name,
      sellPrice: _sellPrice == _baselineSellPrice ? null : _sellPrice,
      status: statusOut,
      baseUnitCode: _baseUnitCode == _baselineBaseUnitCode
          ? null
          : _baseUnitCode,
      categoryId: categoryOpt,
      brandId: brandOpt,
      description: descOpt,
      importPrice: importOpt,
      exportPrice: exportOpt,
      demandStock: demandOpt,
    );
  }

  void _handleError(ApiException err) {
    setState(() => _submitting = false);
    final msg = err.message;
    if (err is BadRequestException) {
      final lower = msg.toLowerCase();
      if (lower.contains('name') || lower.contains('tên')) {
        setState(() => _nameError = msg);
      } else {
        KNotify.warning(context, msg);
      }
      return;
    }
    if (err is NetworkException || err is TimeoutException) {
      KNotify.networkError(context, msg, onRetry: _submit);
      return;
    }
    // 5xx / unknown — surface verbatim as a warning toast so the sheet
    // remains usable.
    KNotify.warning(context, msg);
  }

  // ---------------------------------------------------------------------
  // Build.
  // ---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final insets = MediaQuery.of(context).viewInsets;
    return AnimatedPadding(
      padding: insets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(c),
              _buildHeader(c),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: _buildForm(c),
                ),
              ),
              _buildFooter(c),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle(KuruColors c) => Container(
    margin: const EdgeInsets.only(top: 8),
    width: 40,
    height: 4,
    decoration: BoxDecoration(
      color: c.surfaceHover,
      borderRadius: BorderRadius.circular(999),
    ),
  );

  Widget _buildHeader(KuruColors c) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
    child: Row(
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        IconButton(
          icon: Icon(TablerIcons.x, color: c.textMuted, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );

  Widget _buildForm(KuruColors c) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      KTextField(
        label: 'Tên sản phẩm',
        controller: _nameCtrl,
        placeholder: 'VD: Cà phê đen đá',
        maxLength: 255,
        errorText: _nameError,
      ),
      const SizedBox(height: 12),
      _PickerTriggerRow(
        label: 'Danh mục',
        valueText: _categoryName,
        onTap: _pickCategory,
      ),
      const SizedBox(height: 12),
      _PickerTriggerRow(
        label: 'Thương hiệu',
        valueText: _brandName,
        onTap: _pickBrand,
      ),
      const SizedBox(height: 12),
      _PickerTriggerRow(
        label: 'Đơn vị cơ sở',
        valueText: resolveUomLabel(_baseUnitCode),
        onTap: _pickUnit,
      ),
      const SizedBox(height: 12),
      KCurrencyField(
        label: 'Giá bán',
        value: _sellPrice,
        onChanged: (v) => setState(() => _sellPrice = v),
      ),
      const SizedBox(height: 12),
      KCurrencyField(
        label: 'Giá nhập',
        value: _importPrice,
        onChanged: (v) => setState(() => _importPrice = v),
      ),
      const SizedBox(height: 12),
      KCurrencyField(
        label: 'Giá xuất',
        value: _exportPrice,
        onChanged: (v) => setState(() => _exportPrice = v),
      ),
      const SizedBox(height: 12),
      KTextField(
        label: 'Tồn tối thiểu',
        controller: _demandStockCtrl,
        keyboardType: TextInputType.number,
        placeholder: 'VD: 10',
      ),
      const SizedBox(height: 12),
      KTextarea(
        label: 'Mô tả',
        controller: _descCtrl,
        placeholder: 'Mô tả ngắn về sản phẩm',
        maxLines: 4,
        maxLength: 1000,
      ),
      if (widget.initial != null) ...[
        const SizedBox(height: 12),
        _StatusSwitchRow(
          isActive: _isActive,
          onChanged: (v) => setState(() => _isActive = v),
        ),
      ],
    ],
  );

  Widget _buildFooter(KuruColors c) {
    final enabled = _canSubmit;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.borderSoft)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: enabled ? _submit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: c.accent600,
                  disabledBackgroundColor: c.accent600.withValues(alpha: 0.4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text(
                        'Lưu',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Row that visually mimics [KTextField] / [KCurrencyField]'s trigger
/// shape: small label on top, value below, chevron-down on the right.
/// Tapping invokes [onTap] (typically opens a picker sheet).
class _PickerTriggerRow extends StatelessWidget {
  const _PickerTriggerRow({
    required this.label,
    required this.onTap,
    this.valueText,
  });

  final String label;
  final String? valueText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final showPlaceholder = valueText == null || valueText!.isEmpty;
    final shown = showPlaceholder ? 'Chưa chọn' : valueText!;
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.border),
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
                        color: c.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      shown,
                      style: TextStyle(
                        color: showPlaceholder ? c.textMuted : c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(TablerIcons.chevron_down, size: 18, color: c.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

/// Edit-only "Đang bán / Tạm ngưng" toggle. Rendered as a [SwitchListTile]
/// so the entire row is a single tap target. Wraps a thin border + radius
/// to match the surrounding KTextField / KCurrencyField visual rhythm.
class _StatusSwitchRow extends StatelessWidget {
  const _StatusSwitchRow({required this.isActive, required this.onChanged});

  final bool isActive;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.border),
        ),
        child: SwitchListTile(
          value: isActive,
          onChanged: onChanged,
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          title: Text(
            'Trạng thái',
            style: TextStyle(
              color: c.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          subtitle: Text(
            isActive ? 'Đang bán' : 'Tạm ngưng',
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          activeThumbColor: c.accent600,
        ),
      ),
    );
  }
}
