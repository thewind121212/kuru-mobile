# kuru-mobile

Flutter identity flow demo for a multi-tenant retail / inventory platform. Portfolio-style learning project; the backend is a separate private repo using SuperTokens for auth + REST API for everything else.

If you're a new Claude session: read this whole file first. It captures the conventions, recurring gotchas, and where to look for ground truth.

## Stack (already wired)

- Flutter 3.41.9, Dart 3.11
- **Riverpod** — `flutter_riverpod` + `riverpod_annotation`
- **dio** + **supertokens_flutter** (header-mode session, pinned to master git ref because pub.dev's 0.6.3 caps Dart at `<3.9.0` — `pubspec.yaml` has the reason in a comment)
- **go_router** with auth-state redirect (`lib/app/router.dart`)
- **freezed** + **json_serializable** for models
- **flutter_localizations** + `gen_l10n` — `vi` canonical, `en` mirror. `l10n.yaml` lives at the **project root**, not under `lib/`.
- **toastification** for non-error toasts; SnackBars for retriable errors — accessed via `KNotify` (`lib/core/feedback/k_notify.dart`)
- Custom theme — `KuruColors` extension, 4 palettes (`purple` / `indigo`, light / dark), **default = `indigo`**

## Identity flow (shipped, tag `v0.2.0-identity-full` + several follow-up commits)

```
[cold start] → Splash → bootstrap (POST /api/v1/profile/GetUserInfo)
                  ├─ no session           → /onboarding (first launch) or /login
                  ├─ session + totpEnabled → /totp (or /totp/recovery)
                  ├─ session + 0 orgs     → /create-org
                  ├─ session + 2+ orgs    → /org-picker
                  └─ session + 1 org      → /home (stub)
```

Routes are locked down by `lib/app/router.dart`'s redirect — users on /totp can't bounce to /home until they verify; users with 0 orgs can't reach /home; etc.

Each screen is in `lib/features/<feature>/`. Auth chrome (`AuthBackdrop`, `AuthLogo`) lives in `lib/design/auth/`.

## Backend contract — read this when adding endpoints

Every kuru BE route uses one wire shape (see `be/core/utils/error-response.ts`):

```jsonc
// success — HTTP 200 or 201
{ "success": true,  "data": {...}, "timestamp": "..." }

// error — HTTP 400 / 401 / 403 / 404 / 429 / 5xx
{ "success": false, "error": { "message": "<user-readable>", "code": "..." }, "timestamp": "..." }
```

- `error.message` is **user-readable** for 4xx → surface verbatim in the UI.
- For 5xx, replace with a localized fallback ("Đã có lỗi xảy ra").
- 400 = validation / business error.
- 401 = session invalid → force `signOut()` + redirect to /login.
- 429 + `code: "RATE_LIMITED"` = back-off toast.
- 500 with `"Session does not exist"` in body = same as 401 — BE bug. Mobile mitigation already lives in `AuthRepository._interpretMfaError`.

### Source-of-truth ordering when adding an endpoint

**The openapi spec in `../gen-barcode/openapi/<module>.openapi.json` is unreliable.** It's generated from proto but doesn't always stay in sync. When openapi disagrees with the actual handler, the handler wins.

Always read these in order:

1. `../gen-barcode/be/core/dto/<module>/<thing>.dto.ts` — Zod validation rules + exact rejection messages
2. `../gen-barcode/be/core/api/<module>/<module>.routes.ts` (or `core/domains/<domain>/api/<thing>.route.ts`) — the actual handler
3. `../gen-barcode/be/types/<module>.d.ts` — the generated TS response type
4. `../gen-barcode/be/core/services/<module>.service.ts` — what `resData` actually contains
5. THEN cross-check against `openapi/<module>.openapi.json` if curious — but don't trust it alone

**Real burns we've hit:**

- `openapi/store.openapi.json` says CreateStore returns `{ storeId }`. The actual TS type `CreateStoreResponse` in `be/types/store.d.ts` returns **`{ orgId }`**. Trust the .d.ts.
- CreateStore returns HTTP **201** (not 200). dio treats it as success, but our parser must handle both.
- `/auth/*` routes live at host **root**, `/api/v1/*` are mounted under `/api/v1`. dio's baseUrl is the host root; each call writes its own prefix.
- VerifyTotpCode + UseRecoveryCode return **HTTP 400** for wrong codes (not `200 + verified:false`). Web FE treats any error during verify as wrong code; mobile mirrors that in `AuthRepository._interpretMfaError`.

## UX patterns (use these instead of reinventing)

| Need | Pattern |
|---|---|
| Field validation error (wrong password, invalid email, taken email) | `KFormField.errorText: '...'` — red field border + reserved animated slot under the field; no layout shift |
| Network down / 5xx | `KNotify.networkError(context, msg, onRetry: _submit)` — bottom SnackBar with retry action |
| Success after save / sign-out | `KNotify.success(context, msg)` — top-right auto-dismissing toast |
| Info / sync status | `KNotify.info(context, msg)` |
| Rate-limited warning | `KNotify.warning(context, msg)` |
| 401 / session expired mid-flow | Show toast then call `signOut()` + invalidate bootstrap — router routes to /login |

Toasts are deliberately **not** used for errors (auto-dismiss before user can read them).

## Multi-tenant `x-org-id` header

Every authenticated REST call (i.e. `/api/v1/*` except bootstrap routes) must carry `x-org-id: <orgId>`. The dio interceptor in `lib/core/network/dio_client.dart` attaches this automatically from `currentOrgIdProvider`. After CreateStore or OrgPicker, set the provider **synchronously before invalidating bootstrap** so the next request isn't racing with the microtask in `appBootstrapProvider`:

```dart
ref.read(currentOrgIdProvider.notifier).orgId = newOrgId;
ref.invalidate(appBootstrapProvider);
```

## Project layout

```
lib/
├── app/                — KuruApp + router + theme (4 palettes)
├── core/
│   ├── auth/           — AuthRepository, providers, BootstrapResult sealed class,
│   │                     OnboardingSeenController, UserInfo + OrgInfo (freezed)
│   ├── env/            — API_BASE_URL via --dart-define
│   ├── feedback/       — KNotify (toastification + SnackBar)
│   ├── i18n/           — l10n.yaml at project ROOT; vi/en ARB files here
│   ├── logging/        — single `log` instance via package:logger
│   ├── network/        — dio_client (org-id + logging + error-mapping interceptors)
│   │                     + sealed ApiResult<T> + typed ApiException hierarchy
│   └── validators/     — isValidEmail (TDD, WHATWG HTML5 regex)
├── design/
│   ├── auth/           — AuthBackdrop (3 drifting orbs), AuthLogo (glow + sparkles)
│   └── widgets/        — KGlass, KPrimaryBtn (with shine), KFormField (errorText slot),
│                         KCheckbox, KStepDots (tappable), KOtpInput (6 boxes)
└── features/
    ├── splash/         — SplashScreen, triggers appBootstrapProvider
    ├── onboarding/     — 6-step PageView; back/tap-to-jump dots; illustrations under illustrations/
    ├── login/          — LoginScreen (long-press logo in debug to replay onboarding)
    ├── register/       — RegisterScreen + password strength meter (TDD)
    ├── totp/           — TotpVerificationScreen + RecoveryCodeScreen
    ├── create_org/     — CreateOrgScreen + animated StoreIllustration (cascading boxes)
    ├── org_picker/     — OrgPickerScreen + OrgCard
    └── home/           — HomeStubScreen (placeholder until Catalog v1)
```

## Run

```bash
# kuru BE in one terminal:
cd ../gen-barcode && task fullstack

# mobile in another:
xcrun simctl boot "iPhone 16" 2>/dev/null && open -a Simulator
flutter run -d "iPhone 16" --dart-define=API_BASE_URL=http://localhost:9190
```

Hot reload: `r` in the flutter run terminal. Hot restart: `R`. Quit: `q`.

To replay onboarding mid-session: long-press the kuru logo on the Login screen (debug-only via `kDebugMode` guard).

To force a fresh start (wipes onboarding-seen flag + session): `xcrun simctl uninstall booted com.kuru.kuruMobile`.

## Tests

```bash
flutter test          # ~49 tests (theme + ApiResult + email validator + auth-repo + smoke tests)
flutter analyze --fatal-warnings   # CI runs this — info-level lints fail the build, keep it clean.
```

Widget tests that include `KPrimaryBtn` **cannot use `pumpAndSettle()`** — the shine animation never settles. Use `pump()` × 2 instead.

For widget tests of authed screens, override `appBootstrapProvider`:

```dart
ProviderScope(
  overrides: [
    appBootstrapProvider.overrideWith((_) async => const BootstrapAuthed(user)),
  ],
  child: ...
)
```

## Specs & plans (history)

- `docs/superpowers/specs/2026-05-15-identity-v1-design.md` — full identity design
- `docs/superpowers/plans/2026-05-15-identity-mvp-login.md` — Plan 1 (Splash + Login + HomeStub) — tag `v0.1.0-identity-mvp`
- `docs/superpowers/plans/2026-05-16-identity-full.md` — Plan 2 (Onboarding + Register + CreateOrg + OrgPicker) — tag `v0.2.0-identity-full`

After `v0.2.0-identity-full` (no separate plan docs, single-commit fixes / polish):
- **Indigo default theme** + 3 more onboarding steps (Payment / Multi-store / Customer) + clickable dots + back button + dropped Remember-me
- **KNotify** (`toastification` + SnackBar wrapper) with the layered pattern
- **Email validator** (TDD, WHATWG regex) wired into Login + Register
- **TOTP + recovery code** flow mirroring kuru web's `Auth.tsx` + `mfa.store.ts`
- **CreateStore canonical body** `{ orgName, firstStoreName? }` + reading `orgId` from response

## Future work (not yet specced)

- **Catalog v1** — Brand + Category CRUD. First task should be wiring `openapi_generator_cli` against `../gen-barcode/openapi/*.openapi.json` so we stop hand-rolling endpoint clients.
- **Passkey login** — kuru BE supports it (`be/core/domains/profile/api/passkey-auth.route.ts`) but mobile needs:
  - The `passkeys` Flutter package (Corbado)
  - BE-served `.well-known/apple-app-site-association` + `assetlinks.json` on a real HTTPS staging host
  - Associated Domains entitlement (iOS) + signing config (Android)
  Defer until BE devops provides the staging domain.
- **Settings screen** — palette picker (purple ↔ indigo) + locale picker (vi ↔ en). Infrastructure already there; just needs UI.
- **Real Home screen** — replace HomeStubScreen with the design's Overview (KPIs, quick actions, alerts).

## When something breaks

The dio logging interceptor prints every request + response status to the `flutter run` console:

```
→ POST http://localhost:9190/api/v1/profile/GetUserInfo
← 200 http://localhost:9190/api/v1/profile/GetUserInfo
```

For BE requests that look successful but mobile shows an error, AuthRepository methods log the parsed payload (e.g. `CreateStore ← 201 body={...}` + `CreateStore success orgId=...`). Add the same pattern to new endpoints during development.
