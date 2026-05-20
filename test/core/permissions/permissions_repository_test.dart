import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/permissions/permissions_repository.dart';
import 'package:kuru_mobile/core/permissions/resolved_permissions.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late PermissionsRepository repo;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    dio = _MockDio();
    repo = PermissionsRepository(dio);
  });

  test('parses OWNER on 200', () async {
    when(
      () => dio.get<Map<String, dynamic>>(
        any(),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 200,
        data: {
          'success': true,
          'data': {
            'orgRole': 'OWNER',
            'orgPerms': <String>[],
            'perStore': <Map<String, dynamic>>[],
          },
        },
      ),
    );
    final result = await repo.getMyPermissions('org-1');
    expect(result, isA<ApiSuccess<ResolvedPermissions>>());
    expect((result as ApiSuccess).data.isOwner, isTrue);
  });

  test('401 -> UnauthorizedException', () async {
    when(
      () => dio.get<Map<String, dynamic>>(
        any(),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/'),
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 401,
        ),
        error: const UnauthorizedException('unauth'),
      ),
    );
    final r = await repo.getMyPermissions('org-1');
    expect(r, isA<ApiFailure<ResolvedPermissions>>());
    expect((r as ApiFailure).err, isA<UnauthorizedException>());
  });
}
