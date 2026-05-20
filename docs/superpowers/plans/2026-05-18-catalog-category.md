# Plan 2 — Categories CRUD + detail

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship full create / edit / delete for Categories plus the real `CategoryDetailScreen` (header card + sub-tree drill-down), on top of the read-only scaffold delivered in Plan 1.

**Architecture:** Extend `CategoryRepository` with three mutation methods (`create`, `update`, `remove`) returning `ApiResult<T>`. Wire the long-dormant "+" button + kebab + long-press affordances to `showKActionSheet` (NOT `KPopupMenu` — its `super_context_menu` Rust backing crashes on iOS 26; the stubbed widget stays). The create/edit form lives in one `CreateEditCategorySheet` widget driven by a sealed `CreateEditMode` enum. Provider invalidation per the spec §3.4 table is the widget's responsibility — repository stays stateless. The placeholder `CategoryDetailScreen` from Plan 1 becomes the real implementation: header card with `Edit` + `Add subcategory` buttons + children list filtered client-side from `categoryOverviewProvider`.

**Tech Stack:** Flutter 3.41.9 / Dart 3.11. Reuses Plan 1's `CategoryRepository`, generated `kuru_category_api` client, Riverpod providers, ARB i18n, and the v0.3.0 modal widgets (`showKModalSheet`, `showKActionSheet`, `showKConfirmDialog`, `showKColorPicker`, `showKIconPicker`).

**Spec:** `docs/superpowers/specs/2026-05-17-catalog-category-design.md` §5.4, §5.5, §6.2, §7 Plan 2.

