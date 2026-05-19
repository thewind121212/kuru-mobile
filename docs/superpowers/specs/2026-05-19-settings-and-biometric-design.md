# Settings v1 + Biometric Login — Design Spec

**Date:** 2026-05-19
**Status:** Approved (pending implementation plan)
**Target tag candidate:** `v0.4.0-settings-biometric`
**Mirrors:** kuru-web `fe/src/components/settings-module/` (Profile + Security + Store tabs only; Members + Payment deferred to v1.1)

---

## 1. Goal

Replace the current `SettingsStubScreen` with a real Settings module covering:

- **Profile** — display name + avatar (initials / dicebear / upload)
- **Security** — change password, TOTP enable/disable + recovery codes, biometric login (FaceID / Touch ID / Android fingerprint)
- **Store** — timezone (OWNER-only)
- **Appearance** — theme palette + locale (mobile-only persistence)

Plus enable **biometric sign-in on the Login screen** so returning users can unlock with FaceID / fingerprint instead of typing their password.

Members + Payment tabs from the web Settings module are intentionally deferred to v1.1; the design must not block adding them later.

---

## 2. Non-goals

- **Members management** (invite / role assignment / revoke). Defer to v1.1.
- **Payment / VietQR configuration**. Defer to v1.1.
- **Passkey (WebAuthn) login**. CLAUDE.md flags this as blocked on BE staging domain + AASA/assetlinks. The biometric repository is designed so passkey can replace stored-password later without UI churn.
- **Profile dicebear style picker parity with web** (12 styles). v1 ships with a curated subset of 4–6 styles. The full picker is a v1.1 nice-to-have.
- **Avatar cropping**. v1 takes the image as-is from `image_picker`; BE optimization worker handles resize.

---

## 3. Source-of-truth mirror

Every BE endpoint used in this module is already consumed by kuru-web. We mirror the request shape from the web client; we never invent new BE contracts.

| Flow                       | Endpoint                                          | Web consumer                                |
|----------------------------|---------------------------------------------------|---------------------------------------------|
| Load user                  | `POST /api/v1/profile/GetUserInfo`                | `services/profile/useQuery.ts`              |
| Save name / dicebear       | `POST /api/v1/profile/UpdateProfile`              | `components/settings-module/MainSettings.tsx:142` |
| Upload avatar (multipart)  | `POST /api/v1/store/UploadUserAvatar`             | `services/file/api.ts:108`                  |
| Change password            | `POST /api/v1/profile/ChangePassword`             | `components/settings-module/SecurityTab.tsx` |
| Verify password            | `POST /api/v1/profile/VerifyPassword`             | `components/settings-module/SecurityTab.tsx` (mirrored for biometric-enable step) |
| TOTP status                | `POST /api/v1/profile/GetSecurityStatus`          | `SecurityTab.tsx`                           |
| TOTP enable start          | `POST /api/v1/profile/CreateTotpDevice`           | already wired in mobile (identity v1)       |
| TOTP enable verify         | `POST /api/v1/profile/VerifyTotpDevice`           | already wired                               |
| TOTP disable               | `POST /api/v1/profile/DisableTotp`                | `SecurityTab.tsx`                           |
| Regenerate recovery codes  | `POST /api/v1/profile/RegenerateRecoveryCodes`    | `SecurityTab.tsx`                           |
| Read store settings        | `POST /api/v1/store/GetStoreSettings`             | `StoreTab.tsx`                              |
| Update store settings      | `POST /api/v1/store/UpdateStoreSettings`          | `StoreTab.tsx`                              |
| Role gating                | `GET  /api/v1/store/GetMyPermissions`             | `services/permission/useQuery.ts`           |

No new BE work. Mobile-only state: SharedPreferences (locale, palette) + flutter_secure_storage (biometric credentials).

---

## 4. Information architecture

### 4.1 Routes

```
/settings                      → SettingsHomeScreen   (hero + grouped sections)
/settings/profile              → ProfileScreen        (avatar + display name)
/settings/security             → SecurityScreen       (password / TOTP / biometric)
/settings/store                → StoreScreen          (timezone) — OWNER-only
/settings/appearance           → AppearanceScreen     (palette + locale)
```

All five routes live under the authed shell prefix (already configured in `lib/app/router.dart:174`).

### 4.2 Settings home layout (style E "compact")

