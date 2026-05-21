// TablerIcons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as brand_gen;
import 'package:kuru_category_api/kuru_category_api.dart' as cat_gen;
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/env/env.dart';
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

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({this.initial, super.key});

  final ProductDetail? initial;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _demandStockCtrl;
  late final TextEditingController _descCtrl;

  File? _imageFile;
  String? _categoryId;
  String? _categoryName;
  String? _brandId;
  String? _brandName;
  late String _baseUnitCode;
  int? _sellPrice;
  int? _importPrice;
  int? _exportPrice;
  bool _isActive = true;

  String? _nameError;
  String? _priceError;
  bool _submitting = false;

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
    _demandStockCtrl.addListener(_onDemandStockChanged);
    _descCtrl.addListener(_onDescChanged);
  }

  @override
  void dispose() {
    _nameCtrl
      ..removeListener(_onNameChanged)
      ..dispose();
    _demandStockCtrl
      ..removeListener(_onDemandStockChanged)
      ..dispose();
    _descCtrl
      ..removeListener(_onDescChanged)
      ..dispose();
    super.dispose();
  }

  void _onDescChanged() {
    setState(() {});
  }

  void _onNameChanged() {
    setState(() {
      if (_nameError != null) _nameError = null;
    });
  }

  void _onDemandStockChanged() {
    setState(() {});
  }

  bool get _isDirty {
    if (widget.initial == null) return true; // Always dirty in create mode
    if (_imageFile != null) return true;
    if (_nameCtrl.text.trim() != _baselineName.trim()) return true;
    if (_categoryId != _baselineCategoryId) return true;
    if (_brandId != _baselineBrandId) return true;
    if (_baseUnitCode != _baselineBaseUnitCode) return true;
    if (_sellPrice != _baselineSellPrice) return true;
    if (_descCtrl.text.trim() != _baselineDesc.trim()) return true;
    if (_importPrice != _baselineImportPrice) return true;
    if (_exportPrice != _baselineExportPrice) return true;
    if (_demandStockCtrl.text != _baselineDemandStock) return true;
    if (widget.initial != null && _isActive != _baselineIsActive) return true;
    return false;
  }

  bool get _canSubmit =>
      !_submitting &&
      _isDirty &&
      _nameCtrl.text.trim().isNotEmpty &&
      _sellPrice != null &&
      _sellPrice! > 0;

  @visibleForTesting
  void debugSetSellPrice(int? value) => setState(() => _sellPrice = value);

  @visibleForTesting
  void debugSetImportPrice(int? value) => setState(() => _importPrice = value);

  @visibleForTesting
  void debugSetExportPrice(int? value) => setState(() => _exportPrice = value);

  @visibleForTesting
  void debugSetUnit(String code) => setState(() => _baseUnitCode = code);

  @visibleForTesting
  // Test hook mirrors user text entry without driving a far-off TextField.
  // ignore: use_setters_to_change_properties
  void debugSetDemandStock(String value) => _demandStockCtrl.text = value;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 1800,
    );
    if (!mounted || picked == null) return;
    setState(() => _imageFile = File(picked.path));
  }

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
      _categoryName = null;
      if (picked == null) return;
      for (final c in cats) {
        if (c.categoryId == picked) {
          _categoryName = c.name;
          break;
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
      _brandName = null;
      if (picked == null) return;
      for (final b in brands) {
        if (b.id == picked) {
          _brandName = b.name;
          break;
        }
      }
    });
  }

  Future<void> _pickUnit() async {
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

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final sellPrice = _sellPrice;
    if (name.isEmpty) {
      setState(() => _nameError = 'Tên sản phẩm là bắt buộc');
      return;
    }
    if (name.length > 255) {
      setState(() => _nameError = 'Tên sản phẩm tối đa 255 ký tự');
      return;
    }
    if (sellPrice == null || sellPrice <= 0) {
      setState(() => _priceError = 'Giá bán phải lớn hơn 0');
      return;
    }

    setState(() {
      _submitting = true;
      _nameError = null;
      _priceError = null;
    });

    final desc = _descCtrl.text.trim();
    final demandText = _demandStockCtrl.text.trim();
    final repo = ref.read(productRepositoryProvider);

    if (widget.initial == null) {
      final createResult = await repo.create(
        CreateProductBody(
          name: name,
          baseUnitCode: _baseUnitCode,
          sellPrice: sellPrice,
          categoryId: _categoryId,
          brandId: _brandId,
          description: desc.isEmpty ? null : desc,
          importPrice: _importPrice,
          exportPrice: _exportPrice,
          demandStock: demandText.isEmpty ? null : int.tryParse(demandText),
        ),
      );
      if (!mounted) return;

      switch (createResult) {
        case ApiSuccess<String>(:final data):
          final newProductId = data;
          ref.invalidate(productListProvider);
          final orgId = ref.read(currentOrgIdProvider);
          if (_imageFile != null && orgId != null) {
            final uploadResult = await repo.uploadAvatar(
              file: _imageFile!,
              productId: newProductId,
              orgId: orgId,
            );
            if (!mounted) return;
            switch (uploadResult) {
              case ApiSuccess<String>():
                ref.invalidate(productByIdProvider(newProductId));
              case ApiFailure<String>(:final err):
                KNotify.warning(context, err.message);
            }
          }
          if (!mounted) return;
          KNotify.success(context, 'Đã tạo sản phẩm');
          context.replace('/catalog/products/$newProductId');
        case ApiFailure<String>(:final err):
          _handleError(err);
      }
    } else {
      final p = widget.initial!;
      final body = _buildUpdateBody(p);
      final result = await repo.updateInfo(body);
      if (!mounted) return;
      switch (result) {
        case ApiSuccess<void>():
          final orgId = ref.read(currentOrgIdProvider);
          if (_imageFile != null && orgId != null) {
            final uploadResult = await repo.uploadAvatar(
              file: _imageFile!,
              productId: p.id,
              orgId: orgId,
            );
            if (!mounted) return;
            if (uploadResult is ApiFailure<String>) {
              KNotify.warning(context, uploadResult.err.message);
            }
          }
          if (!mounted) return;
          KNotify.success(context, 'Đã cập nhật');
          ref.invalidate(productByIdProvider(p.id));
          ref.invalidate(productListProvider);
          context.pop();
        case ApiFailure<void>(:final err):
          _handleError(err);
      }
    }
  }

  UpdateProductInfoBody _buildUpdateBody(ProductDetail p) {
    final name = _nameCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final baselineDesc = _baselineDesc.trim();

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
    KNotify.warning(context, msg);
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final unitLabel = resolveUomLabel(_baseUnitCode);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          widget.initial == null ? 'Tạo sản phẩm' : 'Sửa sản phẩm',
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + bottomInset),
                children: [
                  _ImageIdentityPanel(
                    imageFile: _imageFile,
                    networkImageUrl: widget.initial?.hasImage ?? false
                        ? widget.initial!.imageUrl
                        : null,
                    name: _nameCtrl.text,
                    unitLabel: unitLabel,
                    onPickImage: _pickImage,
                    onClearImage:
                        _imageFile == null &&
                            !(widget.initial?.hasImage ?? false)
                        ? null
                        : () {
                            setState(() => _imageFile = null);
                            // To actually clear the image on backend,
                            // it might require a separate API call,
                            // but for now, we just clear the local
                            // selection if any.
                          },
                  ),
                  const SizedBox(height: 18),
                  _CreateSection(
                    title: 'Thông tin chính',
                    icon: TablerIcons.package,
                    required: true,
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
                        icon: TablerIcons.folder,
                        onTap: _pickCategory,
                      ),
                      const SizedBox(height: 12),
                      _PickerTriggerRow(
                        label: 'Thương hiệu',
                        valueText: _brandName,
                        icon: TablerIcons.tag,
                        onTap: _pickBrand,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _CreateSection(
                    title: 'Giá bán',
                    icon: TablerIcons.coin,
                    required: true,
                    children: [
                      KCurrencyField(
                        label: 'Giá bán',
                        value: _sellPrice,
                        errorText: _priceError,
                        onChanged: (v) => setState(() {
                          _sellPrice = v;
                          _priceError = null;
                        }),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: KCurrencyField(
                              label: 'Giá nhập',
                              value: _importPrice,
                              onChanged: (v) =>
                                  setState(() => _importPrice = v),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: KCurrencyField(
                              label: 'Giá xuất',
                              value: _exportPrice,
                              onChanged: (v) =>
                                  setState(() => _exportPrice = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _PriceHealthRow(
                        sellPrice: _sellPrice,
                        importPrice: _importPrice,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _CreateSection(
                    title: 'Đơn vị & tồn kho',
                    icon: TablerIcons.scale,
                    children: [
                      _PickerTriggerRow(
                        label: 'Đơn vị cơ sở',
                        valueText: unitLabel,
                        icon: TablerIcons.scale,
                        onTap: _pickUnit,
                      ),
                      const SizedBox(height: 12),
                      KTextField(
                        label: 'Tồn tối thiểu',
                        controller: _demandStockCtrl,
                        keyboardType: TextInputType.number,
                        placeholder: 'VD: 10',
                      ),
                      const SizedBox(height: 12),
                      _StockGoalPreview(
                        demandText: _demandStockCtrl.text,
                        unitLabel: unitLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _CreateSection(
                    title: 'Mô tả',
                    icon: TablerIcons.notes,
                    children: [
                      KTextarea(
                        label: 'Mô tả',
                        controller: _descCtrl,
                        placeholder: 'Mô tả ngắn về sản phẩm',
                        maxLines: 4,
                        maxLength: 1000,
                      ),
                    ],
                  ),
                  if (widget.initial != null) ...[
                    const SizedBox(height: 18),
                    _StatusSwitchRow(
                      isActive: _isActive,
                      onChanged: (v) => setState(() => _isActive = v),
                    ),
                  ],
                ],
              ),
            ),
            _CreateFooter(
              isEdit: widget.initial != null,
              enabled: _canSubmit,
              submitting: _submitting,
              onSubmit: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageIdentityPanel extends StatelessWidget {
  const _ImageIdentityPanel({
    required this.imageFile,
    required this.name,
    required this.unitLabel,
    required this.onPickImage,
    required this.onClearImage,
    this.networkImageUrl,
  });

  final File? imageFile;
  final String? networkImageUrl;
  final String name;
  final String unitLabel;
  final VoidCallback onPickImage;
  final VoidCallback? onClearImage;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final shownName = name.trim().isEmpty ? 'Sản phẩm mới' : name.trim();
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onPickImage,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: c.borderSoft),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 92,
                  height: 92,
                  child: imageFile != null
                      ? Image.file(imageFile!, fit: BoxFit.cover)
                      : (networkImageUrl != null
                            ? Image.network(
                                '${Env.imageBaseUrl}/product-avatar/$networkImageUrl',
                                fit: BoxFit.cover,
                              )
                            : ColoredBox(
                                color: c.accent50,
                                child: Icon(
                                  TablerIcons.photo_plus,
                                  color: c.accent600,
                                  size: 34,
                                ),
                              )),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shownName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 18,
                        height: 1.14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      unitLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(TablerIcons.photo, size: 16, color: c.accent600),
                        const SizedBox(width: 6),
                        Text(
                          imageFile == null ? 'Thêm ảnh' : 'Đổi ảnh',
                          style: TextStyle(
                            color: c.accent600,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (onClearImage != null) ...[
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: onClearImage,
                            child: Icon(
                              TablerIcons.x,
                              size: 18,
                              color: c.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateSection extends StatelessWidget {
  const _CreateSection({
    required this.title,
    required this.icon,
    required this.children,
    this.required = false,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        border: Border.all(color: c.borderSoft),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: c.accent600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (required)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: c.dangerSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Bắt buộc',
                      style: TextStyle(
                        color: c.danger,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _PickerTriggerRow extends StatelessWidget {
  const _PickerTriggerRow({
    required this.label,
    required this.onTap,
    required this.icon,
    this.valueText,
  });

  final String label;
  final String? valueText;
  final IconData icon;
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
              Icon(icon, size: 18, color: c.textMuted),
              const SizedBox(width: 10),
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
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      shown,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: showPlaceholder ? c.textMuted : c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
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

class _PriceHealthRow extends StatelessWidget {
  const _PriceHealthRow({required this.sellPrice, required this.importPrice});

  final int? sellPrice;
  final int? importPrice;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final sell = sellPrice;
    final cost = importPrice;
    final hasBoth = sell != null && sell > 0 && cost != null;
    final margin = hasBoth ? sell - cost : null;
    final marginPercent = hasBoth ? (margin! / sell * 100) : null;
    final isLoss = margin != null && margin < 0;
    final tone = isLoss ? c.danger : c.success;
    var text = 'Biên lợi nhuận';
    if (hasBoth) {
      text = [
        if (isLoss) 'Lỗ' else 'Lãi',
        '${margin!.abs()}đ',
        '(${marginPercent!.abs().toStringAsFixed(0)}%)',
      ].join(' ');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: hasBoth ? tone.withValues(alpha: 0.1) : c.surfaceHover,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasBoth ? tone.withValues(alpha: 0.25) : c.borderSoft,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isLoss ? TablerIcons.alert_triangle : TablerIcons.chart_bar,
            size: 18,
            color: hasBoth ? tone : c.textMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: hasBoth ? tone : c.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockGoalPreview extends StatelessWidget {
  const _StockGoalPreview({required this.demandText, required this.unitLabel});

  final String demandText;
  final String unitLabel;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final demand = int.tryParse(demandText.trim());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.surfaceHover,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(TablerIcons.target_arrow, size: 18, color: c.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              demand == null || demand <= 0
                  ? 'Không đặt tồn tối thiểu'
                  : 'Cần $demand $unitLabel',
              style: TextStyle(
                color: c.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusSwitchRow extends StatelessWidget {
  const _StatusSwitchRow({required this.isActive, required this.onChanged});

  final bool isActive;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: c.borderSoft),
        ),
        child: SwitchListTile(
          value: isActive,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          activeThumbColor: Colors.white,
          activeTrackColor: c.success,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: c.surfaceHover,
          title: Text(
            'Trạng thái bán',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: c.textPrimary,
            ),
          ),
          subtitle: Text(
            isActive ? 'Đang giao dịch' : 'Tạm ngưng',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? c.success : c.textMuted,
            ),
          ),
          secondary: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFE6F7F0) : c.surfaceHover,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isActive ? TablerIcons.check : TablerIcons.player_pause,
              color: isActive ? c.success : c.textMuted,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateFooter extends StatelessWidget {
  const _CreateFooter({
    required this.enabled,
    required this.submitting,
    required this.onSubmit,
    this.isEdit = false,
  });

  final bool isEdit;
  final bool enabled;
  final bool submitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        border: Border(top: BorderSide(color: c.borderSoft)),
      ),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: enabled ? onSubmit : null,
          icon: submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : const Icon(TablerIcons.check),
          label: Text(
            submitting ? 'Đang lưu' : (isEdit ? 'Lưu' : 'Tạo sản phẩm'),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: c.accent600,
            disabledBackgroundColor: c.accent600.withValues(alpha: 0.38),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}
