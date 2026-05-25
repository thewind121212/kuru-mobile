// flutter_tabler_icons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/input/k_select.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/imports/models/purchase_draft_line.dart';
import 'package:kuru_mobile/features/imports/providers/purchase_providers.dart';

class ImportCreateScreen extends ConsumerStatefulWidget {
  const ImportCreateScreen({super.key});

  @override
  ConsumerState<ImportCreateScreen> createState() => _ImportCreateScreenState();
}

class _ImportCreateScreenState extends ConsumerState<ImportCreateScreen> {
  final _searchCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  Timer? _debounce;
  String _query = '';
  String? _warehouseId;
  String? _error;
  bool _saving = false;
  List<PurchaseDraftLine> _lines = const [];

  static final _money = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      setState(() => _query = _searchCtrl.text.trim());
    });
  }

  Future<void> _addProduct(ProductSummary product) async {
    final warehouses =
        ref.read(productWarehouseOptionsProvider).valueOrNull ?? const [];
    final warehouseId = _warehouseId ?? warehouses.firstOrNull?.warehouseId;
    if (warehouseId == null || warehouseId.isEmpty) {
      setState(() => _error = 'Chọn kho nhập trước khi thêm sản phẩm.');
      return;
    }

    ProductDetail? detail;
    try {
      detail = await ref
          .read(productRepositoryProvider)
          .getById(product.id)
          .unwrap();
    } on Object {
      detail = null;
    }

    final defaultVariant = detail?.variants
        .where((v) => v.isDefault)
        .firstOrNull;
    final cost = (defaultVariant?.importPrice ?? detail?.importPrice ?? 0)
        .round();
    final nonDefaultVariants =
        detail?.variants.where((variant) => !variant.isDefault).toList() ??
        const [];
    final existingIdx = _lines.indexWhere(
      (line) => line.productId == product.id,
    );
    setState(() {
      _error = null;
      if (existingIdx >= 0) {
        final current = _lines[existingIdx];
        _lines = [
          for (var i = 0; i < _lines.length; i++)
            if (i == existingIdx)
              current.copyWith(qty: current.qty + 1, warehouseId: warehouseId)
            else
              _lines[i],
        ];
      } else {
        _lines = [
          ..._lines,
          PurchaseDraftLine(
            productId: product.id,
            productName: product.name,
            warehouseId: warehouseId,
            qty: 1,
            unitCost: cost,
          ),
          for (final variant in nonDefaultVariants)
            PurchaseDraftLine(
              productId: product.id,
              productName: product.name,
              warehouseId: warehouseId,
              qty: 0,
              unitCost: (variant.importPrice ?? detail?.importPrice ?? 0)
                  .round(),
              variantId: variant.id,
              variantName: variant.name,
            ),
        ];
      }
      _searchCtrl.clear();
      _query = '';
    });
  }

  void _updateLine(int index, PurchaseDraftLine line) {
    setState(() {
      _lines = [
        for (var i = 0; i < _lines.length; i++)
          if (i == index) line else _lines[i],
      ];
    });
  }

  void _removeLine(int index) {
    setState(() {
      _lines = [
        for (var i = 0; i < _lines.length; i++)
          if (i != index) _lines[i],
      ];
    });
  }

  Future<void> _submit() async {
    if (_saving) return;
    final warehouseId = _warehouseId;
    final validLines = _lines
        .where(
          (line) =>
              line.qty > 0 && line.unitCost > 0 && line.warehouseId.isNotEmpty,
        )
        .toList();
    if (warehouseId == null || warehouseId.isEmpty) {
      setState(() => _error = 'Chọn kho nhập.');
      return;
    }
    if (validLines.isEmpty) {
      setState(
        () => _error = 'Thêm ít nhất một sản phẩm có số lượng và giá nhập.',
      );
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(purchaseRepositoryProvider)
          .createAndPost(
            lines: validLines,
            warehouseId: warehouseId,
            note: _noteCtrl.text,
          )
          .unwrap();
      ref
        ..invalidate(purchaseEntriesProvider)
        ..invalidate(purchasePostedSummaryProvider)
        ..invalidate(productListProvider)
        ..invalidate(productByIdProvider);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = '$e';
      });
      return;
    }
    if (!mounted) return;
    context.go('/import');
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final warehousesAsync = ref.watch(productWarehouseOptionsProvider);
    final warehouses =
        warehousesAsync.valueOrNull ?? const <ProductWarehouseOption>[];
    _warehouseId ??= warehouses.firstOrNull?.warehouseId;
    final filter = ProductListFilter(search: _query.isEmpty ? null : _query);
    final productsAsync = _query.isEmpty
        ? null
        : ref.watch(productListProvider(filter));
    final total = _lines.fold<int>(0, (sum, line) => sum + line.lineTotal);

    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 128),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: _saving ? null : () => context.pop(),
                  icon: const Icon(TablerIcons.arrow_left),
                ),
                Expanded(
                  child: Text(
                    'Tạo phiếu nhập',
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _SummaryCard(
              total: _money.format(total),
              count: _lines.length,
              qty: _lines.fold<num>(0, (sum, line) => sum + line.qty),
            ),
            const SizedBox(height: 14),
            if (warehousesAsync.isLoading && !warehousesAsync.hasValue)
              const Center(child: CircularProgressIndicator())
            else
              KSelect<String>(
                label: 'Kho nhập',
                value: _warehouseId,
                placeholder: 'Chọn kho nhập',
                options: [
                  for (final warehouse in warehouses)
                    KSelectOption<String>(
                      value: warehouse.warehouseId,
                      label: warehouse.name,
                      icon: TablerIcons.building_warehouse,
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    _warehouseId = value;
                    _lines = [
                      for (final line in _lines)
                        line.copyWith(warehouseId: value),
                    ];
                  });
                },
              ),
            const SizedBox(height: 12),
            _PlainTextField(
              label: 'Ghi chú',
              controller: _noteCtrl,
              icon: TablerIcons.note,
              placeholder: 'Không bắt buộc',
            ),
            const SizedBox(height: 14),
            _PlainTextField(
              label: 'Tìm sản phẩm',
              controller: _searchCtrl,
              icon: TablerIcons.search,
              placeholder: 'Nhập tên sản phẩm',
            ),
            if (productsAsync != null) ...[
              const SizedBox(height: 10),
              productsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text(
                  'Không tìm được sản phẩm: $e',
                  style: TextStyle(color: c.danger, fontSize: 12),
                ),
                data: (page) => _ProductResults(
                  products: page.items.take(8).toList(),
                  onTap: _addProduct,
                ),
              ),
            ],
            const SizedBox(height: 18),
            _SectionTitle(
              title: 'Sản phẩm nhập',
              subtitle: '${_lines.length} dòng',
            ),
            const SizedBox(height: 10),
            if (_lines.isEmpty)
              _EmptyLines()
            else
              for (var i = 0; i < _lines.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ImportLineEditor(
                    line: _lines[i],
                    money: _money,
                    onChanged: (line) => _updateLine(i, line),
                    onRemove: () => _removeLine(i),
                  ),
                ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                style: TextStyle(
                  color: c.danger,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: _saving ? null : _submit,
            icon: Icon(_saving ? TablerIcons.loader_2 : TablerIcons.check),
            label: Text(_saving ? 'Đang nhập hàng' : 'Nhập hàng'),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.total,
    required this.count,
    required this.qty,
  });

  final String total;
  final int count;
  final num qty;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final qtyText = NumberFormat.decimalPattern('vi_VN').format(qty);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
        boxShadow: c.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c.accent100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(TablerIcons.package_import, color: c.accent600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  total,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '$count dòng · $qtyText sản phẩm',
                  style: TextStyle(color: c.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductResults extends StatelessWidget {
  const _ProductResults({required this.products, required this.onTap});

  final List<ProductSummary> products;
  final ValueChanged<ProductSummary> onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    if (products.isEmpty) {
      return Text('Không có sản phẩm', style: TextStyle(color: c.textMuted));
    }
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (var i = 0; i < products.length; i++) ...[
            ListTile(
              leading: Icon(TablerIcons.package, color: c.accent600),
              title: Text(
                products[i].name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                'Tồn: ${products[i].currentStock} ${products[i].baseUnitCode}',
              ),
              trailing: const Icon(TablerIcons.plus),
              onTap: () => onTap(products[i]),
            ),
            if (i < products.length - 1)
              Divider(height: 1, color: c.borderSoft),
          ],
        ],
      ),
    );
  }
}

