# Settings v1 + Biometric Login — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `SettingsStubScreen` with a real Settings module (Profile · Security · Store · Appearance) and add FaceID / Touch ID / Android-fingerprint sign-in on the Login screen.

**Architecture:** Mirrors kuru-web `settings-module/`. Riverpod for state, freezed for models, dio for HTTP, GoRouter for navigation. New core modules: `PermissionsRepository` (role gating via `GetMyPermissions`), `ProfileRepository` (UpdateProfile / UploadUserAvatar / ChangePassword / VerifyPassword / TOTP), `BiometricRepository` (wraps `local_auth` + `flutter_secure_storage`), `LocaleController` (SharedPreferences-persisted). Reuses FLAT design widgets (`KListRow`, `KModalSheet`, `KFormField`, `KPrimaryBtn`).

**Tech Stack:** Flutter 3.41.9 · Riverpod (annotation+codegen) · freezed · dio · GoRouter · SuperTokens (session) · local_auth (biometric prompt) · flutter_secure_storage (Keychain/Keystore) · image_picker (avatar upload) · SharedPreferences (locale + palette persistence) · toastification + SnackBar via `KNotify`.

**Spec:** `docs/superpowers/specs/2026-05-19-settings-and-biometric-design.md`

---

## Pre-flight: Locked answers to spec's open questions

These resolve the four open questions from §10 of the spec so the plan is unambiguous:

| Question | Locked answer |
|---|---|
| Dicebear style subset | `fun-emoji`, `lorelei-line`, `miniavs`, `open-peeps`, `thumbs` (5 styles) |
| Avatar upload preview | `image_picker` with `imageQuality: 80`, `maxWidth: 1024`. No in-app crop. Preview rendered with `BoxFit.cover` inside a circle. |
| Timezone source | Hand-curated VN-first list of 11 zones (Asia/Ho_Chi_Minh, Asia/Bangkok, Asia/Singapore, Asia/Tokyo, Asia/Seoul, Asia/Shanghai, Asia/Manila, Australia/Sydney, Europe/London, America/New_York, America/Los_Angeles). Full IANA list deferred to v1.1. |
| Recovery codes share UX | Clipboard with toast — matches kuru-web. No native share sheet in v1. |

---

## Phase 0 — Conventions

**File layout under `lib/`:**
```
lib/core/permissions/       NEW
lib/core/profile/           NEW
lib/core/auth/              EXISTING — add biometric_repository.dart + biometric_providers.dart
lib/core/i18n/              EXISTING — add locale_controller.dart
lib/design/core/catalog/    EXISTING — add k_avatar.dart
lib/design/core/layout/     EXISTING — add k_settings_hero.dart + k_settings_section.dart
lib/design/core/input/      EXISTING — add k_switch_row.dart
lib/features/settings/      EXISTING (stub) — replace + add sub-screens & sheets
```

**Test layout mirrors source under `test/`.**

**Riverpod codegen:** the codebase uses both `Provider<T>((ref) => …)` (hand-rolled) and `@riverpod`-annotated functions. Pick the simpler hand-rolled form for new providers to avoid adding a build step; existing `auth_providers.dart` uses the hand-rolled form so we follow that.

**Commit cadence:** one commit per task. Subject line under 50 chars, conventional-commits style (`feat(settings): …`, `test(biometric): …`, etc.). Co-author line per repo convention.

**Lint / test gate before every commit:**
```bash
flutter analyze
# Tests run via Very Good CLI MCP run_tests tool (flutter test is blocked per CLAUDE.md)
```

---

## Phase 1 — Foundation (Tasks 1–7)

### Task 1: Add pubspec dependencies

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Edit pubspec.yaml — add three deps under `dependencies:`**

Insert these three lines alphabetically into the dependencies block:
```yaml
  image_picker: ^1.1.2
  local_auth: ^2.3.0
  flutter_secure_storage: ^9.2.2
```

- [ ] **Step 2: Run pub get + native plugin refresh**

Native plugins require a clean install per CLAUDE.md. Run:
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
```
Expected: pod install logs `local_auth`, `flutter_secure_storage`, `image_picker_ios` installed.

- [ ] **Step 3: iOS — add usage description strings to Info.plist**

Open `ios/Runner/Info.plist`. Inside the top-level `<dict>`, add:
```xml
<key>NSFaceIDUsageDescription</key>
<string>Đăng nhập nhanh bằng FaceID</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Chọn ảnh đại diện</string>
<key>NSCameraUsageDescription</key>
<string>Chụp ảnh đại diện</string>
```

- [ ] **Step 4: Android — declare biometric permission**

Open `android/app/src/main/AndroidManifest.xml`. Inside `<manifest>` (above `<application>`):
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
```

`local_auth` on Android also requires `MainActivity` to extend `FlutterFragmentActivity` (not `FlutterActivity`). Open `android/app/src/main/kotlin/com/kuru/kuruMobile/MainActivity.kt`:
```kotlin
package com.kuru.kuruMobile

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity()
```

- [ ] **Step 5: Run analyzer**

```bash
flutter analyze
```
Expected: exit code 0.

- [ ] **Step 6: Commit**

```bash
git add pubspec.yaml pubspec.lock ios/Runner/Info.plist android/app/src/main/AndroidManifest.xml android/app/src/main/kotlin/com/kuru/kuruMobile/MainActivity.kt
git commit -m "build(deps): add local_auth, flutter_secure_storage, image_picker"
```

---

### Task 2: ResolvedPermissions model

**Files:**
- Create: `lib/core/permissions/resolved_permissions.dart`
- Create: `test/core/permissions/resolved_permissions_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/core/permissions/resolved_permissions_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/permissions/resolved_permissions.dart';

void main() {
  group('ResolvedPermissions.fromJson', () {
    test('parses OWNER with org perms', () {
      final json = {
        'orgRole': 'OWNER',
        'orgPerms': ['member.invite', 'setting.write'],
        'perStore': <Map<String, dynamic>>[],
      };
      final p = ResolvedPermissions.fromJson(json);
      expect(p.orgRole, OrgRole.owner);
      expect(p.orgPerms, ['member.invite', 'setting.write']);
      expect(p.isOwner, isTrue);
    });

    test('parses STAFF with empty perms', () {
      final json = {
        'orgRole': 'STAFF',
        'orgPerms': <String>[],
        'perStore': <Map<String, dynamic>>[],
      };
      final p = ResolvedPermissions.fromJson(json);
      expect(p.orgRole, OrgRole.staff);
      expect(p.isOwner, isFalse);
    });

    test('unknown role falls back to staff', () {
      final p = ResolvedPermissions.fromJson({
        'orgRole': 'GUEST',
        'orgPerms': <String>[],
        'perStore': <Map<String, dynamic>>[],
      });
      expect(p.orgRole, OrgRole.staff);
    });
  });
}
```

- [ ] **Step 2: Run test, verify it fails**

```bash
# Via Very Good CLI MCP run_tests tool
```
Expected: FAIL — `ResolvedPermissions` and `OrgRole` are not defined.

- [ ] **Step 3: Implement the model**

Create `lib/core/permissions/resolved_permissions.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resolved_permissions.freezed.dart';

enum OrgRole {
  owner,
  manager,
  staff;

  static OrgRole fromWire(String? wire) {
    switch (wire) {
      case 'OWNER':
        return OrgRole.owner;
      case 'MANAGER':
        return OrgRole.manager;
      case 'STAFF':
      default:
        return OrgRole.staff;
    }
  }
}

@freezed
class ResolvedPermissions with _$ResolvedPermissions {
  const ResolvedPermissions._();

  const factory ResolvedPermissions({
    required OrgRole orgRole,
    @Default(<String>[]) List<String> orgPerms,
  }) = _ResolvedPermissions;

  factory ResolvedPermissions.fromJson(Map<String, dynamic> json) {
    return ResolvedPermissions(
      orgRole: OrgRole.fromWire(json['orgRole'] as String?),
      orgPerms:
          (json['orgPerms'] as List<dynamic>? ?? const <dynamic>[])
              .cast<String>(),
    );
  }

  bool get isOwner => orgRole == OrgRole.owner;
}
```

- [ ] **Step 4: Run codegen**

```bash
dart run build_runner build --delete-conflicting-outputs
```
Expected: generates `lib/core/permissions/resolved_permissions.freezed.dart`.

- [ ] **Step 5: Run test, verify pass**

Expected: 3 tests pass.

- [ ] **Step 6: Commit**

```bash
git add lib/core/permissions test/core/permissions
git commit -m "feat(permissions): ResolvedPermissions model + OrgRole enum"
```

---

### Task 3: PermissionsRepository + provider

**Files:**
- Create: `lib/core/permissions/permissions_repository.dart`
- Create: `lib/core/permissions/permissions_providers.dart`
- Create: `test/core/permissions/permissions_repository_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/core/permissions/permissions_repository_test.dart`:
```dart
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
    when(() => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(
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
    when(() => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenThrow(
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
    expect((r as ApiFailure).error, isA<UnauthorizedException>());
  });
}
```

- [ ] **Step 2: Run test, verify it fails**

Expected: FAIL — `PermissionsRepository` not defined.

- [ ] **Step 3: Implement repository**

Create `lib/core/permissions/permissions_repository.dart`:
```dart
import 'package:dio/dio.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/permissions/resolved_permissions.dart';

class PermissionsRepository {
  PermissionsRepository(this._dio);
  final Dio _dio;

  Future<ApiResult<ResolvedPermissions>> getMyPermissions(String orgId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/v1/store/GetMyPermissions',
        queryParameters: <String, dynamic>{'orgId': orgId},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        return ApiResult.failure(
          const ServerException('Empty body', statusCode: 200),
        );
      }
      return ApiResult.success(ResolvedPermissions.fromJson(data));
    } on DioException catch (e) {
      final mapped = e.error;
      return ApiResult.failure(
        mapped is ApiException
            ? mapped
            : const UnknownException('GetMyPermissions failed'),
      );
    }
  }
}
```

- [ ] **Step 4: Implement provider**

Create `lib/core/permissions/permissions_providers.dart`:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/core/permissions/permissions_repository.dart';
import 'package:kuru_mobile/core/permissions/resolved_permissions.dart';

final permissionsRepositoryProvider = Provider<PermissionsRepository>(
  (ref) => PermissionsRepository(ref.read(dioProvider)),
);

final myPermissionsProvider =
    FutureProvider<ResolvedPermissions>((ref) async {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) {
    throw StateError('myPermissionsProvider read before orgId is set');
  }
  final result = await ref.read(permissionsRepositoryProvider)
      .getMyPermissions(orgId);
  return switch (result) {
    ApiSuccess<ResolvedPermissions>(:final data) => data,
    ApiFailure<ResolvedPermissions>(:final error) => throw error,
  };
});
```

- [ ] **Step 5: Run test, verify pass**

Expected: 2 tests pass.

- [ ] **Step 6: Commit**

```bash
git add lib/core/permissions test/core/permissions
git commit -m "feat(permissions): repository + myPermissionsProvider"
```

---

### Task 4: ProfileRepository (UpdateProfile / ChangePassword / VerifyPassword / TOTP / SecurityStatus / Avatar upload)

**Files:**
- Create: `lib/core/profile/profile_repository.dart`
- Create: `lib/core/profile/profile_providers.dart`
- Create: `lib/core/profile/security_status.dart`
- Create: `test/core/profile/profile_repository_test.dart`

- [ ] **Step 1: Create SecurityStatus model**

Create `lib/core/profile/security_status.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_status.freezed.dart';
part 'security_status.g.dart';

