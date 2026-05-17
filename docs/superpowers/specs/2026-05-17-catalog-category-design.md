# Catalog v1 — Categories module design

**Date:** 2026-05-17
**Branch target:** `release/v0.4.0` (cut from `release/v0.3.0`)
**Tag candidates:** `v0.4.0-catalog-scaffold` (after Plan 1), `v0.4.0-catalog-category` (after Plan 2)
**Status:** approved for plan writing

---

## 1. Overview & scope

Catalog v1 ships the first content-screen feature on top of the flat design system from `v0.3.0-core-design`. This spec covers the first module — **Categories** — plus two pieces of infrastructure that every future module needs:

1. **`openapi_generator_cli` toolchain** — replaces hand-rolled repositories. One annotated host file in `lib/core/network/`, `dart-dio` templates, output committed to `lib/api/`.
2. **`MainShell` with bottom navigation** — three tabs (Home / Catalog / Settings) using `StatefulShellRoute.indexedStack`. Replaces the current flat go_router config for authenticated routes. Each tab keeps its own nav stack.

Inside the Catalog tab, Categories supports the full 5-layer hierarchy the BE allows, with create / edit / delete, drill-down detail screens, search (Vietnamese-diacritic-normalized), and layer-filter pill tabs.

### Why now

- The 20 widgets shipped in `lib/design/core/` are not yet exercised by a real feature. Categories is the first screen built entirely from them.
- `AuthRepository`'s hand-rolled pattern does not scale to 16 BE modules. Codegen is the gate before further BE integration work.
- Without bottom nav there is nowhere to put a Settings entry point, and no scaffold for future Brand / Product / POS tabs.

### Deliverables

- One spec (this document)
- Two implementation plans (see Section 7)
- One release branch `release/v0.4.0` with two feature PRs

---

## 2. Out of scope

The following are explicitly **not** part of this spec — they will land in later specs.

| Item | Why deferred |
|---|---|
| Brand module | Next module after Categories ships; reuses the codegen + nav infrastructure delivered here |
| Product module | Depends on both Categories and Brands |
| Real Home screen content (Overview KPIs) | Home tab keeps existing `HomeStubScreen` body |
| Real Settings content (palette / locale pickers) | Settings tab gets a placeholder stub screen |
| Permission gating (`category.write` etc.) | BE supports it; mobile defers until a permissions provider lands |
| Optimistic mutations | Pessimistic (spinner → success → refresh) for v1; reconsider if it feels sluggish |
| Visual goldens | None in repo today; not introducing them |
| Per-module ARB files | Mobile keeps single `app_en.arb` / `app_vi.arb`; revisit when > 500 entries |
| Per-package monorepo (VGV layered architecture) | Single-package layout for v0.4.0; introduce packages when ≥ 2 features share code |
| Bulk delete UI | BE accepts `categoryIds[]`; mobile sends a one-element array for now |

---

## 3. Architecture

### 3.1 Codegen toolchain

**Packages (add to `pubspec.yaml`):**

```yaml
dependencies:
  built_value: ^8.x          # runtime dep required by dart-dio output
  built_collection: ^5.x     # runtime dep required by dart-dio output

dev_dependencies:
  openapi_generator: ^5.x        # @Openapi annotation host
  openapi_generator_cli: ^5.x    # CLI invoked by build_runner
  built_value_generator: ^8.x    # builds @BuiltValue classes from generated sources
```

**Generator template:** `dart-dio` (uses `dio` + `built_value`). Mature, well-supported, integrates with our existing dio.

**Scope of generation for v0.4.0: category only.** The annotation host file (`lib/core/network/openapi_clients.dart`) declares **one stub class per spec being generated**, each with its own `@Openapi(...)` annotation (the generator emits one client per annotated class — they cannot share a class). v0.4.0 has exactly one annotated class targeting `category.openapi.json`. Future modules (Brand, Product, ...) add one stub class each in their own spec/plan — not bundled into v0.4.0. This is a deliberate revision from an earlier "generate all 16 up front" idea: per CLAUDE.md the openapi files are unreliable, and pre-generating modules we won't use until v0.5+ would commit thousands of lines of code that might be wrong anyway.

