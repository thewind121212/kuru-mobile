# kuru-mobile v1 — Design

> Date: 2026-05-15
> Status: Draft (pending user review)
> Sibling repo (backend + web): `../gen-barcode/`

## 1. Goals

Build the first version of the Flutter mobile companion app for **kuru** (codebase `gen-barcode`), a multi-tenant retail inventory management platform. v1 ships a deliberately small surface that exercises the full stack (auth, network, multi-tenant, i18n, theming, image upload) so the foundation is solid for later features.

**In scope for v1:**

1. Splash screen on app start.
2. Login screen ("hello") — email + password, SuperTokens-backed, matching the kuru web auth recipe.
3. Category CRUD — list, create, edit, delete, with icon + color picker.
4. Brand CRUD — list, create, edit, delete, with logo upload.
5. i18n from day one — `en` and `vi`, mirroring the web app.
6. Profile screen — current user, current store, language switcher, logout.

**Targets:** Android + iOS, debug builds against a local kuru backend on `localhost:9190`.

## 2. Non-Goals (v1)

The following are explicitly out of scope; each gets its own spec later:

- Products, orders, customers, distributors, storages, expenses, taxes, variant attributes — i.e. anything not Category or Brand.
- Barcode scanning.
- Multi-store switcher UX (we hard-pick the user's first store, like the web `AppLoader`).
- Offline mode / background sync / local cache beyond what dio gives us.
- Push notifications.
- Biometric login.
- Image cropping / advanced media editing.
- Production builds, app-store distribution, CI/CD.
- Deep-linking, app-shortcut handling.
- Accessibility audit beyond default Material 3 affordances.

## 3. Tech Stack

| Concern | Choice | Why |
|---|---|---|
| Language / SDK | **Flutter 3.x + Dart 3.x** | Single codebase → iOS + Android. User has no prior mobile experience, Flutter has the shortest ramp. |
| State management | **Riverpod** (`flutter_riverpod`) | Single library covers what kuru web splits across Redux + Zustand + React Query. `AsyncNotifier` ≈ React Query; `Notifier` ≈ Zustand/Redux. |
| HTTP client | **dio** | Mature, interceptor support (we'll plug auth + `x-org-id` here), retries, file upload. |
| Routing | **go_router** | Declarative, URL-style, auth-guard friendly, deep-link ready when we want it. |
| Models / serialization | **freezed + json_serializable** | Immutable data classes + `fromJson`/`toJson` from a short declaration. Equivalent of Zod types. |
| Auth | **supertokens_flutter** | Official SDK that matches the backend's SuperTokens EmailPassword recipe. Handles token storage + automatic header attachment. |
| Image picking | **image_picker** + **image** (compression) | Pick from gallery / camera, downscale before upload. |
| Theming | Material 3, `ThemeMode.system` | Dark/light for free. Re-skin later if/when we copy kuru web's brand palette. |
| i18n | **`flutter_localizations` + `gen_l10n`** (official) | ARB files in `lib/core/i18n/`, code-generated `AppLocalizations` accessor. |
| Logging | **logger** package | Tagged levels (debug/info/warn/error), printable in dev console. |
| Linting | `flutter_lints` (default) plus `very_good_analysis` | Stricter ruleset suited to long-term maintenance. |

**Not chosen, and why:**
- *bloc / flutter_bloc* — more boilerplate per feature; Riverpod gives us the same guarantees with less ceremony.
- *get_it / injectable* — Riverpod is the DI container; no need for a second one.
- *openapi_generator* — for v1 we have ~10 endpoints. Hand-writing is faster than wiring a codegen toolchain. Revisit when Product/Order specs land.
- *flutter_secure_storage* directly — `supertokens_flutter` already persists tokens securely; we don't need to manage that ourselves in v1.

## 4. Mobile C3 (Component Diagram)

Adapted from `../gen-barcode/docs/architecture/c3-frontend.md`.

```
┌─────────────────────────────────────────────────────────────────────┐
│                MOBILE CONTAINER (Flutter + Dart 3)                   │
│                Android + iOS · Material 3                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────┐       │
│  │                    APP SHELL                              │       │
│  │  ProviderScope → MaterialApp.router → go_router          │       │
│  │  Splash → AuthGate → HomeShell (BottomNavBar)            │       │
│  └──────────────────────┬──────────────────────────────────┘       │
│                         │                                           │
│  ┌──────────────────────▼──────────────────────────────────┐       │
│  │              SCREENS / ROUTES                             │       │
│  │  /splash · /login · /home/categories · /home/brands      │       │
│  │  /home/profile · /categories/:id · /brands/:id           │       │
│  └──────────────────────┬──────────────────────────────────┘       │
│                         │                                           │
│  ┌──────────────────────▼──────────────────────────────────┐       │
│  │              FEATURE MODULES                              │       │
│  │  features/auth · features/category · features/brand      │       │
│  │  Each: data/ + presentation/                              │       │
│  └──────────┬───────────────────────────────┬──────────────┘       │
│             │                               │                       │
│  ┌──────────▼──────────┐       ┌────────────▼────────────┐         │
│  │  CORE DESIGN        │       │  CORE NETWORK + AUTH    │         │
│  │  KButton, KInput,   │       │  dio_client + SuperTokens│        │
│  │  KAvatarUpload,     │       │  x-org-id interceptor    │        │
│  │  IconPicker,        │       │  ApiResult<T> wrapper   │         │
│  │  ColorPicker,       │       └────────────┬────────────┘         │
│  │  SplashScreen       │                    │                       │
│  └─────────────────────┘                    │                       │
│                                              │                       │
│  ┌───────────────────────────────────────────▼──────────────┐       │
│  │              STATE (Riverpod ProviderScope)               │       │
│  │  AuthNotifier · CategoryListNotifier · BrandListNotifier  │       │
│  │  LocaleController · ThemeController                       │       │
│  └──────────────────────────────────────────────────────────┘       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                                │
                                ▼ HTTP (dio)
                       Backend (gen-barcode) :9190
```

### Web → Mobile mapping

| Web (kuru) | Mobile (kuru-mobile) | Notes |
|---|---|---|
| `SuperTokensWrapper` | `SuperTokens.init()` in `main.dart` | One-time init. |
| `BrowserRouter` + `Route` | `go_router` with redirect-based auth guard | Same idea, different API. |
| `SessionAuth` HOC | `AuthGate` widget + `authStateProvider` | Wrap protected branches. |
| `Sidebar` | `BottomNavigationBar` in `HomeShell` | Mobile-native pattern. |
| `LoadingScreen` (fetches `orgId`) | `SplashScreen` + `appBootstrapProvider` | Same role: resolves session + storeId before rendering app. |
| `Redux` (global) | Riverpod `Notifier` (e.g. `AuthNotifier`) | App identity. |
| `Zustand` (module) | Riverpod `Notifier` (per-feature) | Module-local UI state. |
| `React Query` (server) | Riverpod `AsyncNotifier` / `FutureProvider` | Server state caching. |
| `core-design/` | `lib/core/design/` | 1:1 mapping. |
| `services/<name>/api.ts` | `lib/features/<name>/data/<name>_api.dart` | Same per-feature pattern. |
| `services/<name>/useQuery.ts` | `lib/features/<name>/data/<name>_providers.dart` | Riverpod equivalents. |
| `react-i18next` | `gen_l10n` + ARB | Official Flutter i18n. |
| `dark:` Tailwind variants | `Theme.of(context)` + Material 3 ColorScheme | Built-in dark mode. |
| `AvatarUpload` (S3) | `KAvatarUpload` widget (image_picker → dio multipart) | Same UX, native picker. |

## 5. Project Structure

```
kuru-mobile/
├── pubspec.yaml                          # deps + asset/i18n config
├── analysis_options.yaml                 # very_good_analysis lints
├── android/, ios/                        # generated by `flutter create`
├── lib/
│   ├── main.dart                         # SuperTokens.init() → runApp(ProviderScope(KuruApp))
│   ├── app/
│   │   ├── app.dart                      # MaterialApp.router, theme, localizations
│   │   ├── router.dart                   # go_router config + auth redirect
│   │   └── theme.dart                    # Material 3 light + dark
│   ├── core/
│   │   ├── env/
│   │   │   └── env.dart                  # API_BASE_URL (dart-define)
│   │   ├── network/
│   │   │   ├── dio_client.dart           # base url, interceptors
│   │   │   ├── api_result.dart           # sealed ApiResult<T> { Success, Failure }
│   │   │   └── api_exception.dart        # typed errors
│   │   ├── auth/
│   │   │   ├── auth_repository.dart      # supertokens_flutter calls
│   │   │   ├── auth_state.dart           # freezed sealed class
│   │   │   └── auth_providers.dart       # authNotifierProvider, currentOrgIdProvider
│   │   ├── design/
│   │   │   ├── k_button.dart
│   │   │   ├── k_input.dart
│   │   │   ├── k_modal.dart
│   │   │   ├── k_avatar_upload.dart
│   │   │   ├── k_icon_picker.dart
│   │   │   ├── k_color_picker.dart
│   │   │   ├── k_loading.dart
│   │   │   └── splash_screen.dart
│   │   ├── i18n/
│   │   │   ├── l10n.yaml                 # gen_l10n config
│   │   │   ├── app_en.arb                # source-of-truth strings
│   │   │   └── app_vi.arb
│   │   └── logging/
│   │       └── log.dart                  # `logger` instance
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/                     # only network calls; SDK handles state
│   │   │   └── presentation/
│   │   │       ├── login_screen.dart
│   │   │       └── widgets/
│   │   ├── category/
│   │   │   ├── data/
│   │   │   │   ├── category_models.dart  # freezed: Category, CategoryOverviewItem, …
│   │   │   │   ├── category_api.dart     # raw dio calls
│   │   │   │   └── category_providers.dart # Riverpod providers/notifiers
│   │   │   └── presentation/
│   │   │       ├── category_list_screen.dart
│   │   │       ├── category_edit_sheet.dart
│   │   │       └── widgets/
│   │   ├── brand/
│   │   │   ├── data/
│   │   │   │   ├── brand_models.dart
│   │   │   │   ├── brand_api.dart
│   │   │   │   └── brand_providers.dart
│   │   │   └── presentation/
│   │   │       ├── brand_list_screen.dart
│   │   │       ├── brand_edit_sheet.dart
│   │   │       └── widgets/
│   │   └── profile/
│   │       └── presentation/profile_screen.dart
│   └── shell/
│       └── home_shell.dart               # Scaffold with BottomNavigationBar
└── test/
    ├── core/
    └── features/
```

## 6. Application Flow

### 6.1 Startup

```
main()
  └─ WidgetsFlutterBinding.ensureInitialized()
  └─ SuperTokens.init(apiDomain: API_BASE_URL, ...)
  └─ runApp(ProviderScope(child: KuruApp()))
       └─ MaterialApp.router(routerConfig: appRouter)
            └─ initial route: /splash
```

### 6.2 Splash → Auth Gate

`SplashScreen` triggers `appBootstrapProvider` which does:

1. `SuperTokens.doesSessionExist()` — has the user logged in before?
2. If **no** → redirect to `/login`.
3. If **yes** → call `GET /v1/store/getUserInfo` to fetch user + enrolled stores.
4. Store first `orgId` in `AuthNotifier`. Redirect to `/home/categories`.
5. On any failure (network, expired session) → clear session, redirect to `/login`.

go_router's `redirect` callback consults `authStateProvider` to gate `/home/**` routes.

### 6.3 Login

`LoginScreen` collects email + password, calls `supertokens_flutter`'s emailpassword sign-in. On success we re-run the bootstrap flow above. Errors surface inline (wrong credentials, network down) via `ApiResult`.

### 6.4 Logout

`ProfileScreen` → tap Logout → `SuperTokens.signOut()` + clear `AuthNotifier` → redirect to `/login`.

### 6.5 Multi-tenant header

The dio interceptor reads `currentOrgIdProvider` and attaches `x-org-id: <orgId>` to every authenticated request. If `orgId` is null (pre-bootstrap), the interceptor lets the request through without the header. The only endpoints we call before `orgId` is set are the SuperTokens auth routes and `GET /v1/store/getUserInfo`; all feature endpoints (`/v1/category/*`, `/v1/brand/*`, `/v1/file/*`) require `orgId` and will be issued only after bootstrap completes.

## 7. Screens

### 7.1 SplashScreen
- Centered kuru logo placeholder + `CircularProgressIndicator`.
- No interaction; routes away after bootstrap completes.

### 7.2 LoginScreen
- `KInput` for email, `KInput` (obscure) for password.
- `KButton` "Sign in" — disabled while loading.
- Error banner under the form for failures.
- No "sign up" / "forgot password" link in v1 (user accounts come from the web onboarding flow).

### 7.3 HomeShell
- `Scaffold` with `BottomNavigationBar` (3 tabs):
  1. **Categories** (icon: folder)
  2. **Brands** (icon: tag)
  3. **Profile** (icon: person)
- Each tab keeps its own navigation stack via `StatefulShellRoute.indexedStack` (go_router pattern).

### 7.4 Categories tab
- `CategoryListScreen`:
  - `AppBar` with title (localized), search field.
  - Body: list (or grid) of `CategoryListItem` cards showing icon + colored chip + name + product count.
  - `FloatingActionButton` (+) → opens `CategoryEditSheet` in create mode.
  - Pull-to-refresh re-runs `GetCategoryOverview`.
- `CategoryEditSheet` (modal bottom sheet, full-height):
  - Fields: `name` (required), `description`, `parentId` (optional, picker among existing categories), `icon` (icon picker), `colorSettings` (color picker), `status` (active/inactive), `layer` (read-only or inferred).
  - "Save" → `CreateCategory` or `UpdateCategory`. Invalidates the `categoryListProvider` so the list refetches.
  - "Delete" button (only in edit mode) → confirm dialog → `RemoveCategory`.

### 7.5 Brands tab
- `BrandListScreen`:
  - Same structure as Categories: list with `BrandListItem` (logo thumb + name + slug + product count).
  - Search via `searchString` query param of `GetBrandOverview`.
  - Pagination — load-more on scroll, using `page` + `limit` (default 20).
  - FAB → `BrandEditSheet`.
- `BrandEditSheet`:
  - Fields: `name` (required), `slug` (auto-generated from name, editable), `logoUrl` via `KAvatarUpload`.
  - Save → `CreateBrand` / `UpdateBrand`. Delete → `DeleteBrand`.

### 7.6 Profile tab
- Current user email + current store name (from `getUserInfo`).
- Language picker (en / vi) — calls `LocaleController.set(...)`, persisted in `SharedPreferences`.
- Theme picker (System / Light / Dark) — `ThemeController`, persisted likewise.
- Logout button.

## 8. Data Layer

### 8.1 Network

`DioClient` (singleton via Riverpod `Provider`) configures:

- `baseUrl`: from `--dart-define=API_BASE_URL=...` (Android emulator default `http://10.0.2.2:9190`, iOS simulator default `http://localhost:9190`).
- Interceptors:
  1. **SuperTokens interceptor** (from `supertokens_flutter`) — attaches session, handles refresh.
  2. **OrgId interceptor** — reads `currentOrgIdProvider`, attaches `x-org-id`.
  3. **Logging interceptor** — dev builds only.
  4. **Error interceptor** — converts dio errors to typed `ApiException`s.

Response wrapper (matches kuru BE contract):
```dart
sealed class ApiResult<T> {
  const ApiResult();
  factory ApiResult.success(T data) = ApiSuccess<T>;
  factory ApiResult.failure(ApiException err) = ApiFailure<T>;
}

extension ApiResultX<T> on Future<ApiResult<T>> {
  Future<T> unwrap() async {
    final r = await this;
    return switch (r) {
      ApiSuccess(:final data) => data,
      ApiFailure(:final err) => throw err,
    };
  }
}
```

`unwrap()` is used inside Riverpod notifiers where throwing into `AsyncValue` is the idiomatic error path. Screens that want to render errors inline switch on the raw `ApiResult` instead.

### 8.2 Models (freezed, generated)

**Category** (mapped from `category.openapi.json`):
```dart
@freezed
class Category with _$Category {
  const factory Category({
    required String categoryId,
    required String name,
    String? parentId,
    required String colorSettings,
    required String layer,
    String? description,
    required String status,
    required String icon,
    int? productCount, // from overview endpoint
  }) = _Category;
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}
```

**Brand** (mapped from `brand.openapi.json`):
```dart
@freezed
class Brand with _$Brand {
  const factory Brand({
    required String id,
    required String orgId,
    required String name,
    String? slug,
    String? logoUrl,
    int? productCount,
    required bool isDelete,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Brand;
  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
}
```

(The BE returns `Timestamp` as `{seconds, nanos}` — we add a custom `JsonConverter` in `core/network/timestamp_converter.dart`.)

### 8.3 API services

Per-feature `*_api.dart` is a thin class around dio:

```dart
class CategoryApi {
  CategoryApi(this._dio);
  final Dio _dio;

  Future<ApiResult<List<Category>>> getOverview() { ... }
  Future<ApiResult<Category>> getById(String id) { ... }
  Future<ApiResult<String>> create(CreateCategoryRequest req) { ... } // returns categoryId
  Future<ApiResult<String>> update(String id, CreateCategoryRequest patch) { ... }
  Future<ApiResult<void>> remove(String id) { ... }
}
```

(Same shape for `BrandApi`.)

### 8.4 Providers (Riverpod)

```dart
final categoryApiProvider = Provider((ref) => CategoryApi(ref.read(dioProvider)));

@riverpod
class CategoryList extends _$CategoryList {
  @override
  Future<List<Category>> build() => ref.read(categoryApiProvider).getOverview().unwrap();

  Future<void> create(CreateCategoryRequest req) async {
    await ref.read(categoryApiProvider).create(req).unwrap();
    ref.invalidateSelf();
  }
  // … update, remove
}
```

Mutations invalidate the list provider on success, which triggers a refetch — same behavior as React Query's `invalidateQueries`.

## 9. Cross-cutting

### 9.1 i18n setup

`pubspec.yaml`:
```yaml
flutter:
  generate: true   # enables gen_l10n
```

`lib/core/i18n/l10n.yaml`:
```yaml
arb-dir: lib/core/i18n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
nullable-getter: false
```

ARB files start minimal — every new string lands in both `app_en.arb` and `app_vi.arb` in the same PR. Lint rule: no raw user-facing strings in widgets (enforced by review, not tooling, in v1).

The `LocaleController` (Riverpod `Notifier<Locale>`) is wired into `MaterialApp.locale`. Persisted to `SharedPreferences` so the choice survives restarts.

### 9.2 Theming

```dart
ThemeData.from(
  colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF6750A4)), // placeholder seed
  useMaterial3: true,
)
```

`ThemeController` (Riverpod `Notifier<ThemeMode>`) gives the user system/light/dark choice. Persisted to `SharedPreferences`.

### 9.3 Avatar upload (`KAvatarUpload`)

1. Tap → `image_picker.pickImage(source: .gallery | .camera)`.
2. Compress via `package:image` to max 1024px longest edge, JPEG 85%.
3. `MultipartFile.fromBytes(...)` → `POST /v1/file/uploadBrandAvatar` (see §10).
4. On success the BE returns an S3 key. Save into the form's `logoUrl` field.
5. Preview shows the picked image while uploading (optimistic).

### 9.4 Icon picker (Category)

Web uses `lucide-react`. Flutter has `lucide_icons` package — same icon set, same names. Picker is a bottom sheet with a search field and a grid of icons; tapping returns the icon name string for `Category.icon`.

### 9.5 Color picker (Category)

A small palette of preset colors (matching the web's options if we can extract them; otherwise a sensible default set of ~12 colors). Returns a hex string for `Category.colorSettings`.

### 9.6 Error handling

- All API calls return `ApiResult<T>`. Screens render error banners on `ApiFailure`.
- Network errors → "No internet. Try again."
- 401 → log out + redirect to `/login`.
- 5xx → generic "Server error. Try again later." + log full error.
- Validation errors → surface BE message inline next to the offending field if structured, otherwise as a top-of-form banner.

### 9.7 Logging

`logger` package, single instance in `core/logging/log.dart`. Levels: `debug` (dev only), `info`, `warn`, `error`. No `print` in production code (enforced by lint).

## 10. Backend Dependencies

**Required before v1 ships:**

- **`POST /v1/file/uploadBrandAvatar`** — new BE endpoint. Mirrors existing `uploadProductAvatar`: multipart upload, returns the S3 object key, store under a new MinIO bucket `brand-avatar` (or reuse `product-avatar` with a `brands/` prefix — BE team decides).

This is the only known BE change. We'll file it as a separate ticket against `gen-barcode` and the mobile spec proceeds in parallel — Brand logo upload remains feature-flagged off in the mobile build until the BE endpoint is live.

**Not required (already exist):**
- Auth: SuperTokens emailpassword endpoints.
- Store: `/v1/store/getUserInfo`.
- Category: `CreateCategory`, `GetCategoryById`, `UpdateCategory`, `RemoveCategory`, `GetCategoryOverview`.
- Brand: `CreateBrand`, `GetBrandById`, `UpdateBrand`, `DeleteBrand`, `GetBrandOverview`.

## 11. Testing

v1 testing is light by design — get the app working end-to-end first, layer tests in subsequent specs.

| Layer | What we test in v1 |
|---|---|
| Models | `Category.fromJson` and `Brand.fromJson` round-trip golden tests. |
| API services | Unit tests with a `MockDio` for happy path + 4xx/5xx + network failure. |
| Providers | A handful of `ProviderContainer` tests for `CategoryList.create` and `BrandList.create` (invalidation + state transitions). |
| Widgets | Smoke test that `HomeShell` renders all three tabs without crashing. |
| Integration | Not in v1. |

## 12. Build / Run

```bash
# one-time (run inside the existing kuru-mobile/ directory)
flutter create --org com.kuru --project-name kuru_mobile .
flutter pub get

# run (Android emulator)
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:9190

# run (iOS simulator)
flutter run --dart-define=API_BASE_URL=http://localhost:9190

# generate freezed / riverpod / gen_l10n
dart run build_runner watch -d
flutter gen-l10n     # if not running build_runner
```

Required local services (in `../gen-barcode/`):
- BE on port 9190 (`task fullstack` or `bun --env-file=.env core/index.ts`).
- PostgreSQL, Redis, MinIO per kuru's compose setup.

## 13. Open Questions

1. **Bundle id / app name** — `com.kuru.mobile`? Confirm with user before `flutter create`.
2. **Brand color seed** — start with Material 3 default purple, or extract from kuru web's Tailwind config now? Decision: ship with default in v1, re-skin in a later spec.
3. **Category `layer` field** — required string in the BE schema, but unclear how the web uses it. Need to inspect web's `CreateCategoryDialog` to see if it's user-input, derived from `parentId`, or hard-coded.
4. **Brand logo BE endpoint** — see §10. Naming/bucket up to BE team.

## 14. Future Work (out of v1)

- Product, Order, Storage, Customer, Distributor, Expense, Tax, Variant Attribute features (each its own spec).
- Barcode scanning (`mobile_scanner` package).
- Offline-first cache (drift / sqflite + sync engine).
- Multi-store switcher UX.
- Push notifications for low-stock alerts.
- Production builds, app store distribution, CI.
- Accessibility / a11y audit.
- E2E tests (Patrol or Maestro).
