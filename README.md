# TuiBuonBan Mobile (`kuru-mobile`)

Flutter mobile app for TuiBuonBan, built as a portfolio / learning project. The companion to a multi-tenant retail platform (separate private backend repo). Covers the full pre-authenticated-feature surface:

- **Splash + bootstrap** — checks SuperTokens session, branches the app
- **6-step onboarding** — PageView carousel with custom illustrations (barcode scan, inventory, sales chart, payment methods, multi-store, customer insights)
- **Login + Register** — email + password forms with WHATWG-grade email validation, password strength meter, terms checkbox
- **TOTP + recovery code** — 6-digit OTP entry mid-login, with a recovery-code fallback for lost devices
- **Multi-tenant** — auto-create-first-org flow, multi-org picker, `x-org-id` header on every authed REST call
- **HomeStub** — placeholder after auth, complete with sign-out

All wired against a real backend (SuperTokens EmailPassword + a REST API following a `{ success, data, timestamp }` / `{ success, error: { message, code } }` envelope).

## Stack

| Concern | Choice |
|---|---|
| Language / SDK | Flutter 3.41.9 · Dart 3.11 |
| State management | `flutter_riverpod` (single library covers app-state, server-state, module-state) |
| HTTP | `dio` + `supertokens_flutter` (header-mode session, auto-refresh on 401) |
| Routing | `go_router` with auth-state-driven `redirect` |
| Models | `freezed` + `json_serializable` |
| i18n | `flutter_localizations` + `gen_l10n` (`vi` canonical + `en` mirror) |
| Feedback | `toastification` + `ScaffoldMessenger.showSnackBar` wrapped in a small `KNotify` API |
| Theme | Custom — 4 palettes (purple/indigo × light/dark) via `ThemeExtension`, system-driven dark mode |

## Design system

Custom theme tokens (page-bg, surface, ambient-orb colors, text, primary/secondary/success/warning/danger, accent ramp, shadows, glass tint) live in `lib/app/theme/kuru_palettes.dart`.

Notable widgets:

- `KGlass` — Liquid Glass surface (backdrop blur + saturation + subtle border, iOS-26 style)
- `KPrimaryBtn` — filled button with a shine sweep animation
- `KFormField` — KGlass-wrapped labelled input with a reserved field-level `errorText` slot (no layout shift when errors appear/disappear)
- `KOtpInput` — 6-box OTP entry with paste support, backspace navigation, idle/success/error states
- `KStepDots` — tappable step indicator with animated active pill
- `AuthBackdrop` — 3 drifting ambient orbs behind every auth screen
- `AuthLogo` — logo with glow + sparkle animations

## UX patterns

| Need | Pattern |
|---|---|
| Field validation / credential error | `KFormField.errorText: '...'` — red field border + animated reserved slot under the field, no layout jolt |
| Network / 5xx error | `KNotify.networkError(context, msg, onRetry: ...)` — bottom SnackBar with retry action |
| Success / info / warning | `KNotify.success(context, msg)` / `.info` / `.warning` — top-right toast |
| 401 / session expired mid-flow | Toast then `signOut()` + invalidate bootstrap — router routes back to login |

Toasts are deliberately not used for errors (auto-dismiss before users can read them).

## Run

```bash
xcrun simctl boot "iPhone 16" 2>/dev/null && open -a Simulator
flutter run -d "iPhone 16" --dart-define=API_BASE_URL=http://localhost:9190
```

Backend must be running on the host given via `--dart-define=API_BASE_URL=...`.

Hot reload: `r` · Hot restart: `R` · Quit: `q`.

To replay onboarding mid-session: long-press the TuiBuonBan logo on the Login screen (debug-only via `kDebugMode`).

## Tests

```bash
flutter test       # ~49 tests
flutter analyze    # 0 errors
```

## Project layout

```
lib/
├── app/                Router + theme + KuruApp shell
├── core/
│   ├── auth/           AuthRepository, providers, BootstrapResult sealed class
│   ├── env/            API_BASE_URL via --dart-define
│   ├── feedback/       KNotify wrapper
│   ├── i18n/           gen_l10n config + ARB files
│   ├── logging/        package:logger instance
│   ├── network/        dio client + sealed ApiResult + typed exceptions
│   └── validators/     isValidEmail (TDD)
├── design/
│   ├── auth/           AuthBackdrop, AuthLogo
│   └── widgets/        KGlass, KPrimaryBtn, KFormField, KCheckbox, KStepDots, KOtpInput
└── features/
    ├── splash/         SplashScreen
    ├── onboarding/     6-step PageView + illustrations
    ├── login/          LoginScreen + dev affordances
    ├── register/       RegisterScreen + password strength meter
    ├── totp/           TotpVerificationScreen + RecoveryCodeScreen
    ├── create_org/     CreateOrgScreen + animated StoreIllustration
    ├── org_picker/     OrgPickerScreen + OrgCard
    └── home/           HomeStubScreen
```

## Specs & plans (development log)

Built spec-first, plan-driven. Reading the docs in order tells the story of how the app was reasoned-into-existence:

- `docs/superpowers/specs/2026-05-15-identity-v1-design.md` — design spec for the full identity surface
- `docs/superpowers/plans/2026-05-15-identity-mvp-login.md` — Plan 1 (Splash + Login + HomeStub) — tag `v0.1.0-identity-mvp`
- `docs/superpowers/plans/2026-05-16-identity-full.md` — Plan 2 (Onboarding + Register + CreateOrg + OrgPicker) — tag `v0.2.0-identity-full`

After v0.2.0 (single-commit fixes / polish): indigo default theme, 3 more onboarding steps, KNotify, email validator, TOTP + recovery flow.

## Future work

- **Catalog v1** — Brand + Category CRUD with `openapi_generator_cli`.
- **Passkey login** — backend supports it; mobile needs the `passkeys` Flutter package + `.well-known/` files on a real HTTPS staging host.
- **Settings screen** — palette + locale picker.

## Acknowledgements

Built with [Claude Code](https://claude.com/claude-code) using a spec → plan → subagent-driven-development workflow. Architecture decisions are walked through in the `docs/` directory.
