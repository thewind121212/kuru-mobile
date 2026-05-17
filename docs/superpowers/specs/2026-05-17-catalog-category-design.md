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
dev_dependencies:
  openapi_generator: ^5.x        # annotation host
  openapi_generator_cli: ^5.x    # CLI invoked by build_runner
```

**Generator template:** `dart-dio` (uses `dio` + `built_value`). Mature, well-supported, integrates with our existing dio.

**Annotation host file:** new file `lib/core/network/openapi_clients.dart` containing one stub class with `@Openapi` annotations for **all 16 specs** in `../gen-barcode/openapi/*.openapi.json`. Generating all up front avoids re-running the generator each time a new module is added.

**Output path:** `lib/api/<module>/` — one directory per spec. Generated code is **committed** to git (see Section 9 decision #1).

**Workflow:** `dart run build_runner build --delete-conflicting-outputs` after any openapi spec change. CI gates: stale generated code = CI failure (run codegen, check `git diff --exit-code`).

**Failure contingency:** if a spec fails to generate cleanly (Section 9 decision #2), patch a copy in `tool/openapi-patches/<module>.openapi.json` and point that module's `@Openapi` annotation at the patched copy. Do not modify files in `../gen-barcode/openapi/` from this repo.

### 3.2 dio integration

The generated client constructor accepts a `Dio` instance. We pass the existing `dioProvider` (`lib/core/network/dio_client.dart`) which already wires:

- SuperTokens header-mode session handling
- `x-org-id` interceptor (reads `currentOrgIdProvider`)
- Logging interceptor (request method/url + response status)
- Error-mapping interceptor (DioException → typed `ApiException`)

The generated client's own default Dio config is **not** used.

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
                  wraps generated CategoryApi(dio: dio)
                            │
        ┌───────────────────┼──────────────────────┐
        ▼                   ▼                      ▼
categoryOverviewProvider   categoryByIdProvider.family   categoryMutationsController
   (FutureProvider)           (FutureProvider<UUID>)        (AsyncNotifier)
        │                       │                              │
        └───────────────────────┴────── ref.invalidate ◄───────┘
                                          after mutation success
```

`categoryOverviewProvider` is the single source of truth for the category list. `CategoryDetailScreen` reuses it (client-side filter on `parentId`) rather than calling `GetCategoryTree`. This means **one network round-trip** per Catalog tab visit, not one-per-screen.

### 3.5 Repository layer

New file: `lib/features/catalog/categories/data/category_repository.dart`.

Responsibilities:
- Wrap each generated client method (`CreateCategory`, `GetCategoryById`, `UpdateCategory`, `RemoveCategory`, `GetCategoryOverviewWithDepth`).
- Translate `DioException` → `ApiException` (reuse existing extractor in `lib/core/network/api_exception.dart`).
- Return `ApiResult<T>` (existing sealed class) for the mutations controller to switch on.
- Use generated `CategoryResponse` model directly — no parallel freezed layer.

`GetCategoryTree` and `GetCategoryOverview` (no-depth) are **not** wrapped — mobile only consumes `GetCategoryOverviewWithDepth`, which returns the full flat list with `layer` baked in.

### 3.6 File layout (new additions)

```
lib/
├── api/                              ← all generated; committed
│   ├── category/
│   ├── brand/
│   ├── product/
│   └── … (16 directories total)
├── core/network/
│   └── openapi_clients.dart          ← @Openapi annotation host
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
```

---

## 4. BE contract reference

### 4.1 Category model fields

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
- **Layer tabs:** derived from data. "All" + each distinct `layer` present, sorted numerically. Labels:
  - `"1"` → "Main"
  - `"2"` → "Sub"
  - `"3"` → "Sub Sub"
  - `"4"` / `"5"` → "Layer 4" / "Layer 5"
  - Count badge per tab. Default = "All". Layer filter held in widget state (not URL).
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

**Widgets used:** `showKModalSheet` (existing) with body composed of `KTextField` (name), `KSelect` (status), `KTextarea` (description), two `KSelect`-styled buttons opening `showKIconPicker` / `showKColorPicker`. Parent display = plain text row.

**Defaults (mirror web FE):** `status = ACTIVE`, `color = "slate-400"`, `icon = "layout-grid"`.

**Validation:**
- Name empty → `KFormField.errorText: "Name is required"` (or whatever BE returns verbatim in 400).
- Other field errors → inline error banner inside sheet body.

**Submit flow:**
1. `KModalSheet.loadingBody` shows during the awaited mutation.
2. Repository call via `categoryMutationsController.create / .update`.
3. On success → close sheet → `KNotify.success("Category created" / "Category updated")` → `ref.invalidate(categoryOverviewProvider)`.
4. On error → sheet stays open; surface per error matrix in Section 6.

### 5.5 Delete flow

Long-press row → `KPopupMenu` → tap "Delete":

→ `showKConfirmDialog`:
- Title: "Delete category?"
- Body: `"{name} will be removed. This cannot be undone."`
- Cancel + Delete (danger).
- `onConfirm: () async { ... }` — dialog stays open with spinner during await.

→ `categoryMutationsController.remove(categoryIds: [id])` — BE expects array even for single delete.

→ On success → close dialog → `KNotify.success("Category deleted")` → invalidate overview.

→ On error (e.g. BE rejects because category has children) → surface per error matrix; dialog closes only on success.

### 5.6 HomeTabScreen, SettingsStubScreen

- **HomeTabScreen:** re-uses the existing `HomeStubScreen` body. No design changes.
- **SettingsStubScreen:** placeholder with title "Settings" and a centered "Coming soon" message. Wired into MainShell so the tab is reachable.

---

## 6. Data flow & error handling

### 6.1 Mutation flow

1. User submits / confirms.
2. Controller sets `state = AsyncLoading()`. UI shows spinner state (KModalSheet `loadingBody` / KConfirmDialog inline spinner).
3. Repository calls generated client.
4. On success → `ref.invalidate(categoryOverviewProvider)` → close sheet/dialog → `KNotify.success`.
5. On error → sheet/dialog stays open → error surfaced per matrix below.

### 6.2 Error matrix

| BE response | UX |
|---|---|
| HTTP 400 + `error.message` mapping to a field | `KFormField.errorText` on that field — message verbatim |
| HTTP 400 + non-field message | Inline error banner inside the sheet |
| HTTP 401 | `KNotify.error` toast → `signOut()` → router → `/login` |
| HTTP 500 with body containing `"Session does not exist"` | Same as 401 (BE bug; mitigation pattern from `AuthRepository`) |
| HTTP 403 | `KNotify.warning("You don't have permission to do that.")`; sheet stays open |
| HTTP 429 + `code: RATE_LIMITED` | `KNotify.warning("Slow down — try again in a moment.")` |
| Other HTTP 5xx | `KNotify.networkError(..., onRetry: _submit)` — bottom SnackBar with Retry |
| `DioException` (connectionError / timeout) | Same as 5xx — `networkError` with Retry |

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
- Add `openapi_generator` + `openapi_generator_cli` to `pubspec.yaml` dev_dependencies
- Create `lib/core/network/openapi_clients.dart` with `@Openapi` annotations for all 16 specs
- Run codegen; commit `lib/api/` output
- Add `tool/openapi-patches/` directory (empty initially; populated only if a spec fails to generate)
- Wire `categoryApiClientProvider` and `categoryOverviewProvider`
- Refactor `lib/app/router.dart` to `StatefulShellRoute.indexedStack` for authenticated routes
- Build `MainShell`, `HomeTabScreen` (re-export of existing stub), `SettingsStubScreen`
- Build `CategoriesListScreen` — read-only: page header (no `+` button yet), search, layer tabs, list rows, skeleton, empty state, error retry
- Add `category_*` strings to `app_en.arb` / `app_vi.arb`
- Tests:
  - `CategoryRepository` unit: DioException → ApiException mapping (400/401/403/429/5xx/network)
  - `categoryOverviewProvider` provider test: success + error paths
  - `CategoriesListScreen` widget tests: renders rows, skeleton on load, empty state, search filter (including Vietnamese normalization), layer tab switching
  - `MainShell` widget test: three tabs visible, tapping Catalog mounts list, per-tab nav stack preserved

**Row tap in Plan 1:** pushes a placeholder `CategoryDetailScreen` whose body is just a "Coming soon" `KEmptyState`. The route + navigation contract are wired in Plan 1; Plan 2 replaces the body with the real header card + children list. This way Plan 2 changes one widget, not routing.

**Acceptance:** an authed user with attached org lands on `/home`, taps Catalog, sees their categories with search + layer filtering working. Tapping a row pushes the placeholder detail screen successfully.

### Plan 2 — Categories CRUD + detail

**Tag candidate:** `v0.4.0-catalog-category`

**Scope:**
- Add `+` to `CategoriesListScreen` header → opens create modal at root
- Build `CreateEditCategorySheet` (one widget, three modes)
- Build `CategoryDetailScreen` (header card with Edit + Add-subcategory buttons, children list)
- Long-press list row → `KPopupMenu` with Edit / Delete
- Delete confirm via `showKConfirmDialog`
- `categoryMutationsController` (AsyncNotifier with `create` / `update` / `remove`)
- Error surfacing per Section 6 matrix
- Extend ARB with form labels, status enum labels, error text
- Tests:
  - `categoryMutationsController` provider tests: create/update/remove happy paths + invalidation
  - `CreateEditCategorySheet` widget tests: empty-name validation, defaults match web, color/icon pickers return value, three modes pre-fill correctly
  - `CategoryDetailScreen` widget tests: renders header + children, Add-subcategory disabled at layer 5, nested drill-down
  - Delete confirm widget test: confirm calls remove with `[id]`, cancel closes without calling

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

Rationale: `flutter analyze` / CI / `flutter pub get` workflows are simpler; PR diffs make spec changes visible; eliminates "did you regenerate?" debugging. The cost (bigger repo, diff noise on regeneration) is acceptable for a small portfolio repo.

### 9.2 Fallback when openapi spec fails to generate

**Decision:** patch a copy in `tool/openapi-patches/<module>.openapi.json`, point that module's annotation at the patched copy. Do not edit files in `../gen-barcode/openapi/` from this repo.

If `category.openapi.json` itself fails to generate, **Plan 1 stops** — we open a BE issue rather than push through. We do not hand-roll Category as a fallback (defeats the purpose of this spec).

### 9.3 ARB namespace organisation

**Decision:** single `app_en.arb` / `app_vi.arb`, no per-module splitting.

Revisit when ARB exceeds ~500 entries or when more than 3 modules share string-collision risk. Mobile-design skill governs naming conventions.

---

## 10. Reference

### 10.1 Source files consulted

- `../gen-barcode/be/core/domains/catalog/dto/category/*.dto.ts`
- `../gen-barcode/be/core/domains/catalog/api/category.route.ts`
- `../gen-barcode/be/core/domains/catalog/services/category.service.ts`
- `../gen-barcode/fe/src/page/Category.tsx`
- `../gen-barcode/fe/src/page/CategoryDetail.tsx`
- `../gen-barcode/fe/src/components/category-module/CreateCategoryDialog.tsx`
- `../gen-barcode/fe/src/components/category-module/MainCategory.tsx`
- `../gen-barcode/openapi/category.openapi.json`

### 10.2 Existing widgets reused (no new design primitives)

From `lib/design/core/`: `KPageHeader`, `KSearchBar`, `KTextField`, `KTextarea`, `KSelect`, `KIconBtn`, `KSecondaryBtn`, `KDangerBtn`, `KTabNav`, `KListRow`, `KSkeleton`, `KSpinner`, `KEmptyState`, `KBadge`, `showKModalSheet`, `showKConfirmDialog`, `showKActionSheet`, `KPopupMenu`, `showKColorPicker`, `showKIconPicker`.

From `lib/core/feedback/`: `KNotify` (success / warning / networkError / info / error).
