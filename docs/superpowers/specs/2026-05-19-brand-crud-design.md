# Brand CRUD v1 — design

**Date:** 2026-05-19
**Branch:** `feat/catalog-brand` (planned — currently on `feat/catalog-category`)
**Status:** design — awaiting plan
**Companion mock:** [`mocks/catalog-tab-layout.html`](../../../mocks/catalog-tab-layout.html) (variant **D — Catalog launcher** selected)

## 1. Context

Category v1 shipped on `feat/catalog-category` (CategoriesListScreen + CategoryDetailScreen + create/edit/delete flow). Brand is the next catalog primitive. BE supports it under `/api/v1/brand/*` (paths under `gen-barcode/be/core/domains/catalog/api/brand.route.ts`).

This spec covers shipping Brand CRUD as a sibling to Category under the Catalog bottom-nav tab, and refactoring `/catalog` from "lands on Categories" to "lands on a launcher screen that lets the user pick which catalog entity to manage".

## 2. Backend contract (source of truth)

Read order per CLAUDE.md: DTO → route → .d.ts → service → repo → (openapi for cross-check only).

### 2.1 Endpoints

| Verb  | Path                                | Returns                                |
|-------|-------------------------------------|----------------------------------------|
| POST  | `/api/v1/brand/CreateBrand`         | HTTP 201, `{ brandId }`                |
| GET   | `/api/v1/brand/GetBrandById`        | HTTP 200, `BrandResponse`              |
| GET   | `/api/v1/brand/GetBrandOverview`    | HTTP 200, `{ brands[], total, page, limit }` |
| PATCH | `/api/v1/brand/UpdateBrand`         | HTTP 200, `{ success: true }`          |
| POST  | `/api/v1/brand/DeleteBrand`         | HTTP 201, `{ success: true }`          |

All authenticated routes require the `x-org-id` header (attached automatically by the dio interceptor from `currentOrgIdProvider`).

### 2.2 Shapes

```ts
BrandOverviewItem { id, orgId, name, slug?, logoUrl?, productCount }
BrandResponse     { id, orgId, name, slug?, logoUrl?, isDelete, createdAt, updatedAt }

CreateBrandRequest  { name (≤120, required), slug? (≤120), logoUrl? (≤500) }
UpdateBrandRequest  { brandId, name?, slug?, logoUrl? }
DeleteBrandRequest  { brandId }            // single delete, not array

GetBrandOverviewRequest {
  searchString?,    // server-side ILIKE on name OR slug; no accent-folding
  page?  = 1,
  limit? = 50  (max 500)
}
```

### 2.3 Known BE behaviors

- `CreateBrand` rejects duplicate name within the same org with HTTP 400 and `error.message = "Brand with this name already exists"` — surface this verbatim in the form's field error slot.
- `DeleteBrand` is soft-delete (`isDelete: true`); the row stays in the DB but is hidden by `findAllOverview`'s `where`.
- `GetBrandOverview` orders by `name ASC`.
- Server-side search uses Postgres ILIKE without accent-folding, so Vietnamese diacritics matter. The mobile client compensates by doing **client-side** search with `normalizeForSearch()` (NFD + đ→d).

## 3. Decisions

| # | Decision                                           | Rationale                                                   |
|---|----------------------------------------------------|-------------------------------------------------------------|
| 1 | Catalog tab = launcher screen                       | Cleanest separation, future-proof for Distributor / Tax. Variant **D** in the mock. |
| 2 | No dedicated Brand detail screen                    | Brand is flat — no children. Tap row = open Edit sheet directly. |
| 3 | No logo input in v1                                 | Skip `logoUrl` entirely. Render initial-letter chip. Re-evaluate when storage upload lands. |
| 4 | No slug input in v1                                 | Mirrors web FE — slug is never sent. BE accepts `slug` omitted. |
| 5 | Single fetch limit=200 + client-side search         | Matches Category pattern. Accent-folded search via `normalizeForSearch()`. Re-evaluate when any org passes ~150 brands. |
| 6 | Codegen Brand API client (mirror `kuru_category_api`) | Run `tool/codegen.sh brand`. Apply the dart-dio Dart 3 library-version override patch (see `openapi-codegen` skill). |
| 7 | Reuse `KModalSheet` + `KConfirmDialog` + `KActionSheet` from `lib/design/core/` | Pattern parity with Category — same UX vocabulary across catalog. |

## 4. Navigation + routing

