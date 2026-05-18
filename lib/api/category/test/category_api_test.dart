import 'package:test/test.dart';
import 'package:kuru_category_api/kuru_category_api.dart';


/// tests for CategoryApi
void main() {
  final instance = KuruCategoryApi().getCategoryApi();

  group(CategoryApi, () {
    // CreateCategory
    //
    //Future<CreateCategory200Response> createCategory(CreateCategoryRequest createCategoryRequest) async
    test('test createCategory', () async {
      // TODO
    });

    // GetCategoryById
    //
    //Future<GetCategoryById200Response> getCategoryById(GetCategoryByIdRequest getCategoryByIdRequest) async
    test('test getCategoryById', () async {
      // TODO
    });

    // GetCategoryOverview
    //
    //Future<GetCategoryOverview200Response> getCategoryOverview() async
    test('test getCategoryOverview', () async {
      // TODO
    });

    // GetCategoryOverviewWithDepth
    //
    //Future<GetCategoryOverview200Response> getCategoryOverviewWithDepth(int depth) async
    test('test getCategoryOverviewWithDepth', () async {
      // TODO
    });

    // GetCategoryTree
    //
    //Future<GetCategoryTree200Response> getCategoryTree(String categoryId) async
    test('test getCategoryTree', () async {
      // TODO
    });

    // RemoveCategory
    //
    //Future<RemoveCategory200Response> removeCategory(RemoveCategoryRequest removeCategoryRequest) async
    test('test removeCategory', () async {
      // TODO
    });

    // UpdateCategory
    //
    //Future<UpdateCategory200Response> updateCategory(UpdateCategoryRequest updateCategoryRequest) async
    test('test updateCategory', () async {
      // TODO
    });

  });
}
