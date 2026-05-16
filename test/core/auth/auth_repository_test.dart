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
  group('AuthRepository.signUp', () {
    test('returns success on OK', () async {
      final dio = _dioWith({'status': 'OK'});
      final r = await AuthRepository(dio).signUp(
        fullName: 'A',
        email: 'a@b.com',
        password: 'pw',
      );
      expect(r, isA<ApiSuccess<void>>());
    });

    test('returns BadRequest on EMAIL_ALREADY_EXISTS_ERROR', () async {
      final dio = _dioWith({'status': 'EMAIL_ALREADY_EXISTS_ERROR'});
      final r = await AuthRepository(dio).signUp(
        fullName: 'A',
        email: 'a@b.com',
        password: 'pw',
      );
      expect(r, isA<ApiFailure<void>>());
      final err = (r as ApiFailure).err as BadRequestException;
      expect(err.code, 'EMAIL_EXISTS');
    });
  });

  group('AuthRepository.createStore', () {
    test('returns the storeId on success', () async {
      final dio = _dioWith({
        'data': {'storeId': 'store-123'},
      });
      final r = await AuthRepository(dio).createStore(name: 'Shop');
      expect(r, isA<ApiSuccess<String>>());
      expect((r as ApiSuccess<String>).data, 'store-123');
    });

    test('returns ServerException when storeId missing', () async {
      final dio = _dioWith({'data': <String, dynamic>{}});
      final r = await AuthRepository(dio).createStore(name: 'Shop');
      expect(r, isA<ApiFailure<String>>());
      expect((r as ApiFailure).err, isA<ServerException>());
    });
  });

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

  group('AuthRepository.verifyTotpCode', () {
    test('returns ok when verified=true', () async {
      final dio = _dioWith({
        'data': {'verified': true},
      });
      final r = await AuthRepository(dio).verifyTotpCode(code: '123456');
      expect(r, isA<ApiSuccess<TotpVerifyResult>>());
      expect((r as ApiSuccess<TotpVerifyResult>).data, isA<TotpOk>());
    });

    test('returns wrongCode when verified=false', () async {
      final dio = _dioWith({
        'data': {'verified': false},
      });
      final r = await AuthRepository(dio).verifyTotpCode(code: '000000');
      expect(r, isA<ApiSuccess<TotpVerifyResult>>());
      expect((r as ApiSuccess<TotpVerifyResult>).data, isA<TotpWrongCode>());
    });
  });

  group('AuthRepository.useRecoveryCode', () {
    test('returns ok on success', () async {
      final dio = _dioWith({
        'data': {'verified': true},
      });
      final r = await AuthRepository(dio).useRecoveryCode(code: 'ABCD-1234');
      expect(r, isA<ApiSuccess<TotpVerifyResult>>());
      expect((r as ApiSuccess<TotpVerifyResult>).data, isA<TotpOk>());
    });

    test('returns wrongCode when verified=false', () async {
      final dio = _dioWith({
        'data': {'verified': false},
      });
      final r = await AuthRepository(dio).useRecoveryCode(code: 'WRONG-CODE');
      expect(r, isA<ApiSuccess<TotpVerifyResult>>());
      expect((r as ApiSuccess<TotpVerifyResult>).data, isA<TotpWrongCode>());
    });
  });
}
