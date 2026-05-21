// TablerIcons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

class ProductFilterChipData {
  const ProductFilterChipData({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;
}

class ProductFilterBar extends StatelessWidget {
  const ProductFilterBar({
    required this.searchController,
    required this.activeCount,
    required this.activeChips,
    required this.onFilterTap,
    required this.onClearAll,
    super.key,
  });

  final TextEditingController searchController;
  final int activeCount;
  final List<ProductFilterChipData> activeChips;
  final VoidCallback onFilterTap;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _FilterButton(count: activeCount, onTap: onFilterTap),
            ],
          ),
          if (activeChips.isNotEmpty) ...[
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final chip in activeChips) ...[
                    _ActiveChip(label: chip.label, onRemove: chip.onRemove),
                    const SizedBox(width: 7),
                  ],
                  TextButton(
                    onPressed: onClearAll,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Xóa lọc'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: c.surfaceElev,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: count > 0 ? c.accent500 : c.borderSoft,
              width: count > 0 ? 1.4 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                TablerIcons.adjustments_horizontal,
                size: 19,
                color: c.textPrimary,
              ),
              if (count > 0) ...[
                const SizedBox(width: 7),
                Container(
                  constraints: const BoxConstraints(minWidth: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: c.accent600,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
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

class _ActiveChip extends StatelessWidget {
  const _ActiveChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      height: 32,
      padding: const EdgeInsets.only(left: 10, right: 5),
      decoration: BoxDecoration(
        color: c.accent50,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.accent200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: c.accent700,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(TablerIcons.x, size: 15, color: c.accent700),
          ),
        ],
      ),
    );
  }
}
