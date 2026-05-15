import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';

void main() {
  group('ApiResult', () {
    test('Success.data returns the value', () {
      final r = ApiResult<int>.success(42);
      expect(r is ApiSuccess<int>, isTrue);
      expect((r as ApiSuccess<int>).data, 42);
    });

    test('Failure.err returns the exception', () {
      const e = NetworkException('down');
      final r = ApiResult<int>.failure(e);
      expect((r as ApiFailure<int>).err, e);
    });

    test('unwrap returns the value on success', () async {
      final v = await Future.value(ApiResult<int>.success(7)).unwrap();
      expect(v, 7);
    });

    test('unwrap throws on failure', () async {
      const e = NetworkException('down');
      expect(
        () async => Future.value(ApiResult<int>.failure(e)).unwrap(),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
