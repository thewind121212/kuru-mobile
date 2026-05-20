import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/products/data/product_repository.dart';
import 'package:kuru_mobile/features/catalog/products/models/create_product_body.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_detail.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_filter.dart';
import 'package:kuru_mobile/features/catalog/products/models/product_list_page.dart';
import 'package:kuru_mobile/features/catalog/products/models/update_product_info_body.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late ProductRepository repo;

  setUpAll(() {
    registerFallbackValue(Options());
  });

  setUp(() {
    dio = _MockDio();
    repo = ProductRepository(dio);
  });

  Response<dynamic> ok(dynamic data, {int status = 200}) => Response(
    requestOptions: RequestOptions(),
    data: {'success': true, 'data': data},
    statusCode: status,
  );

  DioException dioErr(int status, String message) => DioException(
    requestOptions: RequestOptions(),
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: RequestOptions(),
      statusCode: status,
      data: {
        'success': false,
        'error': {'message': message, 'code': null},
      },
    ),
  );

  group('getOverview', () {
    test('200 success returns parsed list page', () async {
      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => ok({
          'products': [
            {
              'id': 'p-1',
              'name': 'A',
              'imageUrl': '',
              'status': 'ACTIVE',
              'baseUnitCode': 'each',
              'sellPricePerUnit': 1000,
              'currentStock': 0,
              'demandStock': 0,
              'category': '',
              'variantCount': 0,
            },
          ],
          'totalProducts': 1,
          'totalValue': 0,
          'maxSellPrice': 1000,
          'totalVariants': 1,
        }),
      );
      final res = await repo.getOverview(filter: const ProductListFilter());
      expect(res, isA<ApiSuccess<ProductListPage>>());
      final page = (res as ApiSuccess<ProductListPage>).data;
      expect(page.items.length, 1);
      expect(page.items.first.name, 'A');
      expect(page.totalProducts, 1);
    });

    test('401 → UnauthorizedException', () async {
      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(dioErr(401, 'session invalid'));
      final res = await repo.getOverview(filter: const ProductListFilter());
      expect(res, isA<ApiFailure<ProductListPage>>());
      expect(
        (res as ApiFailure<ProductListPage>).err,
        isA<UnauthorizedException>(),
      );
    });

    test('passes search + categoryId + brandId as query params', () async {
      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => ok({
          'products': <Map<String, dynamic>>[],
          'totalProducts': 0,
          'totalValue': 0,
          'maxSellPrice': 0,
          'totalVariants': 0,
        }),
      );
      await repo.getOverview(
        filter: const ProductListFilter(
          search: 'cà',
          categoryId: 'c-1',
          brandId: 'b-1',
        ),
        page: 2,
      );
      final captured =
          verify(
                () => dio.get<dynamic>(
                  '/product/GetProductOverview',
                  queryParameters: captureAny(named: 'queryParameters'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured['searchString'], 'cà');
      expect(captured['categoryIds'], ['c-1']);
      expect(captured['brandIds'], ['b-1']);
      expect(captured['page'], 2);
      expect(captured['limit'], 50);
    });
  });

  group('getById', () {
    test('200 returns ProductDetail', () async {
      when(
        () => dio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => ok({
          'id': 'p-1',
          'name': 'X',
          'imageUrl': 'k.jpg',
          'status': 'ACTIVE',
          'baseUnitCode': 'each',
          'sellPrice': 1000,
          'demandStock': 0,
          'avgCost': 0,
          'totalCostValue': 0,
          'totalQtyImported': 0,
        }),
      );
      final res = await repo.getById('p-1');
      expect((res as ApiSuccess<ProductDetail>).data.id, 'p-1');
    });
  });

  group('create', () {
    test('201 returns productId', () async {
      when(
        () => dio.post<dynamic>(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => ok({'productId': 'new-1'}, status: 201));
      final res = await repo.create(
        const CreateProductBody(
          name: 'X',
          baseUnitCode: 'each',
          sellPrice: 1000,
        ),
      );
      expect((res as ApiSuccess<String>).data, 'new-1');
    });

    test('400 → BadRequestException with BE message', () async {
      when(
        () => dio.post<dynamic>(any(), data: any(named: 'data')),
      ).thenThrow(dioErr(400, 'Name already exists'));
      final res = await repo.create(
        const CreateProductBody(
          name: 'X',
          baseUnitCode: 'each',
          sellPrice: 1000,
        ),
      );
      expect(
        ((res as ApiFailure<String>).err as BadRequestException).message,
        'Name already exists',
      );
    });
  });

  group('updateInfo', () {
    test('PATCH only sends dirty fields', () async {
      when(
        () => dio.patch<dynamic>(any(), data: any(named: 'data')),
      ).thenAnswer((_) async => ok({'success': true}));
      await repo.updateInfo(
        const UpdateProductInfoBody(productId: 'p-1', name: 'X'),
      );
      final captured =
          verify(
                () => dio.patch<dynamic>(
                  '/product/UpdateProductInfo',
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured, {'productId': 'p-1', 'name': 'X'});
    });
  });
}
