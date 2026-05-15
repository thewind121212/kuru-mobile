import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._response);
  final ResponseBody _response;
  @override
  void close({bool force = false}) {}
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return _response;
  }
}

Dio _dioWith(Map<String, dynamic> json, {int status = 200}) {
  final dio = Dio();
  dio.httpClientAdapter = _FakeAdapter(
    ResponseBody.fromString(
      jsonEncode(json),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    ),
  );
  return dio;
}

void main() {
  group('AuthRepository.signIn', () {
    test('returns success on OK status', () async {
      final dio = _dioWith({'status': 'OK'});
      final repo = AuthRepository(dio);
      final r = await repo.signIn(email: 'a@b.com', password: 'pw');
      expect(r, isA<ApiSuccess<void>>());
    });

    test('returns Unauthorized on WRONG_CREDENTIALS_ERROR', () async {
      final dio = _dioWith({'status': 'WRONG_CREDENTIALS_ERROR'});
      final repo = AuthRepository(dio);
      final r = await repo.signIn(email: 'a@b.com', password: 'wrong');
      expect(r, isA<ApiFailure<void>>());
      expect((r as ApiFailure).err, isA<UnauthorizedException>());
    });
  });
}
