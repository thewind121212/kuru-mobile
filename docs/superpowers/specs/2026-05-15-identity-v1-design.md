# Identity v1 — Design

> Date: 2026-05-15
> Status: Draft (pending user review)
> Supersedes: §6.2 (Splash/Auth), §6.3 (Login), §7.1 (SplashScreen), §7.2 (LoginScreen), §9.2 (Theming), §9.1 (i18n) of `2026-05-15-kuru-mobile-v1-design.md`. The Categories/Brands sections of that spec stay valid but move to a later "Catalog v1" spec.
> Design source: `design/kuru/project/` (handoff bundle from claude.ai/design)

## 1. Goals

Build the **first user-reachable surface** of kuru-mobile: app launch → onboarding → login (or register / create org) → land on an authenticated home placeholder. Implements the design's full Identity section pixel-faithfully, in Flutter, with the theme + i18n + networking infrastructure that the rest of the app will reuse.

**In scope:**
- 7 screens: Splash, Onboarding (3 steps), Login, Register, CreateOrg, OrgPicker, HomeStub.
- Theme system: 4 palettes (purple-light, purple-dark, indigo-light, indigo-dark), system-driven dark.
- i18n: `vi` (canonical from design) + `en` (user-translated).
- SuperTokens-backed auth (EmailPassword) + session-aware routing.
- Backend integration for: sign-in, sign-up, get-user-info (org list), create-store.

**Out of scope:**
- Every non-identity feature (Home Overview, Products, POS, Orders, etc.) — `HomeStub` is just a "logged in" placeholder.
- Passkey, QR Device sign-in, Forgot Password — the UI is removed in v1 because the BE doesn't support these.
- Live palette switcher UI — the system supports 4 palettes but the picker lands in Settings, which is a later spec.
- Avatar upload, image picker integration.
- Push notifications, biometric login, offline cache.

## 2. Screen Catalog (from `design/kuru/project/kuru-canvas.jsx`)

| # | Screen | Design file | Notes |
|---|---|---|---|
| 1 | **Splash** | _not in design_ | Logo + ambient orbs, runs session bootstrap. |
| 2 | **Onboarding** | `kuru-screens-1.jsx::ScreenOnboarding` | 3-step carousel. Step 1 in design; steps 2 + 3 we author (see §6.2). |
| 3 | **Login** | `kuru-screens-1.jsx::ScreenLogin` (line 69) | Email + password + remember-me + login button. **Drop:** Passkey, QR Device, Forgot Password. |
| 4 | **Register** | `kuru-screens-1.jsx::ScreenRegister` (line 141) | Full name + email + password + strength meter + terms + register button. **Drop:** "Register with Passkey". |
| 5 | **CreateOrg** | `kuru-screens-1.jsx::ScreenCreateOrg` (line 231) | Animated store illustration + business name + branch name + invite-code link + step dots + CTA. |
| 6 | **OrgPicker** | `kuru-screens-1.jsx::ScreenOrgPicker` (line 654) | Card list of user's orgs + "Create new org" dashed button + data-isolation note. |
| 7 | **HomeStub** | _placeholder_ | Single-screen "Đã đăng nhập" with logout link. Replaced by real home in later spec. |

## 3. Navigation Flow

```
[Cold start] → Splash
                 ├─ first-launch (no onboarding-seen flag) → Onboarding
                 │     └─ step 3 "Bắt đầu" → Login
                 │     └─ "Bỏ qua" (any step) → Login
                 ├─ session valid + getUserInfo OK
                 │     ├─ 0 orgs → CreateOrg
                 │     │     └─ "Tạo cửa hàng" → HomeStub
                 │     ├─ 1 org → HomeStub (auto-pick)
                 │     └─ 2+ orgs → OrgPicker
                 │           └─ pick → HomeStub
                 └─ session missing/expired → Login
                       ├─ "Đăng nhập" → bootstrap re-run (same fork as above)
                       └─ "Chưa có tài khoản? Đăng ký" → Register
                                                            └─ "Tạo tài khoản" → CreateOrg
                                                                                   └─ → HomeStub
[From HomeStub] → "Đăng xuất" → clear session → Login
```