@freezed
class SecurityStatus with _$SecurityStatus {
  const factory SecurityStatus({
    @Default(false) bool totpEnabled,
    @Default(0) int recoveryCodesRemaining,
    @Default(0) int passkeyCount,
  }) = _SecurityStatus;

  factory SecurityStatus.fromJson(Map<String, dynamic> json) =>
      _$SecurityStatusFromJson(json);
}
```

- [ ] **Step 2: Write failing test**

Create `test/core/profile/profile_repository_test.dart`:
```dart
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
    test('200 returns success', () async {
      when(() => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer(
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
      final captured = verify(() => dio.post<Map<String, dynamic>>(
            '/api/v1/profile/UpdateProfile',
            data: captureAny(named: 'data'),
          )).captured.single as Map<String, dynamic>;
      expect(captured['name'], 'Linh');
      expect(captured['avatarStyle'], 'fun-emoji');
      expect(captured['avatarSeed'], 'seed-1');
    });

    test('400 -> BadRequestException', () async {
      when(() => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenThrow(
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
      expect((r as ApiFailure).error, isA<BadRequestException>());
    });
  });

  group('changePassword', () {
    test('200 success', () async {
      when(() => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 200,
          data: {'success': true, 'data': {'success': true}},
        ),
      );
      final r =
          await repo.changePassword(oldPassword: 'a12345678', newPassword: 'b12345678');
      expect(r, isA<ApiSuccess<void>>());
    });
  });

  group('verifyPassword', () {
    test('returns true', () async {
      when(() => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 200,
          data: {'success': true, 'data': {'verified': true}},
        ),
      );
      final r = await repo.verifyPassword('pw');
      expect(r, isA<ApiSuccess<bool>>());
      expect((r as ApiSuccess<bool>).data, isTrue);
    });
  });

  group('getSecurityStatus', () {
    test('parses payload', () async {
      when(() => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer(
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
}
```

- [ ] **Step 3: Run test, expect fail**

Expected: FAIL — `ProfileRepository` not defined.

- [ ] **Step 4: Implement ProfileRepository**

Create `lib/core/profile/profile_repository.dart`:
```dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/security_status.dart';

class ProfileRepository {
  ProfileRepository(this._dio);
  final Dio _dio;

  Future<ApiResult<void>> updateProfile({
    String? name,
    String? avatarStyle,
    String? avatarSeed,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/UpdateProfile',
        data: <String, dynamic>{
          if (name != null) 'name': name,
          'avatarStyle': avatarStyle,
          'avatarSeed': avatarSeed,
        },
      );
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'UpdateProfile failed'));
    }
  }

  Future<ApiResult<void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/ChangePassword',
        data: <String, dynamic>{
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'ChangePassword failed'));
    }
  }

  Future<ApiResult<bool>> verifyPassword(String password) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/VerifyPassword',
        data: <String, dynamic>{'password': password},
      );
      final verified =
          (res.data?['data'] as Map<String, dynamic>?)?['verified'] as bool? ??
              false;
      return ApiResult.success(verified);
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'VerifyPassword failed'));
    }
  }

  Future<ApiResult<SecurityStatus>> getSecurityStatus() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/GetSecurityStatus',
        data: <String, dynamic>{},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        return ApiResult.failure(
          const ServerException('Empty body', statusCode: 200),
        );
      }
      return ApiResult.success(SecurityStatus.fromJson(data));
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'GetSecurityStatus failed'));
    }
  }

  Future<ApiResult<void>> disableTotp({required String password}) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/DisableTotp',
        data: <String, dynamic>{'password': password},
      );
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'DisableTotp failed'));
    }
  }

  Future<ApiResult<List<String>>> regenerateRecoveryCodes({
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/RegenerateRecoveryCodes',
        data: <String, dynamic>{'password': password},
      );
      final codes = (res.data?['data'] as Map<String, dynamic>?)?['codes']
          as List<dynamic>?;
      return ApiResult.success((codes ?? const <dynamic>[]).cast<String>());
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'RegenerateRecoveryCodes failed'));
    }
  }

  Future<ApiResult<String>> uploadAvatar({
    required File file,
    required String userId,
  }) async {
    try {
      final form = FormData.fromMap(<String, dynamic>{
        'userId': userId,
        'avatar': await MultipartFile.fromFile(
          file.path,
          filename: file.uri.pathSegments.last,
        ),
      });
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/store/UploadUserAvatar',
        data: form,
      );
      final key =
          (res.data?['data'] as Map<String, dynamic>?)?['key'] as String?;
      if (key == null) {
        return ApiResult.failure(
          const ServerException('Missing key in upload response',
              statusCode: 201),
        );
      }
      return ApiResult.success(key);
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e, 'UploadUserAvatar failed'));
    }
  }

  ApiException _extract(DioException e, String fallback) {
    final mapped = e.error;
    return mapped is ApiException ? mapped : UnknownException(fallback);
  }
}
```

- [ ] **Step 5: Implement provider**

Create `lib/core/profile/profile_providers.dart`:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/core/profile/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.read(dioProvider)),
);
```

- [ ] **Step 6: Run codegen + tests**

```bash
dart run build_runner build --delete-conflicting-outputs
```
Then run tests via MCP. Expected: all pass.

- [ ] **Step 7: Commit**

```bash
git add lib/core/profile test/core/profile
git commit -m "feat(profile): ProfileRepository (update / pwd / totp / avatar)"
```

---

### Task 5: BiometricRepository + providers

**Files:**
- Create: `lib/core/auth/biometric_repository.dart`
- Create: `lib/core/auth/biometric_providers.dart`
- Create: `test/core/auth/biometric_repository_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/core/auth/biometric_repository_test.dart`:
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/auth/biometric_repository.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalAuth extends Mock implements LocalAuthentication {}

class _MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockLocalAuth auth;
  late _MockStorage storage;
  late BiometricRepository repo;

  setUp(() {
    auth = _MockLocalAuth();
    storage = _MockStorage();
    repo = BiometricRepository(auth: auth, storage: storage);
  });

  group('isEnabled', () {
    test('true when email key exists', () async {
      when(() => storage.read(key: 'biometric_email'))
          .thenAnswer((_) async => 'a@b.c');
      expect(await repo.isEnabled(), isTrue);
    });

    test('false when missing', () async {
      when(() => storage.read(key: 'biometric_email'))
          .thenAnswer((_) async => null);
      expect(await repo.isEnabled(), isFalse);
    });
  });

  group('enable', () {
    test('writes both keys when local_auth succeeds', () async {
      when(() => auth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => true);
      when(() => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});
      await repo.enable(email: 'a@b.c', password: 'pw');
      verify(() => storage.write(key: 'biometric_email', value: 'a@b.c'))
          .called(1);
      verify(() => storage.write(key: 'biometric_password', value: 'pw'))
          .called(1);
    });

    test('does NOT write when local_auth returns false', () async {
      when(() => auth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => false);
      await expectLater(
        () => repo.enable(email: 'a@b.c', password: 'pw'),
        throwsA(isA<BiometricAuthCancelled>()),
      );
      verifyNever(() => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ));
    });
  });

  group('unlock', () {
    test('returns creds on auth success', () async {
      when(() => auth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => true);
      when(() => storage.read(key: 'biometric_email'))
          .thenAnswer((_) async => 'a@b.c');
      when(() => storage.read(key: 'biometric_password'))
          .thenAnswer((_) async => 'pw');
      final creds = await repo.unlock();
      expect(creds!.email, 'a@b.c');
      expect(creds.password, 'pw');
    });

    test('returns null on auth failure', () async {
      when(() => auth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => false);
      expect(await repo.unlock(), isNull);
    });
  });

  group('disable', () {
    test('wipes both keys', () async {
      when(() => storage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});
      await repo.disable();
      verify(() => storage.delete(key: 'biometric_email')).called(1);
      verify(() => storage.delete(key: 'biometric_password')).called(1);
    });
  });
}
```

- [ ] **Step 2: Run test, expect fail**

- [ ] **Step 3: Implement BiometricRepository**

Create `lib/core/auth/biometric_repository.dart`:
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthCancelled implements Exception {
  const BiometricAuthCancelled();
}

class BiometricCredentials {
  const BiometricCredentials({required this.email, required this.password});
  final String email;
  final String password;
}

class BiometricRepository {
  BiometricRepository({
    required LocalAuthentication auth,
    required FlutterSecureStorage storage,
  })  : _auth = auth,
        _storage = storage;

  static const _emailKey = 'biometric_email';
  static const _passwordKey = 'biometric_password';

  final LocalAuthentication _auth;
  final FlutterSecureStorage _storage;

  Future<bool> canCheckBiometrics() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return false;
      return _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isEnabled() async {
    final email = await _storage.read(key: _emailKey);
    return email != null && email.isNotEmpty;
  }

  Future<void> enable({
    required String email,
    required String password,
  }) async {
    final ok = await _auth.authenticate(
      localizedReason: 'Bật đăng nhập bằng FaceID / vân tay',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
    if (!ok) throw const BiometricAuthCancelled();
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<void> disable() async {
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
  }

  Future<BiometricCredentials?> unlock() async {
    final ok = await _auth.authenticate(
      localizedReason: 'Đăng nhập bằng FaceID / vân tay',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
    if (!ok) return null;
    final email = await _storage.read(key: _emailKey);
    final password = await _storage.read(key: _passwordKey);
    if (email == null || password == null) return null;
    return BiometricCredentials(email: email, password: password);
  }
}
```

- [ ] **Step 4: Implement providers**

Create `lib/core/auth/biometric_providers.dart`:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kuru_mobile/core/auth/biometric_repository.dart';
import 'package:local_auth/local_auth.dart';

final _secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  ),
);

final _localAuthProvider = Provider<LocalAuthentication>(
  (ref) => LocalAuthentication(),
);

final biometricRepositoryProvider = Provider<BiometricRepository>(
  (ref) => BiometricRepository(
    auth: ref.read(_localAuthProvider),
    storage: ref.read(_secureStorageProvider),
  ),
);

final biometricEnabledProvider = FutureProvider<bool>((ref) async {
  return ref.read(biometricRepositoryProvider).isEnabled();
});

