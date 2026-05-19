# Brand CRUD v1 — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship Brand CRUD (list + create + edit + delete) under the Catalog tab, refactored so `/catalog` lands on a launcher screen that lets the user pick which catalog entity to manage.

**Architecture:** Generated dart-dio client (`kuru_brand_api`) → repository (`BrandRepository`) → Riverpod providers → `BrandsListScreen` with cards / search / action sheet / modal sheet for create-edit / confirm dialog for delete. New `CatalogLauncherScreen` becomes the landing page of the Catalog bottom-nav branch.

**Tech Stack:** Flutter 3.41.9, Dart 3.11, Riverpod, GoRouter (StatefulShellBranch), dio, freezed (not needed here), openapi_generator_cli + dart-dio, flutter_localizations (ARB), TablerIcons, existing `lib/design/core/` flat widgets.

**Spec:** `docs/superpowers/specs/2026-05-19-brand-crud-design.md`
**Mock:** `mocks/catalog-tab-layout.html` (variant **D**)

**Project conventions you MUST know before starting:**

- Read `CLAUDE.md` end-to-end. The BE contract, the `x-org-id` interceptor wiring, and the test gotchas (`pumpAndSettle()` ban on KSpinner/KSkeleton screens, `appBootstrapProvider` overrides) are non-negotiable.
- Read `.claude/skills/openapi-codegen/SKILL.md`. The dart-dio language-version override fix is automated in `tool/codegen.sh` but if it breaks you'll need this skill.
- Read `.claude/skills/mobile-design/SKILL.md`. Glass widgets live in `lib/design/widgets/` (auth only), flat widgets in `lib/design/core/` (everything else — this work).
- After every task: run `flutter analyze` (MUST exit 0 — info lints fail CI).
- **Test runner:** `flutter test` and `dart test` are **hard-blocked** by a PreToolUse Bash hook. Use the `mcp__plugin_vgv-ai-flutter-plugin_very-good-cli__test` MCP tool with `directory: /Users/kotomiichinose/Projects/kuru-mobile`. **It has no single-file filter** — it runs the whole tree. Steps below that say `Run: flutter test path/...` are abbreviations; actually run the MCP tool against the whole suite, then grep the output for the new test names you just added. Expect a non-zero exit code (~69) because `lib/api/*/test/` contains openapi-generator stubs that always fail — the relevant signal is whether YOUR feature tests appear as `+N -0`.

---

## File inventory

**Generated**

- `lib/api/brand/` — dart-dio output, `pubName: kuru_brand_api`. Committed.

**New code**

- `lib/features/catalog/catalog_launcher_screen.dart`
- `lib/features/catalog/brands/brands_list_screen.dart`
- `lib/features/catalog/brands/data/brand_repository.dart`
- `lib/features/catalog/brands/providers/brand_providers.dart`
- `lib/features/catalog/brands/widgets/brand_action_menu.dart`
- `lib/features/catalog/brands/widgets/create_edit_brand_sheet.dart`

**New tests**

- `test/features/catalog/catalog_launcher_screen_test.dart`
- `test/features/catalog/brands/brands_list_screen_test.dart`
- `test/features/catalog/brands/data/brand_repository_test.dart`
- `test/features/catalog/brands/widgets/brand_action_menu_test.dart`
- `test/features/catalog/brands/widgets/create_edit_brand_sheet_test.dart`
- `test/features/catalog/brand_create_flow_test.dart`
- `test/features/catalog/brand_edit_flow_test.dart`
- `test/features/catalog/brand_delete_flow_test.dart`

**Edited**

- `tool/codegen.sh` — add `brand` to `spec_for()` and `ALL_MODULES`
- `pubspec.yaml` — add `kuru_brand_api` path-dep
- `lib/app/router.dart` — refactor `/catalog` branch
- `lib/core/i18n/app_vi.arb` — Brand + catalog hub keys
- `lib/core/i18n/app_en.arb` — same
- `test/features/catalog/categories/*` — every reference to the path `/catalog` (where it means "categories list") becomes `/catalog/categories`

---

## Task 1: Codegen the Brand API client

**Files:**
- Modify: `tool/codegen.sh`
- Create: `lib/api/brand/` (whole dart-dio package, committed)
- Modify: `pubspec.yaml`

- [ ] **Step 1: Verify the upstream openapi spec exists**

Run: `ls ../gen-barcode/openapi/brand.openapi.json`
Expected: file listed; size ~24K.

- [ ] **Step 2: Cross-check the BE source-of-truth against the openapi spec**

Read in this order — they win over the openapi if they disagree (per CLAUDE.md):
1. `../gen-barcode/be/core/domains/catalog/dto/brand/create-brand.dto.ts`
2. `../gen-barcode/be/core/domains/catalog/api/brand.route.ts`
3. `../gen-barcode/be/types/brand.d.ts`
4. `../gen-barcode/be/core/domains/catalog/services/brand.service.ts`

Verify the spec's `CreateBrand` returns `{ brandId }` (HTTP 201), `GetBrandOverview` returns `{ brands[], total, page, limit }`, `DeleteBrand` accepts `{ brandId }` (single, not an array). If any of these disagree with the openapi, copy `../gen-barcode/openapi/brand.openapi.json` to `tool/openapi-patches/brand.openapi.json` and edit the patched copy. The codegen script auto-detects the patched copy.

If no disagreement is found, skip the patch step.

- [ ] **Step 3: Register the module in `tool/codegen.sh`**

Edit `tool/codegen.sh`. Replace these two locations:

```bash
spec_for() {
  local module="$1"
  case "$module" in
    category) echo "../gen-barcode/openapi/category.openapi.json" ;;
    brand)    echo "../gen-barcode/openapi/brand.openapi.json" ;;
    *) echo "" ;;
  esac
}

ALL_MODULES="category brand"
```

- [ ] **Step 4: Run codegen**

Run: `./tool/codegen.sh brand`
Expected output (last line): `✓ codegen complete`. The script (a) generates dart-dio output into `lib/api/brand/`, (b) sed-bumps the SDK constraint to `>=3.11.0 <4.0.0`, (c) runs `pub get` + `build_runner build` inside the sub-package to emit `.g.dart` files.

If you see `The language version override has to be the same in the library and its part(s)`, the sed-bump failed. Read `.claude/skills/openapi-codegen/SKILL.md` "If the fix isn't holding" recovery procedure.

- [ ] **Step 5: Add path-dep to root `pubspec.yaml`**

Find the existing `kuru_category_api` entry and add `kuru_brand_api` directly below it:

```yaml
dependencies:
  # ... existing ...
  kuru_category_api:
    path: lib/api/category
  kuru_brand_api:
    path: lib/api/brand
```

- [ ] **Step 6: Refresh pub + analyze**

Run: `flutter pub get && flutter analyze`
Expected: `flutter pub get` succeeds, `flutter analyze` returns `No issues found!` (exit code 0).

- [ ] **Step 7: Commit**

```bash
git add tool/codegen.sh pubspec.yaml pubspec.lock lib/api/brand/
git commit -m "$(cat <<'EOF'
feat(brand): codegen kuru_brand_api client

Mirrors kuru_category_api setup — dart-dio output committed under
lib/api/brand/, wired as a path-dependency in the root pubspec.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 2: l10n strings — Brand + catalog hub

**Files:**
- Modify: `lib/core/i18n/app_vi.arb`
- Modify: `lib/core/i18n/app_en.arb`

- [ ] **Step 1: Add keys to `app_vi.arb` (canonical)**

Append these keys to `lib/core/i18n/app_vi.arb` (preserve JSON validity — comma after the previous entry, no trailing comma after the last new entry if it's also the last in the file):

```json
"catalogHubTitle": "Danh mục sản phẩm",
"catalogHubCategoriesTitle": "Danh mục",
"catalogHubCategoriesSub": "Tổ chức sản phẩm theo nhóm",
"catalogHubBrandsTitle": "Thương hiệu",
"catalogHubBrandsSub": "Quản lý các nhà sản xuất",
"catalogHubDistributorsTitle": "Nhà phân phối",
"catalogHubTaxTitle": "Thuế",
"catalogHubComingSoon": "Sắp có",

"brandTitle": "Thương hiệu",
"brandTotalCount": "{count} thương hiệu",
"@brandTotalCount": { "placeholders": { "count": { "type": "int" } } },
"brandSearchHint": "Tìm thương hiệu...",
"brandStatProducts": "{count} sản phẩm",
"@brandStatProducts": { "placeholders": { "count": { "type": "int" } } },
"brandEmptyTitle": "Chưa có thương hiệu",
"brandEmptyBody": "Tạo thương hiệu đầu tiên để gom sản phẩm theo nhà sản xuất.",
"brandEmptyAction": "Tạo thương hiệu đầu tiên",
"brandLoadError": "Không tải được danh sách thương hiệu",
"brandLoadRetry": "Thử lại",

