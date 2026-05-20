import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_list_filter.freezed.dart';

@freezed
class ProductListFilter with _$ProductListFilter {
  const factory ProductListFilter({
    String? search,
    String? categoryId,
    String? brandId,
  }) = _ProductListFilter;
}