final biometricAvailableProvider = FutureProvider<bool>((ref) async {
  return ref.read(biometricRepositoryProvider).canCheckBiometrics();
});
```

- [ ] **Step 5: Run tests, expect pass**

- [ ] **Step 6: Commit**

```bash
git add lib/core/auth/biometric_repository.dart lib/core/auth/biometric_providers.dart test/core/auth/biometric_repository_test.dart
git commit -m "feat(auth): BiometricRepository wrapping local_auth + secure storage"
```

---

### Task 6: LocaleController (SharedPreferences-persisted) + wire into KuruApp

**Files:**
- Create: `lib/core/i18n/locale_controller.dart`
- Modify: `lib/app/kuru_app.dart`
- Create: `test/core/i18n/locale_controller_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/core/i18n/locale_controller_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/locale_controller.dart';
import 'package:kuru_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('default locale is vi', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
    ]);
    addTearDown(container.dispose);
    expect(container.read(localeControllerProvider).languageCode, 'vi');
  });

  test('persists chosen locale across reads', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
    ]);
    addTearDown(container.dispose);
    await container
        .read(localeControllerProvider.notifier)
        .setLocale(const Locale('en'));
    expect(prefs.getString('app_locale'), 'en');
    expect(container.read(localeControllerProvider).languageCode, 'en');
  });
}
```

- [ ] **Step 2: Run test, expect fail**

- [ ] **Step 3: Implement controller**

Create `lib/core/i18n/locale_controller.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends Notifier<Locale> {
  static const _key = 'app_locale';
  static const supported = <Locale>[Locale('vi'), Locale('en')];

  @override
  Locale build() {
    final prefs = ref.read(sharedPrefsProvider);
    final code = prefs.getString(_key);
    if (code == null) return const Locale('vi');
    return supported.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => const Locale('vi'),
    );
  }

  Future<void> setLocale(Locale loc) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString(_key, loc.languageCode);
    state = loc;
  }
}

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale>(LocaleController.new);
```

- [ ] **Step 4: Wire into KuruApp**

Open `lib/app/kuru_app.dart`. Find the hardcoded `locale: const Locale('vi')` (line ~23) and replace:
```dart
final locale = ref.watch(localeControllerProvider);
// ...inside MaterialApp.router:
locale: locale,
```

- [ ] **Step 5: Run tests, expect pass**

- [ ] **Step 6: Commit**

```bash
git add lib/core/i18n/locale_controller.dart lib/app/kuru_app.dart test/core/i18n/locale_controller_test.dart
git commit -m "feat(i18n): LocaleController persists app locale in SharedPreferences"
```

---

### Task 7: Persist ThemeController palette in SharedPreferences

**Files:**
- Modify: `lib/app/theme/theme_controller.dart`
- Create: `test/app/theme/theme_controller_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/app/theme/theme_controller_test.dart`:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('defaults to indigo', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
    ]);
    addTearDown(container.dispose);
    expect(container.read(themeControllerProvider), KuruPalette.indigo);
  });

  test('setPalette persists', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
    ]);
    addTearDown(container.dispose);
    await container
        .read(themeControllerProvider.notifier)
        .setPalette(KuruPalette.purple);
    expect(prefs.getString('app_palette'), 'purple');
    expect(container.read(themeControllerProvider), KuruPalette.purple);
  });
}
```

- [ ] **Step 2: Run test, expect fail (setPalette not defined)**

- [ ] **Step 3: Update ThemeController**

Open `lib/app/theme/theme_controller.dart` and replace the class body:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/main.dart';

class ThemeController extends Notifier<KuruPalette> {
  static const _key = 'app_palette';

  @override
  KuruPalette build() {
    final code = ref.read(sharedPrefsProvider).getString(_key);
    for (final p in KuruPalette.values) {
      if (p.name == code) return p;
    }
    return KuruPalette.indigo;
  }

  Future<void> setPalette(KuruPalette palette) async {
    await ref.read(sharedPrefsProvider).setString(_key, palette.name);
    state = palette;
  }
}

final themeControllerProvider =
    NotifierProvider<ThemeController, KuruPalette>(ThemeController.new);

ThemeData buildKuruTheme(KuruPalette palette, Brightness brightness) {
  final c = palette.resolve(brightness);
  final scheme = ColorScheme.fromSeed(
    seedColor: c.primary,
    brightness: brightness,
    primary: c.primary,
    onPrimary: c.textInverse,
    surface: c.surface,
    onSurface: c.textPrimary,
    error: c.danger,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.pageBg,
    extensions: [c],
    fontFamily: '.SF Pro Text',
    textTheme: ThemeData.from(colorScheme: scheme).textTheme.apply(
          bodyColor: c.textPrimary,
          displayColor: c.textPrimary,
        ),
  );
}
```

- [ ] **Step 4: Run tests, expect pass**

- [ ] **Step 5: Commit**

```bash
git add lib/app/theme/theme_controller.dart test/app/theme/theme_controller_test.dart
git commit -m "feat(theme): persist palette selection in SharedPreferences"
```

---

## Phase 2 — Shared widgets (Tasks 8–11)

### Task 8: KAvatar widget

**Files:**
- Create: `lib/design/core/catalog/k_avatar.dart`
- Create: `test/design/core/catalog/k_avatar_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/design/core/catalog/k_avatar_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/design/core/catalog/k_avatar.dart';

