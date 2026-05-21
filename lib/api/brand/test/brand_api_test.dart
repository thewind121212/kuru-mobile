import 'package:test/test.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart';

/// tests for BrandApi
void main() {
  final instance = KuruBrandApi().getBrandApi();

  group(BrandApi, () {
    // CreateBrand
    //
    //Future<CreateBrand200Response> createBrand(CreateBrandRequest createBrandRequest) async
    test('test createBrand', () async {
      // TODO
    });

    // DeleteBrand
    //
    //Future<DeleteBrand200Response> deleteBrand(DeleteBrandRequest deleteBrandRequest) async
    test('test deleteBrand', () async {
      // TODO
    });

    // GetBrandById
    //
    //Future<GetBrandById200Response> getBrandById(String brandId) async
    test('test getBrandById', () async {
      // TODO
    });

    // GetBrandOverview
    //
    //Future<GetBrandOverview200Response> getBrandOverview({ String searchString, int page, int limit }) async
    test('test getBrandOverview', () async {
      // TODO
    });

    // UpdateBrand
    //
    //Future<UpdateBrand200Response> updateBrand(UpdateBrandRequest updateBrandRequest) async
    test('test updateBrand', () async {
      // TODO
    });
  });
}
