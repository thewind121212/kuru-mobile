import 'package:flutter/foundation.dart';

@immutable
class ProductListFilter {
  const ProductListFilter({
    this.search,
    this.categoryIds = const [],
    this.brandIds = const [],
    this.warehouseIds = const [],
    this.attributeFilters = const [],
    this.minPrice,
    this.maxPrice,
  });

  final String? search;
  final List<String> categoryIds;
  final List<String> brandIds;
  final List<String> warehouseIds;
  final List<ProductAttributeFilter> attributeFilters;
  final int? minPrice;
  final int? maxPrice;

  bool get hasActiveFilters =>
      categoryIds.isNotEmpty ||
      brandIds.isNotEmpty ||
      warehouseIds.isNotEmpty ||
      attributeFilters.isNotEmpty ||
      minPrice != null ||
      maxPrice != null;

  int get activeCount =>
      categoryIds.length +
      brandIds.length +
      warehouseIds.length +
      attributeFilters.fold<int>(
        0,
        (count, filter) => count + filter.valueIds.length,
      ) +
      ((minPrice != null || maxPrice != null) ? 1 : 0);

  ProductListFilter copyWith({
    Object? search = _sentinel,
    List<String>? categoryIds,
    List<String>? brandIds,
    List<String>? warehouseIds,
    List<ProductAttributeFilter>? attributeFilters,
    Object? minPrice = _sentinel,
    Object? maxPrice = _sentinel,
  }) {
    return ProductListFilter(
      search: identical(search, _sentinel) ? this.search : search as String?,
      categoryIds: categoryIds ?? this.categoryIds,
      brandIds: brandIds ?? this.brandIds,
      warehouseIds: warehouseIds ?? this.warehouseIds,
      attributeFilters: attributeFilters ?? this.attributeFilters,
      minPrice: identical(minPrice, _sentinel)
          ? this.minPrice
          : minPrice as int?,
      maxPrice: identical(maxPrice, _sentinel)
          ? this.maxPrice
          : maxPrice as int?,
    );
  }

  ProductListFilter clearFilters() => ProductListFilter(search: search);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductListFilter &&
          other.search == search &&
          _listEquals(other.categoryIds, categoryIds) &&
          _listEquals(other.brandIds, brandIds) &&
          _listEquals(other.warehouseIds, warehouseIds) &&
          _attributeFilterListEquals(
            other.attributeFilters,
            attributeFilters,
          ) &&
          other.minPrice == minPrice &&
          other.maxPrice == maxPrice;

  @override
  int get hashCode => Object.hash(
    search,
    Object.hashAll(categoryIds),
    Object.hashAll(brandIds),
    Object.hashAll(warehouseIds),
    Object.hashAll(attributeFilters),
    minPrice,
    maxPrice,
  );
}

@immutable
class ProductAttributeFilter {
  const ProductAttributeFilter({
    required this.attributeId,
    required this.valueIds,
  });

  final String attributeId;
  final List<String> valueIds;

  ProductAttributeFilter copyWith({List<String>? valueIds}) {
    return ProductAttributeFilter(
      attributeId: attributeId,
      valueIds: valueIds ?? this.valueIds,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAttributeFilter &&
          other.attributeId == attributeId &&
          _listEquals(other.valueIds, valueIds);

  @override
  int get hashCode => Object.hash(attributeId, Object.hashAll(valueIds));
}

const _sentinel = Object();

bool _listEquals(List<String> a, List<String> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

bool _attributeFilterListEquals(
  List<ProductAttributeFilter> a,
  List<ProductAttributeFilter> b,
) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
