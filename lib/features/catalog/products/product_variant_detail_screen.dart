import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_section.dart';
import 'package:kuru_mobile/features/catalog/products/data/uoms.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_variant.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_warehouse_option.dart';
import 'package:kuru_mobile/features/catalog/products/providers/product_providers.dart';

final _vnd = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: 'đ',
  decimalDigits: 0,
);

class ProductVariantDetailScreen extends ConsumerWidget {
  const ProductVariantDetailScreen({
    required this.productId,
    required this.variantId,
    this.initial,
    super.key,
  });

  final String productId;
  final String variantId;
  final ProductDetail? initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = initial == null
        ? ref.watch(productByIdProvider(productId))
        : AsyncValue.data(initial!);
    final c = kuruColors(context);

    return Scaffold(
      backgroundColor: c.pageBg,
      appBar: AppBar(
        backgroundColor: c.pageBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          async.maybeWhen(
            data: (detail) =>
                _findVariant(detail, variantId)?.name ?? 'Biến thể',
            orElse: () => 'Biến thể',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Không tải được: $e')),
        data: (detail) {
          final variant = _findVariant(detail, variantId);
          if (variant == null) {
            return const Center(child: Text('Không tìm thấy biến thể'));
          }
          return _VariantDetailBody(detail: detail, variant: variant);
        },
      ),
    );
  }

  ProductVariant? _findVariant(ProductDetail detail, String id) {
    for (final variant in detail.variants) {
      if (variant.id == id && !variant.isDefault) return variant;
    }
    return null;
  }
}

class _VariantDetailBody extends ConsumerWidget {
  const _VariantDetailBody({required this.detail, required this.variant});

  final ProductDetail detail;
  final ProductVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitLabel =
        detail.baseUnitLabel ?? resolveUomLabel(detail.baseUnitCode);
    final stocks = detail.stocks
        .where((stock) => stock.variantId == variant.id)
        .toList(growable: false);
    final totalStock = stocks.fold<num>(0, (sum, stock) => sum + stock.qty);
    final aliases = detail.barcodes
        .where(
          (barcode) =>
              barcode.variantId == variant.id &&
              barcode.isAlias &&
              barcode.isActive,
        )
        .toList(growable: false);
    final warehouseLabels = <String, String>{};
    final warehouses =
        ref.watch(productWarehouseOptionsProvider).valueOrNull ??
        const <ProductWarehouseOption>[];
    for (final warehouse in warehouses) {
      warehouseLabels[warehouse.warehouseId] = warehouse.name;
    }

    String fmtQty(num value) {
      final qty = value == value.truncateToDouble()
          ? value.toInt().toString()
          : value.toString();
      return '$qty $unitLabel';
    }