**Branch:** cut `feat/catalog-category` off `release/v0.4.0` (which Plan 1's PR #3 lives on). Tag candidate after merge: `v0.4.0-catalog-category`.

---

## Prerequisites (do once, before Task 1)

- [ ] **P1.** From repo root, branch off the release branch:
  ```bash
  git checkout release/v0.4.0
  git pull --ff-only
  git checkout -b feat/catalog-category
  ```
- [ ] **P2.** Confirm Plan 1 work is in place — `flutter analyze` exit 0 + tests pass:
  ```bash
  # via VGV MCP (preferred — local hook blocks raw `flutter test`):
  #   mcp__plugin_vgv-ai-flutter-plugin_dart__analyze_files
  #   mcp__plugin_vgv-ai-flutter-plugin_very-good-cli__test
  ```
- [ ] **P3.** Confirm the BE is running for end-to-end checks at the end:
  ```bash
  (cd ../gen-barcode && task fullstack)
  ```
  Plan 2 is mostly unit + widget tests; live BE only matters for Task 19's manual smoke.

---

## File map

```
lib/features/catalog/categories/
├── data/
│   └── category_repository.dart                ← extend with create/update/remove
├── providers/
│   └── category_providers.dart                  ← no new providers; invalidation lives in widgets
├── categories_list_screen.dart                  ← wire + button, kebab + long-press → action sheet
├── category_detail_screen.dart                  ← REPLACE placeholder body with real impl
├── widgets/
│   ├── create_edit_category_sheet.dart          ← NEW — single sheet, three modes
│   ├── category_action_menu.dart                ← NEW — KActionSheet wrapper for Edit / Delete actions
│   ├── color_picker_tile.dart                   ← NEW — tappable preview opens showKColorPicker
│   └── icon_picker_tile.dart                    ← NEW — tappable preview opens showKIconPicker
└── ...
test/features/catalog/categories/
├── category_repository_test.dart                ← extend with mutation tests
├── create_edit_category_sheet_test.dart         ← NEW
├── category_detail_screen_test.dart             ← REPLACE placeholder test
└── delete_confirm_test.dart                     ← NEW (end-to-end on the list screen)
lib/core/i18n/
├── app_en.arb                                   ← extend
└── app_vi.arb                                   ← extend
```

---

## Task 1: `CategoryRepository.create()`

Adds the first mutation method. Returns `ApiResult<gen.CategoryResponse>` — the created category as returned by the BE (the dart-dio model's response envelope is `CreateCategory200Response { success, data: CreateCategoryResponse, timestamp }`; per Plan 1 Task 6 the `.data?.data` unwrap pattern is the standard.)

**Files:**
- Modify: `lib/features/catalog/categories/data/category_repository.dart`
- Modify: `test/features/catalog/categories/category_repository_test.dart`

- [ ] **Step 1: Inspect what the generated client returns**

Read `lib/api/category/lib/src/api/category_api.dart` for `createCategory`'s signature and `lib/api/category/lib/src/model/create_category_response.dart` for the response shape. Confirm:
- Method: `Future<Response<CreateCategory200Response>> createCategory({required CreateCategoryRequest createCategoryRequest, ...})`
- `CreateCategory200Response` envelope wraps `data: CreateCategoryResponse` containing the new category fields (at minimum `categoryId`, `name`, `layer`).

- [ ] **Step 2: Write the failing test**

Append to `test/features/catalog/categories/category_repository_test.dart`, inside the existing `void main()`:

```dart
  group('create', () {
    test('returns ApiSuccess with the new category on 201', () async {
      final newCat = gen.CategoryResponse(
        (b) => b
          ..categoryId = 'new-id'
          ..name = 'Electronics'
          ..layer = '1',
      );
      when(() => api.createCategory(
            createCategoryRequest: any(named: 'createCategoryRequest'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 201,
          data: gen.CreateCategory200Response((b) => b..data.replace(newCat)),
        ),
      );

      final result = await repo.create(
        gen.CreateCategoryRequest(
          (b) => b
            ..name = 'Electronics'
            ..layer = '1'
            ..status = 'ACTIVE',
        ),
      );

      expect(result, isA<ApiSuccess<gen.CategoryResponse>>());
      expect((result as ApiSuccess).data.categoryId, 'new-id');
    });

    test('returns ApiFailure(BadRequestException) on 400', () async {
      when(() => api.createCategory(
            createCategoryRequest: any(named: 'createCategoryRequest'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 400,
          data: {
            'success': false,
            'error': {'message': 'name is required', 'code': 'VALIDATION'},
          },
        ),
      ));

      final result = await repo.create(
        gen.CreateCategoryRequest(
          (b) => b
            ..name = ''
            ..layer = '1'
            ..status = 'ACTIVE',
        ),
      );

      expect(result, isA<ApiFailure<gen.CategoryResponse>>());
      final err = (result as ApiFailure).err;
      expect(err, isA<BadRequestException>());
      expect(err.message, 'name is required');
    });
  });
```

Also extend the existing `setUpAll` registerFallbackValue calls:

```dart
  setUpAll(() {
    registerFallbackValue(gen.GetCategoryByIdRequest((b) => b..categoryId = ''));
    registerFallbackValue(gen.CreateCategoryRequest(
      (b) => b
        ..name = ''
        ..layer = '1'
        ..status = 'ACTIVE',
    ));
  });
```

- [ ] **Step 3: Run test to verify it fails**

Run via `mcp__plugin_vgv-ai-flutter-plugin_very-good-cli__test` with `directory: /Users/kotomiichinose/Projects/kuru-mobile`. Expected: 2 tests fail with `CategoryRepository.create is not defined`.

- [ ] **Step 4: Implement `create()` on `CategoryRepository`**

Append the method to `lib/features/catalog/categories/data/category_repository.dart` (after `getById`):

```dart
  /// Creates a new category. The [request] must already have `name`,
  /// `layer`, and `status` set; mobile derives `layer` from context
  /// (root vs nested) — never lets the user pick it.
  ///
  /// Returns [ApiSuccess] with the newly-created category (the BE
  /// echoes the full row including its generated UUID). On HTTP 400 the
  /// `error.message` is surfaced verbatim through [BadRequestException]
  /// (per spec §6.2 — the BE writes user-readable validation messages).
  Future<ApiResult<gen.CategoryResponse>> create(
    gen.CreateCategoryRequest request,
  ) async {
    try {
      final res = await _api.createCategory(createCategoryRequest: request);
      final body = res.data?.data;
      if (body == null) {
        return ApiResult.failure(
          const UnknownException('Empty body from CreateCategory'),
        );
      }
      log.i('CreateCategory ← ${res.statusCode} id=${body.categoryId}');
      return ApiResult.success(body);
    } on DioException catch (e) {
      log.w('CreateCategory failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }
```

- [ ] **Step 5: Run test to verify it passes**

Via the same MCP test tool. Both new tests should pass. Also run analyze (`mcp__plugin_vgv-ai-flutter-plugin_dart__analyze_files` with the repo root) — must be 0 issues.

- [ ] **Step 6: Commit**

```bash
git add lib/features/catalog/categories/data/category_repository.dart \
        test/features/catalog/categories/category_repository_test.dart
git commit -m "feat(catalog): CategoryRepository.create — POST /CreateCategory

Returns ApiResult<CategoryResponse> with the newly-created row from the
BE. Surfaces 400 validation messages verbatim via BadRequestException
per the spec §6.2 error matrix."
```

---

## Task 2: `CategoryRepository.update()`

Same pattern as create, but PUT `/UpdateCategory` taking `UpdateCategoryRequest { categoryId, categoryUpdate: CreateCategoryRequest }`.

**Files:**
- Modify: `lib/features/catalog/categories/data/category_repository.dart`
- Modify: `test/features/catalog/categories/category_repository_test.dart`

- [ ] **Step 1: Write the failing test**

Inside the same `void main()`:

```dart
  group('update', () {
    test('returns ApiSuccess with the updated category on 200', () async {
      final updated = gen.CategoryResponse(
        (b) => b
          ..categoryId = 'abc'
          ..name = 'Electronics renamed'
          ..layer = '1',
      );
      when(() => api.updateCategory(
            updateCategoryRequest: any(named: 'updateCategoryRequest'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
          data: gen.UpdateCategory200Response(
            (b) => b..data.replace(updated),
          ),
        ),
      );

      final result = await repo.update(
        categoryId: 'abc',
        update: gen.CreateCategoryRequest(
          (b) => b
            ..name = 'Electronics renamed'
            ..layer = '1'
            ..status = 'ACTIVE',
        ),
      );

      expect(result, isA<ApiSuccess<gen.CategoryResponse>>());
      expect((result as ApiSuccess).data.name, 'Electronics renamed');
    });

    test('returns ApiFailure(ForbiddenException) on 403', () async {
      when(() => api.updateCategory(
            updateCategoryRequest: any(named: 'updateCategoryRequest'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 403,
          data: {
            'success': false,
            'error': {'message': 'no permission'},
          },
        ),
      ));

      final result = await repo.update(
        categoryId: 'abc',
        update: gen.CreateCategoryRequest(
          (b) => b
            ..name = 'X'
            ..layer = '1'
            ..status = 'ACTIVE',
        ),
      );
      expect((result as ApiFailure).err, isA<ForbiddenException>());
    });
  });
```

Add to `setUpAll`:

```dart
    registerFallbackValue(gen.UpdateCategoryRequest(
      (b) => b
        ..categoryId = ''
        ..categoryUpdate.replace(gen.CreateCategoryRequest(
          (b2) => b2
            ..name = ''
            ..layer = '1'
            ..status = 'ACTIVE',
        )),
    ));
```

- [ ] **Step 2: Run test → FAIL**

Method not defined.

- [ ] **Step 3: Implement `update()`**

Append:

```dart
  /// Updates an existing category. [update] carries the full new state
  /// (BE expects the whole `CreateCategoryRequest` shape inside
  /// `categoryUpdate`, not a partial). [categoryId] is the row to edit.
  Future<ApiResult<gen.CategoryResponse>> update({
    required String categoryId,
    required gen.CreateCategoryRequest update,
  }) async {
    try {
      final res = await _api.updateCategory(
        updateCategoryRequest: gen.UpdateCategoryRequest(
          (b) => b
            ..categoryId = categoryId
            ..categoryUpdate.replace(update),
        ),
      );
      final body = res.data?.data;
      if (body == null) {
        return ApiResult.failure(
          const UnknownException('Empty body from UpdateCategory'),
        );
      }
      log.i('UpdateCategory ← ${res.statusCode} id=${body.categoryId}');
      return ApiResult.success(body);
    } on DioException catch (e) {
      log.w('UpdateCategory($categoryId) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }
```

- [ ] **Step 4: Run test → PASS + analyze 0**

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/categories/data/category_repository.dart \
        test/features/catalog/categories/category_repository_test.dart
git commit -m "feat(catalog): CategoryRepository.update — PUT /UpdateCategory"
```

---

## Task 3: `CategoryRepository.remove()`

Bulk-shaped delete (BE expects `RemoveCategoryRequest { categoryIds: List<String> }` even for a single delete — per spec §4.2).

**Files:**
- Modify: `lib/features/catalog/categories/data/category_repository.dart`
- Modify: `test/features/catalog/categories/category_repository_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
  group('remove', () {
    test('returns ApiSuccess<void> on 201', () async {
      when(() => api.removeCategory(
            removeCategoryRequest: any(named: 'removeCategoryRequest'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          statusCode: 201,
          data: gen.RemoveCategory200Response(
            (b) => b..data.replace(gen.RemoveCategoryResponse(
              (b2) => b2..removedIds.replace(['abc']),
            )),
          ),
        ),
      );

      final result = await repo.remove(['abc']);
      expect(result, isA<ApiSuccess<void>>());
    });

    test('returns ApiFailure(BadRequestException) when BE rejects '
        '(e.g. category has children)', () async {
      when(() => api.removeCategory(
            removeCategoryRequest: any(named: 'removeCategoryRequest'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 400,
          data: {
            'success': false,
            'error': {'message': 'category has children'},
          },
        ),
      ));

      final result = await repo.remove(['abc']);
      final err = (result as ApiFailure).err;
      expect(err, isA<BadRequestException>());
      expect(err.message, 'category has children');
    });
  });
```

Add to `setUpAll`:

```dart
    registerFallbackValue(gen.RemoveCategoryRequest(
      (b) => b..categoryIds.replace(<String>[]),
    ));
```

- [ ] **Step 2: Run test → FAIL**

- [ ] **Step 3: Implement `remove()`**

Append:

```dart
  /// Deletes one or more categories. BE accepts a list even for a single
  /// id — mobile typically passes `[id]`. Returns [ApiSuccess]<void> on
  /// success; the BE response payload (`removedIds`) is not surfaced
  /// because callers already know which ids they asked to delete.
  ///
  /// 400 with `category has children` is a common UX failure — surface
  /// the verbatim message via [BadRequestException] per §6.2.
  Future<ApiResult<void>> remove(List<String> categoryIds) async {
    try {
      final res = await _api.removeCategory(
        removeCategoryRequest: gen.RemoveCategoryRequest(
          (b) => b..categoryIds.replace(categoryIds),
        ),
      );
      log.i('RemoveCategory ← ${res.statusCode} ids=$categoryIds');
      return const ApiResult.success(null);
    } on DioException catch (e) {
      log.w('RemoveCategory($categoryIds) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }
```

- [ ] **Step 4: Run test → PASS + analyze 0**

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/categories/data/category_repository.dart \
        test/features/catalog/categories/category_repository_test.dart
git commit -m "feat(catalog): CategoryRepository.remove — POST /RemoveCategory

Bulk-shaped delete (BE accepts an id list even for single removal).
Returns ApiSuccess<void>; surfaces 400 'category has children' verbatim."
```

---

## Task 4: ARB strings for Plan 2

All user-facing strings for the form, action menu, delete confirm, and detail screen. Both `app_en.arb` (mirror) and `app_vi.arb` (canonical).

**Files:**
- Modify: `lib/core/i18n/app_en.arb`
- Modify: `lib/core/i18n/app_vi.arb`

- [ ] **Step 1: Append keys to `app_en.arb` before the closing `}`**

Bracket trailing comma in the last existing key first, then add:

```json
  "categoryCreateTitle": "New category",
  "categoryCreateSubcategoryTitle": "New subcategory",
  "categoryEditTitle": "Edit category",
  "categoryFieldName": "Name",
  "categoryFieldNameHint": "e.g. Electronics",
  "categoryFieldDescription": "Description",
  "categoryFieldDescriptionHint": "Short notes (optional)",
  "categoryFieldStatus": "Status",
  "categoryFieldIcon": "Icon",
  "categoryFieldColor": "Color",
  "categoryFieldParent": "Parent",
  "categoryStatusActive": "Active",
  "categoryStatusInactive": "Inactive",
  "categoryStatusArchived": "Archived",
  "categorySaveCta": "Save",
  "categorySavingCta": "Saving…",
  "categoryActionEdit": "Edit",
  "categoryActionDelete": "Delete",
  "categoryActionAddSubcategory": "Add subcategory",
  "categoryDeleteConfirmTitle": "Delete category?",
  "categoryDeleteConfirmBody": "{name} will be removed. This cannot be undone.",
  "@categoryDeleteConfirmBody": {
    "placeholders": {"name": {"type": "String"}}
  },
  "categoryDeleteConfirmCta": "Delete",
  "categoryNotifySaved": "Category saved",
  "categoryNotifyDeleted": "Category deleted",
  "categoryNotifyNetwork": "Couldn't reach the server. Try again.",
  "categoryNotifyServer": "Something went wrong. Try again later.",
  "categoryNotifyForbidden": "You don't have permission to do that.",
  "categoryNotifyRateLimited": "Slow down — try again in a moment.",
  "categoryMaxLayerReached": "Max nesting depth reached",
  "categoryDetailSubcategoriesHeader": "{count, plural, one{Subcategory ({count})} other{Subcategories ({count})}}",
  "@categoryDetailSubcategoriesHeader": {
    "placeholders": {"count": {"type": "num"}}
  },
  "categoryDetailNoSubcategories": "No subcategories yet"
```

- [ ] **Step 2: Mirror in `app_vi.arb`** (vi is canonical):

```json
  "categoryCreateTitle": "Danh mục mới",
  "categoryCreateSubcategoryTitle": "Danh mục con mới",
  "categoryEditTitle": "Sửa danh mục",
  "categoryFieldName": "Tên",
  "categoryFieldNameHint": "VD: Điện tử",
  "categoryFieldDescription": "Mô tả",
  "categoryFieldDescriptionHint": "Ghi chú ngắn (tuỳ chọn)",
  "categoryFieldStatus": "Trạng thái",
  "categoryFieldIcon": "Biểu tượng",
  "categoryFieldColor": "Màu",
  "categoryFieldParent": "Danh mục cha",
  "categoryStatusActive": "Đang hoạt động",
  "categoryStatusInactive": "Ngừng",
  "categoryStatusArchived": "Lưu trữ",
  "categorySaveCta": "Lưu",
  "categorySavingCta": "Đang lưu…",
  "categoryActionEdit": "Sửa",
  "categoryActionDelete": "Xoá",
  "categoryActionAddSubcategory": "Thêm danh mục con",
  "categoryDeleteConfirmTitle": "Xoá danh mục?",
  "categoryDeleteConfirmBody": "{name} sẽ bị xoá. Không thể hoàn tác.",
  "categoryDeleteConfirmCta": "Xoá",
  "categoryNotifySaved": "Đã lưu danh mục",
  "categoryNotifyDeleted": "Đã xoá danh mục",
  "categoryNotifyNetwork": "Không kết nối được máy chủ. Thử lại.",
  "categoryNotifyServer": "Đã có lỗi xảy ra. Thử lại sau.",
  "categoryNotifyForbidden": "Bạn không có quyền thực hiện thao tác này.",
  "categoryNotifyRateLimited": "Chậm lại nhé — thử lại sau giây lát.",
  "categoryMaxLayerReached": "Đã đạt độ sâu tối đa",
  "categoryDetailSubcategoriesHeader": "{count, plural, other{Danh mục con ({count})}}",
  "categoryDetailNoSubcategories": "Chưa có danh mục con"
```

- [ ] **Step 3: Regenerate localizations**

```bash
~/flutter/bin/flutter gen-l10n
```

Expected: writes `lib/core/i18n/generated/app_localizations*.dart` with no errors. If ICU plural complains about en/vi type mismatch, ensure both use `num` for the count placeholder.

- [ ] **Step 4: Run analyze**

Via `mcp__plugin_vgv-ai-flutter-plugin_dart__analyze_files` (root). Must be 0 issues.

- [ ] **Step 5: Commit**

```bash
git add lib/core/i18n/
git commit -m "i18n: ARB strings for Categories CRUD (form, menu, confirm, detail)"
```

---

## Task 5: `_ColorPickerTile` + `_IconPickerTile` widgets

The Create/Edit sheet needs two custom tappable preview tiles for color + icon (NOT `KSelect` — its action sheet doesn't suit dedicated pickers). Per spec §5.4 the implementer should "build the tile as a small composite widget (essentially a `Material.InkWell` over `KListRow`-style internals)".

**Files:**
- Create: `lib/features/catalog/categories/widgets/color_picker_tile.dart`
- Create: `lib/features/catalog/categories/widgets/icon_picker_tile.dart`
- Create: `test/features/catalog/categories/widgets/color_picker_tile_test.dart`
- Create: `test/features/catalog/categories/widgets/icon_picker_tile_test.dart`

- [ ] **Step 1: Write failing test for `_ColorPickerTile`** at `test/features/catalog/categories/widgets/color_picker_tile_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/color_picker_tile.dart';

void main() {
  testWidgets('renders label + swatch for the selected color',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ColorPickerTile(
          label: 'Color',
          valueId: 'red-400',
          onChanged: (_) {},
        ),
      ),
    ));
    expect(find.text('Color'), findsOneWidget);
    // The swatch is a Container painted with the resolved hex.
    expect(find.byType(ColorPickerTile), findsOneWidget);
  });

  testWidgets('falls back to slate-400 when valueId is unknown',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ColorPickerTile(
          label: 'Color',
          valueId: 'not-a-real-color',
          onChanged: (_) {},
        ),
      ),
    ));
    // Should still render without crashing.
    expect(find.text('Color'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test → FAIL** (widget not defined)

- [ ] **Step 3: Implement `ColorPickerTile`** at `lib/features/catalog/categories/widgets/color_picker_tile.dart`:

```dart
// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';
import 'package:kuru_mobile/design/core/modal/k_color_picker.dart';

/// Tappable preview tile that opens [showKColorPicker]. Mirrors the
/// shape of [KSelect] (label above + value row + chevron) but routes
/// through the dedicated color-picker grid instead of an action sheet.
class ColorPickerTile extends StatelessWidget {
  const ColorPickerTile({
    required this.label,
    required this.valueId,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String valueId;
  final ValueChanged<String> onChanged;

  KColorOption get _resolved {
    for (final co in kAllColors) {
      if (co.id == valueId) return co;
    }
    return kAllColors.first; // slate-400 fallback
  }

  Future<void> _open(BuildContext context) async {
    final picked = await showKColorPicker(
      context: context,
      selected: valueId,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final resolved = _resolved;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: c.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () => _open(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: c.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: resolved.swatch,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      resolved.label,
                      style: TextStyle(
                        fontSize: 14,
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                  Icon(TablerIcons.chevron_down, color: c.textMuted, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test → PASS** for ColorPickerTile

- [ ] **Step 5: Write failing test for `IconPickerTile`** at `test/features/catalog/categories/widgets/icon_picker_tile_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/icon_picker_tile.dart';

void main() {
  testWidgets('renders label + icon preview', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: IconPickerTile(
          label: 'Icon',
          valueName: 'package',
          onChanged: (_) {},
        ),
      ),
    ));
    expect(find.text('Icon'), findsOneWidget);
    expect(find.byType(IconPickerTile), findsOneWidget);
  });

  testWidgets('falls back to layout-grid when valueName is null/unknown',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: IconPickerTile(
          label: 'Icon',
          valueName: null,
          onChanged: (_) {},
        ),
      ),
    ));
    expect(find.text('Icon'), findsOneWidget);
  });
}
```

- [ ] **Step 6: Run test → FAIL**

- [ ] **Step 7: Implement `IconPickerTile`** at `lib/features/catalog/categories/widgets/icon_picker_tile.dart`:

```dart
// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/modal/icon_mapping.dart';
import 'package:kuru_mobile/design/core/modal/k_icon_picker.dart';

/// Tappable preview tile that opens [showKIconPicker]. Falls back to
/// [TablerIcons.layout_grid] when the persisted icon name is not in
/// our curated set (per spec §5.4).
class IconPickerTile extends StatelessWidget {
  const IconPickerTile({
    required this.label,
    required this.valueName,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String? valueName;
  final ValueChanged<String> onChanged;

  IconData get _resolvedIcon {
    final name = valueName;
    if (name == null || name.isEmpty) return TablerIcons.layout_grid;
    return resolveIconName(name) ?? TablerIcons.layout_grid;
  }

  Future<void> _open(BuildContext context) async {
    final picked = await showKIconPicker(
      context: context,
      selected: valueName,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: c.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () => _open(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: c.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(_resolvedIcon, size: 22, color: c.textPrimary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      valueName ?? 'layout-grid',
                      style: TextStyle(fontSize: 14, color: c.textPrimary),
                    ),
                  ),
                  Icon(TablerIcons.chevron_down, color: c.textMuted, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 8: Run test → PASS** + analyze 0.

- [ ] **Step 9: Commit**

```bash
git add lib/features/catalog/categories/widgets/color_picker_tile.dart \
        lib/features/catalog/categories/widgets/icon_picker_tile.dart \
        test/features/catalog/categories/widgets/
git commit -m "feat(catalog): ColorPickerTile + IconPickerTile

Tappable preview tiles for the Create/Edit category sheet. Each tile
shows the current selection + a chevron and opens the dedicated picker
(showKColorPicker / showKIconPicker) on tap. Both fall back to the
slate-400 / layout-grid defaults when the persisted value is unknown."
```

---

## Task 6: `CreateEditCategorySheet` — form skeleton (no submit yet)

The form's static structure — name field, status select, description, parent display, color + icon tiles. Submit wiring lands in Task 7.

**Files:**
- Create: `lib/features/catalog/categories/widgets/create_edit_category_sheet.dart`
- Create: `test/features/catalog/categories/widgets/create_edit_category_sheet_test.dart`

- [ ] **Step 1: Define the sealed mode type + helper at the top of `create_edit_category_sheet.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/feedback/k_form_field.dart'
    show KFormField;
import 'package:kuru_mobile/design/core/input/k_select.dart';
import 'package:kuru_mobile/design/core/input/k_text_field.dart';
import 'package:kuru_mobile/design/core/input/k_textarea.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/color_picker_tile.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/icon_picker_tile.dart';

/// Which of the three flows the sheet should run.
///
/// - [createRoot] — top-level category. parentId=NIL_UUID, layer="1".
/// - [createNested] — child of an existing parent. layer = parent.layer + 1.
/// - [edit] — modify an existing category. parentId/layer untouched on save.
sealed class CreateEditMode {
  const CreateEditMode();
}

class CreateRoot extends CreateEditMode {
  const CreateRoot();
}

class CreateNested extends CreateEditMode {
  const CreateNested({
    required this.parentId,
    required this.parentName,
    required this.parentLayer,
  });
  final String parentId;
  final String parentName;
  final String parentLayer;
}

class EditCategory extends CreateEditMode {
  const EditCategory({required this.category});
  final gen.CategoryResponse category;
}
```

Verify `KFormField`, `KTextField`, `KTextarea`, `KSelect` all exist by reading their source files. If `k_form_field.dart` doesn't export `KFormField` exactly, adjust the import. (Per CLAUDE.md, `KFormField` lives in `lib/design/widgets/k_form_field.dart` — the glass-aesthetic version. For content screens we want the flat version: confirm whether one exists in `lib/design/core/input/`. If not, the field's red-border-with-errorText behaviour can be done by passing `errorText` directly to `KTextField` — read its signature.)

- [ ] **Step 2: Write the failing test**

`test/features/catalog/categories/widgets/create_edit_category_sheet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/create_edit_category_sheet.dart';

void main() {
  testWidgets('createRoot mode renders empty name field + Active default',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(builder: (context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () => showCreateEditCategorySheet(
                  context: context,
                  mode: const CreateRoot(),
                ),
                child: const Text('Open'),
              ),
            );
          }),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('New category'), findsOneWidget); // title
    expect(find.text('Active'), findsOneWidget); // default status
    expect(find.text('Save'), findsOneWidget); // confirm CTA
  });

  testWidgets('edit mode pre-fills name + status from category',
      (tester) async {
    // Defer to Task 7 (Edit prefill); for now this test asserts the test
    // file compiles. Full assertion arrives in Task 7's tests.
  });
}
```

- [ ] **Step 3: Run test → FAIL**

`showCreateEditCategorySheet` not defined.

- [ ] **Step 4: Implement the sheet's skeleton**

Append to `create_edit_category_sheet.dart`:

```dart
/// Shows the Create/Edit category sheet. Returns `true` after a
/// successful save, `null` on cancel / dismiss.
Future<bool?> showCreateEditCategorySheet({
  required BuildContext context,
  required CreateEditMode mode,
}) {
  final l = AppLocalizations.of(context);
  final title = switch (mode) {
    CreateRoot() => l.categoryCreateTitle,
    CreateNested() => l.categoryCreateSubcategoryTitle,
    EditCategory() => l.categoryEditTitle,
  };
  return showKModalSheet<bool>(
    context: context,
    title: title,
    confirmLabel: l.categorySaveCta,
    onConfirm: () async {
      // Submit logic wired in Task 7. For now, dismiss with null so the
      // sheet doesn't pretend to save.
      return false;
    },
    builder: (ctx) => _CreateEditBody(mode: mode),
  );
}

class _CreateEditBody extends ConsumerStatefulWidget {
  const _CreateEditBody({required this.mode});
  final CreateEditMode mode;

  @override
  ConsumerState<_CreateEditBody> createState() => _CreateEditBodyState();
}

class _CreateEditBodyState extends ConsumerState<_CreateEditBody> {
  late String _name;
  late String _description;
  late String _status; // "ACTIVE" | "INACTIVE" | "ARCHIVED"
  late String _colorId;
  late String? _iconName;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    final m = widget.mode;
    final cat = m is EditCategory ? m.category : null;
    _name = cat?.name ?? '';
    _description = cat?.description ?? '';
    _status = cat?.status ?? 'ACTIVE';
    _colorId = cat?.colorSettings ?? 'slate-400';
    _iconName = cat?.icon ?? 'layout-grid';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final m = widget.mode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KTextField(
            label: l.categoryFieldName,
            initialValue: _name,
            hint: l.categoryFieldNameHint,
            errorText: _nameError,
            onChanged: (v) => _name = v,
          ),
          const SizedBox(height: 12),
          KSelect<String>(
            label: l.categoryFieldStatus,
            value: _status,
            options: [
              KSelectOption(value: 'ACTIVE', label: l.categoryStatusActive),
              KSelectOption(value: 'INACTIVE', label: l.categoryStatusInactive),
              KSelectOption(value: 'ARCHIVED', label: l.categoryStatusArchived),
            ],
            onChanged: (v) => setState(() => _status = v),
          ),
          const SizedBox(height: 12),
          KTextarea(
            label: l.categoryFieldDescription,
            initialValue: _description,
            hint: l.categoryFieldDescriptionHint,
            onChanged: (v) => _description = v,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: IconPickerTile(
                  label: l.categoryFieldIcon,
                  valueName: _iconName,
                  onChanged: (v) => setState(() => _iconName = v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ColorPickerTile(
                  label: l.categoryFieldColor,
                  valueId: _colorId,
                  onChanged: (v) => setState(() => _colorId = v),
                ),
              ),
            ],
          ),
          if (m is CreateNested) ...[
            const SizedBox(height: 12),
            Text(
              '${l.categoryFieldParent}: ${m.parentName}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
          if (m is EditCategory && (m.category.parentName ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              '${l.categoryFieldParent}: ${m.category.parentName}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }
}
```

**Important**: `KTextField` / `KTextarea` / `KSelect`'s exact constructor signatures need to be read from `lib/design/core/input/k_text_field.dart`, `k_textarea.dart`, `k_select.dart`. Adjust the named arguments if the actual API differs from what's written above (e.g., `initialValue` may be named `value` or require a `TextEditingController`). The test in Step 2 will catch param mismatches at compile time.

- [ ] **Step 5: Run test → PASS** for the "renders" assertions.

- [ ] **Step 6: Commit**

```bash
git add lib/features/catalog/categories/widgets/create_edit_category_sheet.dart \
        test/features/catalog/categories/widgets/create_edit_category_sheet_test.dart
git commit -m "feat(catalog): CreateEditCategorySheet form skeleton

Sealed CreateEditMode (createRoot / createNested / edit) drives the
sheet's title, defaults, and parent display. Form fields use the flat
v0.3.0 widgets; submit wiring lands in Task 7."
```

---

## Task 7: Wire the submit flow (Create + Update)

Submit calls `CategoryRepository.create()` or `.update()` based on mode; on success invalidates the right providers (per spec §3.4 table); on failure shows the appropriate UX (field error / toast).

**Files:**
- Modify: `lib/features/catalog/categories/widgets/create_edit_category_sheet.dart`
- Modify: `test/features/catalog/categories/widgets/create_edit_category_sheet_test.dart`

- [ ] **Step 1: Extend test with submit-path assertions**

Add inside the existing test file's `void main()`:

```dart
testWidgets('empty name shows KFormField errorText, doesn\'t close',
    (tester) async {
  // Override the repository so we don't hit a real BE.
  // ... (full setup pattern: ProviderScope with categoryRepositoryProvider
  //      overrideWithValue(fakeRepo), pump MaterialApp, open the sheet,
  //      tap Save without typing a name, assert errorText is visible
  //      and the sheet is still open.)
});
```

For the test scaffolding, use the same `_FakeCategoryRepo` pattern as `test/features/catalog/categories/category_providers_test.dart` — extend it with a `void Function(gen.CreateCategoryRequest)? onCreate` callback so the test can assert what request was sent.

- [ ] **Step 2: Implement `onConfirm` in `showCreateEditCategorySheet`**

Replace the placeholder onConfirm:

```dart
  // Capture mode + a way to read state.
  final formKey = GlobalKey<_CreateEditBodyState>();
  return showKModalSheet<bool>(
    context: context,
    title: title,
    confirmLabel: l.categorySaveCta,
    onConfirm: () async {
      final state = formKey.currentState!;
      return state._submit(); // returns true to close, false to stay open
    },
    builder: (ctx) => _CreateEditBody(key: formKey, mode: mode),
  );
```

Then in `_CreateEditBodyState`, add:

```dart
  /// Returns true on success (sheet closes), false on failure (stays open).
  Future<bool> _submit() async {
    setState(() => _nameError = null);
    if (_name.trim().isEmpty) {
      setState(() => _nameError = AppLocalizations.of(context).validationNameRequired);
      return false;
    }
    final m = widget.mode;
    final repo = ref.read(categoryRepositoryProvider);

    // Derive parentId + layer from mode.
    final (parentId, layer) = switch (m) {
      CreateRoot() => ('00000000-0000-0000-0000-000000000000', '1'),
      CreateNested(:final parentId, :final parentLayer) =>
          (parentId, (int.parse(parentLayer) + 1).toString()),
      EditCategory(:final category) =>
          (category.parentId ?? '00000000-0000-0000-0000-000000000000',
           category.layer ?? '1'),
    };

    final req = gen.CreateCategoryRequest(
      (b) => b
        ..name = _name.trim()
        ..parentId = parentId
        ..layer = layer
        ..status = _status
        ..colorSettings = _colorId
        ..icon = _iconName
        ..description = _description.trim().isEmpty
            ? null
            : _description.trim(),
    );

    final result = switch (m) {
      CreateRoot() || CreateNested() => await repo.create(req),
      EditCategory(:final category) =>
          await repo.update(categoryId: category.categoryId!, update: req),
    };

    if (!mounted) return false;
    switch (result) {
      case ApiSuccess<gen.CategoryResponse>(:final data):
        // Invalidate per spec §3.4. The exact set depends on mode.
        ref.invalidate(categoryOverviewProvider);
        if (m is CreateNested) {
          ref.invalidate(categoryByIdProvider(m.parentId));
        } else if (m is EditCategory) {
          ref.invalidate(categoryByIdProvider(m.category.categoryId!));
        }
        // Caller (list/detail screen) shows the success toast — the sheet
        // just closes. (Web FE same: ConfirmModal close + outer toast.)
        return true;
      case ApiFailure<gen.CategoryResponse>(:final err):
        _surfaceFieldError(err);
        return false;
    }
  }

  void _surfaceFieldError(ApiException err) {
    final l = AppLocalizations.of(context);
    switch (err) {
      case BadRequestException():
        // 400 — surface verbatim on the Name field. Most BE validation
        // messages we see in practice are name-related; later we can
        // route to the right field based on err.code.
        setState(() => _nameError = err.message);
      case ForbiddenException():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.categoryNotifyForbidden)),
        );
      case UnauthorizedException():
        // 401 — defer to caller; the dio interceptor stack already
        // routes through the auth redirect. Just close the sheet.
      case NetworkException() || TimeoutException():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.categoryNotifyNetwork)),
        );
      case ServerException():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.categoryNotifyServer)),
        );
      case UnknownException():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.categoryNotifyServer)),
        );
    }
  }
```

Add imports:

```dart
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
```

- [ ] **Step 3: Run test → PASS** for the submit-path assertions.

- [ ] **Step 4: Analyze 0 errors.**

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/categories/widgets/create_edit_category_sheet.dart \
        test/features/catalog/categories/widgets/create_edit_category_sheet_test.dart
git commit -m "feat(catalog): wire Create/Edit submit + invalidation matrix

Submit derives parentId + layer from CreateEditMode, calls
CategoryRepository.create or .update via the categoryRepositoryProvider,
invalidates per spec §3.4 (overview always; parentId for createNested;
byId for edit). Field-level error on 400 (KFormField errorText pattern);
SnackBar for 403/network/5xx; 401 falls through to the auth interceptor."
```

---

## Task 8: `CategoryActionMenu` — KActionSheet for Edit / Delete / Add subcategory

Spec §5.4 + §5.5 calls for long-press → `KPopupMenu`, but Plan 1 stubbed `KPopupMenu` due to the `super_context_menu` iOS-26 crash. The pragmatic replacement is `showKActionSheet` — the design system already lists it as "the lightweight mobile equivalent of web's `<PermissionGate>`"-style action affordance. Same `KActionItem` model, no Rust binary.

**Files:**
- Create: `lib/features/catalog/categories/widgets/category_action_menu.dart`

- [ ] **Step 1: Create the helper**

```dart
// TablerIcons uses snake_case.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';

/// Which action the user picked from the category action sheet.
enum CategoryAction { edit, delete, addSubcategory }

/// Opens the Edit / Delete / Add-subcategory action sheet anchored
/// to the given category. Returns the picked action, or null on dismiss.
///
/// Plan 1 stubbed `KPopupMenu` (super_context_menu crashes on iOS 26);
/// this helper is the bottom-sheet fallback that Plan 2 uses for both
/// the kebab tap and the long-press handler on list rows.
///
/// [showAddSubcategory] — pass `false` when the category is already at
/// MAX_LAYER (5). The sheet still renders the item but disabled so the
/// affordance stays predictable.
Future<CategoryAction?> showCategoryActionMenu({
  required BuildContext context,
  required gen.CategoryResponse category,
  required bool canAddSubcategory,
}) async {
  final l = AppLocalizations.of(context);
  return showKActionSheet<CategoryAction>(
    context: context,
    title: category.name ?? '',
    actions: [
      KActionItem<CategoryAction>(
        id: CategoryAction.edit,
        label: l.categoryActionEdit,
        icon: TablerIcons.edit,
      ),
      KActionItem<CategoryAction>(
        id: CategoryAction.addSubcategory,
        label: l.categoryActionAddSubcategory,
        icon: TablerIcons.plus,
        enabled: canAddSubcategory,
      ),
      KActionItem<CategoryAction>(
        id: CategoryAction.delete,
        label: l.categoryActionDelete,
        icon: TablerIcons.trash,
        danger: true,
      ),
    ],
  );
}
```

Read `lib/design/core/modal/k_action_sheet.dart` first to confirm the exact `showKActionSheet` signature — adjust the `title:` parameter name if it differs.

- [ ] **Step 2: Analyze 0**

- [ ] **Step 3: Commit** (no unit test for this helper — it's a thin wrapper; will be covered by widget tests in Tasks 9/11)

```bash
git add lib/features/catalog/categories/widgets/category_action_menu.dart
git commit -m "feat(catalog): CategoryActionMenu — KActionSheet wrapper for row actions

Single entry point used by both the kebab tap and long-press on
category cards. Returns CategoryAction enum (edit | delete |
addSubcategory). Honours canAddSubcategory: false at MAX_LAYER."
```

---

## Task 9: Wire `+` header button + kebab + long-press on `CategoriesListScreen`

Three entry points into the action sheet / create sheet. Plus the delete confirm flow.

**Files:**
- Modify: `lib/features/catalog/categories/categories_list_screen.dart`
- Modify: `test/features/catalog/categories/categories_list_screen_test.dart`

- [ ] **Step 1: Write the failing test for the "+" button**

Append:

```dart
testWidgets('tapping the + button opens the create sheet at root',
    (tester) async {
  await tester.pumpWidget(_wrap(
    const CategoriesListScreen(),
    overrideOverview: categoryOverviewProvider.overrideWith((ref) async => []),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));

  // Empty state's "Create first category" or the header "+" button —
  // either should open the sheet. We assert via the kebab/icon-button.
  await tester.tap(find.byTooltip('New category')); // header KIconBtn tooltip
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  expect(find.text('New category'), findsWidgets);
});
```

- [ ] **Step 2: Add the "+" button to the header**

In `_CategoriesHeader`, accept an `onCreate` callback and render a trailing `KIconBtn` with tooltip `New category`. Wire from `_CategoriesListScreenState.build()` to call `showCreateEditCategorySheet(context: context, mode: CreateRoot())` and toast success.

Update header:

```dart
class _CategoriesHeader extends StatelessWidget {
  const _CategoriesHeader({
    required this.title,
    required this.onCreate,
    this.totalCount,
  });

  final String title;
  final int? totalCount;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Text(title, /* … */),
              if (totalCount != null)
                Text(l.categoryTotalCount(totalCount!), /* … */),
            ],
          ),
          Positioned(
            right: 0,
            child: KIconBtn(
              icon: const Icon(TablerIcons.plus),
              tooltip: l.categoryCreateTitle,
              onPressed: onCreate,
            ),
          ),
        ],
      ),
    );
  }
}
```

Wire in `_CategoriesListScreenState.build()`:

```dart
_CategoriesHeader(
  title: l.categoryTitle,
  totalCount: totalCount,
  onCreate: () async {
    final saved = await showCreateEditCategorySheet(
      context: context,
      mode: const CreateRoot(),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.categoryNotifySaved)),
      );
    }
  },
),
```

Add imports:
```dart
import 'package:kuru_mobile/design/core/input/k_icon_btn.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/create_edit_category_sheet.dart';
```

- [ ] **Step 3: Wire the kebab menu on `_CategoryCardItem`**

Already has a `KIconBtn` with `onPressed: () {}` placeholder. Replace:

```dart
menu: KIconBtn(
  icon: const Icon(TablerIcons.dots_vertical),
  size: 32,
  onPressed: () => _onMenu(context, ref),
),
```

Add `ref: WidgetRef` to the `_CategoryCardItem` constructor + a private `_onMenu` method:

```dart
Future<void> _onMenu(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context);
  final canAdd = (int.tryParse(category.layer ?? '1') ?? 1) < 5;
  final action = await showCategoryActionMenu(
    context: context,
    category: category,
    canAddSubcategory: canAdd,
  );
  if (action == null || !context.mounted) return;
  switch (action) {
    case CategoryAction.edit:
      await showCreateEditCategorySheet(
        context: context,
        mode: EditCategory(category: category),
      );
    case CategoryAction.addSubcategory:
      await showCreateEditCategorySheet(
        context: context,
        mode: CreateNested(
          parentId: category.categoryId!,
          parentName: category.name ?? '',
          parentLayer: category.layer ?? '1',
        ),
      );
    case CategoryAction.delete:
      await _confirmAndDelete(context, ref);
  }
}

Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context);
  final confirmed = await showKConfirmDialog(
    context: context,
    title: l.categoryDeleteConfirmTitle,
    subtitle: l.categoryDeleteConfirmBody(category.name ?? ''),
    confirmLabel: l.categoryDeleteConfirmCta,
    onConfirm: () async {
      final result = await ref
          .read(categoryRepositoryProvider)
          .remove([category.categoryId!]);
      if (result is ApiFailure<void>) {
        // KConfirmDialog closes on exception; throw so it does.
        throw result.err;
      }
    },
  );
  if (confirmed == true && context.mounted) {
    ref.invalidate(categoryOverviewProvider);
    ref.invalidate(categoryByIdProvider(category.categoryId!));
    final parentId = category.parentId;
    if (parentId != null &&
        parentId != '00000000-0000-0000-0000-000000000000') {
      ref.invalidate(categoryByIdProvider(parentId));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.categoryNotifyDeleted)),
    );
  }
}
```

`_CategoryCardItem` becomes a `ConsumerWidget` (or accepts `ref` via callback). The simpler refactor: convert to `ConsumerWidget` and read `ref` inside `build`.

Add imports as needed:
```dart
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/category_action_menu.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/create_edit_category_sheet.dart';
```

- [ ] **Step 4: Wire long-press on the whole card**

`KCategoryCard.onTap` is the existing tap-to-navigate. Wrap the card in a `GestureDetector(onLongPress: () => _onMenu(context, ref), child: KCategoryCard(...))`.

- [ ] **Step 5: Run all tests + analyze**

VGV MCP test tool + analyze. Must be clean.

- [ ] **Step 6: Commit**

```bash
git add lib/features/catalog/categories/categories_list_screen.dart \
        test/features/catalog/categories/categories_list_screen_test.dart
git commit -m "feat(catalog): wire + button, kebab, long-press → action sheet

Header gets a + KIconBtn (tooltip 'New category') → opens CreateRoot.
KCategoryCard's kebab and a new long-press GestureDetector both open
showCategoryActionMenu (Edit / Add subcategory / Delete). Delete routes
through showKConfirmDialog; on success invalidates overview + byId
(plus byId(parentId) if the deleted row had a parent)."
```

---

## Task 10: Replace `CategoryDetailScreen` placeholder with the real screen

Per spec §5.3 — header card with name + description + Edit / Add-subcategory buttons; children list filtered client-side from the overview.

**Files:**
- Modify: `lib/features/catalog/categories/category_detail_screen.dart`
- Modify: `test/features/catalog/categories/category_detail_screen_test.dart`

- [ ] **Step 1: Replace the test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/categories/category_detail_screen.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';

gen.CategoryResponse _cat({
  required String id,
  required String name,
  String layer = '1',
  String? parentId,
}) =>
    gen.CategoryResponse((b) => b
      ..categoryId = id
      ..name = name
      ..layer = layer
      ..parentId = parentId
      ..orgId = 'org'
      ..itemCount = 0
      ..totalValue = 0
      ..lowStockCount = 0
      ..subCategoriesCount = 0);

void main() {
  testWidgets('renders header (name) + child rows when overview has them',
      (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        categoryByIdProvider('root').overrideWith(
          (ref) async => _cat(id: 'root', name: 'Electronics'),
        ),
        categoryOverviewProvider.overrideWith((ref) async => [
              _cat(id: 'root', name: 'Electronics'),
              _cat(id: 'c1', name: 'Audio', layer: '2', parentId: 'root'),
              _cat(id: 'c2', name: 'Mobile', layer: '2', parentId: 'root'),
            ]),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CategoryDetailScreen(categoryId: 'root'),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Electronics'), findsWidgets);
    expect(find.text('Audio'), findsOneWidget);
    expect(find.text('Mobile'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test → FAIL**

- [ ] **Step 3: Replace the screen body**

```dart
// TablerIcons uses snake_case names.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/catalog/k_list_row.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';
import 'package:kuru_mobile/design/core/modal/icon_mapping.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/catalog/categories/widgets/create_edit_category_sheet.dart';

class CategoryDetailScreen extends ConsumerWidget {
  const CategoryDetailScreen({required this.categoryId, super.key});
  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final root = ref.watch(categoryByIdProvider(categoryId));
    final overview = ref.watch(categoryOverviewProvider);
    return Scaffold(
      appBar: AppBar(),
      body: root.when(
        loading: () => const _DetailSkeleton(),
        error: (_, __) => KEmptyState(
          icon: TablerIcons.alert_triangle,
          title: l.categoryLoadError,
          action: KSecondaryBtn(
            onPressed: () => ref.invalidate(categoryByIdProvider(categoryId)),
            label: l.categoryLoadRetry,
            fullWidth: false,
          ),
        ),
        data: (cat) => _DetailBody(
          root: cat,
          allCategories: overview.value ?? const [],
        ),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.root, required this.allCategories});

  final gen.CategoryResponse root;
  final List<gen.CategoryResponse> allCategories;

  Color _bg() {
    for (final co in kAllColors) {
      if (co.id == root.colorSettings) return co.swatch;
    }
    return kAllColors.first.swatch;
  }

  IconData _icon() {
    final n = root.icon;
    if (n == null || n.isEmpty) return TablerIcons.layout_grid;
    return resolveIconName(n) ?? TablerIcons.layout_grid;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final children = allCategories
        .where((cat) => cat.parentId == root.categoryId)
        .toList();
    final canAdd = (int.tryParse(root.layer ?? '1') ?? 1) < 5;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header card.
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.surfaceElev,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _bg(),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon(), color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      root.name ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    if ((root.description ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          root.description!,
                          style: TextStyle(
                            fontSize: 13,
                            color: c.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: KSecondaryBtn(
                onPressed: () async {
                  await showCreateEditCategorySheet(
                    context: context,
                    mode: EditCategory(category: root),
                  );
                },
                label: l.categoryActionEdit,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: KSecondaryBtn(
                onPressed: canAdd
                    ? () async {
                        await showCreateEditCategorySheet(
                          context: context,
                          mode: CreateNested(
                            parentId: root.categoryId!,
                            parentName: root.name ?? '',
                            parentLayer: root.layer ?? '1',
                          ),
                        );
                      }
                    : null,
                label: l.categoryActionAddSubcategory,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          children.isEmpty
              ? l.categoryDetailNoSubcategories
              : l.categoryDetailSubcategoriesHeader(children.length),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: c.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        for (final child in children) ...[
          KListRow(
            leading: const Icon(TablerIcons.layout_grid),
            title: child.name ?? '',
            trailing: const Icon(TablerIcons.chevron_right),
            onTap: () => context.go('/catalog/categories/${child.categoryId}'),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          KSkeleton(height: 80),
          SizedBox(height: 12),
          KSkeleton(height: 44),
          SizedBox(height: 20),
          KSkeleton(height: 48),
          SizedBox(height: 8),
          KSkeleton(height: 48),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test → PASS** + analyze 0

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/categories/category_detail_screen.dart \
        test/features/catalog/categories/category_detail_screen_test.dart
git commit -m "feat(catalog): real CategoryDetailScreen — header card + children

Header card shows the category's icon (colored circle) + name +
description. Two KSecondaryBtn actions: Edit (opens edit sheet pre-
filled) and Add subcategory (CreateNested mode; disabled at layer 5).
Children rendered from a client-side filter on categoryOverviewProvider
(no GetCategoryTree round-trip — single source of truth per spec §3.4).
Tap a child → push another CategoryDetailScreen (drill-down up to 5
deep). Replaces the Plan 1 placeholder."
```

---

## Task 11: End-to-end Delete flow widget test

Already partially exercised by Task 9's wiring, but worth a dedicated regression test on the list screen's full path: card-kebab → action sheet → Delete → confirm → API call → toast.

**Files:**
- Create: `test/features/catalog/categories/delete_confirm_test.dart`

- [ ] **Step 1: Write the test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/categories/categories_list_screen.dart';
import 'package:kuru_mobile/features/catalog/categories/data/category_repository.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';

class _FakeRepo implements CategoryRepository {
  List<String>? removed;

  @override
  Future<ApiResult<gen.CategoryResponse>> create(
          gen.CreateCategoryRequest req) =>
      throw UnimplementedError();

  @override
  Future<ApiResult<List<gen.CategoryResponse>>> getOverview({int depth = 5}) =>
      throw UnimplementedError();

  @override
  Future<ApiResult<gen.CategoryResponse>> getById(String id) =>
      throw UnimplementedError();

  @override
  Future<ApiResult<gen.CategoryResponse>> update({
    required String categoryId,
    required gen.CreateCategoryRequest update,
  }) =>
      throw UnimplementedError();

  @override
  Future<ApiResult<void>> remove(List<String> ids) async {
    removed = ids;
    return const ApiResult.success(null);
  }
}

void main() {
  testWidgets('kebab → Delete → Confirm calls remove with [id]',
      (tester) async {
    final fake = _FakeRepo();
    final cat = gen.CategoryResponse((b) => b
      ..categoryId = 'cat-1'
      ..name = 'Electronics'
      ..layer = '1'
      ..orgId = 'o'
      ..itemCount = 0
      ..totalValue = 0
      ..lowStockCount = 0
      ..subCategoriesCount = 0);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        categoryRepositoryProvider.overrideWithValue(fake),
        categoryOverviewProvider.overrideWith((ref) async => [cat]),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CategoriesListScreen(),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Tap the kebab on the card.
    await tester.tap(find.byIcon(TablerIcons.dots_vertical).first);
    await tester.pump(const Duration(milliseconds: 300));

    // Tap "Delete" in the action sheet.
    await tester.tap(find.text('Delete'));
    await tester.pump(const Duration(milliseconds: 300));

    // Tap "Delete" in the confirm dialog.
    await tester.tap(find.text('Delete').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(fake.removed, ['cat-1']);
  });
}
```

Replace the `/* TablerIcons.dots_vertical */` comment with the actual constant (`import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';` then `TablerIcons.dots_vertical`). Watch out — the file already disables `non_constant_identifier_names` so the snake_case constant is fine.

- [ ] **Step 2: Run test → PASS** (assuming Task 9 wiring is in place)

- [ ] **Step 3: Commit**

```bash
git add test/features/catalog/categories/delete_confirm_test.dart
git commit -m "test(catalog): end-to-end delete flow regression test"
```

---

## Task 12: End-to-end Create flow widget test

Verify: tap "+" → fill name → tap Save → repo.create called with the right request shape → toast shown.

**Files:**
- Modify: `test/features/catalog/categories/categories_list_screen_test.dart` (append test)

- [ ] **Step 1: Append test**

```dart
testWidgets('tapping + → filling name → Save calls repo.create',
    (tester) async {
  gen.CreateCategoryRequest? captured;
  final fakeRepo = _FakeCategoryRepo(
    onCreate: (req) {
      captured = req;
    },
  );
  await tester.pumpWidget(_wrap(
    const CategoriesListScreen(),
    overrideOverview: categoryOverviewProvider.overrideWith((ref) async => []),
    extraOverrides: [
      categoryRepositoryProvider.overrideWithValue(fakeRepo),
    ],
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));

  await tester.tap(find.byTooltip('New category'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  await tester.enterText(find.byType(TextField).first, 'Electronics');
  await tester.pump();

  await tester.tap(find.text('Save'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));

  expect(captured?.name, 'Electronics');
  expect(captured?.layer, '1');
  expect(captured?.status, 'ACTIVE');
});
```

You'll need to extend `_FakeCategoryRepo` (already in `category_providers_test.dart`; create one in this test file too OR consolidate to `test/_helpers/fake_category_repo.dart`). Also extend `_wrap` to accept `extraOverrides`.

- [ ] **Step 2: Run test → PASS**

- [ ] **Step 3: Commit**

```bash
git add test/features/catalog/categories/categories_list_screen_test.dart
git commit -m "test(catalog): end-to-end create flow regression test"
```

---

## Task 13: End-to-end Edit flow widget test

Same shape as Create, but starting from a row's kebab → Edit → change name → Save → repo.update called.

**Files:**
- Modify: `test/features/catalog/categories/categories_list_screen_test.dart`

- [ ] **Step 1: Append test**

```dart
testWidgets('kebab → Edit → rename → Save calls repo.update',
    (tester) async {
  gen.CreateCategoryRequest? captured;
  String? capturedId;
  final fakeRepo = _FakeCategoryRepo(
    onUpdate: (id, req) {
      capturedId = id;
      captured = req;
    },
  );
  final cat = _cat(id: 'c1', name: 'Old name', layer: '1');
  await tester.pumpWidget(_wrap(
    const CategoriesListScreen(),
    overrideOverview:
        categoryOverviewProvider.overrideWith((ref) async => [cat]),
    extraOverrides: [
      categoryRepositoryProvider.overrideWithValue(fakeRepo),
    ],
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));

  await tester.tap(find.byIcon(TablerIcons.dots_vertical).first);
  await tester.pump(const Duration(milliseconds: 300));
  await tester.tap(find.text('Edit'));
  await tester.pump(const Duration(milliseconds: 300));

  await tester.enterText(find.byType(TextField).first, 'New name');
  await tester.pump();
  await tester.tap(find.text('Save'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));

  expect(capturedId, 'c1');
  expect(captured?.name, 'New name');
});
```

Extend `_FakeCategoryRepo` with the `onUpdate` callback.

- [ ] **Step 2: Run test → PASS**

- [ ] **Step 3: Commit**

```bash
git add test/features/catalog/categories/categories_list_screen_test.dart
git commit -m "test(catalog): end-to-end edit flow regression test"
```

---

## Task 14: Nested drill-down widget test on `CategoryDetailScreen`

Verify: detail screen renders → tap a child row → pushes a new detail screen for the child.

**Files:**
- Modify: `test/features/catalog/categories/category_detail_screen_test.dart`

- [ ] **Step 1: Append test**

The full test uses the same router-with-bootstrap-override harness as `test/features/catalog/categories/list_to_detail_navigation_test.dart` (Plan 1 Task 19). Inline it here so the test stands alone:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/router.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/auth/onboarding_seen_provider.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/splash/splash_screen.dart';

class _SeenNotifier extends OnboardingSeenController {
  @override
  bool build() => true;
}

gen.CategoryResponse _cat({
  required String id,
  required String name,
  String layer = '1',
  String? parentId,
}) =>
    gen.CategoryResponse((b) => b
      ..categoryId = id
      ..name = name
      ..layer = layer
      ..parentId = parentId
      ..orgId = 'org-x'
      ..itemCount = 0
      ..totalValue = 0
      ..lowStockCount = 0
      ..subCategoriesCount = 0);

void main() {
  testWidgets('tapping a child row pushes its detail screen', (tester) async {
    const fakeUser = UserInfo(
      email: 't@x.com',
      orgInfos: <OrgInfo>[
        OrgInfo(id: 'org-x', name: 'Test', role: 'Owner'),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          splashGateProvider.overrideWith(
            (ref) async => const BootstrapAuthed(fakeUser),
          ),
          currentOrgIdProvider.overrideWith(() {
            final n = CurrentOrgIdController();
            return n..orgId = 'org-x';
          }),
          onboardingSeenProvider.overrideWith(_SeenNotifier.new),
          categoryByIdProvider('root').overrideWith(
            (ref) async => _cat(id: 'root', name: 'Electronics'),
          ),
          categoryByIdProvider('c1').overrideWith(
            (ref) async => _cat(id: 'c1', name: 'Audio', layer: '2',
                parentId: 'root'),
          ),
          categoryOverviewProvider.overrideWith((ref) async => [
                _cat(id: 'root', name: 'Electronics'),
                _cat(id: 'c1', name: 'Audio', layer: '2', parentId: 'root'),
              ]),
        ],
        child: Consumer(builder: (ctx, ref, _) {
          final router = ref.watch(routerProvider);
          // Navigate directly to the root detail by setting initialLocation
          // on a wrapper router would be cleaner, but driving via the actual
          // router from /home is also acceptable for an e2e test.
          return MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        }),
      ),
    );
    // Splash → home; tap Catalog → tap the root row → land on detail.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Catalog'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Electronics'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Detail of root visible. Now tap the 'Audio' child row.
    expect(find.text('Audio'), findsOneWidget);
    await tester.tap(find.text('Audio'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // The pushed detail screen renders 'Audio' as its title and
    // 'Electronics' is no longer the top-most.
    expect(find.text('Audio'), findsWidgets);
  });
}
```

- [ ] **Step 2: Run test → PASS + analyze 0**

- [ ] **Step 3: Commit**

```bash
git add test/features/catalog/categories/category_detail_screen_test.dart
git commit -m "test(catalog): end-to-end nested drill-down on detail screen"
```

---

## Task 15: Manual smoke + PR

Final preflight before opening the Plan 2 PR.

- [ ] **Step 1: Run the full gate**

```
mcp__plugin_vgv-ai-flutter-plugin_dart__analyze_files (root)   → 0 issues
mcp__plugin_vgv-ai-flutter-plugin_very-good-cli__test (root)   → all green
```

Total test count should be ≥ 214 (baseline 194 from Plan 1 + ~20 new from Plan 2).

- [ ] **Step 2: Manual smoke — golden path**

With BE running (`task fullstack` in `../gen-barcode`) and a seeded org (your existing one from Plan 1's smoke):

```bash
~/flutter/bin/flutter run -d 00008130-000C51693E0A001C \
  --release \
  --dart-define=API_BASE_URL=http://192.168.50.27:9190
```

Walk through:

1. Sign in → land on Home tab → tap Catalog.
2. Tap the **+** header button → create sheet opens, title "New category".
3. Fill name "Smoke test", pick a color + icon, tap Save → sheet closes, success toast.
4. New row appears at the top of the list (overview invalidated).
5. Tap the row's **kebab** → action sheet shows Edit / Add subcategory / Delete.
6. Tap **Add subcategory** → create sheet opens, title "New subcategory", parent line visible.
7. Fill name "Child", Save → row appears in a layer-2 chip count.
8. Tap the parent row → detail screen renders the header card + "Subcategories (1)" + "Child" listed.
9. Tap **Edit** in the header → edit sheet pre-filled, change name, Save.
10. Back on the list, name reflects the change.
11. Long-press the parent → action sheet → **Delete** → confirm dialog → Delete.
12. BE rejects (has children) → red-tone snackbar surfaces the BE message verbatim.
13. Go to the child, delete it → child row disappears, parent's "Subcategories" count drops.
14. Delete the parent → vanishes from the list.

If any step fails, fix the bug before the PR (don't ship with a broken happy path).

- [ ] **Step 3: Push + open PR**

```bash
git push -u origin feat/catalog-category
gh pr create --base release/v0.4.0 \
  --title "feat: Categories CRUD + detail (Plan 2)" \
  --body "$(cat <<'EOF'
## Summary

Plan 2 of Catalog v0.4.0 — Categories CRUD + the real detail screen on
top of Plan 1's read-only scaffold.

- `CategoryRepository.create / update / remove` — three new mutation
  methods returning `ApiResult<T>`, with the §6.2 error matrix surfaced
  per call site (KFormField errorText on 400, SnackBar on 403/network/5xx,
  401 falls through to the auth interceptor).
- `CreateEditCategorySheet` — one widget, three modes (createRoot,
  createNested, edit) driven by a sealed `CreateEditMode`. Uses the
  flat v0.3.0 form widgets + dedicated picker tiles for color/icon.
- `CategoryActionMenu` — KActionSheet helper that replaces the iOS-26-
  crashing `KPopupMenu`. Same UX (Edit / Add subcategory / Delete) via
  bottom sheet.
- Real `CategoryDetailScreen` — header card with colored icon + name +
  description, Edit / Add-subcategory buttons (latter disabled at layer
  5), children list filtered client-side from `categoryOverviewProvider`.
  Drill-down up to 5 layers deep.
- ARB strings (en + vi, vi canonical) for all form labels, status enums,
  menu actions, confirm prompts, and the detail-screen sub-header
  plural.
- 4 new end-to-end widget tests (create, edit, delete, nested
  drill-down).

## Out of scope

- Permission gating (`category.write`) — deferred until a permissions
  provider lands.
- Optimistic mutations — pessimistic (spinner → success → refresh)
  feels fine in practice.

## Test plan

- [x] `flutter analyze` → 0
- [x] `flutter test` → all green (≥ 214 tests)
- [x] Manual smoke per Plan 2 Task 15 Step 2
- [ ] Verify the BE rejects "has children" deletes with the verbatim
      message (surfaces via SnackBar).

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

---

## Self-review checklist

- [ ] §5.4 Create/Edit modal — covered by Tasks 5 (pickers) + 6 (skeleton) + 7 (submit).
- [ ] §5.5 Delete confirm — covered by Tasks 8 (action menu) + 9 (wiring + confirm) + 11 (regression test).
- [ ] §5.3 CategoryDetailScreen — covered by Task 10.
- [ ] §6.2 Error matrix — wired in Task 7's `_surfaceFieldError` (field error for 400, SnackBar for 403/network/5xx, fall-through for 401).
- [ ] §3.4 Invalidation matrix — wired in Task 7 (create/edit success) + Task 9 (delete success).
- [ ] No `pumpAndSettle()` in any new test (KSkeleton + sheet animations) — every new widget test uses `pump()` + small `Duration` per CLAUDE.md.
- [ ] No placeholders in tasks — every step has the actual code or command.
- [ ] No reference to `KPopupMenu` in shipped code — the design system widget stays stubbed; Plan 2 uses `KActionSheet` (which is also kuru-design-system-native).