Implemented via `go_router` with a redirect callback that consults `appBootstrapProvider`. The `hasSeenOnboarding` flag is a `SharedPreferences` boolean set true the first time the user reaches Login.

## 4. Tech Stack (carries over from original v1 spec)

No changes from the parent spec — same Flutter / Riverpod / dio / go_router / freezed / supertokens_flutter / flutter_localizations choices. New additions for identity:

| Concern | Choice | Why |
|---|---|---|
| Animations | Flutter's built-in `Tween` + `AnimationController` + `ImplicitlyAnimatedWidget` | No `rive` / `lottie` needed; design is CSS keyframes that map cleanly to Dart curves. |
| Backdrop blur | `BackdropFilter` widget + `ImageFilter.blur` | Native equivalent of CSS `backdrop-filter`. |
| Persistent flags | `shared_preferences` | `hasSeenOnboarding`, theme palette choice (later), locale choice (later). |
| **API client (identity v1 only)** | **Hand-written `Future<ApiResult<T>>` methods on `AuthRepository`** | Decision (2026-05-15): identity touches ~4 endpoints; setting up codegen costs more than writing them. **Catalog v1** spec will introduce `openapi_generator_cli` pointing at `../gen-barcode/openapi/*.openapi.json`, and identity's hand-written calls will be migrated into the generated client at that point. |

## 5. Theme System

### 5.1 Tokens

Ported from `design/kuru/project/kuru-theme.js`. Each palette × mode is a Dart const `ColorScheme` plus a custom `KuruColors` extension for tokens Material doesn't model (ambient orbs, accent ramp 50–800, shadows, glass tint).

**Palettes implemented:**

| Palette | Light source | Dark source |
|---|---|---|
| `purple` | `:root` block (k-theme.js line 10) | `[data-kuru="midnight"]` block (line 44) |
| `indigo` | `[data-kuru="indigo"]` block (line 78) | **Synthesized** — mirror `midnight`'s structure, swap primary→`#6366f1`/`#818cf8`, secondary→`#3b82f6`, accents → indigo ramp 100s. |

Example tokens (purple-light excerpt, mapped to Dart):

```dart
class KuruColors extends ThemeExtension<KuruColors> {
  final Color pageBg;          // #f5f0fa
  final Color surface;         // #faf7fc
  final Color surfaceElev;     // #ffffff
  final Color surfaceHover;    // #ede4f5
  final Color border;          // #d0c0e0
  final Color borderSoft;      // #e5dbed
  final Color textPrimary;     // #1a1028
  final Color textSecondary;   // #554466
  final Color textMuted;       // #887799
  final Color primary;         // #9c27b0
  final Color primaryHover;    // #8520a0
  final Color secondary;       // #5e35b1
  final Color success;         // #0d9488
  final Color warning;         // #d07000
  final Color danger;          // #c62828
  // accent ramp
  final Color accent50, accent100, accent200, accent300,
              accent400, accent500, accent600, accent700, accent800;
  // ambient orb colors
  final Color ambient1, ambient2;
  // shadow defs
  final List<BoxShadow> shadowSm, shadowMd, shadowPop;
  // glass surface tint
  final Color glassTint;       // surfaceElev @ 55% (light) / 38% (dark)
  // ...
}
```

### 5.2 Theme controller

```dart
@riverpod
class ThemeController extends _$ThemeController {
  @override
  KuruThemeState build() => KuruThemeState(palette: KuruPalette.purple);
  // palette switch deferred; v1 hard-codes purple
}
```

`MaterialApp` consumes `MediaQuery.platformBrightnessOf(context)` to pick light vs dark from the chosen palette.

### 5.3 Liquid Glass widget

Reusable Flutter `KGlass` widget that mirrors the CSS `.k-glass`:

