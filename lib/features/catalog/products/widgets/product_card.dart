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
    final (bg, fg, label) = _stockTone;
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ),
      ],
    );
  }

  (Color, Color, String) get _stockTone {
    final unitLabel = resolveUomLabel(product.baseUnitCode);
    return switch (product.currentStock) {
      0 => (const Color(0xFFFBE9EC), const Color(0xFFE11D48), 'Hết hàng'),
      _ when product.currentStock < product.demandStock => (
        const Color(0xFFFEF6E5),
        const Color(0xFFD97706),
        '${product.currentStock} $unitLabel',
      ),
      _ => (
        const Color(0xFFE6F7F0),
        const Color(0xFF10B981),
        '${product.currentStock} $unitLabel',
      ),
    };
  }
}