- **Hero card** — gradient indigo background, avatar (initials | dicebear | uploaded), display name, email, org chip with `{storeName} · {roleLabel}`, trailing chevron. Tapping anywhere on the hero pushes `/settings/profile`.
- **Section "Bảo mật"** (all roles): Đổi mật khẩu · Xác thực 2 lớp · FaceID / Vân tay (inline switch).
- **Section "Cửa hàng"** (OWNER only, hidden otherwise): Múi giờ.
- **Section "Giao diện"** (all roles): Màu chủ đề · Ngôn ngữ.
- **Bottom destructive group**: Đăng xuất (red label, rose icon tint).

Visual reference (variant **E** "compact"): 10px row padding · 24px icon squares · sectioned grouped cards · 8 desaturated icon tints from the kuru indigo palette (`#eef0ff/#4f46e5` indigo · `#d6f5ee/#0d9488` teal · `#fef3c7/#b45309` amber · `#ffe4e6/#be123c` rose · `#e2e8f0/#475569` slate · `#d1fae5/#047857` emerald · `#ede9fe/#6d28d9` violet · `#e0f2fe/#0369a1` sky) · `linear-gradient(135deg, #6366f1, #4f46e5)` hero card · inline `Switch` for biometric · destructive sign-out in its own bottom group.

### 4.3 Role gating

- Source: `GET /api/v1/store/GetMyPermissions` cached in `myPermissionsProvider` (Riverpod `FutureProvider`, keyed implicitly by `currentOrgIdProvider`; refetched on org switch via `ref.invalidate`).
- Rule: `orgRole == "OWNER"` shows the Store section. Profile + Security + Appearance always shown.
- Failure mode: if `myPermissionsProvider` errors, the home screen renders only the always-visible sections plus a small "Tải lại quyền" retry chip at the bottom. The user is never blocked from Profile / Security / Appearance because the permissions call failed.

---

## 5. Component inventory

### 5.1 New feature screens — `lib/features/settings/`

```
settings_home_screen.dart
profile_screen.dart
security_screen.dart
store_screen.dart
appearance_screen.dart
sheets/
  change_password_sheet.dart       — KModalSheet, 3 password fields
  enable_biometric_sheet.dart      — verify password → arm biometric
  avatar_picker_sheet.dart         — tabs: Chữ cái / Dicebear / Tải lên
  timezone_picker_sheet.dart       — searchable list (port web tzdb data)
  totp_enable_sheet.dart           — wraps existing TOTP flow for in-settings use
  recovery_codes_sheet.dart        — display + copy + regenerate
```

### 5.2 New shared widgets — `lib/design/core/`

```
catalog/k_avatar.dart              — circle avatar dispatch: initials | dicebear | uploaded URL
layout/k_settings_hero.dart        — gradient hero card (consumes BootstrapAuthed user)
layout/k_settings_section.dart     — uppercase section header + grouped KListRow container
input/k_switch_row.dart            — KListRow + trailing Material Switch (biometric, future toggles)
```

`KAvatar` chooses its render mode by inspecting `UserInfo.avatarStyle`:
- `null` or empty → initials from `name`
- `"upload"` → fetch from `avatarUrl` (signed URL returned by BE)
- any other string → dicebear URL constructed client-side from `avatarStyle` + `avatarSeed`
- fallback when BE returns `googleAvatarUrl` and no override → use the Google URL

### 5.3 New core modules

```
lib/core/auth/
  biometric_repository.dart        — wraps local_auth + flutter_secure_storage
  biometric_providers.dart         — biometricEnabledProvider, biometricAvailableProvider, biometricRepoProvider

lib/core/permissions/
  permissions_repository.dart      — calls GetMyPermissions
  permissions_providers.dart       — myPermissionsProvider (FutureProvider)
  resolved_permissions.dart        — freezed: { orgRole, orgPerms, perStore }

lib/core/profile/
  profile_repository.dart          — UpdateProfile, UploadUserAvatar, ChangePassword wrappers
  profile_providers.dart           — profileRepoProvider

lib/core/i18n/
  locale_controller.dart           — Notifier<Locale> persisted to SharedPreferences
```

### 5.4 Existing files modified

```
lib/app/kuru_app.dart                              — read locale from localeControllerProvider (drop hardcoded vi)
lib/app/router.dart                                — register 5 settings routes; redirect /settings/store → /settings when orgRole != OWNER
lib/features/login/login_screen.dart               — add "Đăng nhập bằng FaceID" button under password field, gated by biometricEnabledProvider + biometricAvailableProvider
lib/features/settings/settings_stub_screen.dart    — DELETE
test/features/settings/settings_stub_screen_test.dart — DELETE
pubspec.yaml                                       — add local_auth, flutter_secure_storage, image_picker
```