```dart
class KGlass extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry borderRadius;
  final bool solid; // matches `.k-glass-solid` variant
  // ...
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: kuruColors(context).glassTint,
            borderRadius: borderRadius,
            border: Border.all(
              color: kuruColors(context).textPrimary.withOpacity(0.12),
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

**Performance:** Android emulators don't always perform `BackdropFilter` well. We measure; if FPS drops noticeably we'll add a fallback that uses solid `surfaceElev` with elevation shadow instead.

### 5.4 Animations

| Design class | Flutter implementation | Used by |
|---|---|---|
| `k-anim-orb-1` / `k-anim-orb-2` | `AnimatedBuilder` driving two `Tween<Offset>` curves over 14–18s | `AuthBackdrop` |
| `k-anim-glow` | `BoxShadow` interpolated 0↔14px over 3s | `AuthLogo` |
| `k-anim-shine` | `ShaderMask` with moving `LinearGradient` | Primary buttons |
| `k-anim-sparkle` | Scale tween 0.6 → 1.0 with phase offsets | Logo decorations |
| `k-anim-rise` | One-shot translate-up + fade (entry) | Onboarding text |
| `k-anim-box` | Cascade bounce (delay per box) | CreateOrg illustration |
| `k-anim-pulse-ring` | Scale + opacity 0.8→1.5 / 0.5→0 | Onboarding rings |
| `k-anim-beam` | Vertical translate −44 ↔ 44 | Onboarding phone-scan illustration |
| `k-anim-float` | Sinusoidal Y translate, soft rotate | Floating decorations |

All animations honor `MediaQuery.disableAnimationsOf(context)` — if the user has reduce-motion enabled, controllers don't start.

## 6. Screens (Detail)

### 6.1 SplashScreen

```
┌──────────────────────────────────────┐
│         (ambient orbs)                │
│                                      │
│             [logo + glow]             │
│              KURU                    │
│                                      │
│              · · ·                    │
│         (loading dots)                │
└──────────────────────────────────────┘
```

**Behavior:** runs `appBootstrapProvider.future` then routes per §3.

### 6.2 Onboarding (3 steps)

| Step | Design step 1 (existing) | Step 2 (proposed) | Step 3 (proposed) |
|---|---|---|---|
| **Title** | "Bán hàng nhanh hơn, chỉ với một lần quét." | "Quản lý tồn kho theo thời gian thực." | "Hiểu cửa hàng của bạn qua từng con số." |
| **Body** | "Quét mã vạch để thêm sản phẩm vào giỏ, tính tiền và in hóa đơn — chỉ trong vài giây." | "Mỗi giao dịch cập nhật tồn kho tức thì. Cảnh báo khi sắp hết hàng." | "Báo cáo doanh thu, đơn hàng, khách hàng tự động hoá. Quyết định tốt hơn mỗi ngày." |
| **Illustration** | Phone scanning barcode + floating product card + check badge + cart (already in design) | Stacked-boxes warehouse with floating "in/out" arrows | Animated bar/line chart with rising trend + tabular numbers |
| **CTA** | "Tiếp theo" → step 2 | "Tiếp theo" → step 3 | "Bắt đầu" → Login |
| **Skip** | top-right "Bỏ qua" → Login | same | same |
| **Step dots** | 1st wide, others dots | 2nd wide | 3rd wide |

> **Open question** ⚑ — the design only ships step-1 copy + illustration. The above is my proposed step-2 + step-3 content. User must confirm or rewrite before implementation.

### 6.3 Login

Faithful to `kuru-screens-1.jsx::ScreenLogin` with these removals:
- **Remove** the divider row "HOẶC ĐĂNG NHẬP NHANH" and the Passkey + QR Device buttons (lines 119–127).
- **Remove** the "Quên mật khẩu?" link (line 112).

Kept:
- AuthBackdrop (3 ambient orbs), AuthLogo (with glow + sparkles).
- Headline "Chào mừng trở lại" + sub "Đăng nhập kuru để tiếp tục quản lý cửa hàng."
- Form: email + password fields (KGlass wrap), each with leading icon.
- "Ghi nhớ đăng nhập" checkbox.
- Primary "Đăng nhập" button with shine animation.
- Footer: "Chưa có tài khoản? **Đăng ký**" — tap → /register.

**State:** `LoginNotifier` (Riverpod `AsyncNotifier<void>`); fields collected in a `Form` with `KFormField` widgets. Tap login → `authRepository.signIn(email, password)` → on success, re-run `appBootstrapProvider`.

### 6.4 Register

Faithful to `ScreenRegister` with one removal:
- **Remove** "Đăng ký bằng Passkey" GhostBtn and its divider (lines 213–218).

Kept:
- Compact AuthLogo + title "Tạo tài khoản" + sub "Bắt đầu với kuru chỉ trong 30 giây."
- Form: full name + email + password.
- Password strength meter (4 bars; logic: length ≥ 8 → bar 1, has upper + digit → bar 2, has symbol → bar 3, length ≥ 12 → bar 4). Strength label: "Yếu / Khá / Tốt / Mạnh".
- Terms checkbox (must be ticked to enable Register button).
- Primary "Tạo tài khoản" button (shine).
- Footer: "Đã có tài khoản? **Đăng nhập**".

**Backend dependency** ⚑ — needs confirmation:
- Does kuru BE expose SuperTokens emailpassword `/auth/signup` for mobile clients? (CORS, rate-limit, captcha?)
- After sign-up: server-side, does the user start with **zero orgs** (so we route to CreateOrg)?
- If sign-up requires an invitation code (kuru web flow may), we either need that field in the form (matches the CreateOrg "Have invite code?" link concept) or a server-side flag.

### 6.5 CreateOrg

Faithful to `ScreenCreateOrg`. Includes:
- Custom header row: back chevron + current user email + logout button (top-right). This is the only screen with this chrome.
- Animated illustration: storefront + 5 stacked boxes (cascade bounce with delays) + sparkles.
- Title "Tạo cửa hàng của bạn" + body "Tạo tổ chức và chi nhánh đầu tiên. Bạn có thể thêm chi nhánh khác sau."
- Two KGlass form fields: business name (required), first branch name (optional, with placeholder "Mặc định: cùng tên doanh nghiệp").
- "Đã có mã mời? Nhập tại đây" inline link → opens a bottom sheet for invite code → joins existing org instead of creating.
- Primary "Tạo cửa hàng" button (shine).
- Step dots: 1 / **2** / 3 (active = 2). Steps 1 + 3 are not in identity scope — they're placeholder positions for future onboarding-into-org flow.

**Backend mapping (resolved 2026-05-15 from openapi):**
- Business name → `POST /v1/store/CreateStore`, body `{ name: string }`.
- First branch name → second call `POST /v1/storage/CreateStore`, body schema TBD (BE module names a "Storage" object as `CreateStore` endpoint — naming inherited from legacy code where Storage = Branch). If user leaves the field blank we **skip the second call** and let the BE/admin add storages later from web.

**Invite code path:**
- ⚑ **Unresolved**: BE has `POST /v1/store/CreateInvite` (server-side invite generation) but no obvious "accept invite" endpoint in the inspected openapi. Options:
  - **(A)** Drop the "Đã có mã mời?" link from CreateOrg entirely in identity-v1. Add when BE exposes an accept endpoint.
  - **(B)** Render the link, on tap show a "Sắp ra mắt" toast.
  - **Recommendation:** (A) — fewer broken promises. Revisit when CreateInvite has a matching AcceptInvite.

### 6.6 OrgPicker

Faithful to `ScreenOrgPicker`. Displays:
- TopBar (big variant): title "Chọn tổ chức" + subtitle "Bạn là thành viên của **N** tổ chức".
- List of org cards, each: `AvatarThumb` (hue derived from org name hash) + name + role pill (`Chủ sở hữu` / `Quản lý` / `Thu ngân` / etc) + "{stores} cửa hàng · {members} thành viên" subline + active checkmark on currently-selected.
- "Tạo tổ chức mới" dashed button below the list → /create-org.
- Info card with shield icon: "Mỗi tổ chức là một không gian dữ liệu riêng biệt. Bạn có thể chuyển đổi bất kỳ lúc nào trong Cài đặt."

**Data source:** `getUserInfo` response → orgs array. If user has only 1 org, this screen never renders (router skips to HomeStub). The "active" org is read from the persisted `currentOrgIdProvider`.

### 6.7 HomeStub

Single screen, intentionally minimal:
- Centered text "Đã đăng nhập" (vi) / "Logged in" (en).
- Sub-text showing current user email + current org name.
- "Đăng xuất" button (links to `authRepository.signOut()` → /login).

This will be **deleted** when the real Home spec lands. Its only purpose is giving the auth flow somewhere to land.

## 7. Auth Flow Implementation

### 7.1 Bootstrap provider

```dart
@riverpod
Future<BootstrapResult> appBootstrap(AppBootstrapRef ref) async {
  final hasSession = await SuperTokens.doesSessionExist();
  if (!hasSession) return BootstrapResult.unauthenticated();
  final info = await ref.read(authRepositoryProvider).getUserInfo();
  // info.orgs : List<OrgSummary>
  return BootstrapResult.authenticated(info);
}
```

### 7.2 Router redirect

```dart
final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final boot = ref.read(appBootstrapProvider);
    return boot.when(
      loading: () => state.matchedLocation == '/splash' ? null : '/splash',
      error: (_, __) => state.matchedLocation == '/login' ? null : '/login',
      data: (r) => switch (r) {
        BootstrapUnauth() => publicRoutes.contains(state.matchedLocation) ? null : '/login',
        BootstrapAuth(:final info) when info.orgs.isEmpty => '/create-org',
        BootstrapAuth(:final info) when info.orgs.length > 1 && !ref.read(currentOrgIdProvider.notifier).hasPick => '/org-picker',
        BootstrapAuth() => state.matchedLocation == '/home' ? null : '/home',
      },
    );
  },
  routes: [/* ... */],
);
```

Public routes: `/splash`, `/onboarding`, `/login`, `/register`.

### 7.3 Auth repository

```dart
class AuthRepository {
  Future<ApiResult<void>> signIn({required String email, required String password});
  Future<ApiResult<void>> signUp({required String fullName, required String email, required String password});
  Future<ApiResult<UserInfo>> getUserInfo();
  Future<ApiResult<String>> createStore({required String businessName, String? firstBranchName});
  Future<ApiResult<void>> acceptInvite({required String code});
  Future<void> signOut();
}
```

## 8. i18n

ARB files contain every visible string. We start from Vietnamese, user fills English. No raw string literals in widgets.

**Initial keys** (illustrative; full list in `lib/core/i18n/app_vi.arb` after build):

```jsonc
{
  "onboardingSkip": "Bỏ qua",
  "onboardingNext": "Tiếp theo",
  "onboardingStart": "Bắt đầu",
  "onboardingStep1Title": "Bán hàng nhanh hơn, chỉ với một lần quét.",
  "onboardingStep1Body": "Quét mã vạch để thêm sản phẩm vào giỏ, tính tiền và in hóa đơn — chỉ trong vài giây.",
  "onboardingStep2Title": "Quản lý tồn kho theo thời gian thực.",
  "onboardingStep2Body": "Mỗi giao dịch cập nhật tồn kho tức thì. Cảnh báo khi sắp hết hàng.",
  "onboardingStep3Title": "Hiểu cửa hàng của bạn qua từng con số.",
  "onboardingStep3Body": "Báo cáo doanh thu, đơn hàng, khách hàng tự động hoá.",
  "loginTitle": "Chào mừng trở lại",
  "loginSubtitle": "Đăng nhập kuru để tiếp tục quản lý cửa hàng.",
  "fieldEmail": "Email",
  "fieldPassword": "Mật khẩu",
  "loginRemember": "Ghi nhớ đăng nhập",
  "loginCta": "Đăng nhập",
  "loginFooterNoAccount": "Chưa có tài khoản?",
  "loginFooterRegister": "Đăng ký",
  "registerTitle": "Tạo tài khoản",
  // ...
}
```

User provides `app_en.arb` with the same keys.

## 9. Backend Dependencies (must be confirmed before sprint starts)

| # | Need | Status (resolved 2026-05-15 from BE code inspection) |
|---|---|---|
| 1 | SuperTokens emailpassword sign-in for mobile | ✅ BE wires SuperTokens EmailPassword via `be/core/app.ts`. CORS is configured with `origin: env.WEBSITE_DOMAIN` (web domain) — **mobile bypasses CORS entirely** because native HTTP clients don't send `Origin` headers. We'll use **header-mode** SuperTokens via `supertokens_flutter` (sends `st-auth-mode: header` so tokens come back in response headers, not cookies). |
| 2 | SuperTokens emailpassword sign-up for mobile | ✅ `signUpPOST` is exposed (BE has explicit override at `be/core/app.ts:77` confirming it's enabled). Post-signup the user has zero orgs → routes to `/create-org`. |
| 3 | `getUserInfo` response | ✅ Resolved. Route lives in the **profile** domain (not store) — `POST /api/v1/profile/GetUserInfo`. Response (from `be/types/profile.d.ts`): `{ email, name, orgInfos: [{id, name, role}], avatarStyle, avatarSeed, avatarUrl, totpEnabled, disabledOrgInfos, pendingInviteCount }`. `OrgInfo.role` is exactly the "Chủ sở hữu / Quản lý / Thu ngân" the design uses. Members and stores counts **aren't** in the response — design's "{stores} cửa hàng · {members} thành viên" subline will be **dropped** in v1 (could be added later via a follow-up endpoint). |
| 4 | `POST /v1/store/CreateStore` body `{ name }` | ✅ Verified — body is just `{ name }`. Full path: `/api/v1/store/CreateStore`. |
| 5 | `POST /v1/storage/CreateStore` for first-branch creation | ✅ Endpoint exists. Body schema TBD but follows the same module pattern. Full path: `/api/v1/storage/CreateStore`. |
| 6 | Accept-invite endpoint | ⚠️ Not in openapi, but `getUserInfo.pendingInviteCount` shows invites exist on the BE. **Resolution:** drop invite-code link from CreateOrg in v1 (confirmed by user). Re-investigate when we build the Settings/Notifications spec. |
| 7 | Auth strings (en) | ✅ Mirror style from `../gen-barcode/fe/src/locales/en/auth.json`. Vietnamese stays canonical from design. Where wording differs (design's "Chào mừng trở lại" vs. web's "Xin chào!"), **design wins** — we adapt the English to match design's vi intent in web's en style. |
| 8 | Logo asset | ✅ `../gen-barcode/fe/public/logo.webp` → copy to `kuru-mobile/assets/logo.webp`. Flutter 3+ supports `.webp` via `Image.asset`. |
| 9 | OrgInfo response shape implications | ✅ `OrgPicker` cards use `AvatarThumb` with hue derived from `name` hash (matches design — no avatar URL needed). Role pill text = `orgInfo.role`. Subline "X cửa hàng · Y thành viên" **dropped in v1** per item 3. |

All items resolved. No ⚑ blockers remain.

## 10. Testing (light, same as parent spec)

- `KuruColors.purpleLight` / `.purpleDark` / `.indigoLight` / `.indigoDark` golden colour-list tests.
- Widget smoke tests for each of the 7 screens (renders without crashing in both light + dark, vi + en).
- A bootstrap router test that walks each of the 6 routing branches in §3.
- Auth repo unit tests with a `MockDio`: happy path + 4xx + 5xx + network down.

## 11. Build/Run

Same as parent spec — `flutter run` from `kuru-mobile/` with `--dart-define=API_BASE_URL=...`. iOS simulator already booted; Android emulator pending the SDK setup task.

## 12. Open Questions for User

All five originally-open questions are resolved as of 2026-05-15:

1. ✅ **Onboarding step 2 + 3 copy** — keep my Vietnamese proposals.
2. ✅ **English translations** — mirror kuru web's `fe/src/locales/en/auth.json` style. I author en strings as part of this spec's implementation; user reviews.
3. ✅ **Logo** — copy `fe/public/logo.webp` from kuru web to `kuru-mobile/assets/`.
4. ✅ **BE verification** — done by direct kuru codebase inspection; results folded into §9 above.
5. ✅ **Invite code link** — dropped from CreateOrg in v1.

Remaining unknowns only emerge during implementation (e.g. exact body schema of `/storage/CreateStore`, behavior of `signUpPOST` with bad input, header-mode token roundtrip). They'll get handled in the implementation plan, not as spec-level blockers.

## 13. Out of Scope (recap)

Anything not in §1 In Scope. Everything else gets its own spec.
