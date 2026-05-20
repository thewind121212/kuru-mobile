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
    this.onLongPress,
    super.key,
  });

  final ProductSummary product;
  final VoidCallback onTap;
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              _leading(c),
              const SizedBox(width: 14),
              Expanded(child: _titles(c)),
              const SizedBox(width: 10),
              _trailing(c),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leading(KuruColors c) {
    if (product.hasImage) {
      final url = '${Env.imageBaseUrl}/product-avatar/${product.imageUrl}';
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _placeholder(c),
        ),
      );
    }
    return _placeholder(c);
  }

  Widget _placeholder(KuruColors c) => Container(
    key: const ValueKey('product-card-placeholder'),
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: const Color(0xFFEFF1F4),
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Icon(TablerIcons.package, color: Color(0xFF64748B), size: 22),
  );

  Widget _titles(KuruColors c) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        product.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: c.textPrimary,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        '${product.categoryName ?? 'Chưa phân loại'} · '
        '${product.brandName ?? '—'}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13, color: c.textMuted),
      ),
    ],
  );

  Widget _trailing(KuruColors c) {
    final unitLabel = resolveUomLabel(product.baseUnitCode);
    final (bg, fg, label) = switch (product.currentStock) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _vnd.format(product.sellPricePerUnit),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: c.primary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ),
      ],
    );
  }
}
