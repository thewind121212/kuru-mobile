# kuru-mobile

Flutter mobile companion app for **kuru** (codebase `gen-barcode`) — a multi-tenant retail / inventory management platform. The backend + web FE live at `../gen-barcode/`.

## Stack (already wired)

- Flutter 3.41.9, Dart 3.11
- **Riverpod** (state + DI) — `flutter_riverpod` + `riverpod_annotation`
- **dio** (HTTP) + **supertokens_flutter** (header-mode session)
- **go_router** (auth-state-driven redirect)
- **freezed** + **json_serializable** (models)
- **flutter_localizations** + `gen_l10n` — vi canonical, en mirror in `lib/core/i18n/`
- **toastification** (toasts via `KNotify`)
- Custom theme — `KuruColors` extension, 4 palettes (purple/indigo × light/dark), default = `indigo`

## Backend contract — read this when adding endpoints

The kuru BE uses **one consistent response shape** across every REST route:

```jsonc
// success
{ "success": true,  "data": {...}, "timestamp": "..." }
// error
{ "success": false, "error": { "message": "<user-readable>", "code": "..." }, "timestamp": "..." }
```

- `error.message` is **user-readable** and **safe to surface verbatim** for 4xx (validation / business errors).
- For 5xx, replace with a localized fallback ("Đã có lỗi xảy ra").
- 400 = validation / business; 401 = session invalid (force signOut → /login); 429 + `code: "RATE_LIMITED"` = back-off toast; 500 with `"Session does not exist"` in body = same as 401 (BE bug — file as ticket).

**Don't guess at endpoint shapes.** When adding a feature:
1. Read `../gen-barcode/openapi/<module>.openapi.json`
2. Read `../gen-barcode/be/core/dto/<module>/<thing>.dto.ts` (Zod rules + rejection messages)
3. Read `../gen-barcode/be/core/domains/<domain>/api/<thing>.route.ts` (actual handler)

Auth routes are at the **host root** (`/auth/*`, SuperTokens). Business routes under `/api/v1/*`. dio's baseUrl is the host root; each call writes its own prefix.

## UX patterns

- **Inline field errorText** (`KFormField.errorText`) for validation / credential failures — no banner, no layout shift (animated reserved slot, ~160ms).
- **Bottom SnackBar** with retry action via `KNotify.networkError(context, msg, onRetry: ...)` for network / 5xx.
- **Top-right toast** via `KNotify.success/info/warning(context, msg)` for confirmations.
- Toasts intentionally avoided for errors — they auto-dismiss before the user reads them.

## Project layout

```
lib/
├── app/                — KuruApp + router + theme
├── core/
│   ├── auth/           — AuthRepository + providers + onboarding flag
│   ├── env/            — API_BASE_URL via dart-define
│   ├── feedback/       — KNotify (toastification + SnackBar)
│   ├── i18n/           — l10n.yaml at project ROOT; ARB files here
│   ├── logging/        — logger instance
│   ├── network/        — dio_client + ApiResult + ApiException
│   └── validators/     — isValidEmail (TDD'd)
├── design/
│   ├── auth/           — AuthBackdrop, AuthLogo
│   └── widgets/        — KGlass, KPrimaryBtn, KFormField, KCheckbox,
│                         KStepDots, KOtpInput
└── features/
    ├── splash/         — SplashScreen (triggers bootstrap)
    ├── onboarding/     — 6-step PageView + 6 illustrations
    ├── login/          — LoginScreen (email + password)
    ├── register/       — RegisterScreen + password strength meter
    ├── totp/           — TotpVerificationScreen + RecoveryCodeScreen
    ├── create_org/     — CreateOrgScreen + animated StoreIllustration
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

Hot reload: `r` in the flutter run terminal. Hot restart (preserves session via SharedPreferences but rebuilds state): `R`. Quit: `q`.

To replay onboarding: long-press the kuru logo on the Login screen (debug only).

## Specs & plans

- `docs/superpowers/specs/2026-05-15-identity-v1-design.md` — full identity design
- `docs/superpowers/plans/2026-05-15-identity-mvp-login.md` — Plan 1 (Splash + Login + HomeStub) — tag `v0.1.0-identity-mvp`
- `docs/superpowers/plans/2026-05-16-identity-full.md` — Plan 2 (Onboarding + Register + CreateOrg + OrgPicker) — tag `v0.2.0-identity-full`
- TOTP + KNotify + email validation + indigo default landed after `v0.2.0-identity-full`; no separate plan doc.

Future work mentioned but not yet specced: Catalog v1 (Brand + Category CRUD with `openapi_generator_cli`), Passkey login (needs BE-served `.well-known/` files on a real HTTPS host).
