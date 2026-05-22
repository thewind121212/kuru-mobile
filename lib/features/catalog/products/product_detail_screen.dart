import 'package:flutter/material.dart';
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
          '/catalog/products/${detail.id}/edit',
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
    final variantStockGroups = [
      for (final variant in customVariants)
        _VariantStockGroup(
          variant: variant,
          rows: rowsByVariantId[variant.id] ?? const <ProductStockLocation>[],
        ),
    ];
    final variantStockTotal = variantStockGroups.fold<num>(
      0,
      (sum, group) => sum + group.totalQty,
    );
    final warehouseLabels = customVariants.isEmpty
        ? const <String, String>{}
        : {
            for (final warehouse
                in ref.watch(productWarehouseOptionsProvider).valueOrNull ??
                    const <ProductWarehouseOption>[])
              warehouse.warehouseId: warehouse.name,
          };
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
                label: 'Danh mục',
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
                      '/catalog/products/${detail.id}/variants/${variant.id}',
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
  const _VariantStockGroup({required this.variant, required this.rows});

  final ProductVariant variant;
  final List<ProductStockLocation> rows;

  num get totalQty => rows.fold<num>(0, (sum, stock) => sum + stock.qty);
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
          '/catalog/products/${detail.id}/variants/${variant.id}',
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
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
              if (group.rows.isEmpty)
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
              else
                for (final stock in group.rows)
                  _StockBranchLine(
                    name:
                        warehouseLabels[stock.warehouseId] ?? stock.warehouseId,
                    qtyText: _formatQty(stock.qty, unitLabel),
                  ),
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
