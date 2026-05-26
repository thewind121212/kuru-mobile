// TablerIcons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';

class ProductFilterOption {
  const ProductFilterOption({
    required this.id,
    required this.name,
    this.subtitle,
  });

  final String id;
  final String name;
  final String? subtitle;
}

class ProductVariantFilterAttribute {
  const ProductVariantFilterAttribute({
    required this.id,
    required this.name,
    required this.values,
  });

  final String id;
  final String name;
  final List<ProductFilterOption> values;
}

class ProductFilterSheetResult {
  const ProductFilterSheetResult({
    required this.filter,
    required this.categoryLabels,
    required this.brandLabels,
    required this.warehouseLabels,
    required this.variantLabels,
  });

  final ProductListFilter filter;
  final Map<String, String> categoryLabels;
  final Map<String, String> brandLabels;
  final Map<String, String> warehouseLabels;
  final Map<String, String> variantLabels;
}

Future<ProductFilterSheetResult?> showProductFilterSheet({
  required BuildContext context,
  required ProductListFilter initial,
  required List<ProductFilterOption> categories,
  required List<ProductFilterOption> brands,
  required List<ProductFilterOption> warehouses,
  required List<ProductVariantFilterAttribute> variantAttributes,
  double priceCeiling = 10000000,
}) {
  return showModalBottomSheet<ProductFilterSheetResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ProductFilterSheet(
      initial: initial,
      categories: categories,
      brands: brands,
      warehouses: warehouses,
      variantAttributes: variantAttributes,
      priceCeiling: priceCeiling,
    ),
  );
}

class _ProductFilterSheet extends StatefulWidget {
  const _ProductFilterSheet({
    required this.initial,
    required this.categories,
    required this.brands,
    required this.warehouses,
    required this.variantAttributes,
    required this.priceCeiling,
  });

  final ProductListFilter initial;
  final List<ProductFilterOption> categories;
  final List<ProductFilterOption> brands;
  final List<ProductFilterOption> warehouses;
  final List<ProductVariantFilterAttribute> variantAttributes;
  final double priceCeiling;