"brandCreateTitle": "Tạo thương hiệu",
"brandEditTitle": "Chỉnh sửa thương hiệu",
"brandFieldNameLabel": "Tên thương hiệu *",
"brandFieldNameHint": "VD: Bosch, Makita, Stanley",
"brandFieldNameRequired": "Tên thương hiệu là bắt buộc",
"brandCreateCta": "Tạo",
"brandEditCta": "Cập nhật",

"brandDeleteConfirmTitle": "Xóa thương hiệu?",
"brandDeleteConfirmBody": "Hành động không thể hoàn tác. {name} sẽ bị xóa.",
"@brandDeleteConfirmBody": { "placeholders": { "name": { "type": "String" } } },
"brandDeleteConfirmCta": "Xóa",

"brandNotifySaved": "Đã lưu thương hiệu",
"brandNotifyDeleted": "Đã xóa thương hiệu",
"brandNotifyServer": "Đã có lỗi xảy ra",

"brandActionEdit": "Chỉnh sửa",
"brandActionDelete": "Xóa"
```

- [ ] **Step 2: Add same keys to `app_en.arb` (mirror)**

```json
"catalogHubTitle": "Catalog",
"catalogHubCategoriesTitle": "Categories",
"catalogHubCategoriesSub": "Group products by group",
"catalogHubBrandsTitle": "Brands",
"catalogHubBrandsSub": "Manage manufacturers",
"catalogHubDistributorsTitle": "Distributors",
"catalogHubTaxTitle": "Tax",
"catalogHubComingSoon": "Coming soon",

"brandTitle": "Brands",
"brandTotalCount": "{count, plural, one{# brand} other{# brands}}",
"@brandTotalCount": { "placeholders": { "count": { "type": "int" } } },
"brandSearchHint": "Search brands...",
"brandStatProducts": "{count, plural, one{# product} other{# products}}",
"@brandStatProducts": { "placeholders": { "count": { "type": "int" } } },
"brandEmptyTitle": "No brands yet",
"brandEmptyBody": "Create your first brand to group products by manufacturer.",
"brandEmptyAction": "Create first brand",
"brandLoadError": "Could not load brands",
"brandLoadRetry": "Retry",

"brandCreateTitle": "Create brand",
"brandEditTitle": "Edit brand",
"brandFieldNameLabel": "Name *",
"brandFieldNameHint": "e.g. Bosch, Makita, Stanley",
"brandFieldNameRequired": "Name is required",
"brandCreateCta": "Create",
"brandEditCta": "Update",

"brandDeleteConfirmTitle": "Delete brand?",
"brandDeleteConfirmBody": "Cannot be undone. {name} will be deleted.",
"@brandDeleteConfirmBody": { "placeholders": { "name": { "type": "String" } } },
"brandDeleteConfirmCta": "Delete",

"brandNotifySaved": "Brand saved",
"brandNotifyDeleted": "Brand deleted",
"brandNotifyServer": "Something went wrong",

"brandActionEdit": "Edit",
"brandActionDelete": "Delete"
```

- [ ] **Step 3: Regenerate localizations**

Run: `flutter gen-l10n`
Expected: no errors. `lib/core/i18n/generated/app_localizations.dart` gets updated with new getters.

- [ ] **Step 4: Verify analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/core/i18n/app_vi.arb lib/core/i18n/app_en.arb lib/core/i18n/generated/
git commit -m "$(cat <<'EOF'
feat(brand): l10n keys for catalog hub + Brand CRUD

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 3: BrandRepository (TDD)

**Files:**
- Create: `lib/features/catalog/brands/data/brand_repository.dart`
- Test:   `test/features/catalog/brands/data/brand_repository_test.dart`

This task follows the pattern of `lib/features/catalog/categories/data/category_repository.dart`. Read that file once before you start — your code should mirror its style (logging, `_extract` helper, `ApiResult<T>` return shape).

- [ ] **Step 1: Write the failing test scaffold**

Create `test/features/catalog/brands/data/brand_repository_test.dart`:

```dart
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/brands/data/brand_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockBrandApi extends Mock implements gen.BrandApi {}

gen.BrandOverviewItem _fakeItem({String id = 'brand-1', String name = 'Nike'}) =>
    gen.BrandOverviewItem(
      (b) => b
        ..id = id
        ..orgId = 'org-1'
        ..name = name
        ..productCount = 0,
    );

Response<gen.GetBrandOverview200Response> _overviewResponse(
  List<gen.BrandOverviewItem> items, {
  int statusCode = 200,
  int total = 0,
}) {
  final inner = gen.GetBrandOverviewResponse(
    (b) => b
      ..brands.replace(BuiltList<gen.BrandOverviewItem>(items))
      ..total = total
      ..page = 1
      ..limit = 200,
  );
  final outer = gen.GetBrandOverview200Response(
    (b) => b
      ..success = true
      ..data.replace(inner)
      ..timestamp = DateTime(2026),
  );
  return Response(
    requestOptions: RequestOptions(),
    statusCode: statusCode,
    data: outer,
  );
}

DioException _http400(String message) => DioException(
      requestOptions: RequestOptions(),
      response: Response(
        requestOptions: RequestOptions(),
        statusCode: 400,
        data: {
          'success': false,
          'error': {'message': message, 'code': 'VALIDATION_ERROR'},
          'timestamp': DateTime(2026).toIso8601String(),
        },
      ),
      error: BadRequestException(message),
    );

void main() {
  late _MockBrandApi api;
  late BrandRepository repo;

  setUpAll(() {
    registerFallbackValue(
      gen.CreateBrandRequest((b) => b..name = ''),
    );
    registerFallbackValue(
      gen.UpdateBrandRequest((b) => b..brandId = ''),
    );
    registerFallbackValue(
      gen.DeleteBrandRequest((b) => b..brandId = ''),
    );
  });

  setUp(() {
    api = _MockBrandApi();
    repo = BrandRepository(api);
  });

  group('overview', () {
    test('returns brands on 200', () async {
      when(() => api.getBrandOverview(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            searchString: any(named: 'searchString'),
          )).thenAnswer(
        (_) async => _overviewResponse([
          _fakeItem(id: 'b1', name: 'Nike'),
          _fakeItem(id: 'b2', name: 'Adidas'),
        ], total: 2),
      );

      final result = await repo.getOverview();

      expect(result, isA<ApiSuccess<List<gen.BrandOverviewItem>>>());
      final list = (result as ApiSuccess<List<gen.BrandOverviewItem>>).value;
      expect(list, hasLength(2));
      expect(list[0].name, 'Nike');
    });

    test('returns BadRequestException on 400', () async {
      when(() => api.getBrandOverview(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            searchString: any(named: 'searchString'),
          )).thenThrow(_http400('Bad params'));

      final result = await repo.getOverview();

      expect(result, isA<ApiFailure<List<gen.BrandOverviewItem>>>());
      expect(
        (result as ApiFailure<List<gen.BrandOverviewItem>>).err,
        isA<BadRequestException>(),
      );
    });
  });

  group('create', () {
    test('returns brandId on 201', () async {
      final inner = gen.CreateBrandResponse((b) => b..brandId = 'new-brand-id');
      final outer = gen.CreateBrand200Response(
        (b) => b
          ..success = true
          ..data.replace(inner)
          ..timestamp = DateTime(2026),
      );
      when(() => api.createBrand(createBrandRequest: any(named: 'createBrandRequest')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(),
                statusCode: 201,
                data: outer,
              ));

      final result = await repo.create(name: 'Nike');

      expect(result, isA<ApiSuccess<String>>());
      expect((result as ApiSuccess<String>).value, 'new-brand-id');
    });

    test('surfaces dup-name 400 verbatim', () async {
      when(() => api.createBrand(createBrandRequest: any(named: 'createBrandRequest')))
          .thenThrow(_http400('Brand with this name already exists'));

      final result = await repo.create(name: 'Nike');

      expect(result, isA<ApiFailure<String>>());
      final err = (result as ApiFailure<String>).err;
      expect(err, isA<BadRequestException>());
      expect((err as BadRequestException).message,
          'Brand with this name already exists');
    });
  });

  group('update', () {
    test('returns success on 200', () async {
      final inner = gen.UpdateBrandResponse((b) => b..success = true);
      final outer = gen.UpdateBrand200Response(
        (b) => b
          ..success = true
          ..data.replace(inner)
          ..timestamp = DateTime(2026),
      );
      when(() => api.updateBrand(updateBrandRequest: any(named: 'updateBrandRequest')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(),
                statusCode: 200,
                data: outer,
              ));

      final result = await repo.update(brandId: 'b1', name: 'New Name');

      expect(result, isA<ApiSuccess<void>>());
    });
  });

  group('remove', () {
    test('returns success on 201', () async {
      final inner = gen.DeleteBrandResponse((b) => b..success = true);
      final outer = gen.DeleteBrand200Response(
        (b) => b
          ..success = true
          ..data.replace(inner)
          ..timestamp = DateTime(2026),
      );
      when(() => api.deleteBrand(deleteBrandRequest: any(named: 'deleteBrandRequest')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(),
                statusCode: 201,
                data: outer,
              ));

      final result = await repo.remove('b1');

      expect(result, isA<ApiSuccess<void>>());
    });

    test('surfaces 400 reason verbatim', () async {
      when(() => api.deleteBrand(deleteBrandRequest: any(named: 'deleteBrandRequest')))
          .thenThrow(_http400('Brand has products'));

      final result = await repo.remove('b1');

      expect(result, isA<ApiFailure<void>>());
      expect(
        (result as ApiFailure<void>).err,
        isA<BadRequestException>(),
      );
    });
  });
}
```

> **Note:** the exact generated wrapper type names (`GetBrandOverview200Response`, `CreateBrand200Response`, `UpdateBrand200Response`, `DeleteBrand200Response`) come from openapi-generator's path-operation-based class naming. If they differ after codegen, open `lib/api/brand/lib/src/model/` to find the real names and adjust.

- [ ] **Step 2: Run test, confirm FAIL (no `BrandRepository` yet)**

Run: `flutter test test/features/catalog/brands/data/brand_repository_test.dart`
Expected: build failure — `Error: 'BrandRepository' isn't defined`.