```
Catalog tab (StatefulShellBranch root: /catalog)
├── /catalog                       → CatalogLauncherScreen          (NEW; was CategoriesListScreen)
│
├── /catalog/categories            → CategoriesListScreen           (MOVED from /catalog)
│   └── /catalog/categories/:id    → CategoryDetailScreen           (path unchanged)
│
└── /catalog/brands                → BrandsListScreen               (NEW)
    (no /:id — tap row opens the edit sheet)
```

### 4.1 Router edits (`lib/app/router.dart`)

- Replace `path: '/catalog', builder: CategoriesListScreen` with `path: '/catalog', builder: CatalogLauncherScreen` and add child routes for `categories` and `brands`.
- `authedShellPrefixes = ['/home', '/catalog', '/settings']` still uses `startsWith`, so deeper paths under `/catalog/*` continue to match.
- No splash / bootstrap redirect changes needed.

### 4.2 Back-button behavior

- `/catalog/categories` and `/catalog/brands` are pushed onto the Catalog branch stack, so the Flutter AppBar back-button (or a `KPageHeader` back-arrow) returns to the launcher.
- Tapping the Catalog bottom-nav tab while inside `/catalog/categories` should pop to `/catalog` (launcher) — `StatefulShellBranch` already does this via `goBranch(initialLocation: true)` on tab re-tap.

## 5. Data layer

### 5.1 Generated client

```
lib/api/brand/                       ← codegen output, committed
  pubspec.yaml: name: kuru_brand_api
  pubspec.yaml in root: dependencies: kuru_brand_api: { path: lib/api/brand }
```

Run via `tool/codegen.sh brand`. Apply the language-version override patch from the `openapi-codegen` skill before committing.

### 5.2 Repository

`lib/features/catalog/brands/data/brand_repository.dart`

```dart
class BrandRepository {
  BrandRepository(this._api);
  final BrandApi _api;

  Future<ApiResult<List<BrandOverviewItem>>> overview();
  Future<ApiResult<BrandResponse>> getById(String brandId);
  Future<ApiResult<String>> create({required String name});   // returns brandId
  Future<ApiResult<void>>   update({required String brandId, required String name});
  Future<ApiResult<void>>   remove(String brandId);
}
```

- `overview()` calls `GetBrandOverview(page: 1, limit: 200)` and returns `.brands`. Pagination metadata is discarded.
- All methods return the sealed `ApiResult<T>` (success/failure) and bubble up typed `ApiException` subclasses from `lib/core/network/api_exception.dart`:
  - 400 → `BadRequestException` — `error.message` surfaced verbatim in the UI
  - 401 → `UnauthorizedException` — caught by `AuthRepository`, triggers `signOut()` + bootstrap invalidation
  - 429 RATE_LIMITED → `RateLimitedException`
  - 5xx → fallback `ServerException` with localized message "Đã có lỗi xảy ra"

### 5.3 Providers

`lib/features/catalog/brands/providers/brand_providers.dart`

```dart
@riverpod
BrandRepository brandRepository(Ref ref);

@riverpod
Future<List<BrandOverviewItem>> brandOverview(Ref ref);
```

No `brandByIdProvider` — no detail screen and the edit sheet receives the row's `BrandOverviewItem` directly.

### 5.4 Cache invalidation

Every Create / Update / Delete success calls `ref.invalidate(brandOverviewProvider)`. No cross-entity invalidation (Brand has no shared state with Category).

## 6. Screens + widgets

### 6.1 `CatalogLauncherScreen`

File: `lib/features/catalog/catalog_launcher_screen.dart`

Layout:
- `KPageHeader` with title from `l.catalogHubTitle` ("Danh mục sản phẩm")
- ListView of 4 `_LauncherCard` rows, 12px gap:
  1. Categories — `icon: TablerIcons.layout_grid`, `onTap: context.go('/catalog/categories')`
  2. Brands     — `icon: TablerIcons.shopping_bag`, `onTap: context.go('/catalog/brands')`
  3. Distributors (disabled) — `icon: TablerIcons.truck`, subtitle: `l.catalogHubComingSoon` ("Sắp có")
  4. Tax (disabled)          — `icon: TablerIcons.receipt_tax`, subtitle: `l.catalogHubComingSoon`

`_LauncherCard` is a private widget local to this file. Promote to `lib/design/core/` only when a second consumer appears (YAGNI). Style: `surfaceElev` background, 16px radius, 1px border, 20px padding, 56×56 accent-tinted big-icon chip on the left, title (17px w700) + meta (13px muted) in the middle, right chevron. Disabled = 0.55 opacity + no `onTap`.