    String fmtPrice(num? variantValue, num? baseValue) {
      if (variantValue != null) return _vnd.format(variantValue);
      if (baseValue != null) return '${_vnd.format(baseValue)} (gốc)';
      return '—';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12, bottom: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _VariantHero(
              productName: detail.name,
              variant: variant,
              priceText: fmtPrice(variant.sellPrice, detail.sellPrice),
              stockText: fmtQty(totalStock),
            ),
          ),
          const SizedBox(height: 20),
          KSettingsSection(
            header: 'Giá biến thể',
            children: [
              _InfoRow(
                icon: TablerIcons.coin,
                iconBackground: const Color(0xFFE6F7F0),
                iconColor: const Color(0xFF10B981),
                label: 'Giá bán',
                value: fmtPrice(variant.sellPrice, detail.sellPrice),
              ),
              _InfoRow(
                icon: TablerIcons.arrow_down_circle,
                iconBackground: const Color(0xFFE7F1FB),
                iconColor: const Color(0xFF3B82F6),
                label: 'Giá nhập',
                value: fmtPrice(variant.importPrice, detail.importPrice),
              ),
              _InfoRow(
                icon: TablerIcons.arrow_up_circle,
                iconBackground: const Color(0xFFFEF6E5),
                iconColor: const Color(0xFFD97706),
                label: 'Giá xuất',
                value: fmtPrice(variant.exportPrice, detail.exportPrice),
              ),
            ],
          ),
          if (variant.attributes.isNotEmpty) ...[
            const SizedBox(height: 20),
            KSettingsSection(
              header: 'Thuộc tính',
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final entry in variant.attributes.entries)
                        _AttributePill(label: entry.key, value: entry.value),
                    ],
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          KSettingsSection(
            header: 'Tồn kho theo chi nhánh',
            children: [
              _InfoRow(
                icon: TablerIcons.package,
                iconBackground: const Color(0xFFE7F1FB),
                iconColor: const Color(0xFF3B82F6),
                label: 'Tổng hiện có',
                value: fmtQty(totalStock),
              ),
              if (stocks.isEmpty)
                const _EmptyPanel(text: 'Chưa có tồn kho cho biến thể này')
              else
                for (final stock in stocks)
                  _StockBranchRow(
                    name:
                        warehouseLabels[stock.warehouseId] ?? stock.warehouseId,
                    qtyText: fmtQty(stock.qty),
                  ),
            ],
          ),
          const SizedBox(height: 20),
          KSettingsSection(
            header: 'Mã vạch bán hàng',
            children: [
              if (aliases.isEmpty)
                const _EmptyPanel(
                  text: 'Chưa có mã vạch bán hàng cho biến thể này',
                )
              else
                for (final alias in aliases)
                  _InfoRow(
                    icon: TablerIcons.barcode,
                    iconBackground: const Color(0xFFEFF1F4),
                    iconColor: const Color(0xFF64748B),
                    label: alias.value,
                    value: 'Alias',
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VariantHero extends StatelessWidget {
  const _VariantHero({
    required this.productName,
    required this.variant,
    required this.priceText,
    required this.stockText,
  });

  final String productName;
  final ProductVariant variant;
  final String priceText;
  final String stockText;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VariantHeroMedia(imageUrl: variant.imageUrl, title: variant.name),
          const SizedBox(height: 14),
          Text(
            variant.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 22,
              height: 1.14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            productName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: c.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroChip(
                icon: TablerIcons.coin,
                label: priceText,
                color: c.success,
                background: const Color(0xFFE6F7F0),
              ),
              _HeroChip(
                icon: TablerIcons.package,
                label: stockText,
                color: c.accent600,
                background: c.accent50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VariantHeroMedia extends StatelessWidget {
  const _VariantHeroMedia({required this.imageUrl, required this.title});

  final String? imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final resolvedUrl = hasImage
        ? '${Env.imageBaseUrl}/product-avatar/$imageUrl'
        : null;
    return Semantics(
      button: hasImage,
      label: hasImage ? 'Xem ảnh biến thể' : null,
      child: GestureDetector(
        key: const ValueKey('variant-detail-image-tap-target'),
        onTap: hasImage
            ? () => _showVariantImageViewer(context, title, resolvedUrl!)
            : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: double.infinity,
            height: 178,
            child: hasImage
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        resolvedUrl!,
                        key: const ValueKey('variant-detail-image'),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const _VariantHeroIcon(size: 44),
                      ),
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
                  )
                : const _VariantHeroIcon(size: 48),
          ),
        ),
      ),
    );
  }

  Future<void> _showVariantImageViewer(
    BuildContext context,
    String title,
    String imageUrl,
  ) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (context) => Dialog.fullscreen(
        key: const ValueKey('variant-image-viewer'),
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

class _VariantHeroIcon extends StatelessWidget {
  const _VariantHeroIcon({this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1ECFB),
      alignment: Alignment.center,
      child: Icon(
        TablerIcons.versions,
        color: const Color(0xFF8B5CF6),
        size: size,
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttributePill extends StatelessWidget {
  const _AttributePill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surfaceHover,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.borderSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          '$label: $value',
          style: TextStyle(
            color: c.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 19, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: c.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockBranchRow extends StatelessWidget {
  const _StockBranchRow({required this.name, required this.qtyText});

  final String name;
  final String qtyText;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: c.surfaceHover,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.borderSoft),
        ),
        child: Row(
          children: [
            Icon(TablerIcons.building_warehouse, size: 18, color: c.textMuted),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              qtyText,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: c.surfaceHover,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: c.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