**Output path:** `lib/api/category/` for v0.4.0. Future modules: `lib/api/<module>/`. Generated code is **committed** to git (see Section 9 decision #1) — at one-module scale the diff impact is acceptable.

**Workflow:** `dart run build_runner build --delete-conflicting-outputs` after the openapi spec changes. CI does not have a stale-codegen gate today (no `.github/workflows/` in repo); spec does not require adding one. Treat "regenerate before commit" as developer discipline.

**Pre-generation sanity check (mandatory per CLAUDE.md "Source-of-truth ordering").** Before accepting any generated client into Plan 1, verify it against the BE source-of-truth files in this order:

1. `../gen-barcode/be/core/dto/category/*.dto.ts` — request body validation rules
2. `../gen-barcode/be/core/domains/catalog/api/category.route.ts` — actual handler shape
3. `../gen-barcode/be/types/category.d.ts` — generated TS response types
4. `../gen-barcode/be/core/domains/catalog/services/category.service.ts` — what `resData` actually contains

If the generated Dart model disagrees with `category.d.ts` or the service `resData`, patch a copy of `category.openapi.json` in `tool/openapi-patches/category.openapi.json` and point the `@Openapi` annotation at the patched copy. The handler / service / `.d.ts` win — never the openapi file. Do not modify files in `../gen-barcode/openapi/` from this repo.

### 3.2 dio integration

The generated client constructor accepts a `Dio` instance. We pass the existing `dioProvider` (`lib/core/network/dio_client.dart`) which already wires:

- SuperTokens header-mode session handling
- `x-org-id` interceptor (reads `currentOrgIdProvider`)
- Logging interceptor (request method/url + response status)
- Error-mapping interceptor (DioException → typed `ApiException`)

The generated client's own default Dio config is **not** used.

**Base path handling (load-bearing).** Our `dioProvider` keeps `baseUrl = Env.apiBaseUrl` (host root) because `AuthRepository` calls `/auth/*` at host root and `/api/v1/profile/*` with the prefix hand-written into each call. The openapi specs for `/api/v1/*` modules have their `servers[0].url` set to `${host}/api/v1` (verify per spec). Two viable approaches:

- **(a) Pass `basePathOverride` when constructing the generated client** — `categoryApiClientProvider` does `CategoryApi(dio: dio, basePathOverride: '${apiBaseUrl}/api/v1')`. Each module sets its own override.
- **(b) Patch the openapi `servers[0].url` to a relative `/api/v1`** in `tool/openapi-patches/category.openapi.json`. Dio's `baseUrl` (host root) plus the relative server URL plus the operation path resolves to `${host}/api/v1/category/CreateCategory`.

**Decision:** **(a) — `basePathOverride`**. It keeps the openapi files untouched when they're already correct, and makes the wiring explicit at the Riverpod-provider level (one obvious place to look). The patch directory is reserved for cases where the openapi shape itself is wrong (per §3.1).

### 3.3 Routing

Replace the current authenticated portion of `lib/app/router.dart` with `StatefulShellRoute.indexedStack`:

```
Authenticated branch (gated by appBootstrapProvider redirect):
  /home                          → HomeTabScreen (= existing HomeStubScreen body)
  /catalog                       → CategoriesListScreen
  /catalog/categories/:id        → CategoryDetailScreen
  /settings                      → SettingsStubScreen

Unauthenticated (unchanged):
  /splash, /onboarding, /login, /register, /totp, /totp/recovery,
  /create-org, /org-picker
```

The existing redirect logic (Splash → bootstrap → /login | /totp | /create-org | /org-picker | /home) is preserved. Only the post-bootstrap "home" target changes from a flat `/home` to the indexed-stack shell, with `/home` as the default tab.

### 3.4 State layer (Riverpod)

```
authProvider (existing)            currentOrgIdProvider (existing)
        │                                      │
        ▼                                      ▼
              dioProvider (existing — interceptor reads orgId)
                            │
                            ▼
              categoryApiClientProvider (new)
                  wraps generated CategoryApi(dio, basePathOverride: ...)
                            │
        ┌───────────────────┼──────────────────────┐
        ▼                   ▼                      ▼
categoryOverviewProvider   categoryByIdProvider.family   CategoryRepository
   (FutureProvider          (FutureProvider                (plain class,
    watching                 .family<String>)               not a provider)
    currentOrgIdProvider)
```

**`categoryOverviewProvider`** is the single source of truth for the category list. `CategoryDetailScreen` reuses it (client-side filter on `parentId`) rather than calling `GetCategoryTree`. This means **one network round-trip** per Catalog tab visit, not one-per-screen.

The provider body **must** `ref.watch(currentOrgIdProvider)` so that switching org (OrgPicker re-entry) auto-invalidates the cached list. The dio interceptor alone won't trigger re-fetch — Riverpod's dependency graph does.

**`categoryByIdProvider.family<String>`** (key is the UUID as a string). The provider body calls `repo.getCategoryById(GetCategoryByIdDto(categoryId: key))` — the generated client expects a DTO object in the POST body, not a path/query param. Also `ref.watch(currentOrgIdProvider)`.

**Mutations are not a separate provider.** Instead, `CategoryRepository` exposes `create / update / remove` methods that return `ApiResult<T>` and own no UI state. The widget invoking them (modal sheet, confirm dialog) controls its own `isSubmitting` flag via local state (or `KModalSheet.loadingBody`). This avoids the "concurrent delete-then-create races wipe each other's error" problem of a shared `AsyncNotifier`.

**Invalidation on mutation success (the widget that triggered it does this — repository does not touch `ref`):**

| Mutation | What to invalidate |
|---|---|
| `create(root)` | `categoryOverviewProvider` |
| `create(nested)` | `categoryOverviewProvider`, `categoryByIdProvider(parentId)` (parent's `subCategoriesCount` changed) |
| `update(id)` | `categoryOverviewProvider`, `categoryByIdProvider(id)` |
| `remove([id])` | `categoryOverviewProvider`, `categoryByIdProvider(id)` (force refetch → 404 → AsyncError; CategoryDetailScreen pops to list on error). If category had a `parentId`, also `categoryByIdProvider(parentId)`. |

### 3.5 Repository layer

New file: `lib/features/catalog/categories/data/category_repository.dart`.

Responsibilities:
- Wrap each generated client method (`CreateCategory`, `GetCategoryById`, `UpdateCategory`, `RemoveCategory`, `GetCategoryOverviewWithDepth`).
- Translate `DioException` → `ApiException` (reuse existing extractor in `lib/core/network/api_exception.dart`, after Plan 1 splits 401/403 — see §6.2).
- Return `ApiResult<T>` (existing sealed class) so callers `switch` on success/failure without try/catch.
- Use generated `CategoryResponse` model directly — no parallel freezed layer.
- Own no UI/notifier state. Callers (widgets) manage their own loading flags.

`GetCategoryTree` and `GetCategoryOverview` (no-depth) are **not** wrapped — mobile only consumes `GetCategoryOverviewWithDepth`, which returns the full flat list with `layer` baked in.

### 3.6 File layout (new additions)

```
lib/
├── api/
│   └── category/                     ← generated; committed (v0.4.0 only ships this one)
├── core/network/
│   ├── openapi_clients.dart          ← @Openapi annotation host (one stub class for v0.4.0)
│   └── api_exception.dart            ← extend with ForbiddenException (see §6.2)
└── features/
    ├── main_shell/
    │   └── main_shell.dart           ← StatefulShellRoute + NavigationBar
    ├── catalog/
    │   ├── catalog_tab_screen.dart   ← Catalog tab landing (= Categories list for v0.4.0)
    │   └── categories/
    │       ├── categories_list_screen.dart
    │       ├── category_detail_screen.dart
    │       ├── create_edit_category_sheet.dart
    │       ├── data/
    │       │   └── category_repository.dart
    │       └── providers/
    │           └── category_providers.dart
    └── settings/
        └── settings_stub_screen.dart

tool/
└── openapi-patches/                  ← created empty; populated only if a spec needs patching
```

---

## 4. BE contract reference

### 4.1 Category model fields

#### Request fields (Create / Update body)

Source of truth: `../gen-barcode/be/core/domains/catalog/dto/category/*.dto.ts`.

| Field | Type | Required | Default | Notes |
|---|---|---|---|---|
| `name` | string | yes | — | Trim + min 1; BE rejects with `"name is required"` |
| `parentId` | UUID or `NIL_UUID` | optional | `NIL_UUID` | `NIL_UUID` = root |
| `colorSettings` | string | optional | `"slate-400"` (web default) | Hex / token from `allColors` |
| `layer` | string (numeric) | yes (BE) | computed by mobile | `"1"` for root; `parent.layer + 1` otherwise. Max `"5"`. **Never user-input.** |
| `description` | string | optional | `""` | Trim |
| `status` | enum | yes | `"ACTIVE"` | `ACTIVE` / `INACTIVE` / `ARCHIVED` |
| `icon` | string | optional | `"layout-grid"` (web default) | Name from curated icon set |

#### Response-only fields (returned by `GetCategoryById` and `GetCategoryOverviewWithDepth`)

Source of truth: `../gen-barcode/be/types/category.d.ts` + `../gen-barcode/be/core/domains/catalog/services/category.service.ts` (`resData` shape).

| Field | Type | Notes |
|---|---|---|
| `categoryId` | UUID | Primary key. Required on every response. |
| `subCategoriesCount` | number | Direct children count. Used in list subtitle "N sub". |
| `itemCount` | number | Products in this category. Used in list subtitle "N items". |
| `totalValue` | number | Sum of `price × quantity`. Not displayed in v0.4.0. |
| `lowStockCount` | number | Count of products at/below min stock. Not displayed in v0.4.0. |
| `parentName` | string \| null | Parent's display name. Used in Create/Edit sheet's "Parent: …" line. |

The generated `CategoryResponse` model includes all of these; widgets pick only the ones they need.

### 4.2 Endpoints (mounted under `/api/v1/category`)

| Method + path | Returns | Mobile uses? |
|---|---|---|
| `POST /CreateCategory` | 201 + `{ categoryId, ... }` | Yes |
| `POST /GetCategoryById` | 200 + `CategoryResponse` | Yes (for edit prefill) |
| `PUT /UpdateCategory` | 200 + updated category | Yes |
| `POST /RemoveCategory` | 201 + `{ removedIds }` | Yes |
| `GET /GetCategoryOverview` | 200 + flat list (no depth) | **No** |
| `GET /GetCategoryOverviewWithDepth?depth=5` | 200 + flat list with `layer` | Yes — primary list source |
| `GET /GetCategoryTree?categoryId=...` | 200 + subtree | **No** — use overview filter instead |

### 4.3 Layer rules (enforced by BE service, mirrored by mobile)

- Layer `"1"` (root): `parentId` must be `NIL_UUID` (or omitted).
- Layer > `"1"`: `parentId` must be a real UUID; BE re-derives `layer = parent.layer + 1`.
- Max layer: `5`. Beyond → BE returns 400 `"max layer is 5"`.

Mobile computes `layer` at submit time from context (root create vs nested create vs edit). Users never see or pick a layer value.

---

## 5. Screens & UX

### 5.1 MainShell

`StatefulShellRoute.indexedStack` with Material 3 `NavigationBar`. Active tint = `KuruColors.accent` (theme-aware across the 4 palettes).

```
┌─────────────────────────────┐
│                             │
│      (active tab body)      │
│                             │
├─────────────────────────────┤
│  Home   │ Catalog │ Settings│
└─────────────────────────────┘
```

Icons (Tabler): `home`, `category` (= `layout-grid`), `settings`.

### 5.2 CategoriesListScreen

Composed entirely from existing flat widgets — no new design primitives.

```
┌─────────────────────────────────────┐
│ Categories                       +  │  KPageHeader, trailing KIconBtn
│ Manage product classifications      │
│ ┌─────────────────────────────┐    │  KSearchBar
│ │ 🔍 Search categories...      │    │
│ └─────────────────────────────┘    │
│ ┌All 12┐┌Main 4┐┌Sub 6┐┌Sub Sub 2┐ │  KTabNav (scrollable pills)
│ └──────┘└──────┘└─────┘└──────────┘ │
│                                     │
│ 🎨 Electronics              ›       │  KListRow per category
│    8 sub · 124 items                │
│ ─────────────────────────────────  │
│ 🥗 Food & Beverage          ›       │
│    3 sub · 56 items                 │
└─────────────────────────────────────┘
```

**Behaviors:**

- **Trailing `+`** → opens create modal at root (`parentId = NIL_UUID`, `layer = "1"`).
- **Search:** Vietnamese-normalized — port `normalizeForSearch` from web FE (`NFD` decomposition + `đ→d` + lowercase). Filter is client-side over the cached overview list.
- **Layer tabs:** derived from data. "All" + each distinct `layer` present, sorted numerically. Labels come from ARB — verified against `../gen-barcode/fe/src/locales/en/category.json` which has these exact keys (port them, do not invent new ones):
  - `"1"` → `l10n.categoryLayerMain` ("Main" / "Cấp chính")
  - `"2"` → `l10n.categoryLayerSub` ("Sub" / "Cấp phụ")
  - `"3"` → `l10n.categoryLayerSubSub` ("Sub Sub" / "Cấp phụ phụ")
  - `"4"` / `"5"` → `'${l10n.categoryLayerPrefix} $n'` ("Layer 4" / "Cấp 4") — matches web FE's `${layerPrefix} ${layer}` concatenation. No parameterized ICU plural; the prefix + number is assembled in Dart.
  - Plus `l10n.categoryLayerAll` ("All" / "Tất cả") for the All tab.
  - Count badge per tab. Default = "All". Layer filter held in widget state (not URL).
  - Edge case: when category list is empty, no layer tabs render at all (only the empty state shows).
- **Search ↔ layer-tab interaction:** search filters within the **active** layer (matches web FE behavior). Count badges reflect total per layer (not search-filtered count) so users see how much they're hiding by typing.
- **Rows:** `KListRow` with `leading` = icon container colored by `colorSettings`, `title` = name, `subtitle` = stats joined by " · ". Subtitle composition:
  - If BE returns `subCategoriesCount > 0`: include `"N sub"`.
  - If BE returns `itemCount > 0`: include `"N items"`.
  - If neither: omit subtitle.
- **Tap row** → push `/catalog/categories/:id`.
- **Long-press row** → `KPopupMenu` with `Edit` and `Delete` (danger). No "View" item — tap already views.
- **Loading:** `KSkeleton` rendering 3-5 skeleton rows.
- **Empty:** `KEmptyState` with localized "No categories yet" + primary action "Create first category" (opens create modal at root).

### 5.3 CategoryDetailScreen

```
┌─────────────────────────────────────┐
│ ← Electronics                       │  AppBar, back + name
├─────────────────────────────────────┤
│ 🎨 Electronics                      │  Header card (large icon, name, description)
│    Audio, mobile, accessories...    │
│    [ Edit ] [ Add subcategory ]     │  Two KSecondaryBtn
│                                     │
│ Subcategories (3)                   │  Section label
│ ─────────────────────────────────  │
│ 🎧 Audio                       ›   │  Same KListRow style
│ 📱 Mobile                      ›   │
│ 🔌 Accessories                 ›   │
└─────────────────────────────────────┘
```

**Data:** read `categoryByIdProvider(:id)` for the root, and filter `categoryOverviewProvider` where `parentId == :id` for children. No `GetCategoryTree` call.

**Behaviors:**

- "Add subcategory" opens create modal with `parentId = currentId` and `layer = parent.layer + 1` pre-filled. If `parent.layer == "5"` → button is disabled with tooltip / `KNotify.info` "Max nesting depth reached."
- "Edit" opens edit modal with current values pre-filled.
- Tap subcategory → push another `CategoryDetailScreen`. Drill-down can stack up to 5 deep (= max layer).

### 5.4 Create/Edit modal sheet

One widget — `CreateEditCategorySheet` — with three modes:

| Mode | Trigger | `parentId` | `layer` | Title |
|---|---|---|---|---|
| `createRoot` | List header `+` | `NIL_UUID` | `"1"` | "New category" |
| `createNested` | Detail screen "Add subcategory" | parent's id | `parent.layer + 1` | "New subcategory" |
| `edit` | Long-press → Edit, or detail "Edit" | unchanged | unchanged | "Edit category" |

```
┌─────────────────────────────────────┐
│ New category                    ✕   │
│ ─────────────────────────────────  │
│ Name *                              │
│ [_____________________________]    │
│                                     │
│ Status                              │
│ [ Active ▾ ]                        │
│                                     │
│ Description                         │
│ [_____________________________]    │
│ [_____________________________]    │
│                                     │
│ Icon         Color                  │
│ [📦 Box]    [🟢 Green]              │
│                                     │
│ (Parent: Electronics)               │  shown in createNested + edit only
│                                     │
│ ─────────────────────────────────  │
│        [ Cancel ]   [ Save ]        │
└─────────────────────────────────────┘
```

**Widgets used:** `showKModalSheet` (existing) with body composed of `KTextField` (name), `KSelect` (status — `KSelect` is the right widget here since status has 3 static options), `KTextarea` (description), and **two small custom tappable preview tiles** for Icon and Color. Each tile shows a leading swatch/icon, a label, and a chevron; tap opens `showKIconPicker` / `showKColorPicker` respectively. They are *not* `KSelect` instances — `KSelect` per its widget docstring opens `showKActionSheet` with a static option list, which would not work for these pickers. Implementer should build the tile as a small composite widget (essentially a `Material.InkWell` over `KListRow`-style internals) or extend `KSelect` with an `onTap` override — pick whichever is more idiomatic when implementing. Parent display = plain text row.

**Parent name resolution.** In `createNested` mode, the parent name is **passed in by the caller** (the CategoryDetailScreen has the parent category in its `categoryByIdProvider(parentId)` snapshot already). In `edit` mode, use `categoryResponse.parentName` (response-only field, see §4.1). The sheet does not look up parent via the overview list — that creates an unnecessary dependency.

**Defensive guard for stale state.** Sheet refuses to open in `createNested` mode if `parent.layer == "5"` (silently — the caller is expected to disable the entry button per §5.3). If somehow opened anyway, sheet shows `KEmptyState` with "Max nesting depth reached" instead of the form.

**Defaults (mirror web FE):** `status = ACTIVE`, `color = "slate-400"`, `icon = "layout-grid"`.

**Validation:**
- Name empty → `KFormField.errorText: "Name is required"` (or whatever BE returns verbatim in 400).
- Other field errors → inline error banner inside sheet body.

**Submit flow:**
1. `KModalSheet.loadingBody` shows during the awaited mutation.
2. Repository call via `CategoryRepository.create(...)` or `.update(...)` — returns `ApiResult<T>`.
3. On success → close sheet → `KNotify.success("Category created" / "Category updated")` → `ref.invalidate(categoryOverviewProvider)`.
4. On error → sheet stays open; surface per error matrix in Section 6.

### 5.5 Delete flow

Long-press row → `KPopupMenu` → tap "Delete":

→ `showKConfirmDialog`:
- Title: "Delete category?"
- Body: `"{name} will be removed. This cannot be undone."`
- Cancel + Delete (danger).
- `onConfirm: () async { ... }` — dialog stays open with spinner during await.

→ `CategoryRepository.remove(categoryIds: [id])` — BE expects array even for single delete.

→ On success → close dialog → `KNotify.success("Category deleted")` → invalidate overview.

→ On error (e.g. BE rejects because category has children) → surface per error matrix; dialog closes only on success.

### 5.6 HomeTabScreen, SettingsStubScreen

- **HomeTabScreen:** re-uses the existing `HomeStubScreen` body. No design changes.
- **SettingsStubScreen:** placeholder with title "Settings" and a centered "Coming soon" message. Wired into MainShell so the tab is reachable.

---

## 6. Data flow & error handling

### 6.1 Mutation flow

1. User submits / confirms.
2. The widget that triggered the mutation sets its own `isSubmitting = true` local state. UI shows spinner state (KModalSheet `loadingBody` / KConfirmDialog inline spinner during awaited `onConfirm`).
3. Repository method called; returns `ApiResult<T>` (no exceptions escape).
4. On `ApiResult.success` → `ref.invalidate(...)` per §3.4 invalidation table → close sheet/dialog → `KNotify.success`.
5. On `ApiResult.failure(ApiException)` → sheet/dialog stays open → widget switches on the exception type and surfaces per matrix below.

### 6.2 Error matrix

**Pre-requisite work in Plan 1 (load-bearing):** the existing `_ErrorMappingInterceptor` in `lib/core/network/dio_client.dart` currently maps **both 401 and 403** to a single `UnauthorizedException`. The matrix below requires distinguishing them at the repository layer. Plan 1 must:

1. Add `ForbiddenException` to `lib/core/network/api_exception.dart` (sibling of `UnauthorizedException`).
2. Update `_ErrorMappingInterceptor` so that `response.statusCode == 403` → `ForbiddenException`, `401` → `UnauthorizedException` (existing behavior preserved).
3. Audit `AuthRepository` for any code that currently catches `UnauthorizedException` and intends 403 too — none expected, but verify.

Once that's done:

| BE response | Mapped to | UX |
|---|---|---|
| HTTP 400 + `error.message` mapping to a field | `ValidationException` | `KFormField.errorText` on that field — message verbatim |
| HTTP 400 + non-field message | `ValidationException` | Inline error banner inside the sheet |
| HTTP 401 | `UnauthorizedException` | `KNotify.error` toast → `signOut()` → router → `/login` |
| HTTP 500 with body containing `"Session does not exist"` | `UnauthorizedException` (interceptor remaps; existing pattern from `AuthRepository`) | Same as 401 |
| HTTP 403 | `ForbiddenException` (**new in Plan 1**) | `KNotify.warning("You don't have permission to do that.")`; sheet stays open |
| HTTP 429 + `code: RATE_LIMITED` | `RateLimitedException` | `KNotify.warning("Slow down — try again in a moment.")` |
| Other HTTP 5xx | `ServerException` | `KNotify.networkError(..., onRetry: _submit)` — SnackBar with Retry |
| `DioException` (connectionError / timeout) | `NetworkException` | Same as 5xx — `networkError` with Retry |

For the list screen itself (load failures, not mutations): the list provider exposes `AsyncError`; render `KEmptyState` with an error message + "Retry" action that calls `ref.invalidate(categoryOverviewProvider)`.

### 6.3 Logging

Mirror the existing `AuthRepository` pattern in development:

```
→ POST /api/v1/category/CreateCategory body={...}
← 201 /api/v1/category/CreateCategory body={categoryId: ..., ...}
CreateCategory success categoryId=...
```

Existing dio logging interceptor handles the request/response lines. The repository adds the parsed-payload line on success.

---

## 7. Plan split

### Plan 1 — Catalog scaffold + read-only Categories

**Tag candidate:** `v0.4.0-catalog-scaffold`

**Scope:**
- Add `openapi_generator` + `openapi_generator_cli` to dev_dependencies, plus `built_value` + `built_collection` (runtime) + `built_value_generator` (dev)
- **Split `UnauthorizedException` into `UnauthorizedException` (401) and `ForbiddenException` (403)** — see §6.2. Update `_ErrorMappingInterceptor` in `lib/core/network/dio_client.dart`. Audit `AuthRepository` for affected callers.
- Create `lib/core/network/openapi_clients.dart` with **one** `@Openapi`-annotated stub class for `category.openapi.json` only
- Run codegen; commit `lib/api/category/` output
- Add empty `tool/openapi-patches/` directory; populate `tool/openapi-patches/category.openapi.json` only if the sanity check in §3.1 reveals openapi-vs-handler mismatch
- Verify the generated `CategoryResponse` shape against `../gen-barcode/be/types/category.d.ts` and `category.service.ts` `resData` per §3.1 pre-generation sanity check
- Wire `categoryApiClientProvider` with `basePathOverride: '${Env.apiBaseUrl}/api/v1'` (see §3.2)
- Wire `categoryOverviewProvider` (watches `currentOrgIdProvider`) and `categoryByIdProvider.family<String>` (also watches)
- Build `CategoryRepository` (returns `ApiResult<T>`; no notifier state)
- Refactor `lib/app/router.dart` to `StatefulShellRoute.indexedStack` for authenticated routes
- Build `MainShell`, `HomeTabScreen` (re-export of existing stub), `SettingsStubScreen`
- Build `CategoriesListScreen` — read-only: page header (no `+` button yet), search (Vietnamese-normalized), layer tabs (ARB-localized labels), list rows, skeleton, empty state, error retry
- Add `category_*` strings to `app_en.arb` / `app_vi.arb` — including the layer-label keys from §5.2
- Tests:
  - `CategoryRepository` unit: DioException → ApiException mapping (400 / 401 / **403 distinct from 401** / 429 / 5xx / network)
  - `categoryOverviewProvider` provider test: success + error paths; **re-fires when `currentOrgIdProvider` changes**
  - `categoryByIdProvider` provider test: success path; family caches per-id
  - `CategoriesListScreen` widget tests: renders rows, skeleton on load, empty state, search filter (including Vietnamese normalization: "dien" matches "Điện tử"), layer tab switching, search-within-active-layer behavior
  - `MainShell` widget test: three tabs visible, tapping Catalog mounts list, per-tab nav stack preserved
  - List → placeholder detail navigation test: tapping a row pushes `/catalog/categories/:id` and the placeholder body renders

**Row tap in Plan 1:** pushes a placeholder `CategoryDetailScreen` whose body is just a "Coming soon" `KEmptyState`. The route + navigation contract are wired in Plan 1; Plan 2 replaces the body with the real header card + children list. This way Plan 2 changes one widget, not routing.

**Acceptance (given seeded BE data):** with `task fullstack` running in `../gen-barcode` and at least 3 categories spanning 2+ layers seeded into the dev org, an authed user lands on `/home`, taps Catalog, sees the categories with search + layer filtering working. Tapping a row pushes the placeholder detail screen successfully. If the BE has no fixture script, document the manual creation steps in the Plan 1 PR description.

### Plan 2 — Categories CRUD + detail

**Tag candidate:** `v0.4.0-catalog-category`

**Scope:**
- Add `+` to `CategoriesListScreen` header → opens create modal at root
- Add `create` / `update` / `remove` methods on `CategoryRepository` (return `ApiResult<T>`; no notifier)
- Build `CreateEditCategorySheet` (one widget, three modes; owns its own `isSubmitting` state)
- Build `CategoryDetailScreen` (header card with Edit + Add-subcategory buttons, children list filtered from `categoryOverviewProvider`)
- Long-press list row → `KPopupMenu` with Edit / Delete
- Delete confirm via `showKConfirmDialog` with awaited `onConfirm`
- Invalidation on mutation success per §3.4 table — done by the widget that invoked the mutation
- Error surfacing per §6.2 matrix (relies on 401/403 split shipped in Plan 1)
- Extend ARB with form labels, status enum labels, error text
- Tests:
  - `CategoryRepository.create / update / remove` unit tests: happy path + each ApiException variant
  - `CreateEditCategorySheet` widget tests: empty-name validation, defaults match web (`color = slate-400`, `icon = layout-grid`, `status = ACTIVE`), color/icon pickers return value, three modes pre-fill correctly (parent name comes from caller in createNested)
  - `CategoryDetailScreen` widget tests: renders header + children, Add-subcategory disabled at layer 5, nested drill-down stacks correctly
  - Delete confirm widget test: confirm calls `remove(categoryIds: [id])` (array wrapper), cancel closes without calling
  - Mutation invalidation tests: after `create`/`update`/`remove`, the relevant providers are invalidated per §3.4 table

**Acceptance:** full CRUD + drill-down works end-to-end against a running BE (`task fullstack` in `../gen-barcode`). User can create a root category, nest 4 sub-levels, edit each, delete any.

---

## 8. Branching

```
main
  │
  └── release/v0.3.0  (current; not yet merged to main)
        │
        └── release/v0.4.0   ← cut from release/v0.3.0
              ├── feat/catalog-scaffold   → Plan 1 PR → merges to release/v0.4.0
              └── feat/catalog-category   → Plan 2 PR → merges to release/v0.4.0
                                                                  │
                                          finally → release/v0.4.0 merges to main
```

**Why off `release/v0.3.0` and not `main`:** `release/v0.3.0` has the flat design system that Categories consumes. Basing v0.4.0 off `main` would miss it. The `release/v0.3.0` → `main` merge happens whenever it's ready and won't conflict with v0.4.0 work.

---

## 9. Open decisions — resolved

### 9.1 Generated code: commit or `.gitignore`?

**Decision:** **commit**.

Rationale: `flutter analyze` / `flutter pub get` workflows are simpler; PR diffs make spec changes visible; eliminates "did you regenerate?" debugging. The cost (bigger repo, diff noise on regeneration) is acceptable now that v0.4.0 generates **only one module** (per §3.1 revised scope). The diff bloat argument that would apply at 16-module scale doesn't apply here.

Re-evaluate this decision whenever the codegen scope expands beyond ~3 modules.

### 9.2 Fallback when openapi spec fails to generate

**Decision:** patch a copy in `tool/openapi-patches/<module>.openapi.json`, point that module's annotation at the patched copy. Do not edit files in `../gen-barcode/openapi/` from this repo.

If `category.openapi.json` itself fails to generate, **Plan 1 stops** — we open a BE issue rather than push through. We do not hand-roll Category as a fallback (defeats the purpose of this spec).

### 9.3 ARB namespace organisation

**Decision:** single `app_en.arb` / `app_vi.arb`, no per-module splitting.

Revisit when ARB exceeds ~500 entries or when more than 3 modules share string-collision risk. Mobile-design skill governs naming conventions.

---

## 10. Reference

### 10.1 Source files consulted

**BE (source-of-truth ordering per CLAUDE.md):**

1. `../gen-barcode/be/core/domains/catalog/dto/category/*.dto.ts` — request body validation
2. `../gen-barcode/be/core/domains/catalog/api/category.route.ts` — actual handler
3. `../gen-barcode/be/types/category.d.ts` — generated TS response types (load-bearing for §3.1 sanity check)
4. `../gen-barcode/be/core/domains/catalog/services/category.service.ts` — what `resData` actually contains
5. `../gen-barcode/openapi/category.openapi.json` — cross-check only; do not trust alone

**Mobile (existing code referenced):**

- `lib/core/network/dio_client.dart` — `_ErrorMappingInterceptor` (Plan 1 splits 401/403 here)
- `lib/core/network/api_exception.dart` — Plan 1 adds `ForbiddenException`
- `lib/core/auth/auth_repository.dart` — pattern for `ApiResult<T>` + logging
- `lib/app/router.dart` — Plan 1 refactors to `StatefulShellRoute.indexedStack`

**Web FE (UX port reference):**

- `../gen-barcode/fe/src/page/Category.tsx`
- `../gen-barcode/fe/src/page/CategoryDetail.tsx`
- `../gen-barcode/fe/src/components/category-module/CreateCategoryDialog.tsx`
- `../gen-barcode/fe/src/components/category-module/MainCategory.tsx` (incl. `normalizeForSearch` at lines 43-51 — port verbatim)
- `../gen-barcode/fe/src/locales/{vi,en}/category.json` — ARB key names to port

### 10.2 Existing widgets reused (no new design primitives)

From `lib/design/core/`: `KPageHeader`, `KSearchBar`, `KTextField`, `KTextarea`, `KSelect`, `KIconBtn`, `KSecondaryBtn`, `KDangerBtn`, `KTabNav`, `KListRow`, `KSkeleton`, `KSpinner`, `KEmptyState`, `KBadge`, `showKModalSheet`, `showKConfirmDialog`, `showKActionSheet`, `KPopupMenu`, `showKColorPicker`, `showKIconPicker`.

From `lib/core/feedback/`: `KNotify` (success / warning / networkError / info / error).