### 5.5 New dependencies (`pubspec.yaml`)

```yaml
local_auth: ^2.3.0
flutter_secure_storage: ^9.2.2
image_picker: ^1.1.2
```

Native plugin reminder from CLAUDE.md: after adding these, run `flutter clean && flutter pub get && cd ios && pod install && cd ..` before the next `flutter run`. Hot-reload and hot-restart will not pick up new native code.

---

## 6. Data flow

### 6.1 Settings home build

```
SettingsHomeScreen.build
 ├─ watch(appBootstrapProvider) → BootstrapAuthed(user)        → hero card
 ├─ watch(myPermissionsProvider) → ResolvedPermissions or err  → gates Store section
 └─ watch(biometricEnabledProvider) → bool                     → biometric row "Bật" / "Tắt" label
```

### 6.2 Profile save

```
User taps Save (in ProfileScreen)
 ├─ validate displayName (2–32 chars; KFormField field-error on fail)
 ├─ if avatar mode == upload AND a new file is staged:
 │    POST /api/v1/store/UploadUserAvatar  (multipart, field name "avatar", x-org-id header)
 │      → BE sets avatar_style="upload" + avatar_url=<key> in user metadata
 ├─ else if avatar mode == dicebear:
 │    POST /api/v1/profile/UpdateProfile { name, avatarStyle, avatarSeed }
 ├─ else (initials):
 │    POST /api/v1/profile/UpdateProfile { name, avatarStyle: null, avatarSeed: null }
 └─ on success: KNotify.success + ref.invalidate(appBootstrapProvider) → hero refreshes
```

Note: ordering matters. Upload happens first because the upload route writes the avatar metadata server-side; calling UpdateProfile after would overwrite it. If the user changed both the display name and uploaded a new image, the upload call is sufficient — but we still issue `UpdateProfile { name }` afterwards if `name` changed (BE upload route does not touch `name`).

### 6.3 Biometric enable

```
User flips biometric switch ON in SecurityScreen
 ├─ if biometricAvailableProvider == false:
 │    KNotify.warning("Thiết bị chưa cài FaceID hoặc vân tay") + revert switch
 ├─ open enable_biometric_sheet (KModalSheet)
 │   ├─ field: current password (KFormField, obscure)
 │   └─ Confirm button
 ├─ on Confirm:
 │   ├─ POST /api/v1/profile/VerifyPassword { password }
 │   ├─ if 400 wrong password → KFormField errorText, keep sheet open
 │   ├─ if verified=true → biometricRepo.enable(currentEmail, password)
 │   │     1. await LocalAuthentication.authenticate(localizedReason: "Bật FaceID")
 │   │     2. on success → FlutterSecureStorage.write("biometric_email", email)
 │   │                  + FlutterSecureStorage.write("biometric_password", password)
 │   │     3. on local_auth cancel/fail → throw BiometricAuthCancelled
 │   ├─ on success: ref.invalidate(biometricEnabledProvider) + KNotify.success("Đã bật FaceID")
 │   └─ on BiometricAuthCancelled: close sheet, revert switch, no error toast
 └─ user can later disable via the same row: tap switch off → biometricRepo.disable() → secure storage wiped
```

### 6.4 Biometric login (LoginScreen)

```
LoginScreen.build
 ├─ enabled = biometricEnabledProvider.maybeWhen(data: (v) => v, orElse: () => false)
 ├─ available = biometricAvailableProvider.maybeWhen(data: (v) => v, orElse: () => false)
 └─ if enabled && available: show "Đăng nhập bằng FaceID" KPrimaryBtn under password field

User taps button
 ├─ creds = await biometricRepo.unlock()
 │     1. await LocalAuthentication.authenticate(localizedReason: "Đăng nhập")
 │     2. on success → read both keys → return (email, password)
 │     3. on fail → return null
 ├─ if creds == null: KNotify.warning("Xác thực không thành công"); user types password
 └─ await authRepo.signIn(creds.email, creds.password)
     ├─ 200 → ref.invalidate(appBootstrapProvider) → router routes by BootstrapResult
     └─ 401 (stored creds invalid — password changed elsewhere):
          await biometricRepo.disable() (wipe Keychain)
          KNotify.warning("Vui lòng đăng nhập lại bằng mật khẩu")
```