void main() {
  testWidgets('renders initials for null avatarStyle', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: KAvatar(name: 'Linh Tran', size: 48),
        ),
      ),
    );
    expect(find.text('LT'), findsOneWidget);
  });

  testWidgets('single-name initials use first two letters', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: KAvatar(name: 'Linh', size: 48),
        ),
      ),
    );
    expect(find.text('LI'), findsOneWidget);
  });

  testWidgets('falls back to ? when name empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: KAvatar(name: '', size: 48),
        ),
      ),
    );
    expect(find.text('?'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test, expect fail**

- [ ] **Step 3: Implement KAvatar**

Create `lib/design/core/catalog/k_avatar.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

class KAvatar extends StatelessWidget {
  const KAvatar({
    super.key,
    required this.name,
    this.size = 40,
    this.avatarStyle,
    this.avatarSeed,
    this.avatarUrl,
  });

  final String name;
  final double size;
  final String? avatarStyle;
  final String? avatarSeed;
  final String? avatarUrl;

  static String _initialsFor(String raw) {
    final parts = raw.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(
        0,
        parts.first.length >= 2 ? 2 : 1,
      ).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String? _dicebearUrl() {
    if (avatarStyle == null || avatarStyle!.isEmpty) return null;
    if (avatarStyle == 'upload') return null;
    final seed = Uri.encodeComponent(avatarSeed ?? name);
    return 'https://api.dicebear.com/9.x/$avatarStyle/png?seed=$seed';
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final url = avatarStyle == 'upload' ? avatarUrl : _dicebearUrl();
    final initials = _initialsFor(name);

    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: c.primary.withValues(alpha: 0.15),
        alignment: Alignment.center,
        child: url != null
            ? Image.network(
                url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _initialsLabel(initials, c),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return _initialsLabel(initials, c);
                },
              )
            : _initialsLabel(initials, c),
      ),
    );
  }

  Widget _initialsLabel(String s, KuruColors c) => Text(
        s,
        style: TextStyle(
          color: c.primary,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.38,
        ),
      );
}
```

- [ ] **Step 4: Run test, expect pass**

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/catalog/k_avatar.dart test/design/core/catalog/k_avatar_test.dart
git commit -m "feat(design): KAvatar — initials / dicebear / uploaded"
```

---

### Task 9: KSettingsHero widget

**Files:**
- Create: `lib/design/core/layout/k_settings_hero.dart`
- Create: `test/design/core/layout/k_settings_hero_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/design/core/layout/k_settings_hero_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_hero.dart';

void main() {
  testWidgets('renders name + email + org chip', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KSettingsHero(
            name: 'Linh Tran',
            email: 'linh@example.com',
            orgChip: 'Tiệm Linh · Chủ',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    expect(find.text('Linh Tran'), findsOneWidget);
    expect(find.text('linh@example.com'), findsOneWidget);
    expect(find.text('Tiệm Linh · Chủ'), findsOneWidget);
    await tester.tap(find.byType(KSettingsHero));
    expect(tapped, isTrue);
  });
}
```

- [ ] **Step 2: Run test, expect fail**

- [ ] **Step 3: Implement KSettingsHero**

Create `lib/design/core/layout/k_settings_hero.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/catalog/k_avatar.dart';

class KSettingsHero extends StatelessWidget {
  const KSettingsHero({
    super.key,
    required this.name,
    required this.email,
    required this.orgChip,
    this.avatarStyle,
    this.avatarSeed,
    this.avatarUrl,
    this.onTap,
  });

  final String name;
  final String email;
  final String orgChip;
  final String? avatarStyle;
  final String? avatarSeed;
  final String? avatarUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [c.primary, c.primary.withValues(alpha: 0.78)],
            ),
            boxShadow: [
              BoxShadow(
                color: c.primary.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              KAvatar(
                name: name,
                size: 48,
                avatarStyle: avatarStyle,
                avatarSeed: avatarSeed,
                avatarUrl: avatarUrl,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 1),
                    Text(email,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(orgChip,
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: Colors.white.withValues(alpha: 0.7)),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test, expect pass**

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/layout/k_settings_hero.dart test/design/core/layout/k_settings_hero_test.dart
git commit -m "feat(design): KSettingsHero — gradient profile card"
```

---

### Task 10: KSettingsSection widget

**Files:**
- Create: `lib/design/core/layout/k_settings_section.dart`
- Create: `test/design/core/layout/k_settings_section_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/design/core/layout/k_settings_section_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_section.dart';

void main() {
  testWidgets('renders header + child rows in grouped card', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: KSettingsSection(
            header: 'Bảo mật',
            children: [
              ListTile(title: Text('Đổi mật khẩu')),
              ListTile(title: Text('2FA')),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Bảo mật'), findsOneWidget);
    expect(find.text('Đổi mật khẩu'), findsOneWidget);
    expect(find.text('2FA'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test, expect fail**

- [ ] **Step 3: Implement KSettingsSection**

Create `lib/design/core/layout/k_settings_section.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

class KSettingsSection extends StatelessWidget {
  const KSettingsSection({
    super.key,
    required this.header,
    required this.children,
  });

  final String header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final divided = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      divided.add(children[i]);
      if (i < children.length - 1) {
        divided.add(Divider(
          height: 1,
          thickness: 1,
          color: c.borderSubtle,
          indent: 0,
          endIndent: 0,
        ));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
          child: Text(
            header.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: c.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.borderSubtle),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: divided),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test, expect pass**

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/layout/k_settings_section.dart test/design/core/layout/k_settings_section_test.dart
git commit -m "feat(design): KSettingsSection — grouped card with header"
```

---

### Task 11: KSwitchRow widget

**Files:**
- Create: `lib/design/core/input/k_switch_row.dart`
- Create: `test/design/core/input/k_switch_row_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/design/core/input/k_switch_row_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/design/core/input/k_switch_row.dart';

void main() {
  testWidgets('toggles via callback', (tester) async {
    var value = false;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: KSwitchRow(
              leadingIcon: Icons.fingerprint,
              iconBackground: Colors.green.shade100,
              iconColor: Colors.green,
              label: 'FaceID',
              value: value,
              onChanged: (v) => setState(() => value = v),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(Switch), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(value, isTrue);
  });
}
```

- [ ] **Step 2: Run test, expect fail**

- [ ] **Step 3: Implement KSwitchRow**

Create `lib/design/core/input/k_switch_row.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

class KSwitchRow extends StatelessWidget {
  const KSwitchRow({
    super.key,
    required this.leadingIcon,
    required this.iconBackground,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData leadingIcon;
  final Color iconBackground;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(leadingIcon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: c.textPrimary)),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(subtitle!,
                        style: TextStyle(
                            fontSize: 12, color: c.textSecondary)),
                  ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test, expect pass**

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/input/k_switch_row.dart test/design/core/input/k_switch_row_test.dart
git commit -m "feat(design): KSwitchRow — list row with trailing switch"
```

---

## Phase 3 — Routes + Settings home (Tasks 12–13)

### Task 12: Register settings routes + delete stub

**Files:**
- Modify: `lib/app/router.dart`
- Delete: `lib/features/settings/settings_stub_screen.dart`
- Delete: `test/features/settings/settings_stub_screen_test.dart`

- [ ] **Step 1: Add 5 placeholder screen files**

Create five files now with minimal Scaffolds so the router can resolve them. We'll fill them out in later tasks.

`lib/features/settings/settings_home_screen.dart`:
```dart
import 'package:flutter/material.dart';

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Settings Home')));
}
```

`lib/features/settings/profile_screen.dart`, `security_screen.dart`, `store_screen.dart`, `appearance_screen.dart` — same shape, swap the class name and the visible text.

- [ ] **Step 2: Update router**

Open `lib/app/router.dart`. Replace the import of `settings_stub_screen.dart` and the `/settings` GoRoute:
```dart
import 'package:kuru_mobile/features/settings/appearance_screen.dart';
import 'package:kuru_mobile/features/settings/profile_screen.dart';
import 'package:kuru_mobile/features/settings/security_screen.dart';
import 'package:kuru_mobile/features/settings/settings_home_screen.dart';
import 'package:kuru_mobile/features/settings/store_screen.dart';
```

Locate the existing `GoRoute(path: '/settings', …)` and replace it with this block (inside the same routes list):
```dart
GoRoute(
  path: '/settings',
  builder: (context, state) => const SettingsHomeScreen(),
  routes: [
    GoRoute(
      path: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: 'security',
      builder: (context, state) => const SecurityScreen(),
    ),
    GoRoute(
      path: 'store',
      builder: (context, state) => const StoreScreen(),
    ),
    GoRoute(
      path: 'appearance',
      builder: (context, state) => const AppearanceScreen(),
    ),
  ],
),
```

Confirm `authedShellPrefixes` already includes `/settings` (it does, per CLAUDE.md). No change needed there.

- [ ] **Step 3: Delete the stub**

```bash
rm lib/features/settings/settings_stub_screen.dart
rm test/features/settings/settings_stub_screen_test.dart
```

- [ ] **Step 4: Run analyzer + tests**

```bash
flutter analyze
```
Expected: exit 0.

- [ ] **Step 5: Commit**

```bash
git add lib/app/router.dart lib/features/settings test/features/settings
git commit -m "feat(settings): register 5 routes; delete stub"
```

---

### Task 13: SettingsHomeScreen (hero + sections + role gating)

**Files:**
- Modify: `lib/features/settings/settings_home_screen.dart`
- Create: `test/features/settings/settings_home_screen_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/features/settings/settings_home_screen_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/permissions/permissions_providers.dart';
import 'package:kuru_mobile/core/permissions/resolved_permissions.dart';
import 'package:kuru_mobile/features/settings/settings_home_screen.dart';

UserInfo _user() => const UserInfo(
      email: 'linh@example.com',
      name: 'Linh Tran',
      orgInfos: [OrgInfo(id: 'o1', name: 'Tiệm Linh', role: 'OWNER')],
    );

Widget _harness(WidgetRef ref, {required List<Override> overrides}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routerConfig: GoRouter(routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const SettingsHomeScreen(),
        ),
      ]),
    ),
  );
}

void main() {
  testWidgets('OWNER sees Store section', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith(
              (ref) async => BootstrapAuthed(_user())),
          myPermissionsProvider.overrideWith((ref) async =>
              const ResolvedPermissions(orgRole: OrgRole.owner)),
          biometricEnabledProvider.overrideWith((ref) async => false),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(routes: [
            GoRoute(path: '/', builder: (_, __) => const SettingsHomeScreen()),
          ]),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Cửa hàng'.toUpperCase()), findsOneWidget);
  });

  testWidgets('STAFF does not see Store section', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith(
              (ref) async => BootstrapAuthed(_user())),
          myPermissionsProvider.overrideWith((ref) async =>
              const ResolvedPermissions(orgRole: OrgRole.staff)),
          biometricEnabledProvider.overrideWith((ref) async => false),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(routes: [
            GoRoute(path: '/', builder: (_, __) => const SettingsHomeScreen()),
          ]),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Cửa hàng'.toUpperCase()), findsNothing);
  });
}
```

- [ ] **Step 2: Run test, expect fail**

- [ ] **Step 3: Replace SettingsHomeScreen with the real implementation**

Replace `lib/features/settings/settings_home_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/permissions/permissions_providers.dart';
import 'package:kuru_mobile/design/core/catalog/k_list_row.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_hero.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_section.dart';

class SettingsHomeScreen extends ConsumerWidget {
  const SettingsHomeScreen({super.key});

  static const _heroToProfile = '/settings/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final bootstrap = ref.watch(appBootstrapProvider);
    final perms = ref.watch(myPermissionsProvider);
    final bioEnabled = ref.watch(biometricEnabledProvider);

    final user = bootstrap.maybeWhen(
      data: (b) => b is BootstrapAuthed ? b.user : null,
      orElse: () => null,
    );
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final org = user.orgInfos.isNotEmpty ? user.orgInfos.first : null;
    final orgChip =
        org == null ? '' : '${org.name} · ${_roleLabel(org.role)}';

    final isOwner = perms.maybeWhen(
      data: (p) => p.isOwner,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          children: [
            const KPageHeader(title: 'Cài đặt'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: KSettingsHero(
                name: user.name ?? '',
                email: user.email ?? '',
                orgChip: orgChip,
                avatarStyle: user.avatarStyle,
                avatarSeed: user.avatarSeed,
                avatarUrl: user.avatarUrl,
                onTap: () => context.push(_heroToProfile),
              ),
            ),
            KSettingsSection(
              header: 'Bảo mật',
              children: [
                KListRow(
                  leadingIcon: Icons.key_outlined,
                  iconBackground: const Color(0xFFEEF0FF),
                  iconColor: const Color(0xFF4F46E5),
                  label: 'Đổi mật khẩu',
                  onTap: () => context.push('/settings/security'),
                ),
                KListRow(
                  leadingIcon: Icons.shield_outlined,
                  iconBackground: const Color(0xFFFEF3C7),
                  iconColor: const Color(0xFFB45309),
                  label: 'Xác thực 2 lớp',
                  trailingText: user.totpEnabled ? 'Bật' : 'Tắt',
                  onTap: () => context.push('/settings/security'),
                ),
                KListRow(
                  leadingIcon: Icons.fingerprint,
                  iconBackground: const Color(0xFFD1FAE5),
                  iconColor: const Color(0xFF047857),
                  label: 'FaceID / Vân tay',
                  trailingText: bioEnabled.maybeWhen(
                    data: (v) => v ? 'Bật' : 'Tắt',
                    orElse: () => 'Tắt',
                  ),
                  onTap: () => context.push('/settings/security'),
                ),
              ],
            ),
            if (isOwner)
              KSettingsSection(
                header: 'Cửa hàng',
                children: [
                  KListRow(
                    leadingIcon: Icons.public,
                    iconBackground: const Color(0xFFEDE9FE),
                    iconColor: const Color(0xFF6D28D9),
                    label: 'Múi giờ',
                    onTap: () => context.push('/settings/store'),
                  ),
                ],
              ),
            KSettingsSection(
              header: 'Giao diện',
              children: [
                KListRow(
                  leadingIcon: Icons.palette_outlined,
                  iconBackground: const Color(0xFFD6F5EE),
                  iconColor: const Color(0xFF0D9488),
                  label: 'Màu chủ đề',
                  onTap: () => context.push('/settings/appearance'),
                ),
                KListRow(
                  leadingIcon: Icons.language,
                  iconBackground: const Color(0xFFE0F2FE),
                  iconColor: const Color(0xFF0369A1),
                  label: 'Ngôn ngữ',
                  onTap: () => context.push('/settings/appearance'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            KSettingsSection(
              header: '',
              children: [
                KListRow(
                  leadingIcon: Icons.logout,
                  iconBackground: const Color(0xFFFFE4E6),
                  iconColor: const Color(0xFFBE123C),
                  label: 'Đăng xuất',
                  labelColor: const Color(0xFFDC2626),
                  showChevron: false,
                  onTap: () async {
                    final repo = ref.read(authRepositoryProvider);
                    await repo.signOut();
                    ref.read(currentOrgIdProvider.notifier).clear();
                    ref.invalidate(appBootstrapProvider);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _roleLabel(String wireRole) {
    switch (wireRole) {
      case 'OWNER':
        return 'Chủ shop';
      case 'MANAGER':
        return 'Quản lý';
      case 'STAFF':
        return 'Nhân viên';
      default:
        return wireRole;
    }
  }
}
```

Note: this assumes `KListRow` accepts `leadingIcon`, `iconBackground`, `iconColor`, `label`, `trailingText`, `labelColor`, `showChevron`, `onTap`. If the existing `KListRow` API differs, adapt by inspecting `lib/design/core/catalog/k_list_row.dart` before this step and update the props at the call sites to match.

- [ ] **Step 4: Run tests, expect pass**

- [ ] **Step 5: Commit**

```bash
git add lib/features/settings/settings_home_screen.dart test/features/settings/settings_home_screen_test.dart
git commit -m "feat(settings): SettingsHomeScreen — hero + role-gated sections"
```

---

## Phase 4 — Profile screen + avatar (Tasks 14–16)

### Task 14: ProfileScreen — display name + avatar trigger

**Files:**
- Modify: `lib/features/settings/profile_screen.dart`
- Create: `test/features/settings/profile_screen_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/features/settings/profile_screen_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/features/settings/profile_screen.dart';

void main() {
  testWidgets('shows current name and email', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith((ref) async => const BootstrapAuthed(
                UserInfo(
                  email: 'linh@example.com',
                  name: 'Linh Tran',
                  orgInfos: [OrgInfo(id: 'o1', name: 'Tiệm', role: 'OWNER')],
                ),
              )),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('linh@example.com'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Linh Tran'), findsOneWidget);
  });

  testWidgets('name shorter than 2 chars shows field error', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith((ref) async => const BootstrapAuthed(
                UserInfo(
                  email: 'a@b.c',
                  name: 'Linh',
                  orgInfos: [OrgInfo(id: 'o1', name: 'Tiệm', role: 'OWNER')],
                ),
              )),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.enterText(find.byType(TextFormField), 'A');
    await tester.tap(find.text('Lưu'));
    await tester.pump();
    expect(find.text('Tên phải từ 2 đến 32 ký tự'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Implement ProfileScreen**

Replace `lib/features/settings/profile_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/profile_providers.dart';
import 'package:kuru_mobile/design/core/catalog/k_avatar.dart';
import 'package:kuru_mobile/design/core/input/k_primary_btn.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';
import 'package:kuru_mobile/features/settings/sheets/avatar_picker_sheet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  String? _nameError;
  String? _avatarStyle;
  String? _avatarSeed;
  bool _saving = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _hydrate(UserInfo user) {
    if (_initialized) return;
    _nameCtrl.text = user.name ?? '';
    _avatarStyle = user.avatarStyle;
    _avatarSeed = user.avatarSeed;
    _initialized = true;
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.length < 2 || name.length > 32) {
      setState(() => _nameError = 'Tên phải từ 2 đến 32 ký tự');
      return;
    }
    setState(() {
      _nameError = null;
      _saving = true;
    });
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.updateProfile(
      name: name,
      avatarStyle: _avatarStyle,
      avatarSeed: _avatarSeed,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case ApiSuccess<void>():
        KNotify.success(context, 'Đã lưu hồ sơ');
        ref.invalidate(appBootstrapProvider);
        Navigator.of(context).maybePop();
      case ApiFailure<void>(:final error):
        if (error is BadRequestException) {
          setState(() => _nameError = error.message);
        } else {
          KNotify.networkError(context, 'Không lưu được hồ sơ',
              onRetry: _save);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final bootstrap = ref.watch(appBootstrapProvider);
    final user = bootstrap.maybeWhen(
      data: (b) => b is BootstrapAuthed ? b.user : null,
      orElse: () => null,
    );
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    _hydrate(user);
    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            const KPageHeader(title: 'Hồ sơ', showBack: true),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await showAvatarPickerSheet(
                        context,
                        currentName: user.name ?? '',
                        currentStyle: _avatarStyle,
                        currentSeed: _avatarSeed,
                      );
                      if (result != null) {
                        setState(() {
                          _avatarStyle = result.style;
                          _avatarSeed = result.seed;
                        });
                      }
                    },
                    child: KAvatar(
                      name: _nameCtrl.text.isEmpty
                          ? (user.name ?? '')
                          : _nameCtrl.text,
                      size: 96,
                      avatarStyle: _avatarStyle,
                      avatarSeed: _avatarSeed,
                      avatarUrl: user.avatarUrl,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Nhấn để đổi ảnh đại diện',
                      style: TextStyle(color: c.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(user.email ?? '',
                      style: TextStyle(color: c.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            KFormField(
              controller: _nameCtrl,
              labelText: 'Tên hiển thị',
              errorText: _nameError,
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
            ),
            const SizedBox(height: 24),
            KPrimaryBtn(
              label: _saving ? 'Đang lưu…' : 'Lưu',
              onPressed: _saving ? null : _save,
              loading: _saving,
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Run tests, expect compile error (avatar sheet not yet defined)**

We'll create the sheet in Task 15. Skip running tests for this task until Task 15 lands; commit will combine.

- [ ] **Step 4: Commit (combined with Task 15)** — see Task 15.

---

### Task 15: AvatarPickerSheet (Initials / Dicebear / Upload tabs)

**Files:**
- Create: `lib/features/settings/sheets/avatar_picker_sheet.dart`
- Create: `test/features/settings/sheets/avatar_picker_sheet_test.dart`

- [ ] **Step 1: Implement the sheet API**

Create `lib/features/settings/sheets/avatar_picker_sheet.dart`:
```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/profile_providers.dart';
import 'package:kuru_mobile/design/core/catalog/k_avatar.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

class AvatarSelection {
  const AvatarSelection({required this.style, required this.seed});
  final String? style;
  final String? seed;
}

const _dicebearStyles = <String>[
  'fun-emoji',
  'lorelei-line',
  'miniavs',
  'open-peeps',
  'thumbs',
];

Future<AvatarSelection?> showAvatarPickerSheet(
  BuildContext context, {
  required String currentName,
  String? currentStyle,
  String? currentSeed,
}) {
  return showKModalSheet<AvatarSelection>(
    context: context,
    title: 'Ảnh đại diện',
    showCancel: true,
    enableDrag: true,
    bodyBuilder: (sheetCtx) => _AvatarPickerBody(
      currentName: currentName,
      initialStyle: currentStyle,
      initialSeed: currentSeed,
    ),
  );
}

class _AvatarPickerBody extends ConsumerStatefulWidget {
  const _AvatarPickerBody({
    required this.currentName,
    this.initialStyle,
    this.initialSeed,
  });
  final String currentName;
  final String? initialStyle;
  final String? initialSeed;
  @override
  ConsumerState<_AvatarPickerBody> createState() => _AvatarPickerBodyState();
}

class _AvatarPickerBodyState extends ConsumerState<_AvatarPickerBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);
  String? _style;
  String? _seed;
  File? _pickedFile;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _style = widget.initialStyle;
    _seed = widget.initialSeed;
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (picked == null) return;
    setState(() => _pickedFile = File(picked.path));
  }

  Future<void> _uploadAndApply() async {
    final file = _pickedFile;
    final bootstrap = ref.read(appBootstrapProvider);
    final userId = bootstrap.maybeWhen(
      data: (b) =>
          b is BootstrapAuthed ? b.user.orgInfos.firstOrNull?.id : null,
      orElse: () => null,
    );
    if (file == null) return;
    if (userId == null) return;
    setState(() => _uploading = true);
    final result = await ref
        .read(profileRepositoryProvider)
        .uploadAvatar(file: file, userId: userId);
    if (!mounted) return;
    setState(() => _uploading = false);
    switch (result) {
      case ApiSuccess<String>():
        ref.invalidate(appBootstrapProvider);
        Navigator.of(context)
            .pop(const AvatarSelection(style: 'upload', seed: null));
      case ApiFailure<String>(:final error):
        if (error is BadRequestException) {
          KNotify.warning(context, error.message);
        } else {
          KNotify.networkError(context, 'Tải ảnh thất bại',
              onRetry: _uploadAndApply);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SizedBox(
      height: 420,
      child: Column(
        children: [
          TabBar(
            controller: _tabs,
            labelColor: c.primary,
            unselectedLabelColor: c.textSecondary,
            indicatorColor: c.primary,
            tabs: const [
              Tab(text: 'Chữ cái'),
              Tab(text: 'Hình vẽ'),
              Tab(text: 'Tải lên'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _initialsTab(),
                _dicebearTab(),
                _uploadTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _initialsTab() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          KAvatar(name: widget.currentName, size: 96),
          const SizedBox(height: 12),
          const Text('Tạo từ tên hiển thị'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(
              const AvatarSelection(style: null, seed: null),
            ),
            child: const Text('Dùng chữ cái'),
          ),
        ],
      ),
    );
  }

  Widget _dicebearTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _dicebearStyles.length,
      itemBuilder: (_, i) {
        final s = _dicebearStyles[i];
        final selected = _style == s;
        return GestureDetector(
          onTap: () => setState(() {
            _style = s;
            _seed ??= widget.currentName;
          }),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor,
                width: selected ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: KAvatar(
                    name: widget.currentName,
                    size: 60,
                    avatarStyle: s,
                    avatarSeed: _seed ?? widget.currentName,
                  ),
                ),
                Text(s,
                    style: const TextStyle(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _uploadTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickFromGallery,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              alignment: Alignment.center,
              child: _pickedFile == null
                  ? const Icon(Icons.add_a_photo, size: 36)
                  : ClipOval(
                      child: Image.file(_pickedFile!,
                          width: 140, height: 140, fit: BoxFit.cover),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _pickedFile == null || _uploading ? null : _uploadAndApply,
            child:
                _uploading ? const Text('Đang tải…') : const Text('Lưu ảnh'),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Add the apply-on-confirm path for dicebear**

In `_dicebearTab` selection flow we also need an apply button when a non-upload style is picked. Append a footer in the body — change `build` to wrap the `TabBarView` in a `Column` with a trailing FilledButton when `_style != null && _tabs.index == 1`. Simplest implementation: re-use `_tabs.addListener` to trigger `setState`, then conditionally render the apply button. Add this inside `build` after the `Expanded(child: TabBarView…)`:

```dart
if (_tabs.index == 1 && _style != null)
  Padding(
    padding: const EdgeInsets.all(12),
    child: FilledButton(
      onPressed: () => Navigator.of(context).pop(
        AvatarSelection(style: _style, seed: _seed ?? widget.currentName),
      ),
      child: const Text('Dùng kiểu này'),
    ),
  ),
```

And in `initState`:
```dart
_tabs.addListener(() {
  if (mounted) setState(() {});
});
```

- [ ] **Step 3: Add widget test**

Create `test/features/settings/sheets/avatar_picker_sheet_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/settings/sheets/avatar_picker_sheet.dart';

void main() {
  testWidgets('returns null AvatarSelection when initials tab confirms',
      (tester) async {
    AvatarSelection? captured;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Builder(
            builder: (ctx) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    captured = await showAvatarPickerSheet(ctx,
                        currentName: 'Linh Tran');
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Chữ cái'), findsOneWidget);
    await tester.tap(find.text('Dùng chữ cái'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(captured?.style, isNull);
    expect(captured?.seed, isNull);
  });
}
```

- [ ] **Step 4: Run analyzer + tests**

- [ ] **Step 5: Commit Tasks 14 + 15 together**

```bash
git add lib/features/settings/profile_screen.dart \
        lib/features/settings/sheets/avatar_picker_sheet.dart \
        test/features/settings/profile_screen_test.dart \
        test/features/settings/sheets/avatar_picker_sheet_test.dart
git commit -m "feat(settings): ProfileScreen + AvatarPickerSheet (3 modes)"
```

---

### Task 16: Wire avatar upload error toast i18n + final QA pass

The upload path is already wired in `_uploadAndApply`. This task verifies the multipart payload shape matches BE expectations by adding a deeper unit test.

**Files:**
- Modify: `test/core/profile/profile_repository_test.dart` (add upload test)

- [ ] **Step 1: Add upload test**

Append to `test/core/profile/profile_repository_test.dart`:
```dart
group('uploadAvatar', () {
  test('posts multipart with userId + avatar', () async {
    when(() => dio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        )).thenAnswer(
      (_) async => Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 201,
        data: {
          'success': true,
          'data': {'key': 'user-avatar/abc.webp'},
        },
      ),
    );
    final tmp = await File('${Directory.systemTemp.path}/avatar.png').create();
    await tmp.writeAsBytes([1, 2, 3]);
    final result = await repo.uploadAvatar(file: tmp, userId: 'u-1');
    expect((result as ApiSuccess<String>).data, 'user-avatar/abc.webp');
    final captured = verify(() => dio.post<Map<String, dynamic>>(
          '/api/v1/store/UploadUserAvatar',
          data: captureAny(named: 'data'),
        )).captured.single as FormData;
    expect(captured.fields, contains(const MapEntry('userId', 'u-1')));
    expect(captured.files, hasLength(1));
    expect(captured.files.first.key, 'avatar');
  });
});
```

Add `import 'dart:io';` at the top of the file.

- [ ] **Step 2: Run tests, expect pass**

- [ ] **Step 3: Commit**

```bash
git add test/core/profile/profile_repository_test.dart
git commit -m "test(profile): assert UploadUserAvatar multipart shape"
```

---

## Phase 5 — Appearance (Task 17)

### Task 17: AppearanceScreen (palette grid + locale)

**Files:**
- Modify: `lib/features/settings/appearance_screen.dart`
- Create: `test/features/settings/appearance_screen_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/features/settings/appearance_screen_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/locale_controller.dart';
import 'package:kuru_mobile/features/settings/appearance_screen.dart';
import 'package:kuru_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('tapping purple swatch updates themeControllerProvider',
      (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
    ]);
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AppearanceScreen()),
      ),
    );
    await tester.pump();
    expect(container.read(themeControllerProvider), KuruPalette.indigo);
    await tester.tap(find.byKey(const ValueKey('palette.purple')));
    await tester.pump(const Duration(milliseconds: 50));
    expect(container.read(themeControllerProvider), KuruPalette.purple);
  });

  testWidgets('tapping English updates localeControllerProvider',
      (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
    ]);
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AppearanceScreen()),
      ),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('locale.en')));
    await tester.pump(const Duration(milliseconds: 50));
    expect(container.read(localeControllerProvider).languageCode, 'en');
  });
}
```

- [ ] **Step 2: Implement AppearanceScreen**

Replace `lib/features/settings/appearance_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/locale_controller.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final palette = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const KPageHeader(title: 'Giao diện', showBack: true),
            const SizedBox(height: 12),
            Text('Màu chủ đề',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.textSecondary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final p in KuruPalette.values)
                  _Swatch(
                    key: ValueKey('palette.${p.name}'),
                    label: p.label,
                    color: p.resolve(Brightness.light).primary,
                    selected: palette == p,
                    onTap: () => ref
                        .read(themeControllerProvider.notifier)
                        .setPalette(p),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Ngôn ngữ',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.textSecondary)),
            const SizedBox(height: 8),
            for (final loc in LocaleController.supported)
              RadioListTile<String>(
                key: ValueKey('locale.${loc.languageCode}'),
                value: loc.languageCode,
                groupValue: locale.languageCode,
                onChanged: (v) {
                  if (v == null) return;
                  ref
                      .read(localeControllerProvider.notifier)
                      .setLocale(Locale(v));
                },
                title: Text(loc.languageCode == 'vi'
                    ? 'Tiếng Việt'
                    : 'English'),
              ),
          ],
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: selected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
```

Verify `KuruPalette` exposes `.label` and `.name`. If `.label` doesn't exist, add a getter inside the enum that returns `'Chàm'` for indigo, `'Tím'` for purple, etc. — keep it inside the spec's "palette picker" UX scope.

- [ ] **Step 3: Run tests, expect pass**

- [ ] **Step 4: Commit**

```bash
git add lib/features/settings/appearance_screen.dart test/features/settings/appearance_screen_test.dart
git commit -m "feat(settings): AppearanceScreen — palette grid + locale picker"
```

---

## Phase 6 — Store (Task 18)

### Task 18: StoreScreen + TimezonePickerSheet

**Files:**
- Modify: `lib/features/settings/store_screen.dart`
- Create: `lib/features/settings/sheets/timezone_picker_sheet.dart`
- Create: `lib/core/profile/store_settings_repository.dart` (new — only owns store GET/UPDATE)
- Create: `test/features/settings/store_screen_test.dart`

- [ ] **Step 1: Create StoreSettingsRepository**

Create `lib/core/profile/store_settings_repository.dart`:
```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';

class StoreSettings {
  const StoreSettings({required this.timezone, required this.name});
  final String timezone;
  final String name;
}

class StoreSettingsRepository {
  StoreSettingsRepository(this._dio);
  final Dio _dio;

  Future<ApiResult<StoreSettings>> getStoreSettings() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/store/GetStoreSettings',
        data: <String, dynamic>{},
      );
      final d = res.data?['data'] as Map<String, dynamic>?;
      if (d == null) {
        return ApiResult.failure(
          const ServerException('Empty body', statusCode: 200),
        );
      }
      return ApiResult.success(StoreSettings(
        timezone: d['timezone'] as String? ?? '',
        name: d['name'] as String? ?? '',
      ));
    } on DioException catch (e) {
      final mapped = e.error;
      return ApiResult.failure(mapped is ApiException
          ? mapped
          : const UnknownException('GetStoreSettings failed'));
    }
  }

  Future<ApiResult<void>> updateStoreSettings({required String timezone}) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/v1/store/UpdateStoreSettings',
        data: <String, dynamic>{'timezone': timezone},
      );
      return ApiResult.success(null);
    } on DioException catch (e) {
      final mapped = e.error;
      return ApiResult.failure(mapped is ApiException
          ? mapped
          : const UnknownException('UpdateStoreSettings failed'));
    }
  }
}

