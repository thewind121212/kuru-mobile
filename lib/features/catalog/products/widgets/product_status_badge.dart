import 'package:flutter/material.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';

class ProductStatusBadge extends StatelessWidget {
  const ProductStatusBadge({required this.status, super.key});
  final ProductStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      ProductStatus.active => (
        const Color(0xFFE6F7F0),
        const Color(0xFF10B981),
        'Đang bán',
      ),
      ProductStatus.inactive => (
        const Color(0xFFFEF6E5),
        const Color(0xFFD97706),
        'Tạm ngưng',
      ),
      ProductStatus.archived => (
        const Color(0xFFEFF1F4),
        const Color(0xFF64748B),
        'Ngừng kinh doanh',
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }
}