### 6.5 BiometricRepository contract

```dart
class BiometricRepository {
  Future<bool> canCheckBiometrics();
  Future<bool> isEnabled();
  Future<void> enable(String email, String password);
  Future<void> disable();
  Future<({String email, String password})?> unlock();
}
```

Implementation backs `enable` / `unlock` with `LocalAuthentication.authenticate` and persists the credentials via `FlutterSecureStorage` (iOS Keychain; Android EncryptedSharedPreferences with AndroidOptions(encryptedSharedPreferences: true)). The "is enabled" check is the presence of `biometric_email` in secure storage.

### 6.6 Locale + palette persistence

```
LocaleController build:
  return Locale(sharedPrefs.getString("locale") ?? "vi");

LocaleController.setLocale(Locale loc):
  await sharedPrefs.setString("locale", loc.languageCode);
  state = loc;

KuruApp build:
  final locale = ref.watch(localeControllerProvider);
  return MaterialApp.router(locale: locale, ...);
```

Theme palette uses the same pattern (`paletteControllerProvider` already exists per `lib/app/theme/theme_controller.dart:7`; spec only adds SharedPreferences persistence to the existing controller — it currently lives in-memory).

---

## 7. Error handling

BE error contract (CLAUDE.md): all routes return `{success:false, error:{message, code}}` on 4xx. Mobile shows `error.message` verbatim for 4xx; localized fallback ("Đã có lỗi xảy ra") for 5xx.

| Flow                                  | Failure                                              | UX                                                                                    |
|---------------------------------------|------------------------------------------------------|---------------------------------------------------------------------------------------|
| Save profile                          | 400 invalid name                                     | `KFormField.errorText` under display-name field                                       |
| Save profile                          | 5xx / network                                        | `KNotify.networkError(onRetry: _save)` SnackBar                                       |
| Upload avatar                         | 400 too large / wrong type                           | `KNotify.warning("Ảnh phải dưới 5MB, định dạng PNG/JPG")`                              |
| Upload avatar                         | Network                                              | Retry SnackBar; keep local preview                                                    |
| Change password                       | 400 wrong current pwd                                | Field error under "Mật khẩu hiện tại"                                                 |
| Change password                       | 400 weak new pwd                                     | Field error under "Mật khẩu mới"                                                       |
| Change password                       | 401                                                  | Toast → `signOut()` → /login                                                          |
| Verify password (biometric enable)    | 400 wrong                                            | Field error in sheet, sheet stays open                                                |
| Enable biometric                      | local_auth cancelled by user                         | Close sheet, revert switch, no error toast                                            |
| Enable biometric                      | No biometric enrolled on device                      | `KNotify.warning("Thiết bị chưa cài FaceID hoặc vân tay")`, switch stays off          |
| Login via biometric                   | local_auth failed                                    | `KNotify.warning("Xác thực không thành công")`; user types password                   |
| Login via biometric                   | 401 from signIn (stored creds stale)                 | Wipe Keychain via `biometricRepo.disable()`; toast "Vui lòng đăng nhập lại bằng mật khẩu" |
| GetMyPermissions                      | Network                                              | Hide gated sections (Store); show inline "Tải lại quyền" retry chip in Settings home   |
| GetMyPermissions                      | 403                                                  | Treat as no permissions (hide Store)                                                  |
| UpdateStoreSettings                   | 400 invalid timezone                                 | Field error in picker sheet                                                           |
| Locale / palette change               | n/a (local-only)                                     | Never fails                                                                           |
| 429 on ChangePassword / VerifyPassword | rate-limited                                       | Toast warning with `error.message` verbatim                                           |

### 7.1 Why password (not refresh token) for biometric

The `supertokens_flutter` SDK does not expose the refresh-token API in the public surface; using it would require a fork or patching SuperTokens. Storing the password inside Keychain / Keystore + a biometric gate is the standard mobile pattern for SuperTokens header-mode sessions and matches the threat model used by major Vietnamese banking apps (Vietcombank, Techcombank, MBBank). Migration path: when BE staging supplies the AASA + assetlinks files, swap `BiometricRepository.unlock` from "decrypt password and replay signIn" to "WebAuthn assertion via `StartPasskeyLogin` / `FinishPasskeyLogin`" — the public repository interface stays identical, so neither the LoginScreen nor SettingsScreen need to change.

---

## 8. Testing

