import 'package:test/test.dart';
import 'package:kuru_product_api/kuru_product_api.dart';


/// tests for ProductApi
void main() {
  final instance = KuruProductApi().getProductApi();

  group(ProductApi, () {
    // AdjustContainerLot
    //
    //Future<AdjustContainerLot200Response> adjustContainerLot(AdjustContainerLotRequest adjustContainerLotRequest) async
    test('test adjustContainerLot', () async {
      // TODO
    });

    // AdjustProductStock
    //
    //Future<AdjustProductStock200Response> adjustProductStock(AdjustProductStockRequest adjustProductStockRequest) async
    test('test adjustProductStock', () async {
      // TODO
    });

    // CreateContainerLots
    //
    //Future<CreateContainerLots200Response> createContainerLots(CreateContainerLotsRequest createContainerLotsRequest) async
    test('test createContainerLots', () async {
      // TODO
    });

    // CreateProduct
    //
    //Future<CreateProduct200Response> createProduct(CreateProductRequest createProductRequest) async
    test('test createProduct', () async {
      // TODO
    });

    // CreateProductVariant
    //
    //Future<CreateProductVariant200Response> createProductVariant(CreateProductVariantRequest createProductVariantRequest) async
    test('test createProductVariant', () async {
      // TODO
    });

    // DeleteContainerLot
    //
    //Future<DeleteContainerLot200Response> deleteContainerLot(DeleteContainerLotRequest deleteContainerLotRequest) async
    test('test deleteContainerLot', () async {
      // TODO
    });

    // DeleteProduct
    //
    //Future<DeleteProduct200Response> deleteProduct(DeleteProductRequest deleteProductRequest) async
    test('test deleteProduct', () async {
      // TODO
    });

    // DeleteProductVariant
    //
    //Future<DeleteProductVariant200Response> deleteProductVariant(DeleteProductVariantRequest deleteProductVariantRequest) async
    test('test deleteProductVariant', () async {
      // TODO
    });

    // GetContainerLots
    //
    //Future<GetContainerLots200Response> getContainerLots(String productId, { String variantId }) async
    test('test getContainerLots', () async {
      // TODO
    });

    // GetProductById
    //
    //Future<GetProductById200Response> getProductById(String productId) async
    test('test getProductById', () async {
      // TODO
    });

    // GetProductOverview
    //
    //Future<GetProductOverview200Response> getProductOverview({ String searchString, BuiltList<String> categoryIds, BuiltList<String> distributorIds, int page, int limit, BuiltList<String> warehouseIds, BuiltList<String> attributeFilters, double minPrice, double maxPrice, BuiltList<String> brandIds }) async
    test('test getProductOverview', () async {
      // TODO
    });

    // GetProductVariants
    //
    //Future<GetProductVariants200Response> getProductVariants(String productId) async
    test('test getProductVariants', () async {
      // TODO
    });

    // GetStockHistory
    //
    //Future<GetStockHistory200Response> getStockHistory({ String productId, String warehouseId, DateTime fromDate, DateTime toDate, int page, int limit, String variantId, String type }) async
    test('test getStockHistory', () async {
      // TODO
    });

    // SaveProductVariants
    //
    //Future<SaveProductVariants200Response> saveProductVariants(SaveProductVariantsRequest saveProductVariantsRequest) async
    test('test saveProductVariants', () async {
      // TODO
    });

    // UpdateProductBarcodes
    //
    //Future<UpdateProductBarcodes200Response> updateProductBarcodes(UpdateProductBarcodesRequest updateProductBarcodesRequest) async
    test('test updateProductBarcodes', () async {
      // TODO
    });

    // UpdateProductInfo
    //
    //Future<UpdateProductInfo200Response> updateProductInfo(UpdateProductInfoRequest updateProductInfoRequest) async
    test('test updateProductInfo', () async {
      // TODO
    });

    // UpdateProductUmos
    //
    //Future<UpdateProductUmos200Response> updateProductUmos(UpdateProductUmosRequest updateProductUmosRequest) async
    test('test updateProductUmos', () async {
      // TODO
    });

    // UpdateProductVariant
    //
    //Future<UpdateProductVariant200Response> updateProductVariant(UpdateProductVariantRequest updateProductVariantRequest) async
    test('test updateProductVariant', () async {
      // TODO
    });

  });
}
