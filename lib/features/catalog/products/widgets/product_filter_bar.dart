// (flutter_tabler_icons uses snake_case symbols)
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

class ProductFilterBar extends StatelessWidget {
  const ProductFilterBar({
    required this.searchController,
    required this.categoryLabel,
    required this.brandLabel,
    required this.onCategoryTap,
    required this.onBrandTap,
    super.key,
  });

  final TextEditingController searchController;
  final String? categoryLabel;
  final String? brandLabel;
  final VoidCallback onCategoryTap;
  final VoidCallback onBrandTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Tìm sản phẩm...',
              prefixIcon: const Icon(TablerIcons.search, size: 18),
              filled: true,
              fillColor: c.surfaceElev,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _Chip(
                  label: 'Danh mục: ${categoryLabel ?? 'Tất cả'}',
                  onTap: onCategoryTap,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Chip(
                  label: 'Thương hiệu: ${brandLabel ?? 'Tất cả'}',
                  onTap: onBrandTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: c.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(TablerIcons.chevron_down, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