No counts on the cards — keeps the launcher snappy by avoiding network round-trips during tab switching. Counts surface inside each list screen.

### 6.2 `BrandsListScreen`

File: `lib/features/catalog/brands/brands_list_screen.dart`

Mirrors `CategoriesListScreen` but without the Chính/Phụ tab bar:

```
SafeArea
  ├─ _BrandsHeader (centered title "Thương hiệu" + total-count subtitle + + button on right)
  ├─ KSearchBar (debounceless — pure setState, client-side filter via normalizeForSearch)
  └─ Body switch:
       loading → 4× KSkeleton(height: 80)
       error   → KEmptyState(alert_triangle, retry button)
       empty   → KEmptyState(shopping_bag, "Chưa có thương hiệu", CTA "Tạo thương hiệu")
       data    → ListView.separated(_BrandCardItem, 12px gap)
```

`_BrandCardItem`:
- 44×44 `_InitialChip(letter: name[0].toUpperCase(), bg: kAllColors[name.hashCode.abs() % kAllColors.length].swatch)`
- Body: `name` (15px w600) + meta `${productCount} sản phẩm` (12px muted)
- Trailing: `KIconBtn(dots_vertical, size 32)` → `showBrandActionMenu`
- `GestureDetector(onLongPress: showBrandActionMenu, onTap: showCreateEditBrandSheet(EditBrand(brand)))`

### 6.3 `BrandActionMenu`

File: `lib/features/catalog/brands/widgets/brand_action_menu.dart`

```dart
enum BrandAction { edit, delete }
Future<BrandAction?> showBrandActionMenu({ ... });
```

Implemented via `showKActionSheet<BrandAction>` with two items: Edit + Delete. No "Add subcategory" (Brand is flat).

### 6.4 `CreateEditBrandSheet`

File: `lib/features/catalog/brands/widgets/create_edit_brand_sheet.dart`

```dart
sealed class BrandSheetMode {}
class CreateBrand extends BrandSheetMode {}
class EditBrand   extends BrandSheetMode { final BrandOverviewItem brand; }

Future<bool?> showCreateEditBrandSheet({ required BuildContext context, required BrandSheetMode mode });
```

`showKModalSheet<bool>` body:
- Title: `l.brandCreateTitle` / `l.brandEditTitle`
- One `KFormField` — label `l.brandFieldNameLabel`, hint `l.brandFieldNameHint`, `maxLength: 120`, `autofocus: true`, `errorText` slot for client-side empty + server 400 dup-name
- Confirm label: `l.brandCreateCta` / `l.brandEditCta`
- `onConfirm`:
  - Empty name → set errorText `l.brandFieldNameRequired`, return without closing
  - Call `repo.create(name:)` or `repo.update(brandId:, name:)`
  - `ApiSuccess` → return `true`, dialog closes
  - `ApiFailure<BadRequestException>` → set errorText to the BE message, stay open
  - Other failures → close + outer SnackBar via `KNotify.networkError(..., onRetry: _submit)`

## 7. Error handling + UX feedback

### 7.1 Field-level (inside sheet)

| Trigger                          | Where         | Message                                  |
|----------------------------------|---------------|------------------------------------------|
| Empty name (client-side)         | KFormField    | `l.brandFieldNameRequired`               |
| BE 400 dup-name                  | KFormField    | `error.message` verbatim                 |
| BE 400 other                     | KFormField    | `error.message` verbatim                 |

### 7.2 Screen-level (SnackBar / dialog)

| Trigger                          | Pattern                                              |
|----------------------------------|------------------------------------------------------|
| Create/Update success            | `KNotify.success(context, l.brandNotifySaved)`       |
| Delete success                   | `KNotify.success(context, l.brandNotifyDeleted)`     |
| List load network down / 5xx     | `KEmptyState` with retry button (NOT toast)          |
| Mutation network down / 5xx      | `KNotify.networkError(context, msg, onRetry: ...)`   |
| 429 RATE_LIMITED                 | `KNotify.warning(context, msg)`                      |
| 401 mid-flow                     | `signOut()` + `ref.invalidate(appBootstrapProvider)` — router redirects to /login |

### 7.3 Delete confirm

```dart
showKConfirmDialog(
  context: context,
  title:        l.brandDeleteConfirmTitle,         // "Xóa thương hiệu?"
  subtitle:     l.brandDeleteConfirmBody(name),     // "Hành động không thể hoàn tác..."
  confirmLabel: l.brandDeleteConfirmCta,            // "Xóa"
  onConfirm: () async { await repo.remove(id); },
);
```