class _ImportLineEditor extends StatefulWidget {
  const _ImportLineEditor({
    required this.line,
    required this.money,
    required this.onChanged,
    required this.onRemove,
  });

  final PurchaseDraftLine line;
  final NumberFormat money;
  final ValueChanged<PurchaseDraftLine> onChanged;
  final VoidCallback onRemove;

  @override
  State<_ImportLineEditor> createState() => _ImportLineEditorState();
}

class _ImportLineEditorState extends State<_ImportLineEditor> {
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _costCtrl;

  @override
  void initState() {
    super.initState();
    _qtyCtrl = TextEditingController(text: _formatQty(widget.line.qty));
    _costCtrl = TextEditingController(text: widget.line.unitCost.toString());
  }

  @override
  void didUpdateWidget(covariant _ImportLineEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.line.qty != widget.line.qty &&
        _parseNum(_qtyCtrl.text) != widget.line.qty) {
      _qtyCtrl.text = _formatQty(widget.line.qty);
    }
    if (oldWidget.line.unitCost != widget.line.unitCost &&
        _parseInt(_costCtrl.text) != widget.line.unitCost) {
      _costCtrl.text = widget.line.unitCost.toString();
    }
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _costCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.line.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onRemove,
                icon: Icon(TablerIcons.trash, color: c.danger),
              ),
            ],
          ),
          if (widget.line.variantName != null) ...[
            const SizedBox(height: 2),
            Text(
              widget.line.variantName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: c.textMuted, fontSize: 12),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _SmallNumberField(
                  label: 'Số lượng',
                  controller: _qtyCtrl,
                  allowDecimal: true,
                  onChanged: (value) {
                    widget.onChanged(
                      widget.line.copyWith(qty: _parseNum(value)),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SmallNumberField(
                  label: 'Giá nhập',
                  controller: _costCtrl,
                  onChanged: (value) {
                    widget.onChanged(
                      widget.line.copyWith(unitCost: _parseInt(value)),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.money.format(widget.line.lineTotal),
              style: TextStyle(
                color: c.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallNumberField extends StatelessWidget {
  const _SmallNumberField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.allowDecimal = false,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool allowDecimal;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          allowDecimal ? RegExp('[0-9.]') : RegExp('[0-9]'),
        ),
      ],
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: c.pageBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }
}

class _PlainTextField extends StatelessWidget {
  const _PlainTextField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.placeholder,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        prefixIcon: Icon(icon, color: c.textMuted),
        filled: true,
        fillColor: c.surfaceElev,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(subtitle, style: TextStyle(color: c.textMuted, fontSize: 12)),
      ],
    );
  }
}

class _EmptyLines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(TablerIcons.package_off, size: 42, color: c.textMuted),
          const SizedBox(height: 8),
          Text(
            'Chưa có sản phẩm',
            style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Tìm sản phẩm phía trên rồi thêm vào phiếu nhập.',
            textAlign: TextAlign.center,
            style: TextStyle(color: c.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

String _formatQty(num value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toString();
}

num _parseNum(String value) {
  return num.tryParse(value.trim()) ?? 0;
}

int _parseInt(String value) {
  return int.tryParse(value.trim()) ?? 0;
}