- [ ] **Step 3: Implement `BrandRepository`**

Create `lib/features/catalog/brands/data/brand_repository.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;

/// Wraps the generated [gen.BrandApi] with DioException → ApiException
/// translation and `ApiResult<T>` returns.
///
/// Brand v1 is flat — no children, no slug, no logo. Form sends only `name`.
class BrandRepository {
  BrandRepository(this._api);
  final gen.BrandApi _api;

  static const int _overviewLimit = 200;

  /// Fetches the first page of brands (limit=200). Discards pagination meta —
  /// the list screen treats this as load-all and filters client-side. Re-evaluate
  /// when any real org passes ~150 brands.
  Future<ApiResult<List<gen.BrandOverviewItem>>> getOverview() async {
    try {
      final res = await _api.getBrandOverview(
        page: 1,
        limit: _overviewLimit,
      );
      final list = res.data?.data.brands?.toList() ?? const [];
      log.i('GetBrandOverview ← ${res.statusCode} count=${list.length}');
      return ApiResult.success(list);
    } on DioException catch (e) {
      log.w('GetBrandOverview failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  /// Fetches a single brand by id.
  Future<ApiResult<gen.BrandResponse>> getById(String brandId) async {
    try {
      final res = await _api.getBrandById(brandId: brandId);
      final body = res.data?.data;
      if (body == null) {
        return ApiResult.failure(
          const UnknownException('Empty body from GetBrandById'),
        );
      }
      log.i('GetBrandById ← ${res.statusCode} id=${body.id}');
      return ApiResult.success(body);
    } on DioException catch (e) {
      log.w('GetBrandById($brandId) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  /// Creates a new brand. Returns the new `brandId`.
  ///
  /// HTTP 400 with `error.message = "Brand with this name already exists"` is
  /// surfaced via [BadRequestException] for the form to display verbatim.
  Future<ApiResult<String>> create({required String name}) async {
    try {
      final res = await _api.createBrand(
        createBrandRequest: gen.CreateBrandRequest((b) => b..name = name),
      );
      final body = res.data?.data;
      final id = body?.brandId;
      if (id == null) {
        return ApiResult.failure(
          const UnknownException('Empty brandId from CreateBrand'),
        );
      }
      log.i('CreateBrand ← ${res.statusCode} id=$id');
      return ApiResult.success(id);
    } on DioException catch (e) {
      log.w('CreateBrand failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  /// Updates an existing brand. Only `name` is editable in v1.
  Future<ApiResult<void>> update({
    required String brandId,
    required String name,
  }) async {
    try {
      final res = await _api.updateBrand(
        updateBrandRequest: gen.UpdateBrandRequest(
          (b) => b
            ..brandId = brandId
            ..name = name,
        ),
      );
      log.i('UpdateBrand ← ${res.statusCode} id=$brandId');
      return ApiResult.success(null);
    } on DioException catch (e) {
      log.w('UpdateBrand($brandId) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  /// Soft-deletes a brand. Returns success even on 400; callers must surface
  /// the verbatim BE message (e.g. "Brand has products" if BE adds it).
  Future<ApiResult<void>> remove(String brandId) async {
    try {
      final res = await _api.deleteBrand(
        deleteBrandRequest: gen.DeleteBrandRequest((b) => b..brandId = brandId),
      );
      log.i('DeleteBrand ← ${res.statusCode} id=$brandId');
      return ApiResult.success(null);
    } on DioException catch (e) {
      log.w('DeleteBrand($brandId) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  ApiException _extract(DioException e) {
    final attached = e.error;
    if (attached is ApiException) return attached;
    return mapDioError(e);
  }
}
```

- [ ] **Step 4: Run tests, confirm PASS**

Run: `flutter test test/features/catalog/brands/data/brand_repository_test.dart`
Expected: all 6 tests pass.

- [ ] **Step 5: Verify analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/features/catalog/brands/data/brand_repository.dart \
        test/features/catalog/brands/data/brand_repository_test.dart
git commit -m "$(cat <<'EOF'
feat(brand): BrandRepository over generated kuru_brand_api

Mirrors CategoryRepository — sealed ApiResult<T> + typed ApiException
translation via _extract. overview() fetches limit=200 and discards
pagination meta; create/update/remove map directly to BE routes.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 4: Brand providers (Riverpod)

**Files:**
- Create: `lib/features/catalog/brands/providers/brand_providers.dart`

- [ ] **Step 1: Write the providers**