The dialog stays open with a spinner during the await. If `onConfirm` rethrows, the dialog closes with `null`; the kebab/long-press handler in `_BrandCardItem` then shows `error.message` verbatim via SnackBar (covers future "Brand has products" rejection if BE adds it). This mirrors `_CategoryCardItem._confirmAndDelete`.

### 7.4 Loading affordances

- List skeleton on first load. Riverpod's `keepPrevious` keeps existing data on `invalidate`, so subsequent refreshes don't flash skeleton.
- `KModalSheet` and `KConfirmDialog` confirm buttons show their built-in `KSpinner` during the awaited handler.

## 8. l10n strings

Add to `lib/core/i18n/app_vi.arb` (canonical) and `lib/core/i18n/app_en.arb` (mirror). Wording is first-pass; final copy may tweak during implementation.

### 8.1 Catalog hub

```
catalogHubTitle             "Danh mục sản phẩm"      / "Catalog"
catalogHubCategoriesTitle   "Danh mục"               / "Categories"
catalogHubCategoriesSub     "Tổ chức sản phẩm theo nhóm" / "Group products by group"
catalogHubBrandsTitle       "Thương hiệu"            / "Brands"
catalogHubBrandsSub         "Quản lý các nhà sản xuất" / "Manage manufacturers"
catalogHubDistributorsTitle "Nhà phân phối"          / "Distributors"
catalogHubTaxTitle          "Thuế"                   / "Tax"
catalogHubComingSoon        "Sắp có"                 / "Coming soon"
```

### 8.2 Brand list

```
brandTitle              "Thương hiệu"             / "Brands"
brandTotalCount         "{count} thương hiệu"     / "{count, plural, one{# brand} other{# brands}}"
brandSearchHint         "Tìm thương hiệu..."      / "Search brands..."
brandStatProducts       "{count} sản phẩm"        / "{count, plural, one{# product} other{# products}}"
brandEmptyTitle         "Chưa có thương hiệu"     / "No brands yet"
brandEmptyBody          "Tạo thương hiệu đầu tiên để gom sản phẩm theo nhà sản xuất." / "Create your first brand to group products by manufacturer."
brandEmptyAction        "Tạo thương hiệu"         / "Create brand"
brandLoadError          "Không tải được danh sách thương hiệu" / "Could not load brands"
brandLoadRetry          "Thử lại"                 / "Retry"
```

### 8.3 Create/Edit sheet

```
brandCreateTitle        "Tạo thương hiệu"         / "Create brand"
brandEditTitle          "Chỉnh sửa thương hiệu"   / "Edit brand"
brandFieldNameLabel     "Tên thương hiệu *"       / "Name *"
brandFieldNameHint      "VD: Bosch, Makita, Stanley" / "e.g. Bosch, Makita, Stanley"
brandFieldNameRequired  "Tên thương hiệu là bắt buộc" / "Name is required"
brandCreateCta          "Tạo"                     / "Create"
brandEditCta            "Cập nhật"                / "Update"
```

### 8.4 Delete confirm

```
brandDeleteConfirmTitle "Xóa thương hiệu?"        / "Delete brand?"
brandDeleteConfirmBody  "Hành động không thể hoàn tác. {name} sẽ bị xóa." / "Cannot be undone. {name} will be deleted."
brandDeleteConfirmCta   "Xóa"                     / "Delete"
```

### 8.5 Notifications + action menu

```
brandNotifySaved        "Đã lưu thương hiệu"      / "Brand saved"
brandNotifyDeleted      "Đã xóa thương hiệu"      / "Brand deleted"
brandNotifyServer       "Đã có lỗi xảy ra"        / "Something went wrong"
brandActionEdit         "Chỉnh sửa"               / "Edit"
brandActionDelete       "Xóa"                     / "Delete"
```

## 9. Testing plan

Tests follow Category's TDD discipline and live under `test/features/catalog/brands/` and `test/features/catalog/`.

### 9.1 Repo unit tests

`test/features/catalog/brands/data/brand_repository_test.dart` — dio `MockAdapter` for:
- `overview()` success with 3 brands + paged response shape
- `overview()` 401 → `UnauthorizedException`
- `overview()` 5xx → localized fallback
- `create(name:)` success → returns `brandId`
- `create(name:)` 400 dup-name → `BadRequestException` with verbatim `"Brand with this name already exists"`
- `update(brandId:, name:)` success
- `delete(brandId:)` success
- `delete(brandId:)` 400 → `BadRequestException`

