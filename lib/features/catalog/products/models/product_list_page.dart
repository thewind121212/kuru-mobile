import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_summary.dart';

part 'product_list_page.freezed.dart';

@freezed
class ProductListPage with _$ProductListPage {
  const factory ProductListPage({
    required List<ProductSummary> items,
    required int page,
    required int limit,
    required int totalProducts,
  }) = _ProductListPage;

  const ProductListPage._();

  bool get hasMore => items.length < totalProducts;
}
