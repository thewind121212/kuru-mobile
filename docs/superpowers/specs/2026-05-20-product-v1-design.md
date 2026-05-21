# Product v1 — mobile design

**Status:** Approved design. Brainstormed 2026-05-20 from the scoping note `docs/superpowers/specs/2026-05-20-product-mobile-short-plan.md`. Ready for `writing-plans`.

**Branch:** `feat/product-v1` (off `main`, scoping note cherry-picked as `bb519a3`).

**Bridge:** PR #6 (`feat/settings-and-biometric`) merged into `main`. UI bible, KSettingsRow, KNotify restyle, build.yaml exclusion, and ProfileRepository avatar URL handling all available.

---

## 1. Goal

Ship Product CRUD on mobile. Match the Settings module aesthetic (UI bible `docs/superpowers/specs/2026-05-20-ui-style-guide.md`). Mirror the kuru-web product module at `../gen-barcode/fe/src/components/product-module/`. Sit alongside Brands + Categories under the Catalog tab.

## 2. Scope

### In v1

- List screen — tab-root under Catalog. Search + 2 filter chips (category, brand). Infinite scroll. Per-product card row (image + name + category·brand + sellPrice + stock badge).
- Detail screen — pushed from list. Hero image, name, status pill, classification group, pricing group, stock group, analytics group, optional description group. Action menu: Sửa / Ngừng kinh doanh.
- Create + Edit sheet — KModalSheet bottom sheet, phased fields (see §6). Dirty-gated Save.
- Ngừng kinh doanh — `PATCH UpdateProductInfo { status: 'ARCHIVED' }`. Reversible via "Buôn bán lại" in Phase B.
- Permission gating — `product.write` controls Create/Edit/Ngừng visibility.

### Deferred to v1.1+

