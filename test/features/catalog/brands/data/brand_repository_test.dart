import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/brands/data/brand_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockBrandApi extends Mock implements gen.BrandApi {}

gen.BrandOverviewItem _fakeItem({
  String id = 'brand-1',
  String name = 'Nike',
}) => gen.BrandOverviewItem(
  (b) => b
    ..id = id
    ..orgId = 'org-1'
    ..name = name
    ..productCount = 0,
);

Response<gen.GetBrandOverview200Response> _overviewResponse(
  List<gen.BrandOverviewItem> items, {
  int statusCode = 200,
  int total = 0,
}) {
  final inner = gen.GetBrandOverviewResponse(
    (b) => b
      ..brands.replace(BuiltList<gen.BrandOverviewItem>(items))
      ..total = total
      ..page = 1
      ..limit = 200,
  );
  final outer = gen.GetBrandOverview200Response(
    (b) => b
      ..success = true
      ..data.replace(inner)
      ..timestamp = DateTime(2026),
  );
  return Response(
    requestOptions: RequestOptions(),
    statusCode: statusCode,
    data: outer,
  );
}

DioException _http400(String message) => DioException(
  requestOptions: RequestOptions(),
  response: Response(
    requestOptions: RequestOptions(),
    statusCode: 400,
    data: {
      'success': false,
      'error': {'message': message, 'code': 'VALIDATION_ERROR'},
      'timestamp': DateTime(2026).toIso8601String(),
    },
  ),
  error: BadRequestException(message),
);

void main() {
  late _MockBrandApi api;
  late BrandRepository repo;

  setUpAll(() {
    registerFallbackValue(gen.CreateBrandRequest((b) => b..name = ''));
    registerFallbackValue(gen.UpdateBrandRequest((b) => b..brandId = ''));
    registerFallbackValue(gen.DeleteBrandRequest((b) => b..brandId = ''));
  });

  setUp(() {
    api = _MockBrandApi();
    repo = BrandRepository(api);
  });

  group('overview', () {
    test('returns brands on 200', () async {
      when(
        () => api.getBrandOverview(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          searchString: any(named: 'searchString'),
        ),
      ).thenAnswer(
        (_) async => _overviewResponse([
          _fakeItem(id: 'b1'),
          _fakeItem(id: 'b2', name: 'Adidas'),
        ], total: 2),
      );

      final result = await repo.getOverview();

      expect(result, isA<ApiSuccess<List<gen.BrandOverviewItem>>>());
      final list = (result as ApiSuccess<List<gen.BrandOverviewItem>>).data;
      expect(list, hasLength(2));
      expect(list[0].name, 'Nike');
    });

    test('returns BadRequestException on 400', () async {
      when(
        () => api.getBrandOverview(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          searchString: any(named: 'searchString'),
        ),
      ).thenThrow(_http400('Bad params'));

      final result = await repo.getOverview();

      expect(result, isA<ApiFailure<List<gen.BrandOverviewItem>>>());
      expect(
        (result as ApiFailure<List<gen.BrandOverviewItem>>).err,
        isA<BadRequestException>(),
      );
    });
  });

  group('getById', () {
    test('returns BrandResponse on 200', () async {
      final entity = gen.BrandResponse(
        (b) => b
          ..id = 'b1'
          ..orgId = 'org-1'
          ..name = 'Nike'
          ..isDelete = false
          ..createdAt = DateTime.utc(2026)
          ..updatedAt = DateTime.utc(2026),
      );
      final outer = gen.GetBrandById200Response(
        (b) => b
          ..success = true
          ..data.replace(entity)
          ..timestamp = DateTime(2026),
      );
      when(() => api.getBrandById(brandId: any(named: 'brandId'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: outer,
        ),
      );

      final result = await repo.getById('b1');

      expect(result, isA<ApiSuccess<gen.BrandResponse>>());
      expect((result as ApiSuccess<gen.BrandResponse>).data.name, 'Nike');
    });

    test('returns UnknownException on null body', () async {
      when(() => api.getBrandById(brandId: any(named: 'brandId'))).thenAnswer(
        (_) async =>
            Response(requestOptions: RequestOptions(), statusCode: 200),
      );

      final result = await repo.getById('b1');

      expect(result, isA<ApiFailure<gen.BrandResponse>>());
      expect(
        (result as ApiFailure<gen.BrandResponse>).err,
        isA<UnknownException>(),
      );
    });
  });

  group('create', () {
    test('returns brandId on 201', () async {
      final inner = gen.CreateBrandResponse((b) => b..brandId = 'new-brand-id');
      final outer = gen.CreateBrand200Response(
        (b) => b
          ..success = true
          ..data.replace(inner)
          ..timestamp = DateTime(2026),
      );
      when(
        () => api.createBrand(
          createBrandRequest: any(named: 'createBrandRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 201,
          data: outer,
        ),
      );

      final result = await repo.create(name: 'Nike');

      expect(result, isA<ApiSuccess<String>>());
      expect((result as ApiSuccess<String>).data, 'new-brand-id');
    });

    test('surfaces dup-name 400 verbatim', () async {
      when(
        () => api.createBrand(
          createBrandRequest: any(named: 'createBrandRequest'),
        ),
      ).thenThrow(_http400('Brand with this name already exists'));

      final result = await repo.create(name: 'Nike');

      expect(result, isA<ApiFailure<String>>());
      final err = (result as ApiFailure<String>).err;
      expect(err, isA<BadRequestException>());
      expect(
        (err as BadRequestException).message,
        'Brand with this name already exists',
      );
    });
  });

  group('update', () {
    test('returns success on 200', () async {
      final inner = gen.UpdateBrandResponse((b) => b..success = true);
      final outer = gen.UpdateBrand200Response(
        (b) => b
          ..success = true
          ..data.replace(inner)
          ..timestamp = DateTime(2026),
      );
      when(
        () => api.updateBrand(
          updateBrandRequest: any(named: 'updateBrandRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: outer,
        ),
      );

      final result = await repo.update(brandId: 'b1', name: 'New Name');

      expect(result, isA<ApiSuccess<void>>());
    });
  });

  group('remove', () {
    test('returns success on 201', () async {
      final inner = gen.DeleteBrandResponse((b) => b..success = true);
      final outer = gen.DeleteBrand200Response(
        (b) => b
          ..success = true
          ..data.replace(inner)
          ..timestamp = DateTime(2026),
      );
      when(
        () => api.deleteBrand(
          deleteBrandRequest: any(named: 'deleteBrandRequest'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 201,
          data: outer,
        ),
      );

      final result = await repo.remove('b1');

      expect(result, isA<ApiSuccess<void>>());
    });

    test('surfaces 400 reason verbatim', () async {
      when(
        () => api.deleteBrand(
          deleteBrandRequest: any(named: 'deleteBrandRequest'),
        ),
      ).thenThrow(_http400('Brand has products'));

      final result = await repo.remove('b1');

      expect(result, isA<ApiFailure<void>>());
      expect((result as ApiFailure<void>).err, isA<BadRequestException>());
    });
  });
}
