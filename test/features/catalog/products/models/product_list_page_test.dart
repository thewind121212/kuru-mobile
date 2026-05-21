import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_page.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_status.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';

ProductSummary _ps(String id) => ProductSummary(
  id: id,
  name: id,
  status: ProductStatus.active,
  baseUnitCode: 'each',
  sellPricePerUnit: 0,
  currentStock: 0,
  demandStock: 0,
  variantCount: 0,
);

void main() {
  group('ProductListPage.hasMore', () {
    test('true when page is full AND more rows remain', () {
      final p = ProductListPage(
        items: List.generate(50, (i) => _ps('p$i')),
        page: 1,
        limit: 50,
        totalProducts: 120,
      );
      expect(p.hasMore, true);
    });
    test('false when fetched count covers total', () {
      final p = ProductListPage(
        items: List.generate(50, (i) => _ps('p$i')),
        page: 1,
        limit: 50,
        totalProducts: 50,
      );
      expect(p.hasMore, false);
    });
    test('false when page underfilled', () {
      final p = ProductListPage(
        items: List.generate(30, (i) => _ps('p$i')),
        page: 1,
        limit: 50,
        totalProducts: 30,
      );
      expect(p.hasMore, false);
    });
  });

  group('ProductListFilter', () {
    test('value equality (same args)', () {
      const a = ProductListFilter(
        search: 'cà',
        categoryIds: ['c-1'],
        brandIds: ['b-1'],
        warehouseIds: ['w-1'],
        attributeFilters: [
          ProductAttributeFilter(attributeId: 'a-1', valueIds: ['v-1', 'v-2']),
        ],
        minPrice: 1000,
      );
      const b = ProductListFilter(
        search: 'cà',
        categoryIds: ['c-1'],
        brandIds: ['b-1'],
        warehouseIds: ['w-1'],
        attributeFilters: [
          ProductAttributeFilter(attributeId: 'a-1', valueIds: ['v-1', 'v-2']),
        ],
        minPrice: 1000,
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
    test('inequality on different search', () {
      const a = ProductListFilter(search: 'cà');
      const b = ProductListFilter(search: 'trà');
      expect(a == b, false);
    });
  });
}