- Variants (`Create/Update/DeleteProductVariant`, `SaveProductVariants`, `GetProductVariants`)
- Barcodes UI (`UpdateProductBarcodes`) — needs camera scan
- Stock adjustments (`AdjustProductStock`, `GetStockHistory`) — own POS/Stock module
- Container lots (`GetContainerLots`, `Create/Adjust/DeleteContainerLot`)
- Product image upload (`UploadProductAvatar`) — read existing URL only in v1
- Hard delete (`DeleteProduct`) — v1 only soft-archives via status flip
- Distributor, warehouse, attribute, and price-range filters on the list screen
- Status filter chip on the list (BE GetProductOverview DTO doesn't accept `status` param — BE work first)

## 3. Backend contract — verified

Source-of-truth ordering (per `CLAUDE.md`): handler > `.d.ts` > openapi. The investigation that grounded this spec already cross-checked these.

| Flow | Verb + path | Handler | DTO | TS type |
|---|---|---|---|---|
| List | `GET /api/v1/product/GetProductOverview` | `be/core/domains/catalog/api/product.route.ts:185-213` | `be/core/domains/catalog/dto/product/get-product-overview.dto.ts:61-72` | `be/types/product.d.ts:70-76` (`GetProductOverviewResponse`) |
| Detail | `GET /api/v1/product/GetProductById` | `product.route.ts:155-183` | `get-product-by-id.dto.ts:4-6` | `product.d.ts:115-145` (`ProductResponse`) |
| Create | `POST /api/v1/product/CreateProduct` → 201 | `product.route.ts:125-153` | `create-product.dto.ts:32-51` | `product.d.ts:78-80` (`{productId?}`) |
| Update | `PATCH /api/v1/product/UpdateProductInfo` | `product.route.ts:215-243` | `update-product-info.dto.ts:4-19` | `product.d.ts:166-169` (`{success, error?}`) |

**Scoping-note correction:** verbs are not all POST. GETs for list + detail, POST for create, PATCH for update. DELETE endpoint exists (`product.route.ts:335-363`) but is unused in v1.

**Pricing encoding:** JSON `number`, NOT cents. Prisma `Decimal` server-side, serialized as plain JSON number. VND has no decimals in practice.

**`x-org-id`:** required on all 4 routes. Existing dio interceptor (`lib/core/network/dio_client.dart`) attaches from `currentOrgIdProvider`. No new wiring.

**Error contract:** unchanged from kuru standard (`{success, error: {message, code}, timestamp}`). 401 → existing UnauthorizedException → signOut. 403 → ForbiddenException → "Bạn không có quyền" toast. 400 → field-level errorText (matchable BE message) or KNotify.warning. 5xx / network → KNotify.networkError + retry.

**OpenAPI drift (DTO wins):**

- `CreateProduct`: openapi/proto may include `exportPrice`, `baseUnitLabel`, `containerLabel`, `containerSize` at root; the DTO REJECTS them. Mobile **must not** send these on Create. Apply via UpdateProductInfo PATCH after creation if needed.
- `CreateProduct.packs[].exportPrice`: DTO type is `string`; proto says `number`. Service treats as numeric. Mobile doesn't use packs in v1.
- `UpdateProductInfo`: DTO has `brandId`, `name`, `sellPrice`, `categoryId`, `distributorId`, `description`, `imageUrl`, `status`, `baseUnitCode`, `baseUnitLabel`, `exportPrice`, `importPrice`, `demandStock`. All optional except `productId`. Accepts `null` to clear category / distributor / brand / description / imageUrl / baseUnitLabel / exportPrice / importPrice / demandStock.
- Repository hand-builds request maps. Generated dart-dio request models are transport-only — do not pass through blindly.

## 4. Architecture

### 4.1 File layout

```
lib/api/product/                                       GENERATED dart-dio (committed)
  pubspec.yaml + path-dep added to root pubspec.yaml

lib/features/catalog/products/
  products_list_screen.dart            tab-root, inline 32sp title
  product_detail_screen.dart           pushed, AppBar centered 17sp
  data/
    product_repository.dart            wraps generated client, returns ApiResult<T>
    uoms.dart                          port of AVAILABLE_UOMS (web constants.ts)
  models/
    product_summary.dart               freezed, list-row shape
    product_detail.dart                freezed, GetProductById shape
    product_status.dart                enum ACTIVE / INACTIVE / ARCHIVED
    product_form_state.dart            freezed, Create/Edit working draft
  providers/
    product_providers.dart             productListProvider, productByIdProvider,
                                         productRepositoryProvider, canWriteProductsProvider
  widgets/
    product_card.dart                  KListRow-shaped (bible §3.7)
    product_filter_bar.dart            KSearchBar + 2 picker-trigger chips
    product_status_badge.dart          small pill, color by status
    create_edit_product_sheet.dart     KModalSheet body, phased fields
    category_brand_picker_sheet.dart   KModalSheet + KSearchBar + filtered list,
                                         reused by filter chips AND form fields
    product_archive_dialog.dart        KConfirmDialog wrapper

test/features/catalog/products/        mirror source layout
```

### 4.2 Router wiring

Extend the Catalog `StatefulShellBranch` (`lib/app/router.dart`) with sub-routes:

```
/catalog/products              → ProductsListScreen
/catalog/products/:id          → ProductDetailScreen
```

Replace one of the disabled "Sắp có" tiles in `CatalogLauncherScreen` (`lib/features/catalog/catalog_launcher_screen.dart`) with the Products tile.

### 4.3 Codegen

Add `product` to `tool/codegen.sh`'s `spec_for()` + `ALL_MODULES`. Run `./tool/codegen.sh product`. Commit `lib/api/product/`. Add path-dep to root `pubspec.yaml`:

```yaml
kuru_product_api:
  path: lib/api/product
```

`build.yaml` already excludes `lib/api/**` (commit `a8057ee`). See `.claude/skills/openapi-codegen/SKILL.md` for the dart-dio language-version-override fix.

### 4.4 CLAUDE.md updates (companion edit)

Append two short subsections under §3 ("Backend contract"):

```markdown
### Mirroring web — constants
When porting a web feature, scan `fe/src/components/<module>/constants.ts` (and adjacent) for hardcoded business constants. Web owns lookup lists that BE doesn't expose via endpoint (units, color palette, status labels). Port verbatim into `lib/features/<module>/data/`. Cross-check before assuming a constant comes from BE.

### OpenAPI is transport, not contract
Generated dart-dio in `lib/api/` is the wire transport. The request body and field set are governed by BE Zod DTO (`be/core/domains/<domain>/dto/`), not by the generated request type. When the two disagree, hand-build the request map in the repository — do not pass through generated request models blindly.
```

## 5. Data flow + repository

### 5.1 Repository contract

```dart
class ProductRepository {
  Future<ApiResult<ProductListPage>> getOverview({
    String? search,
    String? categoryId,           // single-select v1
    String? brandId,              // single-select v1
    int page = 1,
    int limit = 50,
  });

  Future<ApiResult<ProductDetail>> getById(String id);

  Future<ApiResult<String>> create(CreateProductBody body);
  // 201 → returns productId

  Future<ApiResult<void>> updateInfo(UpdateProductInfoBody body);
  // PATCH with only dirty fields
}
```

### 5.2 Models

**`ProductSummary`** (freezed) — list-row shape (mirrors `GetProductOverviewResponse.products[*]` per `product.service.ts:423-446`):
```
id, name, imageUrl (String — BE returns "" not null per service.ts:427; treat empty as missing),
status (ProductStatus enum),
baseUnitCode,
sellPricePerUnit (num — note: list endpoint uses this name, NOT sellPrice),
currentStock (num), demandStock (num),
categoryName? (BE field is `category`, denormalized),
brandId?, brandName?, variantCount (int)
```

**`ProductDetail`** (freezed) — `GetProductById` shape (`product.d.ts:115-145`):
```
id, name, imageUrl (String, may be "" — treat empty as missing),
status, baseUnitCode, baseUnitLabel?,
sellPrice (num — note: detail endpoint returns `sellPrice` NOT `sellPricePerUnit`),
exportPrice?, importPrice?,
categoryId?, distributorId?, brandId?, brandName?,
description?,
demandStock (num), avgCost (num), totalCostValue (num), totalQtyImported (num)
```

> **Detail-screen denormalization gap:** `GetProductById` returns `categoryId` but NOT a category name. The detail screen resolves `categoryId → categoryName` by reading `categoryOverviewProvider` (already loaded for the picker). When `categoryId == null` OR lookup misses, render "—".  Brand denormalization works server-side (`brandName?` is returned). Distributor name is not surfaced in v1 (field unused on detail).

`umos`, `barcodes`, `stocks`, `variants` arrays parsed as `List<dynamic>` and ignored in v1.

**`ProductListPage`** (freezed): `items: List<ProductSummary>, page, limit, totalProducts`. Computed getter `hasMore = items.length == limit && page * limit < totalProducts`.

**`ProductListFilter`** (freezed): `({String? search, String? categoryId, String? brandId})`. Used as the family key for `productListProvider`. Equality + hash defined by freezed so changing any field invalidates the provider.

**`ProductStatus`** enum: `active, inactive, archived` (camelCase Dart, wire is uppercase `ACTIVE/INACTIVE/ARCHIVED`).

**`CreateProductBody`** (Phase A required): `name, status='ACTIVE', baseUnitCode, sellPrice`. (Phase A optional): `categoryId, brandId, description`. (Phase B adds): `importPrice, exportPrice, demandStock`.

**`UpdateProductInfoBody`**: all-optional except `productId`. Same field set as Phase B Create + `status` toggle. Repository serializes only fields the caller set (dirty-only); explicit `null` sentinels for fields being cleared.

### 5.3 Providers

```dart
@riverpod
ProductRepository productRepository(Ref ref) =>
    ProductRepository(ref.read(dioProvider));

@riverpod
class ProductList extends _$ProductList {
  // family-keyed on ProductListFilter (see §5.2)
  // State holds the accumulated ProductListPage across pages.
  //   build(filter) → fetches page 1, returns initial page
  //   loadMore()    → fetches next page, returns a new ProductListPage whose
  //                    .items = old.items + newPage.items, .page = newPage.page
  //                    no-op when state.hasMore == false
  @override
  Future<ProductListPage> build(ProductListFilter filter) async { ... }
  Future<void> loadMore() async { ... }
}

@riverpod
Future<ProductDetail> productById(Ref ref, String id) async { ... }

@riverpod
bool canWriteProducts(Ref ref) {
  final permsAsync = ref.watch(myPermissionsProvider);
  return permsAsync.maybeWhen(
    data: (p) => p.orgPerms.contains('product.write'),
    orElse: () => false,
  );
}
```

Provider name notes (verified against existing code):
- `myPermissionsProvider` lives at `lib/core/permissions/permissions_providers.dart` (NOT `resolvedPermissionsProvider`)
- `ResolvedPermissions.orgPerms: List<String>` — `product.write` is in BE's `permission.catalog.ts:70` `orgPerms` set
- Category list = `categoryOverviewProvider` at `lib/features/catalog/categories/providers/category_providers.dart` (NOT `categoryListProvider`)
- Brand list = `brandOverviewProvider` at `lib/features/catalog/brands/providers/brand_providers.dart` (NOT `brandListProvider`)
- All `*Overview` providers are `FutureProvider`, return `List<gen.*Response>`, and watch `currentOrgIdProvider` for auto-invalidation on org switch
- Mobile catalog brands/categories currently do NOT gate writes by permission; `canWriteProductsProvider` is the first such check on mobile. Existing approach in Settings uses `p.isOwner` for OWNER-only flows.

After Create/Update success: `ref.invalidate(productListProvider)` + `ref.invalidate(productByIdProvider(id))`.

## 6. Phasing

### Phase A — minimal CRUD (lands first)

Form fields:

| Field | Widget | Required | Notes |
|---|---|---|---|
| Tên sản phẩm | KFormField | yes | min 1, max 255 (BE Zod: `name min 1 max 255`) |
| Danh mục | Picker trigger → `category_brand_picker_sheet.dart` | no | null = uncategorized |
| Thương hiệu | Picker trigger → same sheet (brand mode) | no | null = no brand |
| Đơn vị cơ sở | Picker trigger → KActionSheet of `AVAILABLE_UOMS` (grouped by type) | yes | default `'each'` per web schema.ts:98 |
| Giá bán | **`KCurrencyField` (user-supplied component, TBD)** | yes | num ≥0; format VND with thousands separators |
| Mô tả | KTextarea (3-line min) | no | max 1000 |

Status defaults to `'ACTIVE'` on Create. Status edit not surfaced in Phase A (only Ngừng-kinh-doanh path can change status).

Ngừng kinh doanh action: shipped in Phase A. Reactivate not available until Phase B (no UI to surface ARCHIVED products on list yet).

### Phase B — extended scalars (follow-up commit, same branch + PR)

Adds 4 fields to the Create/Edit sheet:

| Field | Widget | Notes |
|---|---|---|
| Giá nhập | KCurrencyField (TBD) | optional, ≥0 |
| Giá xuất | KCurrencyField (TBD) | optional, ≥0 |
| Tồn tối thiểu | KFormField, number keyboard | optional, ≥0 |
| Trạng thái | KSwitchRow "Đang bán" ↔ "Tạm ngưng" | edit-only; never settable to ARCHIVED here (that's the Ngừng action). Create defaults ACTIVE. |

Adds "Buôn bán lại" affordance on the detail screen when `status == ARCHIVED` → `KConfirmDialog('Mở bán lại sản phẩm?')` → `updateInfo(status: ACTIVE)`.

No new screens, no new endpoints, no test-infra changes between phases. Phase B is purely additive on `create_edit_product_sheet.dart` + `product_detail_screen.dart`.

## 7. UI specifications

All adherence to `docs/superpowers/specs/2026-05-20-ui-style-guide.md`. Settings module is the reference. Catalog (brands/categories) already aligned per PR #6.

### 7.1 List screen `products_list_screen.dart`

Tab-root template (bible §3.1). Inline 32sp/800w title "Sản phẩm" + skeleton subtitle "{totalProducts} sản phẩm" → "Đang tải…" before first response.

```
[32sp "Sản phẩm"]
[skel-subtitle]
[KSearchBar 'Tìm sản phẩm...']           ← 300ms debounce (web parity, MainProduct.tsx:205)
[Row of 2 picker-trigger chips]
  "Danh mục: {selected name ?? 'Tất cả'}" ▾
  "Thương hiệu: {selected name ?? 'Tất cả'}" ▾
[Pull-to-refresh ListView.builder]
  └─ product_card (KListRow body)
  └─ Loading footer KSpinner when fetching next page (scroll listener: within 3 items of bottom)
  └─ Empty state KEmptyState:
       icon TablerIcons.package, slate tint
       title 'Chưa có sản phẩm'
       subtitle 'Tạo sản phẩm đầu tiên để bắt đầu.'
       cta 'Tạo sản phẩm' (KPrimaryBtn, perm-gated)

Floating action (bottom-right, 16r 16b inset):
  KPrimaryBtn fab-style '+ Tạo sản phẩm', perm-gated by canWriteProducts.
```

### 7.2 `product_card.dart` (KListRow consumer)

```
leading: 44sq rounded-10 container
  - hasImage = imageUrl != null && imageUrl.isNotEmpty
    (BE returns empty string when missing — see service.ts:427)
  - if hasImage: NetworkImage('${Env.imageBaseUrl}/product-avatar/${imageUrl}'),
    BoxFit.cover, errorBuilder → fallback
  - fallback: TablerIcons.package on slate tint (icon 22, fg slate-500)

title: name, 15/500, ellipsis maxLines 1, c.textPrimary
subtitle: '{categoryName ?? 'Chưa phân loại'} · {brandName ?? '—'}',
          13/400, c.textMuted, ellipsis maxLines 1

trailing column (CrossAxisAlignment.end, mainAxisSize.min):
  - sellPrice formatted vi-VN VND, 15/700, c.primary
  - stock pill:
      currentStock == 0       → rose tint, 'Hết hàng'
      currentStock < demand   → amber tint, '{currentStock} {baseUnitLabel}'
      else                    → emerald tint, '{currentStock} {baseUnitLabel}'

Tap → context.push('/catalog/products/$id')
Long-press → KPopupMenu (write-perm only):
  - 'Sửa'           → opens Create/Edit sheet in edit mode
  - 'Ngừng kinh doanh' (rose) → product_archive_dialog
```

### 7.3 Detail screen `product_detail_screen.dart`

Pushed-detail template (bible §3.1). AppBar centered title = product name, 17/700, ellipsis.

```
AppBar:
  leading BackButton
  title Text(product.name, 17/700, ellipsis)
  trailing KIconBtn(TablerIcons.dots_vertical) → KActionSheet
    (perm-gated, hidden if !canWriteProducts):
    - 'Sửa thông tin'        → Create/Edit sheet (edit mode)
    - 'Ngừng kinh doanh'     (rose) → product_archive_dialog
    - 'Buôn bán lại'         (Phase B, only when status == ARCHIVED)

Body ListView, padding top:12 bottom:32:

1. Hero block (no card, 16h inset):
   - 220h container, 18-radius:
     • hasImage = imageUrl != null && imageUrl.isNotEmpty
     • if hasImage: NetworkImage same URL pattern, BoxFit.cover,
       errorBuilder → centered TablerIcons.package
     • else: centered TablerIcons.package, slate tint
   - 16vp gap
   - name 22/700 c.textPrimary
   - 4vp gap
   - product_status_badge (small pill 12sp, see §7.6)

2. KSettingsSection 'Phân loại':
   - KSettingsRow leading violet-tint folder, 'Danh mục',
       trailingText: resolveCategoryName(categoryId) ?? '—'
       (lookup via categoryOverviewProvider — detail BE response omits categoryName)
   - KSettingsRow leading blue-tint tag, 'Thương hiệu',
       trailingText: brandName ?? '—'
   - KSettingsRow leading slate-tint scale, 'Đơn vị',
       trailingText: baseUnitLabel ?? baseUnitCode

3. KSettingsSection 'Giá':
   - KSettingsRow 'Giá bán', trailing sellPrice VND (15/700 indigo)
   - KSettingsRow 'Giá nhập', trailing importPrice VND or '—'
   - KSettingsRow 'Giá xuất', trailing exportPrice VND or '—'

4. KSettingsSection 'Tồn kho':
   - KSettingsRow 'Hiện có',
       trailingText: '{currentStock} {baseUnitLabel}'
   - KSettingsRow 'Tồn tối thiểu',
       trailingText: demandStock > 0 ? '{demandStock} {baseUnitLabel}' : '—'

5. KSettingsSection 'Thống kê':
   - KSettingsRow 'Giá vốn trung bình', trailing avgCost VND
   - KSettingsRow 'Đã nhập tổng', trailing '{totalQtyImported} {baseUnitLabel}'
   - KSettingsRow 'Giá trị tồn kho', trailing totalCostValue VND

6. (optional) KSettingsSection 'Mô tả' if description present:
   - Single row, full description text 14/400 left-aligned, no trailing.

Loading: KSkeleton blocks per section.
Error: KEmptyState with retry → invalidate productByIdProvider(id).
```

Note: internalBarcode and the barcode list are **not** rendered. Internal barcode is BE bookkeeping (PRD format, auto-generated in the same CreateProduct transaction at `service.ts:658-714`). User-facing alias barcodes ship with v1.1 barcode UI.

### 7.4 Create + Edit sheet `create_edit_product_sheet.dart`

`showKModalSheet(title: isEdit ? 'Sửa sản phẩm' : 'Sản phẩm mới', confirmLabel: 'Lưu', showCancel: true, body: ...)`.

Body — single-column scroll inside the sheet. Each field is a KFormField (or picker trigger row styled like KFormField, with chevron + selected name to the right).

Dirty-gating: `_isDirty` getter compares working `ProductFormState` against the original. Save disabled until `_isDirty == true` AND all required fields are valid. Pattern copied from `lib/features/settings/profile_screen.dart`.

Picker triggers (Danh mục, Thương hiệu, Đơn vị):

- Trigger row visual: KFormField-shaped, label above, value text inside, trailing chevron. Tap opens the picker sheet.
- Category + Brand → `category_brand_picker_sheet.dart` (KModalSheet + KSearchBar + filtered list, see §7.5). Includes a "Bỏ chọn" sentinel at the top to clear selection (Update API accepts null).
- Đơn vị cơ sở → KActionSheet of `AVAILABLE_UOMS` grouped by `type` ("count" / "pack" / "weight" / "volume" / "length" / "area"). No search (≤30 items). Required field, no clear option.

Submit flow:

```
Create:
  repo.create(body)
  → success: KNotify.success('Đã tạo sản phẩm')
             pop sheet
             ref.invalidate(productListProvider)
             context.push('/catalog/products/$newId')
  → 400: parse error.message, try to match against known field rejections;
         field-level errorText if matched, KNotify.warning otherwise
  → 5xx / network: KNotify.networkError, sheet stays open

Edit:
  repo.updateInfo({productId, ...dirtyFieldsOnly})
  → success: KNotify.success('Đã cập nhật')
             pop sheet
             ref.invalidate(productByIdProvider(id))
             ref.invalidate(productListProvider)
  → errors as above
```

Repository explicit-null vs omit: `UpdateProductInfoBody` field set uses `JsonOptional<T>` wrapper (or equivalent sentinel pattern) so the repository can distinguish "omit key entirely" (leave field unchanged) from "send `null`" (clear the field). UpdateProductInfo's DTO accepts `null` to disconnect category/distributor/brand. Suggested concrete: `freezed` model with each clearable field as `JsonOptional<T?>?` where `null` outer = omit, `JsonOptional(null)` = clear, `JsonOptional(value)` = set. Final shape settled during plan writing.

### 7.5 `category_brand_picker_sheet.dart`

Reusable feature-local widget. Modes: `category` (reads `categoryOverviewProvider`) or `brand` (reads `brandOverviewProvider`). Same shell:

```
KModalSheet(
  title: mode == category ? 'Chọn danh mục' : 'Chọn thương hiệu',
  showCancel: true,
  body: Column [
    KSearchBar (in-sheet) — debounce 200ms, filter the local list
    Scrollable list:
      - 'Bỏ chọn' sentinel row (rose-tint X icon) on top — pops with null
      - One row per item: leading icon (folder for category, tag for brand),
        title = item.name, optional secondary line for category layer or
        brand productCount, chevron trailing
      - Empty filter: small 'Không tìm thấy' text
)
```

Promote to `lib/design/core/modal/k_searchable_picker.dart` if a 2nd consumer appears outside this feature.

### 7.6 `product_status_badge.dart`

Small pill, 12/500, no chevron:

| Status | Bg | Fg | Label |
|---|---|---|---|
| ACTIVE | emerald-tint bg | emerald fg | "Đang bán" |
| INACTIVE | amber-tint bg | amber fg | "Tạm ngưng" |
| ARCHIVED | slate-tint bg | slate fg | "Ngừng kinh doanh" |

Tints pulled from UI bible §2.4 palette.

### 7.7 Ngừng kinh doanh — `product_archive_dialog.dart`

```
showKConfirmDialog(
  title: 'Ngừng kinh doanh sản phẩm?',
  body:  'Sản phẩm sẽ bị ẩn khỏi bán hàng và danh mục. '
         'Lịch sử nhập xuất kho và mua hàng được giữ nguyên.',
  confirmLabel: 'Ngừng kinh doanh',
  destructive: true,
  onConfirm: () async {
    final res = await repo.updateInfo(
      UpdateProductInfoBody(productId: id, status: ProductStatus.archived),
    );
    res.when(
      success: (_) {
        KNotify.success('Đã ngừng kinh doanh sản phẩm');
        ref.invalidate(productListProvider);
        ref.invalidate(productByIdProvider(id));
        // pop back to list only when dialog opened from detail; no-op on list long-press
      },
      failure: (e) => KNotify.warning(e.message),
    );
  },
)
```

VN copy ported verbatim from web `fe/src/locales/vi/product.json:24-29`.

PATCH UpdateProductInfo path does NOT run the stock/lots/draftPO blocker check that DeleteProduct does. No blocker-parse UX needed.

## 8. Permission gating

`canWriteProductsProvider` reads from `resolvedPermissionsProvider` (already shipped in PR #6 Settings module). Predicate: `perms.anyStorePerm.contains('product.write')`.

Visibility map:

| Surface | Visible when |
|---|---|
| List FAB "+ Tạo sản phẩm" | canWriteProducts |
| List empty-state CTA "Tạo sản phẩm" | canWriteProducts |
| List row long-press menu | canWriteProducts (menu has no rows otherwise → don't open) |
| Detail AppBar dots menu | canWriteProducts (button hidden otherwise) |
| Detail Phase B "Buôn bán lại" row | canWriteProducts |

STAFF without `product.write` sees full read-only list + detail. Write attempts blocked at UI; BE rejects with 403 → existing ForbiddenException toast.

## 9. Tests

Mirror `test/features/catalog/products/`. Per CLAUDE.md: never `pumpAndSettle` with KPrimaryBtn / KSpinner / KSkeleton present — use `pump()` + `pump(Duration(ms: 50))` to step microtasks.

| Suite | File | Coverage |
|---|---|---|
| Repo | `product_repository_test.dart` | Mock Dio. 200/201/400/401/403/5xx for each of 4 methods. Null-disconnect on update. Verbs + paths verified. |
| Models | `product_summary_test.dart`, `product_detail_test.dart` | freezed JSON round-trip + null handling. Status enum mapping (uppercase ↔ camelCase). |
| List screen | `products_list_screen_test.dart` | empty state / loaded list / pagination footer / pull-to-refresh / search debounce / chip filters / FAB perm-gated |
| Detail screen | `product_detail_screen_test.dart` | renders all sections / null fields show '—' / dots menu perm-gated / Ngừng kinh doanh confirm path |
| Create+Edit sheet | `create_edit_product_sheet_test.dart` | Phase A dirty-gate / required-field validation / picker open + select / submit success+failure / null-disconnect on edit |
| Archive dialog | `product_archive_dialog_test.dart` | confirm calls updateInfo(status=ARCHIVED) / success toast / error path |
| Picker sheet | `category_brand_picker_sheet_test.dart` | search filter / 'Bỏ chọn' returns null / empty filter copy |

Test overrides: `productRepositoryProvider`, `appBootstrapProvider` (existing pattern), `resolvedPermissionsProvider` (to flip write-perm on/off).

Target: ~35-45 new tests. Run via `mcp__plugin_vgv-ai-flutter-plugin_dart__run_tests`. `flutter analyze` exit 0.

## 10. Risks + unknowns

1. **Currency input (`KCurrencyField`)** — user-supplied component. Spec assumes API surface: `value: int?, onChanged: (int?) => void, errorText: String?, label: String, suffix: 'đ', keyboardType: TextInputType.number`. **Phase A gating order** for the plan: (i) codegen + models + repository + tests on those, (ii) list screen + detail screen (read-only, no currency *input*; currency *display* uses `intl.NumberFormat.currency`), (iii) wait for user-supplied component, (iv) create/edit sheet + tests. Read-only surfaces ship without the dependency.
2. **Brand/Category picker scaling** — if a single org's brand list grows past ~200 items the in-sheet local filter still works but initial fetch may be slow. `brandListProvider` already fetches all; revisit pagination only if real users hit the wall.
3. **OpenAPI/DTO drift** — Create + Update have field mismatches (§3). Hand-build request maps in the repository; do not pass generated request types through. Spec covers this; CLAUDE.md note codifies for future endpoints.
4. **Image render fallback** — NetworkImage errorBuilder must always render the package icon, not the broken-image glyph. Cover with widget test (mock NetworkImage error).
5. **ARCHIVED products on list** — resolved. `product.repo.ts:102-105` (`findAllOverview`) filters by `isDelete: false` only, NOT by `status`. ARCHIVED products are returned. v1 mobile displays them inline with the "Ngừng kinh doanh" badge from §7.6. No client-side filter, no server-side status filter param. "Buôn bán lại" in Phase B reactivates them. Acceptable: user retains visibility into what they've archived without losing the row entirely.

## 11. Out-of-spec confirmations (decided during brainstorming, kept here for posterity)

- Money input component will be provided by the user; spec does not design it.
- Hard delete (`DeleteProduct`) endpoint is generated but unused in v1. Stop-selling uses the status flip path.
- Internal barcode is BE bookkeeping; never rendered.
- KActionSheet is used only for the unit picker (≤30 items, no search). Category + Brand pickers use the searchable modal-sheet pattern (§7.5).
- Single-select for category + brand filter chips in v1 (no multi-select chips even though BE accepts arrays).
- Currency display formatting on read screens uses `intl` package (`NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0)`). `intl 0.20.2` already in `pubspec.yaml`, pinned to match what `flutter_localizations` vendors.
- Sources of denormalized names on list vs detail: list endpoint returns `category` (string name) and `brandName`. Detail endpoint returns only `categoryId` + `brandName`. Detail screen looks category name up via `categoryOverviewProvider`.

## 12. References

- Scoping note: `docs/superpowers/specs/2026-05-20-product-mobile-short-plan.md`
- UI bible: `docs/superpowers/specs/2026-05-20-ui-style-guide.md`
- Settings reference impl: `lib/features/settings/` (esp. `profile_screen.dart` for dirty-gating, `change_password_sheet.dart` for sheet pattern)
- Catalog precedents: `lib/features/catalog/{brands,categories}/`
- Web product module: `../gen-barcode/fe/src/components/product-module/`
- BE handlers: `../gen-barcode/be/core/domains/catalog/api/product.route.ts`
- BE DTOs: `../gen-barcode/be/core/domains/catalog/dto/product/`
- BE service: `../gen-barcode/be/core/domains/catalog/services/product.service.ts`
- Codegen skill: `.claude/skills/openapi-codegen/SKILL.md`
- Mobile-design skill: `.claude/skills/mobile-design/SKILL.md`

---

**Next:** hand off to `superpowers:writing-plans` to produce `docs/superpowers/plans/2026-05-20-product-v1.md`.