  @override
  State<_ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<_ProductFilterSheet> {
  late final Set<String> _categoryIds;
  late final Set<String> _brandIds;
  late final Set<String> _warehouseIds;
  late final Map<String, Set<String>> _attributeValueIds;
  late final double _priceCeiling;
  late RangeValues _priceRange;
  late bool _priceActive;

  @override
  void initState() {
    super.initState();
    _categoryIds = {...widget.initial.categoryIds};
    _brandIds = {...widget.initial.brandIds};
    _warehouseIds = {...widget.initial.warehouseIds};
    _attributeValueIds = {
      for (final filter in widget.initial.attributeFilters)
        if (filter.valueIds.isNotEmpty)
          filter.attributeId: {...filter.valueIds},
    };
    final initialMax = (widget.initial.maxPrice ?? 0).toDouble();
    _priceCeiling = initialMax > widget.priceCeiling
        ? _roundedCeiling(initialMax)
        : widget.priceCeiling;
    final start = (widget.initial.minPrice ?? 0).toDouble();
    final end = (widget.initial.maxPrice ?? _priceCeiling).toDouble();
    final clampedStart = start.clamp(0, _priceCeiling).toDouble();
    final clampedEnd = end.clamp(0, _priceCeiling).toDouble();
    _priceRange = RangeValues(
      clampedStart <= clampedEnd ? clampedStart : clampedEnd,
      clampedEnd,
    );
    _priceActive =
        widget.initial.minPrice != null || widget.initial.maxPrice != null;
  }

  void _clear() {
    setState(() {
      _categoryIds.clear();
      _brandIds.clear();
      _warehouseIds.clear();
      _attributeValueIds.clear();
      _priceActive = false;
      _priceRange = RangeValues(0, _priceCeiling);
    });
  }

  static double _roundedCeiling(double value) {
    if (value <= 0) return 1;
    if (value <= 1000000) return value;
    return ((value / 1000000).ceil() * 1000000).toDouble();
  }

  void _apply() {
    final categoryLabels = {
      for (final option in widget.categories)
        if (_categoryIds.contains(option.id)) option.id: option.name,
    };
    final brandLabels = {
      for (final option in widget.brands)
        if (_brandIds.contains(option.id)) option.id: option.name,
    };
    final warehouseLabels = {
      for (final option in widget.warehouses)
        if (_warehouseIds.contains(option.id)) option.id: option.name,
    };
    final variantLabels = {
      for (final attribute in widget.variantAttributes)
        for (final value in attribute.values)
          if (_attributeValueIds[attribute.id]?.contains(value.id) ?? false)
            '${attribute.id}:${value.id}': '${attribute.name}: ${value.name}',
    };
    Navigator.of(context).pop(
      ProductFilterSheetResult(
        filter: widget.initial.copyWith(
          categoryIds: _categoryIds.toList(growable: false),
          brandIds: _brandIds.toList(growable: false),
          warehouseIds: _warehouseIds.toList(growable: false),
          attributeFilters: [
            for (final entry in _attributeValueIds.entries)
              if (entry.value.isNotEmpty)
                ProductAttributeFilter(
                  attributeId: entry.key,
                  valueIds: entry.value.toList(growable: false),
                ),
          ],
          minPrice: _priceActive && _priceRange.start > 0
              ? _priceRange.start.round()
              : null,
          maxPrice: _priceActive && _priceRange.end < _priceCeiling
              ? _priceRange.end.round()
              : null,
        ),
        categoryLabels: categoryLabels,
        brandLabels: brandLabels,
        warehouseLabels: warehouseLabels,
        variantLabels: variantLabels,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return FractionallySizedBox(
      heightFactor: 0.92,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 8, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Bộ lọc sản phẩm',
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Đóng',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(TablerIcons.x, color: c.textMuted),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                  children: [
                    _PriceRangeSection(
                      values: _priceRange,
                      max: _priceCeiling,
                      active: _priceActive,
                      onChanged: (values) => setState(() {
                        _priceActive = true;
                        _priceRange = values;
                      }),
                      onClear: () => setState(() {
                        _priceActive = false;
                        _priceRange = RangeValues(0, _priceCeiling);
                      }),
                    ),
                    const SizedBox(height: 14),
                    _OptionSection(
                      title: 'Nhóm sản phẩm',
                      icon: TablerIcons.folder,
                      options: widget.categories,
                      selectedIds: _categoryIds,
                      onChanged: (ids) => setState(() {
                        _categoryIds
                          ..clear()
                          ..addAll(ids);
                      }),
                    ),
                    const SizedBox(height: 14),
                    _OptionSection(
                      title: 'Thương hiệu',
                      icon: TablerIcons.tag,
                      options: widget.brands,
                      selectedIds: _brandIds,
                      onChanged: (ids) => setState(() {
                        _brandIds
                          ..clear()
                          ..addAll(ids);
                      }),
                    ),
                    const SizedBox(height: 14),
                    _OptionSection(
                      title: 'Kho',
                      icon: TablerIcons.building_warehouse,
                      options: widget.warehouses,
                      selectedIds: _warehouseIds,
                      pickerStyle: _OptionPickerStyle.rows,
                      onChanged: (ids) => setState(() {
                        _warehouseIds
                          ..clear()
                          ..addAll(ids);
                      }),
                    ),
                    const SizedBox(height: 14),
                    _VariantSection(
                      attributes: widget.variantAttributes,
                      selectedValueIds: _attributeValueIds,
                      onChanged: (next) => setState(() {
                        _attributeValueIds
                          ..clear()
                          ..addAll(next);
                      }),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: c.borderSoft)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _clear,
                        child: const Text('Xóa lọc'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _apply,
                        child: const Text('Áp dụng'),
                      ),
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

class _PriceRangeSection extends StatelessWidget {
  const _PriceRangeSection({
    required this.values,
    required this.max,
    required this.active,
    required this.onChanged,
    required this.onClear,
  });

  final RangeValues values;
  final double max;
  final bool active;
  final ValueChanged<RangeValues> onChanged;
  final VoidCallback onClear;

  static final _money = NumberFormat.decimalPattern('vi_VN');

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final start = values.start.round();
    final end = values.end.round();
    return _SectionShell(
      title: 'Giá bán',
      icon: TablerIcons.coin,
      trailing: active
          ? IconButton(
              tooltip: 'Xóa giá',
              onPressed: onClear,
              visualDensity: VisualDensity.compact,
              icon: Icon(TablerIcons.x, size: 18, color: c.textMuted),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _PricePill(
                  label: 'Từ',
                  value: active ? '${_money.format(start)}đ' : '0đ',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PricePill(
                  label: 'Đến',
                  value: '${_money.format(end)}đ',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              rangeThumbShape: const RoundRangeSliderThumbShape(),
              rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
              trackHeight: 4,
            ),
            child: RangeSlider(
              values: values,
              max: max,
              divisions: 100,
              labels: RangeLabels(
                '${_money.format(start)}đ',
                '${_money.format(end)}đ',
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.pageBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.borderSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: c.textMuted)),
            const SizedBox(height: 3),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionSection extends StatelessWidget {
  const _OptionSection({
    required this.title,
    required this.icon,
    required this.options,
    required this.selectedIds,
    required this.onChanged,
    this.pickerStyle = _OptionPickerStyle.pills,
  });

  final String title;
  final IconData icon;
  final List<ProductFilterOption> options;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;
  final _OptionPickerStyle pickerStyle;

  Future<void> _openLayer(BuildContext context) async {
    final next = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OptionPickerSheet(
        title: title,
        icon: icon,
        options: options,
        initialSelectedIds: selectedIds,
        pickerStyle: pickerStyle,
      ),
    );
    if (next != null) onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final selectedOptions = options
        .where((option) => selectedIds.contains(option.id))
        .toList();
    return _SectionShell(
      title: title,
      icon: icon,
      trailing: selectedIds.isEmpty
          ? null
          : Text(
              '${selectedIds.length}',
              style: TextStyle(color: c.accent600, fontWeight: FontWeight.w800),
            ),
      child: options.isEmpty
          ? Text(
              'Chưa có dữ liệu',
              style: TextStyle(color: c.textMuted, fontSize: 13),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (selectedOptions.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final option in selectedOptions)
                        InputChip(
                          label: Text(option.name),
                          onDeleted: () {
                            final next = {...selectedIds}..remove(option.id);
                            onChanged(next);
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                Material(
                  color: c.pageBg,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: () => _openLayer(context),
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 13,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedIds.isEmpty
                                  ? 'Chọn ${title.toLowerCase()}'
                                  : 'Sửa ${title.toLowerCase()}',
                              style: TextStyle(
                                color: c.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            '${options.length} mục',
                            style: TextStyle(
                              color: c.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            TablerIcons.chevron_right,
                            color: c.textMuted,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

enum _OptionPickerStyle { pills, rows }

class _VariantSection extends StatelessWidget {
  const _VariantSection({
    required this.attributes,
    required this.selectedValueIds,
    required this.onChanged,
  });

  final List<ProductVariantFilterAttribute> attributes;
  final Map<String, Set<String>> selectedValueIds;
  final ValueChanged<Map<String, Set<String>>> onChanged;

  int get _selectedCount => selectedValueIds.values.fold<int>(
    0,
    (count, values) => count + values.length,
  );

  Future<void> _openLayer(BuildContext context) async {
    final next = await showModalBottomSheet<Map<String, Set<String>>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _VariantPickerSheet(
        attributes: attributes,
        initialSelectedValueIds: selectedValueIds,
      ),
    );
    if (next != null) onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final selectedChips = <Widget>[];
    for (final attribute in attributes) {
      final values = selectedValueIds[attribute.id] ?? const <String>{};
      if (values.isEmpty) continue;
      final names = attribute.values
          .where((value) => values.contains(value.id))
          .map((value) => value.name)
          .join(', ');
      if (names.isEmpty) continue;
      selectedChips.add(
        InputChip(
          label: Text('${attribute.name}: $names'),
          onDeleted: () {
            final next = _copySelection(selectedValueIds)..remove(attribute.id);
            onChanged(next);
          },
          visualDensity: VisualDensity.compact,
        ),
      );
    }

    return _SectionShell(
      title: 'Biến thể',
      icon: TablerIcons.components,
      trailing: _selectedCount == 0
          ? null
          : Text(
              '$_selectedCount',
              style: TextStyle(color: c.accent600, fontWeight: FontWeight.w800),
            ),
      child: attributes.isEmpty
          ? Text(
              'Chưa có dữ liệu',
              style: TextStyle(color: c.textMuted, fontSize: 13),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (selectedChips.isNotEmpty) ...[
                  Wrap(spacing: 8, runSpacing: 8, children: selectedChips),
                  const SizedBox(height: 12),
                ],
                Material(
                  color: c.pageBg,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: () => _openLayer(context),
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 13,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedCount == 0
                                  ? 'Chọn biến thể'
                                  : 'Sửa biến thể',
                              style: TextStyle(
                                color: c.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            '${attributes.length} nhóm',
                            style: TextStyle(
                              color: c.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            TablerIcons.chevron_right,
                            color: c.textMuted,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _VariantPickerSheet extends StatefulWidget {
  const _VariantPickerSheet({
    required this.attributes,
    required this.initialSelectedValueIds,
  });

  final List<ProductVariantFilterAttribute> attributes;
  final Map<String, Set<String>> initialSelectedValueIds;

  @override
  State<_VariantPickerSheet> createState() => _VariantPickerSheetState();
}

class _VariantPickerSheetState extends State<_VariantPickerSheet> {
  final _searchCtrl = TextEditingController();
  late final Map<String, Set<String>> _selectedValueIds;

  @override
  void initState() {
    super.initState();
    _selectedValueIds = _copySelection(widget.initialSelectedValueIds);
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  int get _selectedCount => _selectedValueIds.values.fold<int>(
    0,
    (count, values) => count + values.length,
  );

  List<ProductVariantFilterAttribute> get _visibleAttributes {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) return widget.attributes;

    final visible = <ProductVariantFilterAttribute>[];
    for (final attribute in widget.attributes) {
      final attributeMatches = attribute.name.toLowerCase().contains(query);
      final values = attributeMatches
          ? attribute.values
          : attribute.values
                .where((value) => value.name.toLowerCase().contains(query))
                .toList();
      if (values.isNotEmpty) {
        visible.add(
          ProductVariantFilterAttribute(
            id: attribute.id,
            name: attribute.name,
            values: values,
          ),
        );
      }
    }
    return visible;
  }

  void _toggle(String attributeId, String valueId) {
    setState(() {
      final values = _selectedValueIds.putIfAbsent(
        attributeId,
        () => <String>{},
      );
      values.contains(valueId) ? values.remove(valueId) : values.add(valueId);
      if (values.isEmpty) _selectedValueIds.remove(attributeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final visible = _visibleAttributes;
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Trở lại',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(TablerIcons.arrow_left, color: c.textMuted),
                    ),
                    Icon(TablerIcons.components, size: 19, color: c.accent600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Biến thể',
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _selectedCount == 0
                          ? null
                          : () => setState(_selectedValueIds.clear),
                      child: const Text('Xóa'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(
                        context,
                      ).pop(_copySelection(_selectedValueIds)),
                      child: const Text('Xong'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Tìm biến thể',
                    prefixIcon: const Icon(TablerIcons.search, size: 18),
                    filled: true,
                    fillColor: c.pageBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: c.borderSoft),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: c.borderSoft),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: visible.isEmpty
                    ? Center(
                        child: Text(
                          'Không tìm thấy',
                          style: TextStyle(color: c.textMuted, fontSize: 13),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                        itemCount: visible.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final attribute = visible[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                attribute.name,
                                style: TextStyle(
                                  color: c.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 9),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final value in attribute.values)
                                    _PickerPill(
                                      option: value,
                                      selected:
                                          _selectedValueIds[attribute.id]
                                              ?.contains(value.id) ??
                                          false,
                                      onTap: () =>
                                          _toggle(attribute.id, value.id),
                                    ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionPickerSheet extends StatefulWidget {
  const _OptionPickerSheet({
    required this.title,
    required this.icon,
    required this.options,
    required this.initialSelectedIds,
    required this.pickerStyle,
  });

  final String title;
  final IconData icon;
  final List<ProductFilterOption> options;
  final Set<String> initialSelectedIds;
  final _OptionPickerStyle pickerStyle;

  @override
  State<_OptionPickerSheet> createState() => _OptionPickerSheetState();
}

class _OptionPickerSheetState extends State<_OptionPickerSheet> {
  final _searchCtrl = TextEditingController();
  late final Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = {...widget.initialSelectedIds};
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  List<ProductFilterOption> get _visibleOptions {
    final query = _searchCtrl.text.trim().toLowerCase();
    return widget.options.where((option) {
      if (query.isEmpty) return true;
      return option.name.toLowerCase().contains(query) ||
          (option.subtitle?.toLowerCase().contains(query) ?? false);
    }).toList()..sort((a, b) {
      final aSelected = _selectedIds.contains(a.id);
      final bSelected = _selectedIds.contains(b.id);
      if (aSelected == bSelected) return a.name.compareTo(b.name);
      return aSelected ? -1 : 1;
    });
  }

  void _toggle(String id) {
    setState(() {
      _selectedIds.contains(id)
          ? _selectedIds.remove(id)
          : _selectedIds.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final visible = _visibleOptions;
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Trở lại',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(TablerIcons.arrow_left, color: c.textMuted),
                    ),
                    Icon(widget.icon, size: 19, color: c.accent600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(_selectedIds.clear),
                      child: const Text('Xóa'),
                    ),
                    FilledButton(
                      onPressed: () =>
                          Navigator.of(context).pop({..._selectedIds}),
                      child: const Text('Xong'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Tìm ${widget.title.toLowerCase()}',
                    prefixIcon: const Icon(TablerIcons.search, size: 18),
                    filled: true,
                    fillColor: c.pageBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: c.borderSoft),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: c.borderSoft),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: visible.isEmpty
                    ? Center(
                        child: Text(
                          'Không tìm thấy',
                          style: TextStyle(color: c.textMuted, fontSize: 13),
                        ),
                      )
                    : widget.pickerStyle == _OptionPickerStyle.rows
                    ? ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                        itemCount: visible.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final option = visible[index];
                          return _PickerRow(
                            option: option,
                            selected: _selectedIds.contains(option.id),
                            onTap: () => _toggle(option.id),
                          );
                        },
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final option in visible)
                              _PickerPill(
                                option: option,
                                selected: _selectedIds.contains(option.id),
                                onTap: () => _toggle(option.id),
                              ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerPill extends StatelessWidget {
  const _PickerPill({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final ProductFilterOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: selected ? c.accent50 : c.pageBg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(maxWidth: 220),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? c.accent500 : c.borderSoft),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  option.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? c.accent700 : c.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (option.subtitle != null && option.subtitle!.isNotEmpty) ...[
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    option.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: c.textMuted, fontSize: 11),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final ProductFilterOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: selected ? c.accent50 : c.pageBg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? c.accent500 : c.borderSoft),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: selected ? c.accent100 : c.surfaceElev,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: c.borderSoft),
                ),
                child: Icon(
                  TablerIcons.building_warehouse,
                  size: 18,
                  color: selected ? c.accent700 : c.textMuted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (option.subtitle != null &&
                        option.subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        option.subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: c.textMuted, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                selected ? TablerIcons.circle_check_filled : TablerIcons.circle,
                color: selected ? c.accent600 : c.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, Set<String>> _copySelection(Map<String, Set<String>> source) {
  return {
    for (final entry in source.entries)
      if (entry.value.isNotEmpty) entry.key: {...entry.value},
  };
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        border: Border.all(color: c.borderSoft),
        borderRadius: BorderRadius.circular(16),
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
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