### 9.2 Widget tests

- `brands_list_screen_test.dart` — list renders cards, total-count subtitle, empty state, error state, search filters client-side incl. Vietnamese accent ("nuoc" → "Nước"), tap card → edit sheet opens
- `widgets/create_edit_brand_sheet_test.dart` — empty name → errorText; success → sheet closes + SnackBar; edit prefills name; dup-name 400 → errorText stays open
- `widgets/brand_action_menu_test.dart` — long-press / kebab opens action sheet; Edit / Delete return the right enum
- `catalog_launcher_screen_test.dart` — 4 cards render (2 live + 2 disabled); tap Categories → `/catalog/categories` invoked; tap Brands → `/catalog/brands` invoked; tap disabled card → no navigation

### 9.3 End-to-end regression tests

Mirror the Category set:
- `brand_create_flow_test.dart`
- `brand_edit_flow_test.dart`
- `brand_delete_flow_test.dart`

Each spins up a router + dio mock, drives the full user gesture (launcher → list → +/kebab → sheet → confirm → assert SnackBar + invalidation).

### 9.4 Gotchas (per CLAUDE.md)

- `KSpinner` / `KSkeleton` / `KPrimaryBtn` animations never settle. Use `pump()` + `pump(Duration(milliseconds: 50))` to step microtasks. **Do not call `pumpAndSettle()`** in any test that mounts those widgets.
- Override `appBootstrapProvider` with `BootstrapAuthed(testUser)` for any authed-screen test.
- Override `currentOrgIdProvider` so the dio `x-org-id` interceptor doesn't trip.

## 10. Out of scope (deferred)

- **Logo upload.** Requires wiring `kuru_storage_api` + `image_picker` plugin. Punt to v1.1.
- **Brand detail screen.** No drill-down view. Re-evaluate when "Products in brand" lands.
- **Slug field.** Web doesn't ship it; mobile doesn't either. BE accepts it omitted.
- **Server-side pagination / infinite scroll.** Replace the limit=200 single fetch when any real org passes ~150 brands.
- **Brand → product navigation.** Tapping a brand card does NOT navigate to a product list yet.
- **Bulk operations.** No bulk delete, no multi-select. Delete is one-at-a-time per BE shape.

## 11. Risks + migrations

| Risk | Mitigation |
|---|---|
| `tool/codegen.sh` produces dart-dio output that hits the Dart 3 library-version mismatch | Apply the canonical fix from `.claude/skills/openapi-codegen/SKILL.md` before committing. Do not ship until `flutter analyze` returns 0. |
| `/catalog` route refactor surprises a deep link / push notification | None known (router has no inbound `/catalog` deep links today). `authedShellPrefixes` uses `startsWith` so subroutes keep working. |
| Existing widget tests that mount `CategoriesListScreen` at `/catalog` fail after the route move | Update those tests to push `/catalog/categories` instead. Tracked as part of the implementation plan, not a separate risk. |
| BE adds "Brand has products" rejection during this work | The delete confirm already surfaces `BadRequestException.message` verbatim, so the UX is forward-compatible. No code change needed when BE ships it. |

## 12. File inventory

**New files**

```
lib/api/brand/                                                      (codegen output)
lib/features/catalog/catalog_launcher_screen.dart
lib/features/catalog/brands/brands_list_screen.dart
lib/features/catalog/brands/data/brand_repository.dart
lib/features/catalog/brands/providers/brand_providers.dart
lib/features/catalog/brands/widgets/brand_action_menu.dart
lib/features/catalog/brands/widgets/create_edit_brand_sheet.dart

test/features/catalog/catalog_launcher_screen_test.dart
test/features/catalog/brands/brands_list_screen_test.dart
test/features/catalog/brands/data/brand_repository_test.dart
test/features/catalog/brands/widgets/brand_action_menu_test.dart
test/features/catalog/brands/widgets/create_edit_brand_sheet_test.dart
test/features/catalog/brand_create_flow_test.dart
test/features/catalog/brand_edit_flow_test.dart
test/features/catalog/brand_delete_flow_test.dart
```

**Edited files**

```
lib/app/router.dart                                                 (move /catalog → launcher; add /catalog/categories + /catalog/brands)
lib/core/i18n/app_vi.arb                                            (l10n keys §8)
lib/core/i18n/app_en.arb                                            (l10n keys §8)
pubspec.yaml                                                        (path-dep kuru_brand_api)
test/features/catalog/categories/*                                  (update any explicit '/catalog' path to '/catalog/categories')
```