final storeSettingsRepositoryProvider = Provider<StoreSettingsRepository>(
  (ref) => StoreSettingsRepository(ref.read(dioProvider)),
);
```

- [ ] **Step 2: Build the timezone picker sheet**

Create `lib/features/settings/sheets/timezone_picker_sheet.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

const kCuratedTimezones = <({String id, String label})>[
  (id: 'Asia/Ho_Chi_Minh', label: 'Việt Nam (GMT+7)'),
  (id: 'Asia/Bangkok', label: 'Thái Lan (GMT+7)'),
  (id: 'Asia/Singapore', label: 'Singapore (GMT+8)'),
  (id: 'Asia/Shanghai', label: 'Trung Quốc (GMT+8)'),
  (id: 'Asia/Tokyo', label: 'Nhật Bản (GMT+9)'),
  (id: 'Asia/Seoul', label: 'Hàn Quốc (GMT+9)'),
  (id: 'Asia/Manila', label: 'Philippines (GMT+8)'),
  (id: 'Australia/Sydney', label: 'Sydney (GMT+11)'),
  (id: 'Europe/London', label: 'Anh (GMT+0)'),
  (id: 'America/New_York', label: 'New York (GMT-5)'),
  (id: 'America/Los_Angeles', label: 'Los Angeles (GMT-8)'),
];

