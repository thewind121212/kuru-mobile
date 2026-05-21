# Product module — mobile short plan

**Status:** Scoping note for the next session. Not a full spec or implementation plan — just enough scaffolding that a fresh Claude can pick it up and produce the real spec via brainstorming.

**Branch when starting:** off `main` (after PR #6 merges) → `feat/product-v1`.

---

## Goal

Ship Product CRUD on mobile, matching the Settings module aesthetic (UI bible: `docs/superpowers/specs/2026-05-20-ui-style-guide.md`). Tab will live under the existing Catalog branch alongside Brands + Categories.

## Scope — v1 (this session)

- **List screen** — Catalog → Products. Search + filter chip (by category / by brand). Skeleton subtitle for total count. Card row per product (name, brand, category, price, stock badge).
- **Detail screen** — pushed from list. Hero image (if any), name, code/SKU, category, brand, description, price, stock total. Read-only first. Action menu: Edit, Delete.
- **Create / Edit sheet** — KModalSheet bottom sheet, fields: name, code, category picker (KActionSheet — uses existing category list), brand picker, base price, description. Avatar/image upload deferred to v1.1.

## Scope — out (defer to v1.1+)

- **Variants** (`GetProductVariants` / `Create/Update/DeleteProductVariant` / `SaveProductVariants`) — heavy matrix UI on web. Mobile-native pattern needs its own design pass.
- **Barcodes** (`UpdateProductBarcodes`) — needs camera scan integration.
- **Stock adjustments** (`AdjustProductStock` / `GetStockHistory`) — own POS/Stock module later.
- **Container lots** (`GetContainerLots` / `Create/Adjust/DeleteContainerLot`) — batch tracking, complex.
- **Product images upload** — needs BE `UploadProductAvatar` integration (route exists, multipart at `/api/v1/file/UploadProductAvatar`). Defer image picker UI to v1.1; render BE-returned URL when present.

## BE endpoints (already exist, port from web)

Mirror kuru-web `fe/src/components/product-module/`. Source-of-truth ordering (per CLAUDE.md): handlers > .d.ts > openapi.

v1 needs only these 5 of the 18 routes in `openapi/product.openapi.json`:

| Flow | Endpoint | Mounted at |
|---|---|---|
| List | `POST /api/v1/product/GetProductOverview` | `/api/v1/product/*` |
| Detail | `POST /api/v1/product/GetProductById` | same |
| Create | `POST /api/v1/product/CreateProduct` | same |
| Update | `POST /api/v1/product/UpdateProductInfo` | same |
| Delete | `POST /api/v1/product/DeleteProduct` | same |

Defer the other 13 routes (variants, barcodes, stock, lots).

## Codegen

Add `product` to `tool/codegen.sh`'s `spec_for()` + `ALL_MODULES`. Run `./tool/codegen.sh product`. Commit the generated `lib/api/product/` sub-package. Add path-dep to root `pubspec.yaml`. The root `build.yaml` already excludes `lib/api/**` (added in CI fix `a8057ee`).

Verify BE source-of-truth before accepting generated client:
- `../gen-barcode/be/core/domains/catalog/api/product.route.ts` — actual handler
- `../gen-barcode/be/core/dto/product/*.dto.ts` — Zod request schemas
- `../gen-barcode/be/types/product.d.ts` — response types

## File layout (proposed)

```
lib/api/product/                                              GENERATED (committed)
lib/features/catalog/products/
  products_list_screen.dart        tab-root, inline 32sp title
  product_detail_screen.dart       pushed detail, AppBar centered 17sp title
  data/
    product_repository.dart
  providers/
    product_providers.dart
  widgets/
    product_card.dart              uses KListRow per bible §3.7
    create_edit_product_sheet.dart KModalSheet, fields above

test/features/catalog/products/    mirror source layout
```

Wire into router: extend the Catalog StatefulShellBranch with a new sub-route `/catalog/products`. Update CatalogLauncherScreen to add a 4th tile (replace the disabled "Sắp có" placeholder for one of distributor/tax).

## UI bible adherence

- Tab-root list screen: inline 32sp title + skeleton-subtitle pattern (copy from `categories_list_screen.dart` header).
- Pushed detail: small centered AppBar title (copy from `category_detail_screen.dart`).
- Card row: 18-radius, no outer border, soft pastel icon tile if no product image; ellipsis name; muted secondary line for `code · category · brand`.
- Toasts via `KNotify` (success on save/delete, warning on BE 400, networkError SnackBar with retry).
- Sheets via `KModalSheet`; fields via `KFormField`; primary via `KPrimaryBtn(child: Text('Lưu'))`.
- Form dirty-gating: Save disabled until something actually changed (copy from `profile_screen.dart`'s `_isDirty` getter pattern).
- Confirm delete via `showKConfirmDialog` (destructive tone).

## Risks / unknowns to brainstorm in the new session

1. **Price format** — kuru-web likely stores VND as integer cents/đồng. Confirm with `product.d.ts`. Mobile needs a money input + intl formatter (`intl` is already a dep).
2. **Category / brand picker UX** — full-list KActionSheet is fine if <50 items, but if BE returns hundreds we need a searchable bottom-sheet picker. Look at how web does it.
3. **`UpdateProductInfo` vs full product update** — web has a separate `UpdateProductBarcodes` + `UpdateProductUmos` (units). `UpdateProductInfo` is the metadata only (name, code, description, prices, category, brand). v1 sticks to `UpdateProductInfo`.
4. **Role gating** — Catalog writes need `product.write` permission. Read existing `ResolvedPermissions` + add a `canWriteProducts` predicate. Editor screens should hide Save / Delete for STAFF without write perm.
5. **Empty state copy / illustration** — match brands/categories pattern.

## Start of next session — first 3 things to do

1. Invoke `superpowers:brainstorming` skill — it'll ask clarifying questions before writing the real spec.
2. Spawn 2 cavecrew-investigator subagents in parallel: one for web product-module IA, one for BE product handler + dto cross-check. Both feed into the brainstorming round.
3. Read `docs/superpowers/specs/2026-05-20-ui-style-guide.md` + the Settings module reference implementation under `lib/features/settings/` before writing any widget code.

---

**Bridge from current branch:** PR #6 (`feat/settings-and-biometric`) needs to merge first because it carries the UI bible, KSettingsRow, KNotify restyle, build.yaml exclusion, and ProfileRepository upload-URL handling — all of which Product v1 depends on.
