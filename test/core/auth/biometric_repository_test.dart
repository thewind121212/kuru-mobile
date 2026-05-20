import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/auth/biometric_repository.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalAuth extends Mock implements LocalAuthentication {}

class _MockStorage extends Mock implements FlutterSecureStorage {}

class _FakeAuthOptions extends Fake implements AuthenticationOptions {}

void main() {
  late _MockLocalAuth auth;
  late _MockStorage storage;
  late BiometricRepository repo;

  setUpAll(() {
    registerFallbackValue(_FakeAuthOptions());
  });

  setUp(() {
    auth = _MockLocalAuth();
    storage = _MockStorage();
    repo = BiometricRepository(auth: auth, storage: storage);
  });

  group('isEnabled', () {
    test('true when email key exists', () async {
      when(
        () => storage.read(key: 'biometric_email'),
      ).thenAnswer((_) async => 'a@b.c');
      expect(await repo.isEnabled(), isTrue);
    });

    test('false when missing', () async {
      when(
        () => storage.read(key: 'biometric_email'),
      ).thenAnswer((_) async => null);
      expect(await repo.isEnabled(), isFalse);
    });
  });

  group('enable', () {
    test('writes both keys when local_auth succeeds', () async {
      when(
        () => auth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => true);
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
      await repo.enable(email: 'a@b.c', password: 'pw');
      verify(
        () => storage.write(key: 'biometric_email', value: 'a@b.c'),
      ).called(1);
      verify(
        () => storage.write(key: 'biometric_password', value: 'pw'),
      ).called(1);
    });

    test('does NOT write when local_auth returns false', () async {
      when(
        () => auth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => false);
      await expectLater(
        () => repo.enable(email: 'a@b.c', password: 'pw'),
        throwsA(isA<BiometricAuthCancelled>()),
      );
      verifyNever(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      );
    });
  });

  group('unlock', () {
    test('returns creds on auth success', () async {
      when(
        () => auth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => true);
      when(
        () => storage.read(key: 'biometric_email'),
      ).thenAnswer((_) async => 'a@b.c');
      when(
        () => storage.read(key: 'biometric_password'),
      ).thenAnswer((_) async => 'pw');
      final creds = await repo.unlock();
      expect(creds!.email, 'a@b.c');
      expect(creds.password, 'pw');
    });

    test('returns null on auth failure', () async {
      when(
        () => auth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => false);
      expect(await repo.unlock(), isNull);
    });
  });

  group('disable', () {
    test('wipes both keys', () async {
      when(
        () => storage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});
      await repo.disable();
      verify(() => storage.delete(key: 'biometric_email')).called(1);
      verify(() => storage.delete(key: 'biometric_password')).called(1);
    });
  });
}
