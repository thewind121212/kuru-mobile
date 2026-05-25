import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/catalog/k_settings_row.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_section.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/products/data/uoms.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_barcode.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_container_lot.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_stock_location.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_variant.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';
import 'package:kuru_mobile/features/catalog/products/models/update_product_info_body.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_archive_dialog.dart';
import 'package:kuru_mobile/features/catalog/products/widgets/product_status_badge.dart';

final _vnd = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: 'đ',
  decimalDigits: 0,
);
final _date = DateFormat('dd/MM/yyyy');

String _productRouteBase(BuildContext context) {
  final path = GoRouterState.of(context).uri.path;
  return path.startsWith('/products') ? '/products' : '/catalog/products';
}

/// Pushed detail screen for a single product — hero image + 5 grouped
/// info sections (Phân loại / Giá / Tồn kho / Thống kê / Mô tả).
///
/// Action menu (edit / archive) is gated by `canWriteProductsProvider`.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final async = ref.watch(productByIdProvider(productId));
    final canWrite = ref.watch(canWriteProductsProvider);

    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          async.maybeWhen(data: (p) => p.name, orElse: () => 'Sản phẩm'),
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (canWrite)
            IconButton(
              tooltip: 'Tác vụ',
              icon: const Icon(TablerIcons.dots_vertical),
              // Only enabled once the detail has loaded — the action sheet
              // needs a resolved [ProductDetail] to hand to the edit sheet.
              onPressed: async.maybeWhen(
                data: (p) =>
                    () => _openActionMenu(context, ref, p),
                orElse: () => null,
              ),
            ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Không tải được: $e')),
        data: (p) => _Body(detail: p),
      ),
    );
  }

  Future<void> _openActionMenu(
    BuildContext context,
    WidgetRef ref,
    ProductDetail detail,
  ) async {
    final picked = await showKActionSheet<String>(
      context: context,
      title: 'Tác vụ',
      actions: [
        const KActionItem(
          id: 'edit',
          label: 'Sửa thông tin',
          icon: TablerIcons.pencil,
        ),
        if (detail.status == ProductStatus.archived)
          const KActionItem(
            id: 'reactivate',
            label: 'Buôn bán lại',
            icon: TablerIcons.refresh,
          ),
        const KActionItem(
          id: 'archive',
          label: 'Ngừng kinh doanh',
          icon: TablerIcons.archive,
          danger: true,
        ),
      ],
    );
    if (picked == null || !context.mounted) return;
    switch (picked) {
      case 'edit':
        await context.push(
          '${_productRouteBase(context)}/${detail.id}/edit',
          extra: detail,
        );
      case 'reactivate':
        final repo = ref.read(productRepositoryProvider);
        final result = await repo.updateInfo(
          UpdateProductInfoBody(productId: detail.id, status: 'ACTIVE'),
        );
        if (!context.mounted) return;
        switch (result) {
          case ApiSuccess():
            KNotify.success(context, 'Đã mở bán lại');
            ref.invalidate(productByIdProvider(detail.id));
            ref.invalidate(productListProvider);
          case ApiFailure(:final err):
            KNotify.warning(context, err.message);
        }
      case 'archive':
        final ok = await showProductArchiveDialog(
          context,
          productId: productId,
        );
        if ((ok ?? false) && context.mounted) context.pop();
    }
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final unitLabel =
        detail.baseUnitLabel ?? resolveUomLabel(detail.baseUnitCode);
    // Only read categoryOverviewProvider when we actually have a category
    // to resolve — keeps the screen testable without overriding the category
    // provider when a product has no categoryId.
    String? catName;
    if (detail.categoryId != null) {
      final cats = ref.watch(categoryOverviewProvider).valueOrNull ?? const [];
      for (final cat in cats) {
        if (cat.categoryId == detail.categoryId) {
          catName = cat.name;
          break;
        }
      }
    }

    String fmtPrice(num? v) => v == null ? '—' : _vnd.format(v);
    String fmtQty(num v) => _formatQty(v, unitLabel);
    final customVariants = detail.variants
        .where((variant) => !variant.isDefault)
        .toList(growable: false);
    final variantsById = {
      for (final variant in detail.variants) variant.id: variant,
    };
    final defaultVariantId = _defaultVariantId(detail);
    final lotsAsync = ref.watch(productContainerLotsProvider(detail.id));
    final lots = lotsAsync.valueOrNull ?? const <ProductContainerLot>[];
    num baseStockTotal = 0;
    final rowsByVariantId = <String, List<ProductStockLocation>>{};
    for (final stock in detail.stocks) {
      final variantId = stock.variantId;
      final variant = variantId == null ? null : variantsById[variantId];
      if (variant == null || variant.isDefault) {
        baseStockTotal += stock.qty;
      } else {
        rowsByVariantId.putIfAbsent(variant.id, () => []).add(stock);
      }
    }
    final lotsByVariantId = <String, List<ProductContainerLot>>{};
    for (final lot in lots) {
      final variantId = lot.variantId ?? defaultVariantId;
      final variant = variantId == null ? null : variantsById[variantId];
      if (variant == null || variant.isDefault) {
        baseStockTotal += lot.qtyRemaining;
      } else {
        lotsByVariantId.putIfAbsent(variant.id, () => []).add(lot);
      }
    }
    final variantStockGroups = [
      for (final variant in customVariants)
        _VariantStockGroup(
          variant: variant,
          stockRows:
              rowsByVariantId[variant.id] ?? const <ProductStockLocation>[],
          lotRows: lotsByVariantId[variant.id] ?? const <ProductContainerLot>[],
        ),
    ];
    final variantStockTotal = variantStockGroups.fold<num>(
      0,
      (sum, group) => sum + group.totalQty,
    );
    final needsWarehouseLabels = customVariants.isNotEmpty || lots.isNotEmpty;
    final warehouseLabels = needsWarehouseLabels
        ? {
            for (final warehouse
                in ref.watch(productWarehouseOptionsProvider).valueOrNull ??
                    const <ProductWarehouseOption>[])
              warehouse.warehouseId: warehouse.name,
          }
        : const <String, String>{};
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12, bottom: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _Hero(detail: detail),
          ),
          const SizedBox(height: 20),
          KSettingsSection(
            header: 'Phân loại',
            children: [
              KSettingsRow(
                leadingIcon: TablerIcons.folder,
                iconBackground: const Color(0xFFF1ECFB),
                iconColor: const Color(0xFF8B5CF6),
                label: 'Nhóm sản phẩm',
                trailingText: catName ?? '—',
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: TablerIcons.tag,
                iconBackground: const Color(0xFFE7F1FB),
                iconColor: const Color(0xFF3B82F6),
                label: 'Thương hiệu',
                trailingText: detail.brandName ?? '—',
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: TablerIcons.scale,
                iconBackground: const Color(0xFFEFF1F4),
                iconColor: const Color(0xFF64748B),
                label: 'Đơn vị',
                trailingText: unitLabel,
                showChevron: false,
              ),
            ],
          ),
          if (detail.umos.isNotEmpty) ...[
            const SizedBox(height: 20),
            KSettingsSection(
              header: 'Đơn vị quy đổi',
              children: [
                for (final umo in detail.umos)
                  KSettingsRow(
                    leadingIcon: TablerIcons.package_export,
                    iconBackground: const Color(0xFFE6F7F0),
                    iconColor: const Color(0xFF10B981),
                    label: umo.label,
                    trailingText: [
                      '${umo.ratio} $unitLabel',
                      if (umo.sellPrice != null) _vnd.format(umo.sellPrice),
                    ].join(' · '),
                    showChevron: false,
                  ),
              ],
            ),
          ],
          if (customVariants.isNotEmpty) ...[
            const SizedBox(height: 20),
            KSettingsSection(
              header: 'Biến thể bán hàng',
              children: [
                const _VariantSectionNote(),
                for (final variant in customVariants)
                  _VariantSummaryTile(
                    variant: variant,
                    priceText: fmtPrice(variant.sellPrice ?? detail.sellPrice),
                    importPriceText: fmtPrice(variant.importPrice),
                    exportPriceText: fmtPrice(variant.exportPrice),
                    onTap: () => context.push(
                      '${_productRouteBase(context)}/${detail.id}/variants/${variant.id}',
                      extra: detail,
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          KSettingsSection(
            header: 'Giá',
            children: [
              KSettingsRow(
                leadingIcon: TablerIcons.coin,
                iconBackground: const Color(0xFFE6F7F0),
                iconColor: const Color(0xFF10B981),
                label: 'Giá bán',
                trailingText: _vnd.format(detail.sellPrice),
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: TablerIcons.arrow_down_circle,
                iconBackground: const Color(0xFFE7F1FB),
                iconColor: const Color(0xFF3B82F6),
                label: 'Giá nhập',
                trailingText: fmtPrice(detail.importPrice),
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: TablerIcons.arrow_up_circle,
                iconBackground: const Color(0xFFFEF6E5),
                iconColor: const Color(0xFFD97706),
                label: 'Giá xuất',
                trailingText: fmtPrice(detail.exportPrice),
                showChevron: false,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ProductBarcodesSection(
            barcodes: detail.barcodes,
            variantsById: variantsById,
          ),
          const SizedBox(height: 20),
          KSettingsSection(
            header: 'Tồn kho',
            children: [
              _StockSummaryRow(
                key: const ValueKey('stock-summary-base'),
                leadingIcon: TablerIcons.package,
                iconBackground: const Color(0xFFE7F1FB),
                iconColor: const Color(0xFF3B82F6),
                title: 'Tồn kho đơn vị gốc',
                value: fmtQty(baseStockTotal),
                subtitle: 'Tổng tồn của đơn vị gốc',
              ),
              _StockSummaryRow(
                key: const ValueKey('stock-summary-variants'),
                leadingIcon: TablerIcons.versions,
                iconBackground: const Color(0xFFF1ECFB),
                iconColor: const Color(0xFF8B5CF6),
                title: 'Tồn kho biến thể',
                value: fmtQty(variantStockTotal),
                subtitle: customVariants.isEmpty
                    ? 'Chưa có biến thể'
                    : 'Chạm để xem theo chi nhánh',
                onTap: customVariants.isEmpty
                    ? null
                    : () => _openVariantStockSheet(
                        context,
                        detail: detail,
                        groups: variantStockGroups,
                        unitLabel: unitLabel,
                        warehouseLabels: warehouseLabels,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ContainerLotsSection(
            lotsAsync: lotsAsync,
            unitLabel: unitLabel,
            warehouseLabels: warehouseLabels,
          ),
          const SizedBox(height: 20),
          KSettingsSection(
            header: 'Thống kê',
            children: [
              KSettingsRow(
                leadingIcon: TablerIcons.chart_bar,
                iconBackground: const Color(0xFFF1ECFB),
                iconColor: const Color(0xFF8B5CF6),
                label: 'Giá vốn trung bình',
                trailingText: _vnd.format(detail.avgCost),
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: TablerIcons.package,
                iconBackground: const Color(0xFFE7F1FB),
                iconColor: const Color(0xFF3B82F6),
                label: 'Đã nhập tổng',
                trailingText: fmtQty(detail.totalQtyImported),
                showChevron: false,
              ),
              KSettingsRow(
                leadingIcon: TablerIcons.cash,
                iconBackground: const Color(0xFFE6F7F0),
                iconColor: const Color(0xFF10B981),
                label: 'Giá trị tồn kho',
                trailingText: _vnd.format(detail.totalCostValue),
                showChevron: false,
              ),
            ],
          ),
          if (detail.description != null && detail.description!.isNotEmpty) ...[
            const SizedBox(height: 20),
            KSettingsSection(
              header: 'Mô tả',
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Text(
                    detail.description!,
                    style: TextStyle(fontSize: 14, color: c.textPrimary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _VariantStockGroup {
  const _VariantStockGroup({
    required this.variant,
    required this.stockRows,
    required this.lotRows,
  });

  final ProductVariant variant;
  final List<ProductStockLocation> stockRows;
  final List<ProductContainerLot> lotRows;

  num get totalQty =>
      stockRows.fold<num>(0, (sum, stock) => sum + stock.qty) +
      lotRows.fold<num>(0, (sum, lot) => sum + lot.qtyRemaining);
}

class _LotWarehouseGroup {
  const _LotWarehouseGroup({
    required this.warehouseId,
    required this.warehouseName,
    required this.lots,
  });

  final String warehouseId;
  final String warehouseName;
  final List<ProductContainerLot> lots;

  num get totalRemaining =>
      lots.fold<num>(0, (sum, lot) => sum + lot.qtyRemaining);
  num get totalInitial => lots.fold<num>(0, (sum, lot) => sum + lot.qtyInitial);
}

class _ProductBarcodesSection extends StatelessWidget {
  const _ProductBarcodesSection({
    required this.barcodes,
    required this.variantsById,
  });

  final List<ProductBarcode> barcodes;
  final Map<String, ProductVariant> variantsById;

  @override
  Widget build(BuildContext context) {
    final visible = barcodes
        .where((barcode) => barcode.value.trim().isNotEmpty)
        .toList(growable: false);
    return KSettingsSection(
      header: 'Mã vạch',
      children: [
        if (visible.isEmpty)
          const _SectionMessage(
            key: ValueKey('product-barcodes-empty'),
            text: 'Chưa có mã vạch',
          )
        else
          for (final barcode in visible)
            _BarcodeRow(
              key: ValueKey('product-barcode-${barcode.id}'),
              barcode: barcode,
              scopeLabel: _barcodeScopeLabel(barcode, variantsById),
            ),
      ],
    );
  }
}

class _BarcodeRow extends StatelessWidget {
  const _BarcodeRow({
    required this.barcode,
    required this.scopeLabel,
    super.key,
  });

  final ProductBarcode barcode;
  final String scopeLabel;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openBarcodeSheet(
          context,
          barcode: barcode,
          scopeLabel: scopeLabel,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF1F4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  TablerIcons.barcode,
                  color: Color(0xFF64748B),
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barcode.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$scopeLabel · ${_barcodeKindLabel(barcode)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (!barcode.isActive)
                _TinyStatusPill(
                  text: 'Tạm ngưng',
                  color: c.warning,
                  background: c.warningSoft,
                ),
              Icon(Icons.chevron_right, size: 20, color: c.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _TinyStatusPill extends StatelessWidget {
  const _TinyStatusPill({
    required this.text,
    required this.color,
    required this.background,
  });

  final String text;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

Future<void> _openBarcodeSheet(
  BuildContext context, {
  required ProductBarcode barcode,
  required String scopeLabel,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _BarcodeSheet(barcode: barcode, scopeLabel: scopeLabel),
  );
}

class _BarcodeSheet extends StatelessWidget {
  const _BarcodeSheet({required this.barcode, required this.scopeLabel});

  final ProductBarcode barcode;
  final String scopeLabel;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Mã vạch',
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Đóng',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(TablerIcons.x),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _BarcodeMetaPill(text: scopeLabel),
                  _BarcodeMetaPill(text: _barcodeKindLabel(barcode)),
                  if (!barcode.isActive)
                    const _BarcodeMetaPill(text: 'Tạm ngưng'),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: c.borderSoft),
                ),
                child: Column(
                  children: [
                    _BarcodePreviewBars(value: barcode.value),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const SizedBox(width: 40),
                        Expanded(
                          child: SelectableText(
                            barcode.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: c.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            tooltip: 'Sao chép',
                            padding: EdgeInsets.zero,
                            iconSize: 20,
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: barcode.value),
                              );
                              if (!context.mounted) return;
                              KNotify.success(context, 'Đã sao chép mã vạch');
                            },
                            icon: Icon(
                              TablerIcons.copy,
                              color: c.textSecondary,
                            ),
                          ),
                        ),
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

class _BarcodeMetaPill extends StatelessWidget {
  const _BarcodeMetaPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.surfaceHover,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: c.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _BarcodePreviewBars extends StatelessWidget {
  const _BarcodePreviewBars({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ColoredBox(
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 84,
          child: BarcodeWidget(
            barcode: Barcode.code128(),
            data: value,
            drawText: false,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ),
    );
  }
}

class _SectionMessage extends StatelessWidget {
  const _SectionMessage({
    required this.text,
    super.key,
    this.color,
    this.leading,
  });

  final String text;
  final Color? color;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 10)],
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: color ?? c.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _barcodeKindLabel(ProductBarcode barcode) {
  if (barcode.isInternal) return 'Nội bộ';
  if (barcode.isAlias) return 'Bán hàng';
  final kind = barcode.kind.trim();
  return kind.isEmpty ? 'Mã vạch' : kind;
}

String _barcodeScopeLabel(
  ProductBarcode barcode,
  Map<String, ProductVariant> variantsById,
) {
  final variantId = barcode.variantId;
  if (variantId != null && variantId.isNotEmpty) {
    return variantsById[variantId]?.name ?? 'Biến thể';
  }
  final packId = barcode.packId;
  if (packId != null && packId.isNotEmpty) return 'Đơn vị quy đổi';
  return 'Sản phẩm';
}

class _ContainerLotsSection extends StatelessWidget {
  const _ContainerLotsSection({
    required this.lotsAsync,
    required this.unitLabel,
    required this.warehouseLabels,
  });

  final AsyncValue<List<ProductContainerLot>> lotsAsync;
  final String unitLabel;
  final Map<String, String> warehouseLabels;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final lots = lotsAsync.valueOrNull ?? const <ProductContainerLot>[];
    Widget body;

    if (lotsAsync.isLoading && lots.isEmpty) {
      body = _SectionMessage(
        key: const ValueKey('product-container-lots-loading'),
        text: 'Đang tải lô hàng...',
        leading: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: c.accent600),
        ),
      );
    } else if (lotsAsync.hasError && lots.isEmpty) {
      body = _SectionMessage(
        key: const ValueKey('product-container-lots-error'),
        text: 'Không tải được lô hàng',
        color: c.danger,
      );
    } else if (lots.isEmpty) {
      body = const _SectionMessage(
        key: ValueKey('product-container-lots-empty'),
        text: 'Chưa có lô hàng',
      );
    } else {
      body = Column(
        key: const ValueKey('product-container-lots-section'),
        children: [
          _LotSummary(lots: lots, unitLabel: unitLabel),
          for (final group in _groupLots(lots, warehouseLabels))
            _LotWarehouseBlock(group: group, unitLabel: unitLabel),
        ],
      );
    }

    return KSettingsSection(header: 'Lô hàng', children: [body]);
  }
}

class _LotSummary extends StatelessWidget {
  const _LotSummary({required this.lots, required this.unitLabel});

  final List<ProductContainerLot> lots;
  final String unitLabel;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final total = lots.fold<num>(0, (sum, lot) => sum + lot.qtyRemaining);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              TablerIcons.packages,
              color: Color(0xFF10B981),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${lots.length} lô đang theo dõi',
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tổng còn ${_formatQty(total, unitLabel)}',
                  style: TextStyle(
                    color: c.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LotWarehouseBlock extends StatelessWidget {
  const _LotWarehouseBlock({required this.group, required this.unitLabel});

  final _LotWarehouseGroup group;
  final String unitLabel;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: c.surfaceHover,
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Row(
            children: [
              Icon(
                TablerIcons.building_warehouse,
                size: 17,
                color: c.textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.warehouseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${_formatQty(group.totalRemaining, unitLabel)} / '
                '${_formatQty(group.totalInitial, unitLabel)}',
                style: TextStyle(
                  color: c.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        for (final lot in group.lots) _LotRow(lot: lot, unitLabel: unitLabel),
      ],
    );
  }
}

class _LotRow extends StatelessWidget {
  const _LotRow({required this.lot, required this.unitLabel});

  final ProductContainerLot lot;
  final String unitLabel;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final progress = lot.qtyInitial <= 0
        ? 0.0
        : (lot.qtyRemaining / lot.qtyInitial).clamp(0, 1).toDouble();
    final accent = lot.isEmpty
        ? c.danger
        : lot.isPartiallyUsed
        ? c.warning
        : c.success;
    final dateText = lot.createdAt == null ? '—' : _date.format(lot.createdAt!);
    return Padding(
      key: ValueKey('product-lot-row-${lot.id}'),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 34,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                backgroundColor: c.borderSoft,
                color: accent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        lot.barcode ?? 'Lô ${_shortId(lot.id)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_formatQty(lot.qtyRemaining, unitLabel)} / '
                      '${_formatQty(lot.qtyInitial, unitLabel)}',
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _LotMeta(icon: TablerIcons.calendar, text: dateText),
                    _LotMeta(
                      icon: TablerIcons.versions,
                      text: lot.variantName ?? 'Mặc định',
                    ),
                    if (lot.isPartiallyUsed)
                      _LotMeta(
                        icon: TablerIcons.chart_pie,
                        text: 'Đã dùng ${((1 - progress) * 100).round()}%',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LotMeta extends StatelessWidget {
  const _LotMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: c.textMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: c.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

List<_LotWarehouseGroup> _groupLots(
  List<ProductContainerLot> lots,
  Map<String, String> warehouseLabels,
) {
  final byWarehouse = <String, List<ProductContainerLot>>{};
  for (final lot in lots) {
    byWarehouse.putIfAbsent(lot.warehouseId, () => []).add(lot);
  }
  final groups = [
    for (final entry in byWarehouse.entries)
      _LotWarehouseGroup(
        warehouseId: entry.key,
        warehouseName: warehouseLabels[entry.key] ?? entry.key,
        lots: entry.value,
      ),
  ]..sort((a, b) => a.warehouseName.compareTo(b.warehouseName));
  return groups;
}

String? _defaultVariantId(ProductDetail detail) {
  for (final variant in detail.variants) {
    if (variant.isDefault) return variant.id;
  }
  return null;
}

String _shortId(String id) => id.length <= 6 ? id : id.substring(0, 6);

String _lotStockLineName(
  ProductContainerLot lot,
  Map<String, String> warehouseLabels,
) {
  final warehouseName = warehouseLabels[lot.warehouseId] ?? lot.warehouseId;
  return 'Lô ${lot.barcode ?? _shortId(lot.id)} · $warehouseName';
}

class _StockSummaryRow extends StatelessWidget {
  const _StockSummaryRow({
    required this.leadingIcon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
    super.key,
    this.onTap,
  });

  final IconData leadingIcon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final isClickable = onTap != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(leadingIcon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                value,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (isClickable) ...[
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 20, color: c.textMuted),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _openVariantStockSheet(
  BuildContext context, {
  required ProductDetail detail,
  required List<_VariantStockGroup> groups,
  required String unitLabel,
  required Map<String, String> warehouseLabels,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _VariantStockSheet(
      detail: detail,
      groups: groups,
      unitLabel: unitLabel,
      warehouseLabels: warehouseLabels,
      onVariantTap: (variant) {
        Navigator.of(sheetContext).pop();
        context.push(
          '${_productRouteBase(context)}/${detail.id}/variants/${variant.id}',
          extra: detail,
        );
      },
    ),
  );
}

class _VariantStockSheet extends StatelessWidget {
  const _VariantStockSheet({
    required this.detail,
    required this.groups,
    required this.unitLabel,
    required this.warehouseLabels,
    required this.onVariantTap,
  });

  final ProductDetail detail;
  final List<_VariantStockGroup> groups;
  final String unitLabel;
  final Map<String, String> warehouseLabels;
  final ValueChanged<ProductVariant> onVariantTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final total = groups.fold<num>(0, (sum, group) => sum + group.totalQty);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return DraggableScrollableSheet(
      initialChildSize: 0.68,
      minChildSize: 0.38,
      maxChildSize: 0.92,
      builder: (context, controller) => Container(
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: c.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tồn kho biến thể',
                          style: TextStyle(
                            color: c.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${detail.name} · ${_formatQty(total, unitLabel)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: c.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Đóng',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(TablerIcons.x),
                  ),
                ],
              ),
            ),
            Expanded(
              child: groups.isEmpty
                  ? const Center(child: Text('Chưa có biến thể'))
                  : ListView.separated(
                      controller: controller,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 24 + bottomInset),
                      itemCount: groups.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => _VariantStockSheetRow(
                        group: groups[index],
                        unitLabel: unitLabel,
                        warehouseLabels: warehouseLabels,
                        onTap: () => onVariantTap(groups[index].variant),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VariantStockSheetRow extends StatelessWidget {
  const _VariantStockSheetRow({
    required this.group,
    required this.unitLabel,
    required this.warehouseLabels,
    required this.onTap,
  });

  final _VariantStockGroup group;
  final String unitLabel;
  final Map<String, String> warehouseLabels;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey('variant-stock-${group.variant.id}'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
          child: Column(
            children: [
              Row(
                children: [
                  _VariantThumb(imageUrl: group.variant.imageUrl),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      group.variant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _formatQty(group.totalQty, unitLabel),
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 20, color: c.textMuted),
                ],
              ),
              const SizedBox(height: 10),
              if (group.stockRows.isEmpty && group.lotRows.isEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Chưa có tồn kho cho biến thể này',
                    style: TextStyle(
                      color: c.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else ...[
                for (final stock in group.stockRows)
                  _StockBranchLine(
                    name:
                        warehouseLabels[stock.warehouseId] ?? stock.warehouseId,
                    qtyText: _formatQty(stock.qty, unitLabel),
                  ),
                for (final lot in group.lotRows)
                  _StockBranchLine(
                    name: _lotStockLineName(lot, warehouseLabels),
                    qtyText: _formatQty(lot.qtyRemaining, unitLabel),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StockBranchLine extends StatelessWidget {
  const _StockBranchLine({required this.name, required this.qtyText});

  final String name;
  final String qtyText;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(TablerIcons.building_store, size: 16, color: c.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: c.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            qtyText,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _VariantThumb extends StatelessWidget {
  const _VariantThumb({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final resolvedUrl = hasImage
        ? '${Env.imageBaseUrl}/product-avatar/$imageUrl'
        : null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: SizedBox(
        width: 40,
        height: 40,
        child: hasImage
            ? Image.network(
                resolvedUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _VariantThumbIcon(),
              )
            : const _VariantThumbIcon(),
      ),
    );
  }
}

class _VariantThumbIcon extends StatelessWidget {
  const _VariantThumbIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1ECFB),
      alignment: Alignment.center,
      child: const Icon(
        TablerIcons.versions,
        color: Color(0xFF8B5CF6),
        size: 20,
      ),
    );
  }
}

String _formatQty(num value, String unitLabel) {
  final qty = value == value.truncateToDouble()
      ? value.toInt().toString()
      : value.toString();
  return '$qty $unitLabel';
}

class _VariantSectionNote extends StatelessWidget {
  const _VariantSectionNote();

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(TablerIcons.info_circle, size: 18, color: c.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Biến thể dưới đây chỉ hiển thị giá bán, giá nhập và giá xuất. '
              'Tồn kho biến thể nằm ở mục Tồn kho.',
              style: TextStyle(
                color: c.textMuted,
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VariantSummaryTile extends StatelessWidget {
  const _VariantSummaryTile({
    required this.variant,
    required this.priceText,
    required this.importPriceText,
    required this.exportPriceText,
    required this.onTap,
  });

  final ProductVariant variant;
  final String priceText;
  final String importPriceText;
  final String exportPriceText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey('variant-price-${variant.id}'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            children: [
              _VariantThumb(imageUrl: variant.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _VariantChip(
                          icon: TablerIcons.coin,
                          label: priceText,
                          foreground: c.success,
                          background: const Color(0xFFE6F7F0),
                        ),
                        _VariantChip(
                          icon: TablerIcons.arrow_down_circle,
                          label: importPriceText,
                          foreground: const Color(0xFF3B82F6),
                          background: const Color(0xFFE7F1FB),
                        ),
                        _VariantChip(
                          icon: TablerIcons.arrow_up_circle,
                          label: exportPriceText,
                          foreground: const Color(0xFFD97706),
                          background: const Color(0xFFFEF6E5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 20, color: c.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _VariantChip extends StatelessWidget {
  const _VariantChip({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: foreground),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final imageUrl = detail.hasImage
        ? '${Env.imageBaseUrl}/product-avatar/${detail.imageUrl}'
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          button: imageUrl != null,
          label: imageUrl == null ? null : 'Xem ảnh sản phẩm',
          child: GestureDetector(
            key: const ValueKey('product-detail-image'),
            onTap: imageUrl == null
                ? null
                : () => _showProductImageViewer(context, detail.name, imageUrl),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (imageUrl == null)
                      _placeholder()
                    else
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, error, __) =>
                            _ImageErrorOverlay(url: imageUrl, error: error),
                      ),
                    if (imageUrl != null)
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.54),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              TablerIcons.arrows_maximize,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          detail.name,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        ProductStatusBadge(status: detail.status),
      ],
    );
  }

  Widget _placeholder() => const ColoredBox(
    color: Color(0xFFEFF1F4),
    child: Center(
      child: Icon(TablerIcons.package, size: 64, color: Color(0xFF94A3B8)),
    ),
  );

  Future<void> _showProductImageViewer(
    BuildContext context,
    String title,
    String imageUrl,
  ) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (context) => Dialog.fullscreen(
        key: const ValueKey('product-image-viewer'),
        backgroundColor: Colors.black,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      TablerIcons.photo_off,
                      color: Colors.white54,
                      size: 56,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 16,
                right: 64,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 8,
                child: IconButton.filled(
                  tooltip: 'Đóng ảnh',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(TablerIcons.x),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.14),
                    foregroundColor: Colors.white,
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

class _ImageErrorOverlay extends StatelessWidget {
  const _ImageErrorOverlay({required this.url, required this.error});

  final String url;
  final Object error;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF1F2937),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(TablerIcons.photo_off, color: Colors.redAccent, size: 28),
                SizedBox(width: 8),
                Text(
                  'Image load failed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              url,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              error.toString(),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.amberAccent,
                fontSize: 11,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
