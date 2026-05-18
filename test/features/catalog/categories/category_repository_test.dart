import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/categories/data/category_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockCategoryApi extends Mock implements gen.CategoryApi {}

/// Builds a minimal valid [gen.CategoryResponse] (required fields only).
gen.CategoryResponse _fakeCategoryResponse({String id = 'cat-1'}) =>
    gen.CategoryResponse(
      (b) => b
        ..categoryId = id
        ..orgId = 'org-1'
        ..itemCount = 0
        ..totalValue = 0
        ..lowStockCount = 0,
    );

/// Wraps a list of [gen.CategoryResponse] in the full 200-wrapper the
/// generated client returns from `getCategoryOverviewWithDepth`.
Response<gen.GetCategoryOverview200Response> _overviewResponse(
  List<gen.CategoryResponse> items, {
  int statusCode = 200,
}) {
  final inner = gen.GetCategoryOverviewResponse(
    (b) => b..categoryOverviews.replace(BuiltList<gen.CategoryResponse>(items)),
  );
  final outer = gen.GetCategoryOverview200Response(
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

/// Wraps a single [gen.CategoryResponse] in the full 200-wrapper the
/// generated client returns from `getCategoryById`.
Response<gen.GetCategoryById200Response> _byIdResponse(
  gen.CategoryResponse category, {
  int statusCode = 200,
}) {
  final outer = gen.GetCategoryById200Response(
    (b) => b
      ..success = true
      ..data.replace(category)
      ..timestamp = DateTime(2026),
  );
  return Response(
    requestOptions: RequestOptions(),
    statusCode: statusCode,
    data: outer,
  );
}

void main() {
  late _MockCategoryApi api;
  late CategoryRepository repo;

  setUpAll(() {
    registerFallbackValue(
      gen.GetCategoryByIdRequest((b) => b..categoryId = ''),
    );
  });

  setUp(() {
    api = _MockCategoryApi();
    repo = CategoryRepository(api);
  });

  // ---------------------------------------------------------------------------
  // getOverview
  // ---------------------------------------------------------------------------
  group('getOverview', () {
    test('returns ApiSuccess with list on 200', () async {
      final cats = [_fakeCategoryResponse()];
      when(
        () => api.getCategoryOverviewWithDepth(depth: any(named: 'depth')),
      ).thenAnswer((_) async => _overviewResponse(cats));

      final result = await repo.getOverview();

      expect(result, isA<ApiSuccess<List<gen.CategoryResponse>>>());
      final data = (result as ApiSuccess<List<gen.CategoryResponse>>).data;
      expect(data, hasLength(1));
      expect(data.first.categoryId, 'cat-1');
    });

    test(
      'returns ApiSuccess with empty list when categoryOverviews is empty',
      () async {
        when(
          () => api.getCategoryOverviewWithDepth(depth: any(named: 'depth')),
        ).thenAnswer((_) async => _overviewResponse([]));

        final result = await repo.getOverview();

        expect(result, isA<ApiSuccess<List<gen.CategoryResponse>>>());
        expect(
          (result as ApiSuccess<List<gen.CategoryResponse>>).data,
          isEmpty,
        );
      },
    );

    test('returns ApiFailure(ForbiddenException) on 403', () async {
      when(
        () => api.getCategoryOverviewWithDepth(depth: any(named: 'depth')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 403,
            data: <String, dynamic>{
              'success': false,
              'error': <String, dynamic>{'message': 'no perms'},
            },
          ),
        ),
      );

      final result = await repo.getOverview();

      expect(result, isA<ApiFailure<List<gen.CategoryResponse>>>());
      expect(
        (result as ApiFailure<List<gen.CategoryResponse>>).err,
        isA<ForbiddenException>(),
      );
    });

    test('returns ApiFailure(NetworkException) on connectionError', () async {
      when(
        () => api.getCategoryOverviewWithDepth(depth: any(named: 'depth')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repo.getOverview();

      expect(result, isA<ApiFailure<List<gen.CategoryResponse>>>());
      expect(
        (result as ApiFailure<List<gen.CategoryResponse>>).err,
        isA<NetworkException>(),
      );
    });

    test('returns ApiFailure(UnauthorizedException) on 401', () async {
      when(
        () => api.getCategoryOverviewWithDepth(depth: any(named: 'depth')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 401,
            data: <String, dynamic>{
              'success': false,
              'error': <String, dynamic>{'message': 'unauthorized'},
            },
          ),
        ),
      );

      final result = await repo.getOverview();

      expect(result, isA<ApiFailure<List<gen.CategoryResponse>>>());
      expect(
        (result as ApiFailure<List<gen.CategoryResponse>>).err,
        isA<UnauthorizedException>(),
      );
    });

    test('returns ApiFailure(ServerException) on 500', () async {
      when(
        () => api.getCategoryOverviewWithDepth(depth: any(named: 'depth')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 500,
            data: <String, dynamic>{
              'success': false,
              'error': <String, dynamic>{'message': 'internal error'},
            },
          ),
        ),
      );

      final result = await repo.getOverview();

      expect(result, isA<ApiFailure<List<gen.CategoryResponse>>>());
      final err = (result as ApiFailure<List<gen.CategoryResponse>>).err;
      expect(err, isA<ServerException>());
      expect((err as ServerException).statusCode, 500);
    });

    test('returns ApiFailure(TimeoutException) on connectionTimeout', () async {
      when(
        () => api.getCategoryOverviewWithDepth(depth: any(named: 'depth')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await repo.getOverview();

      expect(result, isA<ApiFailure<List<gen.CategoryResponse>>>());
      expect(
        (result as ApiFailure<List<gen.CategoryResponse>>).err,
        isA<TimeoutException>(),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // getById
  // ---------------------------------------------------------------------------
  group('getById', () {
    test('returns ApiSuccess<CategoryResponse> on 200', () async {
      final cat = _fakeCategoryResponse(id: 'abc');
      when(
        () => api.getCategoryById(
          getCategoryByIdRequest: any(named: 'getCategoryByIdRequest'),
        ),
      ).thenAnswer((_) async => _byIdResponse(cat));

      final result = await repo.getById('abc');

      expect(result, isA<ApiSuccess<gen.CategoryResponse>>());
      expect(
        (result as ApiSuccess<gen.CategoryResponse>).data.categoryId,
        'abc',
      );
    });

    test('returns ApiFailure(ForbiddenException) on 403', () async {
      when(
        () => api.getCategoryById(
          getCategoryByIdRequest: any(named: 'getCategoryByIdRequest'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 403,
            data: <String, dynamic>{
              'success': false,
              'error': <String, dynamic>{'message': 'no perms'},
            },
          ),
        ),
      );

      final result = await repo.getById('abc');

      expect(result, isA<ApiFailure<gen.CategoryResponse>>());
      expect(
        (result as ApiFailure<gen.CategoryResponse>).err,
        isA<ForbiddenException>(),
      );
    });

    test('returns ApiFailure(UnauthorizedException) on 401', () async {
      when(
        () => api.getCategoryById(
          getCategoryByIdRequest: any(named: 'getCategoryByIdRequest'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 401,
            data: <String, dynamic>{
              'success': false,
              'error': <String, dynamic>{'message': 'unauthorized'},
            },
          ),
        ),
      );

      final result = await repo.getById('abc');

      expect(result, isA<ApiFailure<gen.CategoryResponse>>());
      expect(
        (result as ApiFailure<gen.CategoryResponse>).err,
        isA<UnauthorizedException>(),
      );
    });

    test('returns ApiFailure(NetworkException) on connectionError', () async {
      when(
        () => api.getCategoryById(
          getCategoryByIdRequest: any(named: 'getCategoryByIdRequest'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repo.getById('abc');

      expect(result, isA<ApiFailure<gen.CategoryResponse>>());
      expect(
        (result as ApiFailure<gen.CategoryResponse>).err,
        isA<NetworkException>(),
      );
    });

    test('returns ApiFailure(ServerException) on 500', () async {
      when(
        () => api.getCategoryById(
          getCategoryByIdRequest: any(named: 'getCategoryByIdRequest'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 500,
            data: <String, dynamic>{
              'success': false,
              'error': <String, dynamic>{'message': 'internal error'},
            },
          ),
        ),
      );

      final result = await repo.getById('abc');

      expect(result, isA<ApiFailure<gen.CategoryResponse>>());
      final err = (result as ApiFailure<gen.CategoryResponse>).err;
      expect(err, isA<ServerException>());
      expect((err as ServerException).statusCode, 500);
    });
  });
}
