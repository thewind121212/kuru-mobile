import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/features/catalog/products/data/uoms.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.onTap,
    this.imageAspectRatio = 1,
    this.onLongPress,
    super.key,
  });

  final ProductSummary product;
  final VoidCallback onTap;
  final double imageAspectRatio;
  final VoidCallback? onLongPress;

  static final _vnd = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );
  static final _qty = NumberFormat.decimalPattern('vi_VN');

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _productImage(c),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _title(c),
                  const SizedBox(height: 7),
                  _priceAndStock(c),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productImage(KuruColors c) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : 180.0;
      final imageHeight = (width / imageAspectRatio).clamp(136.0, 260.0);
      final pixelRatio = MediaQuery.devicePixelRatioOf(context);

      return SizedBox(
        width: double.infinity,
        height: imageHeight,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          child: product.hasImage
              ? Image.network(
                  '${Env.imageBaseUrl}/product-avatar/${product.imageUrl}',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  cacheWidth: (width * pixelRatio).round(),
                  errorBuilder: (_, _, _) => _placeholder(c),
                )
              : _placeholder(c),
        ),
      );
    },
  );

  Widget _placeholder(KuruColors c) => Container(
    key: const ValueKey('product-card-placeholder'),
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(color: Color(0xFFEFF1F4)),
    child: Center(
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: c.surfaceElev.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          TablerIcons.package,
          color: Color(0xFF64748B),
          size: 25,
        ),
      ),
    ),
  );

  Widget _title(KuruColors c) => Text(
    product.name,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 12,
      height: 1.22,
      fontWeight: FontWeight.w700,
      color: c.textPrimary,
    ),
  );

  Widget _priceAndStock(KuruColors c) {
    final unitLabel = resolveUomLabel(product.baseUnitCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _vnd.format(product.sellPricePerUnit),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: c.primary,
          ),
        ),
        const SizedBox(height: 6),
        _StockProgressBar(
          current: product.currentStock,
          demand: product.demandStock > 0 ? product.demandStock : null,
          unitLabel: unitLabel,
          formatQty: _formatQty,
        ),
      ],
    );
  }

  static String _formatQty(num value) => _qty.format(value);
}

class _StockProgressBar extends StatelessWidget {
  const _StockProgressBar({
    required this.current,
    required this.demand,
    required this.unitLabel,
    required this.formatQty,
  });

  final num current;
  final num? demand;
  final String unitLabel;
  final String Function(num value) formatQty;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final hasDemand = demand != null;
    final isEmpty = current <= 0;
    final isUnderDemand = hasDemand && current < demand!;
    final isTargetMet = hasDemand && current >= demand!;
    final stockColor = isEmpty
        ? c.danger
        : isUnderDemand
        ? c.warning
        : c.success;
    final stockLabel = isEmpty
        ? 'Hết hàng'
        : '${formatQty(current)} $unitLabel';

    final maxValue = hasDemand
        ? <num>[current, demand!, 1].reduce((a, b) => a > b ? a : b)
        : 1;
    final scaleMax = hasDemand ? maxValue * 1.15 : 1;
    final currentFraction = hasDemand
        ? (current / scaleMax).clamp(0, 1).toDouble()
        : isEmpty
        ? 1.0
        : 1.0;
    final demandFraction = hasDemand
        ? (demand! / scaleMax).clamp(0, 1).toDouble()
        : 0.0;

    return Column(
      key: const ValueKey('product-card-stock-progress'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                stockLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: stockColor,
                ),
              ),
            ),
            if (hasDemand) ...[
              const SizedBox(width: 5),
              Text(
                'Cần ${formatQty(demand!)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: isTargetMet ? c.success : c.textMuted,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : 120.0;
            final markerLeft = (width * demandFraction).clamp(0.0, width);
            final fillWidth = current > 0
                ? (width * currentFraction).clamp(4.0, width)
                : width;

            return SizedBox(
              height: 13,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    top: 2.5,
                    bottom: 2.5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: c.textMuted.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: c.border.withValues(alpha: 0.55),
                          width: 0.7,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: fillWidth,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: isEmpty ? c.dangerSoft : stockColor,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (hasDemand)
                    Positioned(
                      left: markerLeft - 2.5,
                      top: 0,
                      bottom: 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: isTargetMet ? c.success : c.textPrimary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const SizedBox(width: 3),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