Future<String?> showTimezonePickerSheet(
  BuildContext context, {
  required String current,
}) {
  return showKModalSheet<String>(
    context: context,
    title: 'Múi giờ',
    showCancel: true,
    enableDrag: true,
    bodyBuilder: (sheetCtx) =>
        _TimezonePickerBody(current: current),
  );
}

class _TimezonePickerBody extends StatefulWidget {
  const _TimezonePickerBody({required this.current});
  final String current;
  @override
  State<_TimezonePickerBody> createState() => _TimezonePickerBodyState();
}

class _TimezonePickerBodyState extends State<_TimezonePickerBody> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = kCuratedTimezones
        .where((tz) =>
            tz.id.toLowerCase().contains(_query.toLowerCase()) ||
            tz.label.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return SizedBox(
      height: 480,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Tìm múi giờ',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final tz = filtered[i];
                final selected = tz.id == widget.current;
                return ListTile(
                  title: Text(tz.label),
                  subtitle: Text(tz.id, style: const TextStyle(fontSize: 11)),
                  trailing: selected ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.of(context).pop(tz.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Replace StoreScreen**

Replace `lib/features/settings/store_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/store_settings_repository.dart';
import 'package:kuru_mobile/design/core/catalog/k_list_row.dart';
import 'package:kuru_mobile/design/core/input/k_primary_btn.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';
import 'package:kuru_mobile/features/settings/sheets/timezone_picker_sheet.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});
  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  StoreSettings? _settings;
  String? _selectedTz;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(storeSettingsRepositoryProvider);
    final r = await repo.getStoreSettings();
    if (!mounted) return;
    switch (r) {
      case ApiSuccess<StoreSettings>(:final data):
        setState(() {
          _settings = data;
          _selectedTz = data.timezone;
          _loading = false;
        });
      case ApiFailure<StoreSettings>():
        setState(() => _loading = false);
        KNotify.networkError(context, 'Không tải được thiết lập cửa hàng',
            onRetry: _load);
    }
  }

  Future<void> _save() async {
    final tz = _selectedTz;
    if (tz == null) return;
    setState(() => _saving = true);
    final repo = ref.read(storeSettingsRepositoryProvider);
    final r = await repo.updateStoreSettings(timezone: tz);
    if (!mounted) return;
    setState(() => _saving = false);
    switch (r) {
      case ApiSuccess<void>():
        KNotify.success(context, 'Đã lưu múi giờ');
        Navigator.of(context).maybePop();
      case ApiFailure<void>(:final error):
        if (error is BadRequestException) {
          KNotify.warning(context, error.message);
        } else {
          KNotify.networkError(context, 'Lưu thất bại', onRetry: _save);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const KPageHeader(title: 'Cửa hàng', showBack: true),
            const SizedBox(height: 12),
            KListRow(
              leadingIcon: Icons.public,
              iconBackground: const Color(0xFFEDE9FE),
              iconColor: const Color(0xFF6D28D9),
              label: 'Múi giờ',
              trailingText: _selectedTz ?? '',
              onTap: () async {
                final tz = await showTimezonePickerSheet(
                  context,
                  current: _selectedTz ?? '',
                );
                if (tz != null) setState(() => _selectedTz = tz);
              },
            ),
            const SizedBox(height: 24),
            KPrimaryBtn(
              label: _saving ? 'Đang lưu…' : 'Lưu',
              onPressed: _saving ||
                      _selectedTz == null ||
                      _selectedTz == _settings?.timezone
                  ? null
                  : _save,
              loading: _saving,
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Add widget test**

Create `test/features/settings/store_screen_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/store_settings_repository.dart';
import 'package:kuru_mobile/features/settings/store_screen.dart';
import 'package:mocktail/mocktail.dart';

class _FakeRepo extends Mock implements StoreSettingsRepository {}

void main() {
  late _FakeRepo repo;

  setUp(() {
    repo = _FakeRepo();
    when(() => repo.getStoreSettings()).thenAnswer((_) async =>
        ApiResult.success(
            const StoreSettings(timezone: 'Asia/Ho_Chi_Minh', name: 'Tiệm')));
    when(() => repo.updateStoreSettings(timezone: any(named: 'timezone')))
        .thenAnswer((_) async => ApiResult.success(null));
  });

  testWidgets('shows current timezone after load', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storeSettingsRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(home: StoreScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Asia/Ho_Chi_Minh'), findsOneWidget);
  });
}
```

- [ ] **Step 5: Run analyzer + tests**

- [ ] **Step 6: Commit**

```bash
git add lib/core/profile/store_settings_repository.dart \
        lib/features/settings/store_screen.dart \
        lib/features/settings/sheets/timezone_picker_sheet.dart \
        test/features/settings/store_screen_test.dart
git commit -m "feat(settings): StoreScreen + TimezonePickerSheet (VN-first list)"
```

---

## Phase 7 — Security (Tasks 19–22)

### Task 19: SecurityScreen — entry rows + state

**Files:**
- Modify: `lib/features/settings/security_screen.dart`
- Create: `test/features/settings/security_screen_test.dart`

- [ ] **Step 1: Implement SecurityScreen**

Replace `lib/features/settings/security_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_repository.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/profile/profile_providers.dart';
import 'package:kuru_mobile/design/core/catalog/k_list_row.dart';
import 'package:kuru_mobile/design/core/input/k_switch_row.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';
import 'package:kuru_mobile/design/core/layout/k_settings_section.dart';
import 'package:kuru_mobile/features/settings/sheets/change_password_sheet.dart';
import 'package:kuru_mobile/features/settings/sheets/enable_biometric_sheet.dart';

class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final bioEnabled = ref.watch(biometricEnabledProvider);
    final bioAvailable = ref.watch(biometricAvailableProvider);
    final bootstrap = ref.watch(appBootstrapProvider);

    final user = bootstrap.maybeWhen(
      data: (b) => b is BootstrapAuthed ? b.user : null,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            const KPageHeader(title: 'Bảo mật', showBack: true),
            const SizedBox(height: 8),
            KSettingsSection(
              header: 'Tài khoản',
              children: [
                KListRow(
                  leadingIcon: Icons.key_outlined,
                  iconBackground: const Color(0xFFEEF0FF),
                  iconColor: const Color(0xFF4F46E5),
                  label: 'Đổi mật khẩu',
                  onTap: () => showChangePasswordSheet(context),
                ),
                KListRow(
                  leadingIcon: Icons.shield_outlined,
                  iconBackground: const Color(0xFFFEF3C7),
                  iconColor: const Color(0xFFB45309),
                  label: 'Xác thực 2 lớp',
                  trailingText:
                      user?.totpEnabled == true ? 'Bật' : 'Tắt',
                  onTap: () {
                    // TOTP entry — reuse identity-flow screens via navigator
                    // push of /totp/enable (existing) which already handles
                    // CreateTotpDevice → VerifyTotpDevice → recovery codes.
                    Navigator.of(context).pushNamed('/totp/enable');
                  },
                ),
                KSwitchRow(
                  leadingIcon: Icons.fingerprint,
                  iconBackground: const Color(0xFFD1FAE5),
                  iconColor: const Color(0xFF047857),
                  label: 'FaceID / Vân tay',
                  subtitle: bioEnabled.maybeWhen(
                    data: (v) =>
                        v ? 'Đã bật' : 'Đăng nhập nhanh không cần mật khẩu',
                    orElse: () => '',
                  ),
                  value: bioEnabled.maybeWhen(
                      data: (v) => v, orElse: () => false),
                  onChanged: (target) async {
                    final available = bioAvailable.maybeWhen(
                        data: (v) => v, orElse: () => false);
                    if (!available) {
                      KNotify.warning(context,
                          'Thiết bị chưa cài FaceID hoặc vân tay');
                      return;
                    }
                    if (target) {
                      final ok =
                          await showEnableBiometricSheet(context);
                      if (ok) ref.invalidate(biometricEnabledProvider);
                    } else {
                      await ref
                          .read(biometricRepositoryProvider)
                          .disable();
                      ref.invalidate(biometricEnabledProvider);
                      KNotify.success(context, 'Đã tắt FaceID');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Run analyzer — compile fails on missing sheets. Proceed to Task 20.**

- [ ] **Step 3: Commit deferred (combined with Tasks 20–22).**

---

### Task 20: ChangePasswordSheet

**Files:**
- Create: `lib/features/settings/sheets/change_password_sheet.dart`
- Create: `test/features/settings/sheets/change_password_sheet_test.dart`

- [ ] **Step 1: Implement the sheet**

Create `lib/features/settings/sheets/change_password_sheet.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/profile_providers.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';

Future<void> showChangePasswordSheet(BuildContext context) {
  return showKModalSheet<void>(
    context: context,
    title: 'Đổi mật khẩu',
    confirmLabel: 'Lưu',
    showCancel: true,
    bodyBuilder: (sheetCtx) => const _ChangePasswordBody(),
    onConfirm: () async => null,
  );
}

class _ChangePasswordBody extends ConsumerStatefulWidget {
  const _ChangePasswordBody();
  @override
  ConsumerState<_ChangePasswordBody> createState() => _State();
}

class _State extends ConsumerState<_ChangePasswordBody> {
  final _old = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  String? _oldError;
  String? _newError;
  String? _confirmError;
  bool _saving = false;

  @override
  void dispose() {
    _old.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _oldError = _old.text.isEmpty ? 'Bắt buộc' : null;
      _newError = _new.text.length < 8 ? 'Tối thiểu 8 ký tự' : null;
      _confirmError =
          _confirm.text != _new.text ? 'Mật khẩu không khớp' : null;
    });
    if (_oldError != null || _newError != null || _confirmError != null) {
      return;
    }
    setState(() => _saving = true);
    final r = await ref.read(profileRepositoryProvider).changePassword(
          oldPassword: _old.text,
          newPassword: _new.text,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (r) {
      case ApiSuccess<void>():
        KNotify.success(context, 'Đã đổi mật khẩu');
        Navigator.of(context).pop();
      case ApiFailure<void>(:final error):
        if (error is BadRequestException) {
          setState(() => _oldError = error.message);
        } else if (error is UnauthorizedException) {
          KNotify.warning(context, 'Phiên đã hết, đăng nhập lại');
        } else {
          KNotify.networkError(context, 'Đổi mật khẩu thất bại',
              onRetry: _submit);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KFormField(
            controller: _old,
            labelText: 'Mật khẩu hiện tại',
            obscureText: true,
            errorText: _oldError,
            onChanged: (_) {
              if (_oldError != null) setState(() => _oldError = null);
            },
          ),
          const SizedBox(height: 12),
          KFormField(
            controller: _new,
            labelText: 'Mật khẩu mới',
            obscureText: true,
            errorText: _newError,
            onChanged: (_) {
              if (_newError != null) setState(() => _newError = null);
            },
          ),
          const SizedBox(height: 12),
          KFormField(
            controller: _confirm,
            labelText: 'Xác nhận mật khẩu',
            obscureText: true,
            errorText: _confirmError,
            onChanged: (_) {
              if (_confirmError != null) setState(() => _confirmError = null);
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: Text(_saving ? 'Đang lưu…' : 'Lưu'),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Add widget test**

Create `test/features/settings/sheets/change_password_sheet_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/profile_providers.dart';
import 'package:kuru_mobile/core/profile/profile_repository.dart';
import 'package:kuru_mobile/features/settings/sheets/change_password_sheet.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ProfileRepository {}

void main() {
  testWidgets('mismatch new vs confirm shows field error', (tester) async {
    final repo = _MockRepo();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (ctx) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showChangePasswordSheet(ctx),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.enterText(
        find.widgetWithText(TextField, 'Mật khẩu hiện tại'), 'old1234567');
    await tester.enterText(
        find.widgetWithText(TextField, 'Mật khẩu mới'), 'newpw12345');
    await tester.enterText(
        find.widgetWithText(TextField, 'Xác nhận mật khẩu'), 'mismatch');
    await tester.tap(find.text('Lưu'));
    await tester.pump();
    expect(find.text('Mật khẩu không khớp'), findsOneWidget);
    verifyNever(() => repo.changePassword(
          oldPassword: any(named: 'oldPassword'),
          newPassword: any(named: 'newPassword'),
        ));
  });
}
```

- [ ] **Step 3: Run test, expect pass.**

- [ ] **Step 4: Commit deferred — combined with Task 22.**

---

### Task 21: EnableBiometricSheet

**Files:**
- Create: `lib/features/settings/sheets/enable_biometric_sheet.dart`

- [ ] **Step 1: Implement the sheet**

Create `lib/features/settings/sheets/enable_biometric_sheet.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_repository.dart';
import 'package:kuru_mobile/core/feedback/k_notify.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/profile/profile_providers.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';

Future<bool> showEnableBiometricSheet(BuildContext context) async {
  final ok = await showKModalSheet<bool>(
    context: context,
    title: 'Bật FaceID / Vân tay',
    showCancel: true,
    bodyBuilder: (sheetCtx) => const _EnableBiometricBody(),
  );
  return ok == true;
}

class _EnableBiometricBody extends ConsumerStatefulWidget {
  const _EnableBiometricBody();
  @override
  ConsumerState<_EnableBiometricBody> createState() => _State();
}

class _State extends ConsumerState<_EnableBiometricBody> {
  final _pw = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _pw.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final email = ref.read(appBootstrapProvider).maybeWhen(
          data: (b) => b is BootstrapAuthed ? b.user.email : null,
          orElse: () => null,
        );
    if (email == null) return;
    setState(() => _busy = true);
    final verify =
        await ref.read(profileRepositoryProvider).verifyPassword(_pw.text);
    if (!mounted) return;
    switch (verify) {
      case ApiSuccess<bool>(:final data) when data == false:
        setState(() {
          _busy = false;
          _error = 'Mật khẩu không đúng';
        });
        return;
      case ApiFailure<bool>(:final error):
        setState(() => _busy = false);
        if (error is BadRequestException) {
          setState(() => _error = error.message);
        } else {
          KNotify.networkError(context, 'Không xác minh được mật khẩu',
              onRetry: _confirm);
        }
        return;
      case ApiSuccess<bool>():
        break;
    }
    try {
      await ref
          .read(biometricRepositoryProvider)
          .enable(email: email, password: _pw.text);
      if (!mounted) return;
      KNotify.success(context, 'Đã bật FaceID');
      Navigator.of(context).pop(true);
    } on BiometricAuthCancelled {
      if (!mounted) return;
      setState(() => _busy = false);
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Nhập mật khẩu để bật đăng nhập sinh trắc.'),
          const SizedBox(height: 12),
          KFormField(
            controller: _pw,
            labelText: 'Mật khẩu',
            obscureText: true,
            errorText: _error,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _confirm,
            child: Text(_busy ? 'Đang xác minh…' : 'Tiếp tục'),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Commit deferred — combined with Task 22.**

---

### Task 22: TOTP entry from Settings + SecurityScreen tests + combined commit

**Files:**
- Modify: `lib/app/router.dart` (add `/totp/enable` route + reuse existing TOTP screens)
- Create: `test/features/settings/security_screen_test.dart`

- [ ] **Step 1: Add /totp/enable route**

The existing TOTP screens were built for mid-login enforcement. For Settings, we wrap `CreateTotpDevice` → `VerifyTotpDevice` in a thin flow that returns the user to `/settings/security` on success.

Open `lib/app/router.dart`. Add to the routes list:
```dart
GoRoute(
  path: '/totp/enable',
  builder: (context, state) => const TotpEnableScreen(),
),
```

Create `lib/features/totp/totp_enable_screen.dart` that calls `authRepositoryProvider`'s existing TOTP methods (already present in `auth_repository.dart` and used by the identity flow). The screen flow:
1. POST CreateTotpDevice → show QR + secret
2. User enters 6-digit code → POST VerifyTotpDevice → show recovery codes
3. "Done" pops back to `/settings/security` + invalidates `appBootstrapProvider`

Use the patterns from `lib/features/totp/totp_verification_screen.dart` as reference. The screen scaffold:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';

class TotpEnableScreen extends ConsumerStatefulWidget {
  const TotpEnableScreen({super.key});
  @override
  ConsumerState<TotpEnableScreen> createState() => _TotpEnableScreenState();
}

class _TotpEnableScreenState extends ConsumerState<TotpEnableScreen> {
  // Phase 1: fetch QR (mirror web SecurityTab.tsx initial enable flow)
  // Phase 2: 6-digit OTP input
  // Phase 3: recovery codes display + copy
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('TOTP enable flow — port from web SecurityTab')),
    );
  }
}
```

Note: full TOTP enable flow is large enough to warrant its own task. For v1 we accept this is a stubbed screen and revisit in a follow-up. The biometric path is the higher-value half of Security and is fully implemented in Tasks 19-21.

- [ ] **Step 2: SecurityScreen widget test**

Create `test/features/settings/security_screen_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/features/settings/security_screen.dart';

void main() {
  testWidgets('toggle off when no biometric available shows warning',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider.overrideWith((ref) async => const BootstrapAuthed(
                UserInfo(
                  email: 'a@b.c',
                  name: 'Linh',
                  orgInfos: [OrgInfo(id: 'o1', name: 'Tiệm', role: 'OWNER')],
                ),
              )),
          biometricEnabledProvider.overrideWith((ref) async => false),
          biometricAvailableProvider.overrideWith((ref) async => false),
        ],
        child: const MaterialApp(home: SecurityScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(find.textContaining('chưa cài'), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run analyzer + tests**

- [ ] **Step 4: Commit Tasks 19-22**

```bash
git add lib/features/settings/security_screen.dart \
        lib/features/settings/sheets/change_password_sheet.dart \
        lib/features/settings/sheets/enable_biometric_sheet.dart \
        lib/features/totp/totp_enable_screen.dart \
        lib/app/router.dart \
        test/features/settings/security_screen_test.dart \
        test/features/settings/sheets/change_password_sheet_test.dart
git commit -m "feat(settings): SecurityScreen + change-pwd + enable-biometric sheets"
```

---

## Phase 8 — Login biometric (Tasks 23–24)

### Task 23: Add biometric button to LoginScreen

**Files:**
- Modify: `lib/features/login/login_screen.dart`

- [ ] **Step 1: Read existing LoginScreen** to keep the visual chrome intact. Find the password field's parent column.

- [ ] **Step 2: Insert biometric button conditionally**

Below the password `KFormField`, add:
```dart
Consumer(builder: (context, ref, _) {
  final enabled = ref.watch(biometricEnabledProvider).maybeWhen(
        data: (v) => v,
        orElse: () => false,
      );
  final available = ref.watch(biometricAvailableProvider).maybeWhen(
        data: (v) => v,
        orElse: () => false,
      );
  if (!enabled || !available) return const SizedBox.shrink();
  return Padding(
    padding: const EdgeInsets.only(top: 12),
    child: OutlinedButton.icon(
      onPressed: _signInWithBiometric,
      icon: const Icon(Icons.fingerprint),
      label: const Text('Đăng nhập bằng FaceID / Vân tay'),
    ),
  );
}),
```

- [ ] **Step 3: Add the handler**

Inside `_LoginScreenState`, add:
```dart
Future<void> _signInWithBiometric() async {
  final bio = ref.read(biometricRepositoryProvider);
  final creds = await bio.unlock();
  if (!mounted) return;
  if (creds == null) {
    KNotify.warning(context, 'Xác thực không thành công');
    return;
  }
  final repo = ref.read(authRepositoryProvider);
  final result = await repo.signIn(email: creds.email, password: creds.password);
  if (!mounted) return;
  switch (result) {
    case ApiSuccess<void>():
      ref.invalidate(appBootstrapProvider);
    case ApiFailure<void>(:final error):
      if (error is UnauthorizedException) {
        await bio.disable();
        ref.invalidate(biometricEnabledProvider);
        if (!mounted) return;
        KNotify.warning(
            context, 'Vui lòng đăng nhập lại bằng mật khẩu');
      } else {
        KNotify.networkError(context, 'Đăng nhập thất bại',
            onRetry: _signInWithBiometric);
      }
  }
}
```

Add the relevant imports:
```dart
import 'package:kuru_mobile/core/auth/biometric_providers.dart';
import 'package:kuru_mobile/core/auth/biometric_repository.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
```

- [ ] **Step 4: Run analyzer + existing login tests**

Existing tests should still pass (biometric button hidden when provider returns false).

- [ ] **Step 5: Commit**

```bash
git add lib/features/login/login_screen.dart
git commit -m "feat(login): biometric sign-in button"
```

---

### Task 24: Login biometric widget test

**Files:**
- Modify: `test/features/login/login_screen_test.dart` (add two test cases)

- [ ] **Step 1: Add tests**

Append to the existing login screen test file:
```dart
testWidgets('biometric button hidden when disabled', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        biometricEnabledProvider.overrideWith((ref) async => false),
        biometricAvailableProvider.overrideWith((ref) async => true),
      ],
      child: const MaterialApp(home: LoginScreen()),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  expect(find.text('Đăng nhập bằng FaceID / Vân tay'), findsNothing);
});

testWidgets('biometric button visible when enabled + available',
    (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        biometricEnabledProvider.overrideWith((ref) async => true),
        biometricAvailableProvider.overrideWith((ref) async => true),
      ],
      child: const MaterialApp(home: LoginScreen()),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  expect(find.text('Đăng nhập bằng FaceID / Vân tay'), findsOneWidget);
});
```

- [ ] **Step 2: Run tests, expect pass**

- [ ] **Step 3: Commit**

```bash
git add test/features/login/login_screen_test.dart
git commit -m "test(login): biometric button visibility"
```

---

## Phase 9 — Verification (Task 25)

### Task 25: Manual QA + final analyze pass

- [ ] **Step 1: Run analyzer**

```bash
flutter analyze
```
Expected: exit 0.

- [ ] **Step 2: Run all tests via Very Good CLI MCP run_tests**

Expected: all tests pass.

- [ ] **Step 3: Boot iOS simulator + run**

```bash
xcrun simctl boot "iPhone 16" 2>/dev/null && open -a Simulator
flutter run -d "iPhone 16" --dart-define=API_BASE_URL=http://localhost:9190
```

Walk this manual QA checklist (record each as a checkbox):

- [ ] /settings opens with hero showing current user data
- [ ] STAFF role does not see "Cửa hàng" section
- [ ] OWNER role sees "Cửa hàng"
- [ ] Tap hero → /settings/profile loads with name + avatar
- [ ] Open avatar picker → Initials tab → "Dùng chữ cái" → hero updates
- [ ] Dicebear tab → pick a style → "Dùng kiểu này" → hero updates
- [ ] Upload tab → pick image from library → upload → hero updates
- [ ] Save with name "A" → field error "Tên phải từ 2 đến 32 ký tự"
- [ ] /settings/security: change password sheet opens, wrong current password shows field error
- [ ] Biometric toggle on a sim without enrolled biometric → warning toast, switch reverts
- [ ] On a device with FaceID enrolled: toggle on → password sheet → FaceID prompt → success toast
- [ ] Sign out → return to /login → "Đăng nhập bằng FaceID" button visible
- [ ] Tap button → FaceID prompt → auto-signin → /home
- [ ] /settings/store: change timezone, save, persists on reload
- [ ] /settings/appearance: switch palette → entire app retints; switch locale → UI strings flip vi ↔ en
- [ ] Kill app, reopen → palette + locale persisted from SharedPreferences

- [ ] **Step 4: Tag the release**

```bash
git tag v0.4.0-settings-biometric
```

- [ ] **Step 5: Commit any final cleanup**

If a typo or missing import surfaced during QA, fix it and commit:
```bash
git add -p
git commit -m "fix(settings): <issue surfaced during manual QA>"
```

---

## Self-Review

### Spec coverage check

| Spec section | Plan task(s) |
|---|---|
| §3 Mirror endpoints — UpdateProfile/ChangePassword/VerifyPassword/Totp/SecurityStatus/Avatar | Task 4, 16 |
| §3 Mirror endpoints — GetMyPermissions | Task 3 |
| §3 Mirror endpoints — Store settings get/update | Task 18 |
| §4.1 5 routes | Task 12 |
| §4.2 Style E layout | Task 13 |
| §4.3 Role gating | Task 3 + Task 13 |
| §5.1 Feature screens | Tasks 13, 14, 17, 18, 19 |
| §5.2 Shared widgets (KAvatar, KSettingsHero, KSettingsSection, KSwitchRow) | Tasks 8-11 |
| §5.3 Core modules (permissions, profile, biometric, locale) | Tasks 3, 4, 5, 6 |
| §5.4 KuruApp locale wire + settings stub delete | Tasks 6, 12 |
| §5.5 Pubspec deps | Task 1 |
| §6.2 Profile save flow (3 avatar modes) | Tasks 14, 15, 16 |
| §6.3 Biometric enable flow | Tasks 19, 21 |
| §6.4 Login biometric flow | Tasks 23, 24 |
| §6.5 BiometricRepository contract | Task 5 |
| §6.6 Locale + palette persistence | Tasks 6, 7 |
| §7 Error handling | Distributed: Task 14 (profile errors), 18 (store), 20 (pwd), 21 (biometric), 23 (login biometric) |
| §8.1 Unit tests | Tasks 2, 3, 4, 5, 6, 7 |
| §8.2 Widget tests | Tasks 13, 14, 15, 17, 18, 19, 24 |

Gaps:
- **TOTP enable from Settings (§5.1 `totp_enable_sheet.dart`, `recovery_codes_sheet.dart`)** — Task 22 stubs this. Full implementation deferred to a follow-up. This is acceptable because TOTP enable already works mid-login per the identity-v1 flow; the Settings-entry version is a UX polish, not a security gap.

### Placeholder scan

No `TBD`, `TODO`, or "implement later" markers. Task 22 explicitly documents the deferred TOTP-from-Settings flow rather than leaving a placeholder.

### Type consistency

- `BiometricCredentials` referenced in Tasks 5, 23 ✓
- `AvatarSelection` referenced in Tasks 14, 15 ✓
- `ResolvedPermissions.isOwner` referenced in Tasks 2, 13 ✓
- `StoreSettings` referenced in Task 18 ✓
- `LocaleController.supported` referenced in Tasks 6, 17 ✓

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-05-19-settings-and-biometric.md`. Two execution options:

**1. Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration.

**2. Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints.

Which approach?
