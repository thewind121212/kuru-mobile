import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';

DioException _badResponse(int status, [Object? body]) {
  final req = RequestOptions(path: '/x');
  return DioException(
    requestOptions: req,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: req,
      statusCode: status,
      data: body,
    ),
  );
}

void main() {
  group('mapDioError', () {
    test('HTTP 401 → UnauthorizedException', () {
      final e = mapDioError(_badResponse(401, {
        'success': false,
        'error': {'message': 'session expired'},
      }));
      expect(e, isA<UnauthorizedException>());
      expect(e.message, 'session expired');
    });

    test('HTTP 403 → ForbiddenException (not Unauthorized)', () {
      final e = mapDioError(_badResponse(403, {
        'success': false,
        'error': {'message': 'no permission'},
      }));
      expect(e, isA<ForbiddenException>());
      expect(e, isNot(isA<UnauthorizedException>()));
      expect(e.message, 'no permission');
    });

    test('HTTP 400 → BadRequestException with code', () {
      final e = mapDioError(_badResponse(400, {
        'success': false,
        'error': {'message': 'name is required', 'code': 'VALIDATION'},
      }));
      expect(e, isA<BadRequestException>());
      expect((e as BadRequestException).code, 'VALIDATION');
    });

    test('HTTP 500 → ServerException with statusCode', () {
      final e = mapDioError(_badResponse(503));
      expect(e, isA<ServerException>());
      expect((e as ServerException).statusCode, 503);
    });

    test('DioExceptionType.connectionError → NetworkException', () {
      final req = RequestOptions(path: '/x');
      final e = mapDioError(DioException(
        requestOptions: req,
        type: DioExceptionType.connectionError,
      ));
      expect(e, isA<NetworkException>());
    });
  });
}