Create `lib/features/catalog/brands/providers/brand_providers.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/supertokens_setup.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/features/catalog/brands/data/brand_repository.dart';

/// Generated Brand API client wired with our configured dio.
///
/// Same pattern as `categoryApiClientProvider`: clone the shared dio so we can
/// set the baseUrl to `${apiBaseUrl}/api/v1` without mutating the host instance
/// used by `/auth/*` routes. Re-install SuperTokens via its extension method
/// (it is NOT in `sharedDio.interceptors` so `addAll` below does not bring it)
/// and copy the manual interceptors (x-org-id, logging, error-mapping).
final brandApiClientProvider = Provider<gen.BrandApi>((ref) {
  final sharedDio = ref.watch(dioProvider);
  final brandDio = Dio(
    sharedDio.options.copyWith(baseUrl: '${Env.apiBaseUrl}/api/v1'),
  );
  wireSuperTokensToDio(brandDio);
  brandDio.interceptors.addAll(sharedDio.interceptors);
  return gen.KuruBrandApi(dio: brandDio).getBrandApi();
});

final brandRepositoryProvider = Provider<BrandRepository>((ref) {
  return BrandRepository(ref.watch(brandApiClientProvider));
});

/// Flat list of brands for the current org. Watches [currentOrgIdProvider] so
/// org switches auto-invalidate the cache.
final brandOverviewProvider =
    FutureProvider<List<gen.BrandOverviewItem>>((ref) async {
  ref.watch(currentOrgIdProvider);
  final repo = ref.watch(brandRepositoryProvider);
  return repo.getOverview().unwrap();
});
```

> **Note:** The generated root class name follows the openapi `info.title`. If codegen produces something other than `KuruBrandApi`, open `lib/api/brand/lib/kuru_brand_api.dart` and use the actual class name.

- [ ] **Step 2: Verify analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/features/catalog/brands/providers/brand_providers.dart
git commit -m "$(cat <<'EOF'
feat(brand): Riverpod providers wired with dio interceptors

brandApiClientProvider clones the shared dio with /api/v1 baseUrl and
reinstalls SuperTokens — same pattern as categoryApiClientProvider.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 5: CatalogLauncherScreen widget (no router wiring yet)

**Files:**
- Create: `lib/features/catalog/catalog_launcher_screen.dart`

- [ ] **Step 1: Write the screen**

Create `lib/features/catalog/catalog_launcher_screen.dart`:

```dart
// TablerIcons uses snake_case symbols.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';

/// Landing screen for the Catalog bottom-nav branch.
///
/// Renders a vertical list of "what do you want to manage?" cards: live
/// Categories + Brands, plus disabled "Sắp có" placeholders for Distributor
/// and Tax. Tapping a live card pushes to the dedicated list screen.
class CatalogLauncherScreen extends StatelessWidget {
  const CatalogLauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            KPageHeader(title: l.catalogHubTitle),
            const SizedBox(height: 16),
            _LauncherCard(
              icon: TablerIcons.layout_grid,
              title: l.catalogHubCategoriesTitle,
              subtitle: l.catalogHubCategoriesSub,
              onTap: () => context.go('/catalog/categories'),
            ),
            const SizedBox(height: 12),
            _LauncherCard(
              icon: TablerIcons.shopping_bag,
              title: l.catalogHubBrandsTitle,
              subtitle: l.catalogHubBrandsSub,
              onTap: () => context.go('/catalog/brands'),
            ),
            const SizedBox(height: 12),
            _LauncherCard(
              icon: TablerIcons.truck,
              title: l.catalogHubDistributorsTitle,
              subtitle: l.catalogHubComingSoon,
              disabled: true,
            ),
            const SizedBox(height: 12),
            _LauncherCard(
              icon: TablerIcons.receipt_tax,
              title: l.catalogHubTaxTitle,
              subtitle: l.catalogHubComingSoon,
              disabled: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _LauncherCard extends StatelessWidget {
  const _LauncherCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.disabled = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Opacity(
      opacity: disabled ? 0.55 : 1.0,
      child: Material(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: c.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: c.accent100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, size: 30, color: c.accent300),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: c.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(TablerIcons.chevron_right, color: c.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/features/catalog/catalog_launcher_screen.dart
git commit -m "$(cat <<'EOF'
feat(catalog): CatalogLauncherScreen — 4-card chooser

Categories + Brands live; Distributor + Tax disabled with "Sắp có"
subtitle. Tapping a live card uses context.go to push into the
dedicated list screen.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 6: Router refactor — /catalog → launcher

**Files:**
- Modify: `lib/app/router.dart`

This task moves `CategoriesListScreen` from `/catalog` to `/catalog/categories` and adds `/catalog/brands` as a placeholder stub. Brand list arrives in Task 11.

- [ ] **Step 1: Edit the Catalog branch**

Open `lib/app/router.dart` and locate the Catalog branch (~line 97-113). Replace it with:

```dart
// Branch 1: Catalog
StatefulShellBranch(
  routes: [
    GoRoute(
      path: '/catalog',
      builder: (_, __) => const CatalogLauncherScreen(),
      routes: [
        GoRoute(
          path: 'categories',
          builder: (_, __) => const CategoriesListScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (_, state) => CategoryDetailScreen(
                categoryId: state.pathParameters['id'] ?? '',
              ),
            ),
          ],
        ),
        // /catalog/brands is added by Task 11 once BrandsListScreen ships.
      ],
    ),
  ],
),
```

> **Watch out:**
> - The new `/catalog/categories/:id` path is `/catalog/categories/:id`, NOT `/catalog/categories/categories/:id`. GoRoute's `path: ':id'` inside the `categories` parent yields the combined path correctly.
> - Between this commit and Task 11, tapping the launcher's "Thương hiệu" card in a live app will trigger a GoRouter "no route" error — that's expected for the intermediate state. T8's launcher widget test uses its own router harness (with stub `/catalog/brands` route), so it passes without the real route existing.

- [ ] **Step 2: Add imports at top of router.dart**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/features/catalog/catalog_launcher_screen.dart';
```

The `CategoriesListScreen` and `CategoryDetailScreen` imports stay — both are still referenced inside the nested `categories` route.

- [ ] **Step 3: Verify analyze + tests still pass**

Run: `flutter analyze`
Expected: `No issues found!`

Run: `flutter test`
Expected: existing Category tests still pass — they will because T7 hasn't run yet AND many tests don't tap the Catalog tab. Any failure here MUST be a pre-existing test that taps Catalog and expected to land on Categories — let T7 (next task) handle those, do not patch in this task.

Acceptable: tests in `test/features/main_shell/`, `test/features/catalog/categories/list_to_detail_navigation_test.dart`, `test/features/catalog/categories/category_detail_screen_test.dart`, and `test/features/demo/core_design_demo_screen_test.dart` may fail at this checkpoint. Their fixes belong to T7. Note which ones failed in the commit message.

- [ ] **Step 4: Smoke-test in the simulator (optional but recommended)**

If a simulator is already running, hot-restart the app:
1. Boot Catalog tab → expect the launcher with 4 cards.
2. Tap Categories card → expect the existing CategoriesListScreen.
3. Tap Catalog bottom-nav tab again → expect to return to the launcher (StatefulShellBranch re-tap behavior).
4. **Do NOT** tap Brands yet — the route doesn't exist until T11. Tapping it now will throw a GoRouter "no route" error.
5. Tap a disabled card → expect no navigation.

- [ ] **Step 5: Commit**

```bash
git add lib/app/router.dart
git commit -m "$(cat <<'EOF'
refactor(router): /catalog → launcher; categories at /catalog/categories

Adds /catalog/brands placeholder. CategoriesListScreen moves under
/catalog/categories so the launcher (T5) can present catalog primitives
side by side. Brand list ships in a later task.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 7: Retarget existing tests at the new Catalog tab structure

**Files (will be discovered in Step 1):**
- Likely modified: `test/features/catalog/categories/list_to_detail_navigation_test.dart`
- Likely modified: `test/features/catalog/categories/category_detail_screen_test.dart`
- Likely modified: `test/features/main_shell/main_shell_e2e_test.dart`
- Likely modified: `test/features/main_shell/main_shell_test.dart`
- Likely modified: `test/features/demo/core_design_demo_screen_test.dart` (only the assertion that "Catalog" is visible — that still holds)

After T6, the Catalog tab's root is `CatalogLauncherScreen`, NOT `CategoriesListScreen`. Two distinct patterns in tests need updating.

- [ ] **Step 1: Find hardcoded `'/catalog'` strings**

```bash
grep -rn "'/catalog'" test/features/
grep -rn '"/catalog"' test/features/
```

For each result whose intent is "the categories list lives here", change to `/catalog/categories`. If it's a `go('/catalog')` whose intent is "the catalog landing screen", leave it as `/catalog` (it now lands on the launcher).

- [ ] **Step 2: Find Catalog-tab-tap call sites**

```bash
grep -rn "find.text('Catalog')" test/features/
```

Expected matches (confirmed at plan-write time): `list_to_detail_navigation_test.dart`, `category_detail_screen_test.dart`, `main_shell_e2e_test.dart`, `main_shell_test.dart`, `core_design_demo_screen_test.dart`.

For each `await tester.tap(find.text('Catalog'))` that EXPECTS the categories list to appear next (i.e. `await tester.tap(find.text('Categories'))` immediately fails because the user is now on the launcher), insert a follow-up tap on the launcher's Categories card:

```dart
await tester.tap(find.text('Catalog'));          // bottom-nav tab
await tester.pump();
await tester.pump(const Duration(milliseconds: 50));
// NEW: launcher renders. Drill into Categories.
await tester.tap(find.text('Categories'));       // English-locale tests
// OR if the test renders the vi locale:
// await tester.tap(find.text('Danh mục'));
await tester.pump();
await tester.pump(const Duration(milliseconds: 50));
```

Inspect each test's `MaterialApp(locale: ...)` or default locale to choose the right card label. `category_detail_screen_test.dart` sets `locale: Locale('en')` → use `'Categories'`. Most others have no override and inherit the default `vi` → use `'Danh mục'`.

Tests where the Catalog tap is just to verify the tab itself works (e.g. `main_shell_test.dart:23` asserting `find.text('Catalog'), findsOneWidget` for the bottom-nav label) need no follow-up — the launcher arrival is still proof that the tab works.

- [ ] **Step 3: Run the full test directory**

Run: `flutter test test/features/catalog/ test/features/main_shell/ test/features/demo/`
Expected: all pass. If any fail with "Multiple widgets found for finder" or "no widget", the follow-up tap is missing or pointing at the wrong locale's card title.

- [ ] **Step 4: Verify analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add test/features/
git commit -m "$(cat <<'EOF'
test(catalog): retarget existing tests at /catalog launcher

Catalog tab now lands on CatalogLauncherScreen; existing tests that
tapped the Catalog bottom-nav tab and expected to see the categories
list need an extra tap on the launcher's Categories card.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 8: catalog_launcher_screen widget test

**Files:**
- Create: `test/features/catalog/catalog_launcher_screen_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/features/catalog/catalog_launcher_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/catalog_launcher_screen.dart';

GoRouter _routerHarness() {
  return GoRouter(
    initialLocation: '/catalog',
    routes: [
      GoRoute(
        path: '/catalog',
        builder: (_, __) => const CatalogLauncherScreen(),
        routes: [
          GoRoute(
            path: 'categories',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('CATEGORIES_HIT'))),
          ),
          GoRoute(
            path: 'brands',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('BRANDS_HIT'))),
          ),
        ],
      ),
    ],
  );
}

Widget _harness() {
  final router = _routerHarness();
  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

void main() {
  testWidgets('renders 4 cards (2 live + 2 disabled)', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    expect(find.text('Danh mục'), findsOneWidget);
    expect(find.text('Thương hiệu'), findsOneWidget);
    expect(find.text('Nhà phân phối'), findsOneWidget);
    expect(find.text('Thuế'), findsOneWidget);
    // Two "Sắp có" subtitles (Distributor + Tax).
    expect(find.text('Sắp có'), findsNWidgets(2));
  });

  testWidgets('tap Categories card → navigates to /catalog/categories',
      (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    await tester.tap(find.text('Danh mục'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('CATEGORIES_HIT'), findsOneWidget);
  });

  testWidgets('tap Brands card → navigates to /catalog/brands',
      (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    await tester.tap(find.text('Thương hiệu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('BRANDS_HIT'), findsOneWidget);
  });

  testWidgets('tap disabled Distributor card → no navigation', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    await tester.tap(find.text('Nhà phân phối'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Still on the launcher — the other 3 titles remain visible.
    expect(find.text('Danh mục'), findsOneWidget);
    expect(find.text('Thương hiệu'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run the test**

Run: `flutter test test/features/catalog/catalog_launcher_screen_test.dart`
Expected: all 4 tests pass.

- [ ] **Step 3: Commit**

```bash
git add test/features/catalog/catalog_launcher_screen_test.dart
git commit -m "$(cat <<'EOF'
test(catalog): widget test for CatalogLauncherScreen

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 9: BrandActionMenu (TDD)

**Files:**
- Create: `lib/features/catalog/brands/widgets/brand_action_menu.dart`
- Test:   `test/features/catalog/brands/widgets/brand_action_menu_test.dart`

Modeled on `lib/features/catalog/categories/widgets/category_action_menu.dart` — read that file first.

- [ ] **Step 1: Write the failing test**

Create `test/features/catalog/brands/widgets/brand_action_menu_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/brands/widgets/brand_action_menu.dart';

Widget _harness(void Function(BuildContext) onMount) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) => onMount(context));
        return const Scaffold();
      },
    ),
  );
}

void main() {
  testWidgets('Edit returns BrandAction.edit', (tester) async {
    BrandAction? result;
    await tester.pumpWidget(_harness((ctx) async {
      result = await showBrandActionMenu(context: ctx, brandName: 'Nike');
    }));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Chỉnh sửa'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(result, BrandAction.edit);
  });

  testWidgets('Delete returns BrandAction.delete', (tester) async {
    BrandAction? result;
    await tester.pumpWidget(_harness((ctx) async {
      result = await showBrandActionMenu(context: ctx, brandName: 'Nike');
    }));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.text('Xóa'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(result, BrandAction.delete);
  });
}
```

- [ ] **Step 2: Run, confirm FAIL**

Run: `flutter test test/features/catalog/brands/widgets/brand_action_menu_test.dart`
Expected: build error — `BrandAction` undefined.

- [ ] **Step 3: Implement BrandActionMenu**

Create `lib/features/catalog/brands/widgets/brand_action_menu.dart`:

```dart
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';

enum BrandAction { edit, delete }

/// Shows the Edit / Delete action sheet for a brand row. Returns the chosen
/// action, or `null` if the user dismissed without picking.
Future<BrandAction?> showBrandActionMenu({
  required BuildContext context,
  required String brandName,
}) {
  final l = AppLocalizations.of(context);
  return showKActionSheet<BrandAction>(
    context: context,
    title: brandName,
    actions: [
      KActionItem(
        id: BrandAction.edit,
        label: l.brandActionEdit,
        icon: TablerIcons.edit,
      ),
      KActionItem(
        id: BrandAction.delete,
        label: l.brandActionDelete,
        icon: TablerIcons.trash,
        danger: true,
      ),
    ],
  );
}
```

Verified against `lib/design/core/modal/k_action_sheet.dart`: parameter is `actions:` (not `items:`), `KActionItem` uses `id:` (not `value:`), and destructive rows use `danger: true` (no `iconColor` / `labelColor`). Same shape as `lib/features/catalog/categories/widgets/category_action_menu.dart`.

- [ ] **Step 4: Run tests, confirm PASS**

Run: `flutter test test/features/catalog/brands/widgets/brand_action_menu_test.dart`
Expected: both tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/brands/widgets/brand_action_menu.dart \
        test/features/catalog/brands/widgets/brand_action_menu_test.dart
git commit -m "$(cat <<'EOF'
feat(brand): BrandActionMenu — Edit / Delete action sheet

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 10: CreateEditBrandSheet (TDD — create + edit + dup-name surfacing)

**Files:**
- Create: `lib/features/catalog/brands/widgets/create_edit_brand_sheet.dart`
- Test:   `test/features/catalog/brands/widgets/create_edit_brand_sheet_test.dart`

Read `lib/features/catalog/categories/widgets/create_edit_category_sheet.dart` first — same patterns: sealed mode, `showKModalSheet<bool>`, internal `GlobalKey<_StateName>` to invoke `_submit()` from `onConfirm`.

- [ ] **Step 1: Write the failing test**

Create `test/features/catalog/brands/widgets/create_edit_brand_sheet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/brands/data/brand_repository.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:kuru_mobile/features/catalog/brands/widgets/create_edit_brand_sheet.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements BrandRepository {}

Widget _harness(_MockRepo repo, void Function(BuildContext) onMount) {
  return ProviderScope(
    overrides: [brandRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) => onMount(context));
          return const Scaffold();
        },
      ),
    ),
  );
}

gen.BrandOverviewItem _existing() => gen.BrandOverviewItem(
      (b) => b
        ..id = 'b1'
        ..orgId = 'org-1'
        ..name = 'Nike'
        ..productCount = 0,
    );

void main() {
  setUpAll(() {
    registerFallbackValue('');
  });

  group('create', () {
    testWidgets('empty name → required errorText, stays open', (tester) async {
      final repo = _MockRepo();
      await tester.pumpWidget(_harness(repo, (ctx) async {
        await showCreateEditBrandSheet(
          context: ctx,
          mode: const CreateBrand(),
        );
      }));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Tap Create with empty field.
      await tester.tap(find.text('Tạo').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Tên thương hiệu là bắt buộc'), findsOneWidget);
      verifyNever(() => repo.create(name: any(named: 'name')));
    });

    testWidgets('success → closes with true', (tester) async {
      final repo = _MockRepo();
      when(() => repo.create(name: 'Nike'))
          .thenAnswer((_) async => ApiResult.success('new-id'));

      bool? returned;
      await tester.pumpWidget(_harness(repo, (ctx) async {
        returned = await showCreateEditBrandSheet(
          context: ctx,
          mode: const CreateBrand(),
        );
      }));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.enterText(find.byType(TextField).first, 'Nike');
      await tester.tap(find.text('Tạo').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(returned, isTrue);
      verify(() => repo.create(name: 'Nike')).called(1);
    });

    testWidgets('400 dup-name → errorText surfaces verbatim, stays open',
        (tester) async {
      final repo = _MockRepo();
      when(() => repo.create(name: 'Nike')).thenAnswer((_) async =>
          ApiResult.failure(
              const BadRequestException('Brand with this name already exists')));

      await tester.pumpWidget(_harness(repo, (ctx) async {
        await showCreateEditBrandSheet(
          context: ctx,
          mode: const CreateBrand(),
        );
      }));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.enterText(find.byType(TextField).first, 'Nike');
      await tester.tap(find.text('Tạo').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Brand with this name already exists'), findsOneWidget);
    });
  });

  group('edit', () {
    testWidgets('prefills name field', (tester) async {
      final repo = _MockRepo();
      await tester.pumpWidget(_harness(repo, (ctx) async {
        await showCreateEditBrandSheet(
          context: ctx,
          mode: EditBrand(brand: _existing()),
        );
      }));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Nike'), findsWidgets);
    });

    testWidgets('success → closes with true + calls update', (tester) async {
      final repo = _MockRepo();
      when(() => repo.update(brandId: 'b1', name: 'Nike v2'))
          .thenAnswer((_) async => ApiResult.success(null));

      bool? returned;
      await tester.pumpWidget(_harness(repo, (ctx) async {
        returned = await showCreateEditBrandSheet(
          context: ctx,
          mode: EditBrand(brand: _existing()),
        );
      }));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.enterText(find.byType(TextField).first, 'Nike v2');
      await tester.tap(find.text('Cập nhật').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(returned, isTrue);
      verify(() => repo.update(brandId: 'b1', name: 'Nike v2')).called(1);
    });
  });
}
```

- [ ] **Step 2: Run, confirm FAIL**

Run: `flutter test test/features/catalog/brands/widgets/create_edit_brand_sheet_test.dart`
Expected: build error — `CreateBrand` / `EditBrand` / `showCreateEditBrandSheet` undefined.

- [ ] **Step 3: Implement the sheet**

Create `lib/features/catalog/brands/widgets/create_edit_brand_sheet.dart`:

```dart
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';

sealed class BrandSheetMode {
  const BrandSheetMode();
}

class CreateBrand extends BrandSheetMode {
  const CreateBrand();
}

class EditBrand extends BrandSheetMode {
  const EditBrand({required this.brand});
  final gen.BrandOverviewItem brand;
}

/// Shows the Create or Edit brand sheet. Returns `true` after a successful
/// save; `null` on cancel / dismiss.
Future<bool?> showCreateEditBrandSheet({
  required BuildContext context,
  required BrandSheetMode mode,
}) {
  final l = AppLocalizations.of(context);
  final title = switch (mode) {
    CreateBrand() => l.brandCreateTitle,
    EditBrand() => l.brandEditTitle,
  };
  final confirmLabel = switch (mode) {
    CreateBrand() => l.brandCreateCta,
    EditBrand() => l.brandEditCta,
  };
  final key = GlobalKey<_BrandFormState>();
  return showKModalSheet<bool>(
    context: context,
    title: title,
    confirmLabel: confirmLabel,
    onConfirm: () async => key.currentState?._submit() ?? false,
    builder: (_) => _BrandForm(key: key, mode: mode),
  );
}

class _BrandForm extends ConsumerStatefulWidget {
  const _BrandForm({required this.mode, super.key});
  final BrandSheetMode mode;

  @override
  ConsumerState<_BrandForm> createState() => _BrandFormState();
}

class _BrandFormState extends ConsumerState<_BrandForm> {
  late final TextEditingController _name;
  String? _error;

  @override
  void initState() {
    super.initState();
    final m = widget.mode;
    _name = TextEditingController(
      text: m is EditBrand ? (m.brand.name ?? '') : '',
    );
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<bool> _submit() async {
    final l = AppLocalizations.of(context);
    final value = _name.text.trim();
    if (value.isEmpty) {
      setState(() => _error = l.brandFieldNameRequired);
      return false;
    }
    setState(() => _error = null);
    final repo = ref.read(brandRepositoryProvider);
    final result = switch (widget.mode) {
      CreateBrand() => await repo.create(name: value),
      EditBrand(brand: final b) =>
        await repo.update(brandId: b.id!, name: value),
    };
    if (result is ApiSuccess) {
      return true;
    }
    // ApiFailure — handle ALL error types inside the sheet without throwing.
    // KModalSheet._handleConfirm has no try/catch (k_modal_sheet.dart:90-105);
    // any throw wedges the busy state forever. BadRequestException → field
    // errorText (sheet stays open). Network/timeout/server → SnackBar via
    // ScaffoldMessenger and stay open so the user can retry.
    final err = (result as ApiFailure).err;
    if (err is BadRequestException) {
      setState(() => _error = err.message);
    } else {
      final msg = err is NetworkException || err is TimeoutException
          ? err.message
          : l.brandNotifyServer;
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: KTextField(
        controller: _name,
        label: l.brandFieldNameLabel,
        placeholder: l.brandFieldNameHint,
        maxLength: 120,
        errorText: _error,
      ),
    );
  }
}
```

Verified against `lib/design/core/input/k_text_field.dart`: hint param is `placeholder:` (not `hint:`); there is no `autofocus:` param (do not add — first-field-focus is acceptable to skip in v1). `showKModalSheet`'s `onConfirm` contract per `lib/design/core/modal/k_modal_sheet.dart:90-105`: return `false` to keep the sheet open (busy state clears via `setState`); return `true` to close and pop `true as T?`. **Do NOT throw from `onConfirm`** — `_handleConfirm` has no try/catch, an unhandled throw wedges `_busy=true` forever and surfaces an unhandled async error.

- [ ] **Step 4: Run tests, confirm PASS**

Run: `flutter test test/features/catalog/brands/widgets/create_edit_brand_sheet_test.dart`
Expected: all 5 tests pass.

- [ ] **Step 5: Verify analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/features/catalog/brands/widgets/create_edit_brand_sheet.dart \
        test/features/catalog/brands/widgets/create_edit_brand_sheet_test.dart
git commit -m "$(cat <<'EOF'
feat(brand): CreateEditBrandSheet — single name field

Sealed BrandSheetMode (Create | Edit). Empty name → required errorText;
BE 400 dup-name → verbatim message in errorText. Other failures rethrow
so the caller's SnackBar handler runs.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 11: BrandsListScreen (TDD — empty / loading / error / data / search)

**Files:**
- Create: `lib/features/catalog/brands/brands_list_screen.dart`
- Test:   `test/features/catalog/brands/brands_list_screen_test.dart`

This task includes the inline `_InitialChip` + `_BrandCardItem` widgets — they live inside `brands_list_screen.dart` (private). YAGNI: do not split until a second consumer appears.

- [ ] **Step 1: Write the failing test**

Create `test/features/catalog/brands/brands_list_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/brands/brands_list_screen.dart';
import 'package:kuru_mobile/features/catalog/brands/data/brand_repository.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements BrandRepository {}

gen.BrandOverviewItem _item({required String id, required String name, int products = 0}) =>
    gen.BrandOverviewItem(
      (b) => b
        ..id = id
        ..orgId = 'org-1'
        ..name = name
        ..productCount = products,
    );

Widget _harness(_MockRepo repo) {
  return ProviderScope(
    overrides: [brandRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const BrandsListScreen(),
    ),
  );
}

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  testWidgets('empty state shows CTA', (tester) async {
    when(() => repo.getOverview()).thenAnswer((_) async => ApiResult.success([]));

    await tester.pumpWidget(_harness(repo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Chưa có thương hiệu'), findsOneWidget);
    expect(find.text('Tạo thương hiệu đầu tiên'), findsOneWidget);
  });

  testWidgets('error state shows retry', (tester) async {
    when(() => repo.getOverview()).thenAnswer((_) async =>
        ApiResult.failure(const ServerException('boom', statusCode: 500)));

    await tester.pumpWidget(_harness(repo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Không tải được danh sách thương hiệu'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
  });

  testWidgets('data state renders cards', (tester) async {
    when(() => repo.getOverview()).thenAnswer((_) async => ApiResult.success([
          _item(id: 'b1', name: 'Nike', products: 42),
          _item(id: 'b2', name: 'Adidas', products: 31),
        ]));

    await tester.pumpWidget(_harness(repo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Nike'), findsOneWidget);
    expect(find.text('Adidas'), findsOneWidget);
  });

  testWidgets('search filters with accent-folding', (tester) async {
    when(() => repo.getOverview()).thenAnswer((_) async => ApiResult.success([
          _item(id: 'b1', name: 'Nước Suối'),
          _item(id: 'b2', name: 'Coca'),
        ]));

    await tester.pumpWidget(_harness(repo));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.enterText(find.byType(TextField), 'nuoc');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Nước Suối'), findsOneWidget);
    expect(find.text('Coca'), findsNothing);
  });
}
```

- [ ] **Step 2: Run, confirm FAIL**

Run: `flutter test test/features/catalog/brands/brands_list_screen_test.dart`
Expected: build error — `BrandsListScreen` undefined.

- [ ] **Step 3: Implement the screen**

Create `lib/features/catalog/brands/brands_list_screen.dart`:

```dart
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/text/search_normalize.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';
import 'package:kuru_mobile/design/core/input/k_icon_btn.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:kuru_mobile/features/catalog/brands/widgets/brand_action_menu.dart';
import 'package:kuru_mobile/features/catalog/brands/widgets/create_edit_brand_sheet.dart';

class BrandsListScreen extends ConsumerStatefulWidget {
  const BrandsListScreen({super.key});

  @override
  ConsumerState<BrandsListScreen> createState() => _BrandsListScreenState();
}

class _BrandsListScreenState extends ConsumerState<BrandsListScreen> {
  String _query = '';

  Future<void> _openCreate() async {
    final l = AppLocalizations.of(context);
    final saved = await showCreateEditBrandSheet(
      context: context,
      mode: const CreateBrand(),
    );
    if (!mounted) return;
    if (saved ?? false) {
      ref.invalidate(brandOverviewProvider);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.brandNotifySaved)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final overview = ref.watch(brandOverviewProvider);
    final total = overview.maybeWhen(data: (b) => b.length, orElse: () => null);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BrandsHeader(
                title: l.brandTitle,
                totalCount: total,
                onCreate: _openCreate,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: KSearchBar(
                  hint: l.brandSearchHint,
                  onChanged: (q) => setState(() => _query = q),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: overview.when(
                  loading: () => const _SkeletonList(),
                  error: (e, _) =>
                      _ErrorState(onRetry: () => ref.invalidate(brandOverviewProvider)),
                  data: (brands) => brands.isEmpty
                      ? _Empty(onCreate: _openCreate)
                      : _List(brands: brands, query: _query),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandsHeader extends StatelessWidget {
  const _BrandsHeader({
    required this.title,
    required this.onCreate,
    this.totalCount,
  });
  final String title;
  final int? totalCount;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Text(title,
                  textAlign: TextAlign.center,
                  style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              if (totalCount != null) ...[
                const SizedBox(height: 2),
                Text(
                  l.brandTotalCount(totalCount!),
                  textAlign: TextAlign.center,
                  style: t.bodySmall?.copyWith(
                    color: t.bodySmall?.color?.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ],
          ),
          Positioned(
            right: 0,
            child: KIconBtn(
              icon: const Icon(TablerIcons.plus),
              tooltip: l.brandCreateTitle,
              onPressed: onCreate,
            ),
          ),
        ],
      ),
    );
  }
}

class _List extends ConsumerWidget {
  const _List({required this.brands, required this.query});
  final List<gen.BrandOverviewItem> brands;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = normalizeForSearch(query);
    final visible = q.isEmpty
        ? brands
        : brands
            .where((b) => normalizeForSearch(b.name ?? '').contains(q))
            .toList();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: visible.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _BrandCardItem(brand: visible[i]),
    );
  }
}

class _BrandCardItem extends ConsumerWidget {
  const _BrandCardItem({required this.brand});
  final gen.BrandOverviewItem brand;

  Future<void> _onMenu(BuildContext context, WidgetRef ref) async {
    final action = await showBrandActionMenu(
      context: context,
      brandName: brand.name ?? '',
    );
    if (action == null || !context.mounted) return;
    final l = AppLocalizations.of(context);
    switch (action) {
      case BrandAction.edit:
        final saved = await showCreateEditBrandSheet(
          context: context,
          mode: EditBrand(brand: brand),
        );
        if ((saved ?? false) && context.mounted) {
          ref.invalidate(brandOverviewProvider);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.brandNotifySaved)));
        }
      case BrandAction.delete:
        // Delete flow lives in Task 12.
        break;
    }
  }

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final saved = await showCreateEditBrandSheet(
      context: context,
      mode: EditBrand(brand: brand),
    );
    if ((saved ?? false) && context.mounted) {
      ref.invalidate(brandOverviewProvider);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.brandNotifySaved)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final name = brand.name ?? '';
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => _onMenu(context, ref),
      onTap: () => _onTap(context, ref),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            _InitialChip(name: name),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    l.brandStatProducts(brand.productCount ?? 0),
                    style: TextStyle(fontSize: 12, color: c.textMuted),
                  ),
                ],
              ),
            ),
            KIconBtn(
              icon: const Icon(TablerIcons.dots_vertical),
              size: 32,
              onPressed: () => _onMenu(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

class _InitialChip extends StatelessWidget {
  const _InitialChip({required this.name});
  final String name;

  Color _bg() {
    if (name.isEmpty) return kAllColors.first.swatch;
    final idx = name.hashCode.abs() % kAllColors.length;
    return kAllColors[idx].swatch;
  }

  String _letter() => name.isEmpty ? '?' : name.characters.first.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _bg(),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        _letter(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: 4,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: KSkeleton(height: 80),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.onCreate});
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return KEmptyState(
      icon: TablerIcons.shopping_bag,
      title: l.brandEmptyTitle,
      subtitle: l.brandEmptyBody,
      action: KSecondaryBtn(
        onPressed: onCreate,
        label: l.brandEmptyAction,
        fullWidth: false,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return KEmptyState(
      icon: TablerIcons.alert_triangle,
      title: l.brandLoadError,
      action: KSecondaryBtn(
        onPressed: onRetry,
        label: l.brandLoadRetry,
        fullWidth: false,
      ),
    );
  }
}
```

> **Watch out:**
> - `kAllColors` is the same color set Category uses. Verify the file path: `lib/design/core/modal/color_options.dart`.
> - If `KSearchBar`, `KEmptyState`, `KSecondaryBtn`, `KSkeleton`, or `KIconBtn`'s constructor params differ from above (especially `fullWidth`), open the design-core file and adapt the call site.
> - `String.characters.first` requires `import 'package:characters/characters.dart';` — add it if dart-analyze complains. (Most Flutter projects re-export it through material.dart; verify before adding.)

- [ ] **Step 4: Run tests, confirm PASS**

Run: `flutter test test/features/catalog/brands/brands_list_screen_test.dart`
Expected: all 4 tests pass.

- [ ] **Step 5: Verify analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 6: Add /catalog/brands route to the router**

Open `lib/app/router.dart`. Inside the Catalog branch's `routes:`, immediately after the `categories` `GoRoute` (and the placeholder-routes-only comment from T6), add:

```dart
GoRoute(
  path: 'brands',
  builder: (_, __) => const BrandsListScreen(),
),
```

Add the import at the top:

```dart
import 'package:kuru_mobile/features/catalog/brands/brands_list_screen.dart';
```

The comment placeholder from T6 ("`// /catalog/brands is added by Task 11 ...`") can now be removed.

- [ ] **Step 7: Re-run analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 8: Commit**

```bash
git add lib/features/catalog/brands/brands_list_screen.dart \
        test/features/catalog/brands/brands_list_screen_test.dart \
        lib/app/router.dart
git commit -m "$(cat <<'EOF'
feat(brand): BrandsListScreen + initial-letter chip + client search

Single fetch limit=200 via brandOverviewProvider, client-side
normalize-search (accent-folded). Tap row = edit sheet; long-press /
kebab = action sheet. Delete flow wires up in the next task.

Router /catalog/brands now points to BrandsListScreen (was placeholder).

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 12: Wire delete confirm + invalidation (TDD)

**Files:**
- Modify: `lib/features/catalog/brands/brands_list_screen.dart` (delete branch in `_BrandCardItem._onMenu`)

The list screen already has the `BrandAction.delete` switch case stubbed in Task 11. This task fills it in.

- [ ] **Step 1: Extend the widget test to cover delete**

Append to `test/features/catalog/brands/brands_list_screen_test.dart` (also add `import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';` at top of file if not already present):

```dart
  group('delete', () {
    testWidgets('confirm → repo.remove + invalidate + SnackBar',
        (tester) async {
      when(() => repo.getOverview()).thenAnswer((_) async => ApiResult.success([
            _item(id: 'b1', name: 'Nike', products: 0),
          ]));
      when(() => repo.remove('b1'))
          .thenAnswer((_) async => ApiResult.success(null));

      await tester.pumpWidget(_harness(repo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Open kebab → action sheet → Xóa → confirm dialog → Xóa.
      await tester.tap(find.byIcon(TablerIcons.dots_vertical).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.text('Xóa').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Confirm dialog visible — tap the destructive Xóa button.
      await tester.tap(find.text('Xóa').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      verify(() => repo.remove('b1')).called(1);
      expect(find.text('Đã xóa thương hiệu'), findsOneWidget);
    });

    testWidgets('400 reason → SnackBar with verbatim message', (tester) async {
      when(() => repo.getOverview()).thenAnswer((_) async => ApiResult.success([
            _item(id: 'b1', name: 'Nike'),
          ]));
      when(() => repo.remove('b1')).thenAnswer((_) async =>
          ApiResult.failure(const BadRequestException('Brand has products')));

      await tester.pumpWidget(_harness(repo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.byIcon(TablerIcons.dots_vertical).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.text('Xóa').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.text('Xóa').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Brand has products'), findsOneWidget);
    });
  });
```

> The kebab is `TablerIcons.dots_vertical` — exactly the icon the assertion looks for. If the trailing `KIconBtn` has issues, you can also use `find.byType(KIconBtn).first`.

- [ ] **Step 2: Run, confirm FAIL (delete branch is still a `break`)**

Run: `flutter test test/features/catalog/brands/brands_list_screen_test.dart`
Expected: the two new tests fail (`repo.remove` never called).

- [ ] **Step 3: Fill in the delete branch**

In `lib/features/catalog/brands/brands_list_screen.dart`, add the import at top:

```dart
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';
```

Replace the `BrandAction.delete:` branch inside `_BrandCardItem._onMenu` with:

```dart
case BrandAction.delete:
  await _confirmAndDelete(context, ref);
```

Then add this method inside `_BrandCardItem`:

```dart
Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context);
  ApiException? failure;
  final confirmed = await showKConfirmDialog(
    context: context,
    title: l.brandDeleteConfirmTitle,
    subtitle: l.brandDeleteConfirmBody(brand.name ?? ''),
    confirmLabel: l.brandDeleteConfirmCta,
    onConfirm: () async {
      final result =
          await ref.read(brandRepositoryProvider).remove(brand.id!);
      if (result is ApiFailure<void>) {
        failure = result.err;
        throw result.err; // closes the dialog with null
      }
    },
  );
  if (!context.mounted) return;
  if (confirmed ?? false) {
    ref.invalidate(brandOverviewProvider);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.brandNotifyDeleted)));
  } else if (failure != null) {
    final msg = failure is BadRequestException
        ? (failure! as BadRequestException).message
        : l.brandNotifyServer;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
```

- [ ] **Step 4: Run tests, confirm PASS**

Run: `flutter test test/features/catalog/brands/brands_list_screen_test.dart`
Expected: all delete tests pass alongside the earlier ones.

- [ ] **Step 5: Verify analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/features/catalog/brands/brands_list_screen.dart \
        test/features/catalog/brands/brands_list_screen_test.dart
git commit -m "$(cat <<'EOF'
feat(brand): wire delete confirm + invalidation

KConfirmDialog surfaces BadRequestException verbatim (covers the future
"Brand has products" rejection). Success path invalidates the overview
provider and toasts via SnackBar.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 13: End-to-end regression — create flow

**Files:**
- Create: `test/features/catalog/brand_create_flow_test.dart`

- [ ] **Step 1: Write the test**

Create `test/features/catalog/brand_create_flow_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/brands/brands_list_screen.dart';
import 'package:kuru_mobile/features/catalog/brands/data/brand_repository.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements BrandRepository {}

void main() {
  testWidgets('list → + → fill name → Tạo → list refreshes + SnackBar',
      (tester) async {
    final repo = _MockRepo();
    final initial = <gen.BrandOverviewItem>[];
    final afterCreate = [
      gen.BrandOverviewItem(
        (b) => b
          ..id = 'b1'
          ..orgId = 'org-1'
          ..name = 'Nike'
          ..productCount = 0,
      ),
    ];
    var callCount = 0;
    when(() => repo.getOverview()).thenAnswer((_) async {
      callCount++;
      return ApiResult.success(callCount == 1 ? initial : afterCreate);
    });
    when(() => repo.create(name: 'Nike'))
        .thenAnswer((_) async => ApiResult.success('b1'));

    await tester.pumpWidget(ProviderScope(
      overrides: [brandRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const BrandsListScreen(),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Empty state visible — tap the empty-state CTA.
    expect(find.text('Chưa có thương hiệu'), findsOneWidget);
    await tester.tap(find.text('Tạo thương hiệu đầu tiên'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Sheet open. Fill name + tap Tạo (the sheet confirm button).
    await tester.enterText(find.byType(TextField).first, 'Nike');
    await tester.tap(find.text('Tạo').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    verify(() => repo.create(name: 'Nike')).called(1);
    expect(find.text('Đã lưu thương hiệu'), findsOneWidget);
    // After invalidation the overview provider refetches → second call serves
    // afterCreate.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Nike'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run, confirm PASS**

Run: `flutter test test/features/catalog/brand_create_flow_test.dart`
Expected: test passes.

- [ ] **Step 3: Commit**

```bash
git add test/features/catalog/brand_create_flow_test.dart
git commit -m "$(cat <<'EOF'
test(brand): end-to-end create flow regression

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 14: End-to-end regression — edit flow

**Files:**
- Create: `test/features/catalog/brand_edit_flow_test.dart`

- [ ] **Step 1: Write the test**

Create `test/features/catalog/brand_edit_flow_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/brands/brands_list_screen.dart';
import 'package:kuru_mobile/features/catalog/brands/data/brand_repository.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements BrandRepository {}

gen.BrandOverviewItem _b(String name) => gen.BrandOverviewItem(
      (b) => b
        ..id = 'b1'
        ..orgId = 'org-1'
        ..name = name
        ..productCount = 0,
    );

void main() {
  testWidgets('row tap → edit sheet → save → list updates + SnackBar',
      (tester) async {
    final repo = _MockRepo();
    var callCount = 0;
    when(() => repo.getOverview()).thenAnswer((_) async {
      callCount++;
      return ApiResult.success([_b(callCount == 1 ? 'Nike' : 'Nike Air Max')]);
    });
    when(() => repo.update(brandId: 'b1', name: 'Nike Air Max'))
        .thenAnswer((_) async => ApiResult.success(null));

    await tester.pumpWidget(ProviderScope(
      overrides: [brandRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const BrandsListScreen(),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Tap the row body (not the kebab).
    await tester.tap(find.text('Nike'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Sheet open, name prefilled. Replace.
    final field = find.byType(TextField).first;
    await tester.enterText(field, 'Nike Air Max');
    await tester.tap(find.text('Cập nhật').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    verify(() => repo.update(brandId: 'b1', name: 'Nike Air Max')).called(1);
    expect(find.text('Đã lưu thương hiệu'), findsOneWidget);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Nike Air Max'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run, confirm PASS**

Run: `flutter test test/features/catalog/brand_edit_flow_test.dart`
Expected: test passes.

- [ ] **Step 3: Commit**

```bash
git add test/features/catalog/brand_edit_flow_test.dart
git commit -m "$(cat <<'EOF'
test(brand): end-to-end edit flow regression

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 15: End-to-end regression — delete flow

**Files:**
- Create: `test/features/catalog/brand_delete_flow_test.dart`

- [ ] **Step 1: Write the test**

Create `test/features/catalog/brand_delete_flow_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_brand_api/kuru_brand_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/brands/brands_list_screen.dart';
import 'package:kuru_mobile/features/catalog/brands/data/brand_repository.dart';
import 'package:kuru_mobile/features/catalog/brands/providers/brand_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements BrandRepository {}

void main() {
  testWidgets('long-press → action sheet → Xóa → confirm → list refreshes',
      (tester) async {
    final repo = _MockRepo();
    var callCount = 0;
    when(() => repo.getOverview()).thenAnswer((_) async {
      callCount++;
      if (callCount == 1) {
        return ApiResult.success([
          gen.BrandOverviewItem(
            (b) => b
              ..id = 'b1'
              ..orgId = 'org-1'
              ..name = 'Nike'
              ..productCount = 0,
          ),
        ]);
      }
      return ApiResult.success(const <gen.BrandOverviewItem>[]);
    });
    when(() => repo.remove('b1'))
        .thenAnswer((_) async => ApiResult.success(null));

    await tester.pumpWidget(ProviderScope(
      overrides: [brandRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const BrandsListScreen(),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Long-press the row.
    await tester.longPress(find.text('Nike'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Action sheet → tap Xóa.
    await tester.tap(find.text('Xóa').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Confirm dialog → tap destructive Xóa.
    await tester.tap(find.text('Xóa').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    verify(() => repo.remove('b1')).called(1);
    expect(find.text('Đã xóa thương hiệu'), findsOneWidget);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Chưa có thương hiệu'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run, confirm PASS**

Run: `flutter test test/features/catalog/brand_delete_flow_test.dart`
Expected: test passes.

- [ ] **Step 3: Commit**

```bash
git add test/features/catalog/brand_delete_flow_test.dart
git commit -m "$(cat <<'EOF'
test(brand): end-to-end delete flow regression

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Task 16: Final smoke test + close-out

**Files:** none new.

- [ ] **Step 1: Run the full suite**

Run: `flutter test`
Expected: every test passes. Existing identity (49) + core-design (87) + new brand (~15) + updated category (existing) — count should match.

- [ ] **Step 2: Run analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Boot the simulator and exercise the flow manually**

```bash
cd ../gen-barcode && task fullstack    # BE in one terminal
# new terminal:
xcrun simctl boot "iPhone 16" 2>/dev/null && open -a Simulator
flutter run -d "iPhone 16" --dart-define=API_BASE_URL=http://localhost:9190
```

Walk through:
1. Sign in.
2. Tap Catalog bottom-nav. Expect the launcher with 4 cards.
3. Tap Brands. Expect an empty state (assuming fresh org) with the Create CTA.
4. Tap `+` on the header. Sheet opens.
5. Type "Test Brand" → Tạo. Sheet closes. Toast "Đã lưu thương hiệu". Row appears.
6. Type a duplicate "Test Brand" → verify the BE dup-name message renders under the field, sheet stays open.
7. Tap the row → edit sheet. Change name → Cập nhật. Row updates.
8. Long-press the row → action sheet → Xóa → confirm → toast + row removed.
9. Tap Catalog tab again. Should return to the launcher (re-tap behavior).

- [ ] **Step 4: Commit if anything tweaked during smoke test, otherwise skip**

If you fixed copy / spacing / icon issues during the smoke test, commit each fix as its own `fix(brand): ...` commit. No final close-out commit is needed otherwise.

---

## Acceptance criteria

- [ ] All 16 tasks committed
- [ ] `flutter analyze` exits 0
- [ ] `flutter test` exits 0
- [ ] Manual smoke test (Task 16, Step 3) walks the full create / edit / delete loop end-to-end against a running BE
- [ ] `lib/api/brand/` is committed (including all `.g.dart` files emitted by build_runner)
- [ ] `/catalog` lands on the launcher; `/catalog/categories` shows the existing Category list; `/catalog/brands` shows the new Brand list

## Out of scope (parked)

- Logo upload (needs `kuru_storage_api` + `image_picker`)
- Brand detail screen
- Slug field
- Server-side pagination / infinite scroll
- Brand → product navigation
- Bulk delete
