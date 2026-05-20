import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/profile_repository.dart';
import 'package:kuru_mobile/core/profile/security_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late ProfileRepository repo;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(Options());
  });

  setUp(() {
    dio = _MockDio();
    repo = ProfileRepository(dio);
  });

  group('updateProfile', () {
    test('200 returns success with avatarStyle/Seed in payload', () async {
      when(
        () => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 200,
          data: {'success': true, 'data': <String, dynamic>{}},
        ),
      );
      final r = await repo.updateProfile(
        name: 'Linh',
        avatarStyle: 'fun-emoji',
        avatarSeed: 'seed-1',
      );
      expect(r, isA<ApiSuccess<void>>());
      final captured =
          verify(
                () => dio.post<Map<String, dynamic>>(
                  '/api/v1/profile/UpdateProfile',
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured['name'], 'Linh');
      expect(captured['avatarStyle'], 'fun-emoji');
      expect(captured['avatarSeed'], 'seed-1');
    });

    test('omits avatarStyle/Seed when null '
        '(Plan Correction #10 — Zod .optional())', () async {
      when(
        () => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 200,
          data: {'success': true, 'data': <String, dynamic>{}},
        ),
      );
      await repo.updateProfile(name: 'Linh');
      final captured =
          verify(
                () => dio.post<Map<String, dynamic>>(
                  '/api/v1/profile/UpdateProfile',
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured.containsKey('avatarStyle'), isFalse);
      expect(captured.containsKey('avatarSeed'), isFalse);
    });

    test('400 -> BadRequestException', () async {
      when(
        () => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          response: Response(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 400,
          ),
          error: const BadRequestException('name too short'),
        ),
      );
      final r = await repo.updateProfile(name: 'L');
      expect(r, isA<ApiFailure<void>>());
      expect((r as ApiFailure).err, isA<BadRequestException>());
    });
  });

  group('changePassword', () {
    test('200 success', () async {
      when(
        () => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 200,
          data: {
            'success': true,
            'data': {'success': true},
          },
        ),
      );
      final r = await repo.changePassword(
        oldPassword: 'a12345678',
        newPassword: 'b12345678',
      );
      expect(r, isA<ApiSuccess<void>>());
    });
  });

  group('verifyPassword', () {
    test('returns true', () async {
      when(
        () => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 200,
          data: {
            'success': true,
            'data': {'verified': true},
          },
        ),
      );
      final r = await repo.verifyPassword('pw');
      expect(r, isA<ApiSuccess<bool>>());
      expect((r as ApiSuccess<bool>).data, isTrue);
    });
  });

  group('getSecurityStatus', () {
    test('parses payload', () async {
      when(
        () => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 200,
          data: {
            'success': true,
            'data': {
              'totpEnabled': true,
              'recoveryCodesRemaining': 7,
              'passkeyCount': 0,
            },
          },
        ),
      );
      final r = await repo.getSecurityStatus();
      expect((r as ApiSuccess<SecurityStatus>).data.totpEnabled, isTrue);
      expect(r.data.recoveryCodesRemaining, 7);
    });
  });

  group('uploadAvatar', () {
    test('posts multipart with userId + avatar', () async {
      when(
        () => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 201,
          data: {
            'success': true,
            'data': {'key': 'user-avatar/abc.webp'},
          },
        ),
      );
      final tmp = await File(
        '${Directory.systemTemp.path}/avatar-test-${DateTime.now().microsecondsSinceEpoch}.png',
      ).create();
      addTearDown(() async {
        if (tmp.existsSync()) await tmp.delete();
      });
      await tmp.writeAsBytes([1, 2, 3]);
      final result = await repo.uploadAvatar(file: tmp, userId: 'u-1');
      expect((result as ApiSuccess<String>).data, 'user-avatar/abc.webp');
      final captured =
          verify(
                () => dio.post<Map<String, dynamic>>(
                  '/api/v1/store/UploadUserAvatar',
                  data: captureAny(named: 'data'),
                ),
              ).captured.single
              as FormData;
      final userIdField = captured.fields.firstWhere(
        (e) => e.key == 'userId',
        orElse: () => const MapEntry('', ''),
      );
      expect(userIdField.value, 'u-1');
      expect(captured.files, hasLength(1));
      expect(captured.files.first.key, 'avatar');
    });
  });
}