### 8.1 Unit tests (`test/core/`)

```
biometric_repository_test.dart
  - enable() writes email + password keys after local_auth success
  - enable() skips writes when local_auth.authenticate throws
  - unlock() returns null on local_auth failure
  - disable() wipes both keys
  - mocks: LocalAuthentication + FlutterSecureStorage via mocktail

permissions_repository_test.dart
  - getMyPermissions parses { orgRole, orgPerms[], perStore[] }
  - 401 → throws UnauthorizedException
  - 5xx → throws KuruApiException with fallback message

profile_repository_test.dart
  - UpdateProfile 200 / 400 / 401
  - UploadUserAvatar multipart payload shape; 5MB guard
  - ChangePassword 200 / 400 / 429

locale_controller_test.dart
  - build() reads SharedPreferences default 'vi'
  - setLocale persists + updates state
```

### 8.2 Widget tests (`test/features/settings/`)

```
settings_home_screen_test.dart
  - STAFF: hero + 3 sections (no Store)
  - OWNER: hero + 4 sections
  - Tap hero → pushes /settings/profile
  - Permissions error → retry chip visible

profile_screen_test.dart
  - Name validation 2–32 chars
  - Avatar mode switching (initials ↔ dicebear ↔ upload preview)
  - Save invokes the right endpoint per mode

security_screen_test.dart
  - Change-password row opens KModalSheet
  - Wrong current pwd → field error, sheet stays open
  - Biometric toggle on a device without biometric → warning toast + revert
  - Biometric enable: sheet → verify pwd → switch flips on

appearance_screen_test.dart
  - Palette grid selection invalidates themeControllerProvider
  - Locale selection persists + updates localeControllerProvider

store_screen_test.dart
  - Timezone picker sheet opens, search filters list
  - Save calls UpdateStoreSettings with the selected tz

login_screen_test.dart (modified existing)
  - Biometric button hidden when biometricEnabledProvider == false
  - Biometric button visible when enabled + device supports
  - Tap → success path invalidates appBootstrapProvider
  - Tap → stored creds invalid (401) → wipes Keychain + toast
```

### 8.3 Animation pitfalls (CLAUDE.md)

Tests that include `KSpinner`, `KPrimaryBtn`, or `KSkeleton` cannot use `pumpAndSettle()` — the animations never settle. Use `pump()` + `pump(Duration(milliseconds: 50))` to step microtasks. The same applies inside `KModalSheet` confirm flows where a brief spinner appears during the awaited `onConfirm`.

### 8.4 Deferred from v1 tests

- `local_auth` platform plugin path (needs a real device or integration test harness). Manual QA on iOS sim + Android emulator only for v1.
- `image_picker` UI selection. Manual QA covers it.

### 8.5 Coverage target

Existing repo has 136 tests. Settings v1 adds ~40 tests. CI gate: `flutter analyze` exit 0 + `flutter test` green.

---

## 9. Implementation order (preview — real plan comes from `writing-plans`)

1. Foundation: pubspec deps + `BiometricRepository` + `PermissionsRepository` + `ProfileRepository` + `LocaleController`
2. Shared widgets: `KAvatar`, `KSettingsHero`, `KSettingsSection`, `KSwitchRow`
3. SettingsHomeScreen (replaces stub) + router wiring
4. Sub-screens: Profile → Appearance → Store → Security (in that order; Security depends on biometric repo)
5. Biometric integration on LoginScreen
6. End-to-end test pass + manual QA on iOS sim + Android emu

---

## 10. Open questions for the implementation plan

These do not block the spec but should be answered before code:

- Curated dicebear style subset for v1: which 4–6 styles? (Web ships 12.) Suggestion: `fun-emoji`, `lorelei-line`, `miniavs`, `open-peeps`, `thumbs`.
- Avatar upload preview crop policy: square-clip the picked image in-app, or let BE worker handle resize unchanged? Suggestion: square-clip client-side via `image_picker`'s `imageQuality` + simple `BoxFit.cover` preview, no manual crop UI.
- Timezone picker source: port `@vvo/tzdb` to a Dart asset, or read the device's `DateTime.now().timeZoneName` plus a hand-curated VN-first list? Suggestion: hand-curated VN-first list of ~20 zones; "More…" expands to the full IANA set lazily.
- Recovery codes copy-all UX: native share sheet vs. clipboard toast? Suggestion: clipboard toast (matches kuru-web).

These will be resolved in the implementation plan's first phase.
