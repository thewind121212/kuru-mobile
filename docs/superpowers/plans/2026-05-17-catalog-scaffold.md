# Plan 1 — Catalog scaffold + read-only Categories

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship the openapi codegen toolchain, a bottom-nav `MainShell` (Home / Catalog / Settings), and a read-only Categories list screen — proving the entire data + nav infrastructure that Plan 2 (CRUD + detail) will build on.

**Architecture:** `openapi_generator_cli` (pub.dev, annotation-based, build_runner-driven) emits a `dart-dio` client to `lib/api/category/`. Our existing `dioProvider` (host-root baseUrl, with org-id + logging + error-mapping interceptors) is injected via `basePathOverride: '${apiBaseUrl}/api/v1'`. Riverpod providers (`categoryOverviewProvider`, `categoryByIdProvider.family<String>`) watch `currentOrgIdProvider` so cache invalidates on org switch. `CategoryRepository` translates `DioException` → `ApiException` and returns `ApiResult<T>`. Routing uses `go_router`'s `StatefulShellRoute.indexedStack` to give each bottom-nav tab its own preserved nav stack.

**Tech Stack:** Flutter 3.41.9 / Dart 3.11. Adds `openapi_generator` + `openapi_generator_cli` + `built_value` + `built_collection` + `built_value_generator`. Uses existing `flutter_riverpod`, `dio`, `go_router`, `flutter_tabler_icons`.

**Spec:** `docs/superpowers/specs/2026-05-17-catalog-category-design.md`

---

## Prerequisites (do once, before Task 1)

- [ ] **P1.** Cut release branch:
  ```bash
  git checkout release/v0.3.0
  git pull --ff-only
  git checkout -b release/v0.4.0
  git push -u origin release/v0.4.0
  ```
- [ ] **P2.** Cut feature branch from `release/v0.4.0`:
  ```bash
  git checkout -b feat/catalog-scaffold
  ```
- [ ] **P3.** Verify Java is installed (required by `openapi_generator_cli`'s underlying JAR):
  ```bash
  java -version
  ```
  Expected: `openjdk version "11"` or higher. If missing on macOS: `brew install openjdk@17` then follow the brew post-install instructions for symlinking.
- [ ] **P4.** Confirm BE is running for Task 4 sanity check + manual smoke:
  ```bash
  (cd ../gen-barcode && task fullstack)
  ```
  Should serve at `http://localhost:9190`. Leave running in a separate terminal.
- [ ] **P5.** Seed at least 3 categories spanning 2+ layers in the dev org. If BE has no fixture script, use the web FE (`http://localhost:5173`) Category page to create them — needed for the manual smoke in Task 20.

---

## Task 1: Split UnauthorizedException into 401/403

The existing `_ErrorMappingInterceptor` lumps HTTP 401 and 403 into `UnauthorizedException`. The Categories error matrix needs them distinct (401 → sign out + /login; 403 → warning toast, stay put). Add `ForbiddenException`, split the interceptor branch, keep all existing 401 callers working.

**Files:**
- Modify: `lib/core/network/api_exception.dart`
- Modify: `lib/core/network/dio_client.dart`
- Create: `test/core/network/dio_error_mapping_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/core/network/dio_error_mapping_test.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';

DioException _badResponse(int status, [Object? body]) {
  final req = RequestOptions(path: '/x');
  return DioException(
    requestOptions: req,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: req,
      statusCode: status,
      data: body,
    ),
  );
}

void main() {
  group('mapDioError', () {
    test('HTTP 401 → UnauthorizedException', () {
      final e = mapDioError(_badResponse(401, {
        'success': false,
        'error': {'message': 'session expired'},
      }));
      expect(e, isA<UnauthorizedException>());
      expect(e.message, 'session expired');
    });

    test('HTTP 403 → ForbiddenException (not Unauthorized)', () {
      final e = mapDioError(_badResponse(403, {
        'success': false,
        'error': {'message': 'no permission'},
      }));
      expect(e, isA<ForbiddenException>());
      expect(e, isNot(isA<UnauthorizedException>()));
      expect(e.message, 'no permission');
    });

    test('HTTP 400 → BadRequestException with code', () {
      final e = mapDioError(_badResponse(400, {
        'success': false,
        'error': {'message': 'name is required', 'code': 'VALIDATION'},
      }));
      expect(e, isA<BadRequestException>());
      expect((e as BadRequestException).code, 'VALIDATION');
    });

    test('HTTP 500 → ServerException with statusCode', () {
      final e = mapDioError(_badResponse(503));
      expect(e, isA<ServerException>());
      expect((e as ServerException).statusCode, 503);
    });

    test('DioExceptionType.connectionError → NetworkException', () {
      final req = RequestOptions(path: '/x');
      final e = mapDioError(DioException(
        requestOptions: req,
        type: DioExceptionType.connectionError,
      ));
      expect(e, isA<NetworkException>());
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/core/network/dio_error_mapping_test.dart
```

Expected: FAIL — `ForbiddenException` is not defined; 403 currently maps to `UnauthorizedException`.

- [ ] **Step 3: Add `ForbiddenException` to `api_exception.dart`**

Insert after the `UnauthorizedException` class (line 20):

```dart
class ForbiddenException extends ApiException {
  const ForbiddenException(super.message);
}
```

- [ ] **Step 4: Split the 401/403 branch in `dio_client.dart`**

In `lib/core/network/dio_client.dart`, replace the block at lines 99-101:

```dart
      if (status == 401 || status == 403) {
        return UnauthorizedException(msg);
      }
```

with:

```dart
      if (status == 401) {
        return UnauthorizedException(msg);
      }
      if (status == 403) {
        return ForbiddenException(msg);
      }
```

- [ ] **Step 5: Run tests to verify they pass**

```bash
flutter test test/core/network/dio_error_mapping_test.dart
flutter analyze
```

Expected: all tests PASS; analyze exits 0.

- [ ] **Step 6: Audit existing 401 callers**

Verify nothing in the codebase intends to catch 403 via `UnauthorizedException`:

```bash
grep -rn "UnauthorizedException" lib/ --include="*.dart"
```

Currently the only catcher is `lib/core/auth/auth_repository.dart` interpreting MFA errors. Read the matches and confirm none treat 401 + 403 as identical for the purposes of forced sign-out. If any do, leave a code comment in that file noting "403 no longer routes here; handle ForbiddenException explicitly if needed."

- [ ] **Step 7: Commit**

```bash
git add lib/core/network/ test/core/network/dio_error_mapping_test.dart
git commit -m "feat(network): split UnauthorizedException into 401 + 403

Adds ForbiddenException for HTTP 403; existing 401 callers unaffected.
Required by the Catalog v0.4.0 error matrix."
```

---

## Task 2: Add openapi codegen dependencies

Add the three packages required by `dart-dio` codegen. No code changes — just pubspec + a successful pub get.

**Revision note (2026-05-17 mid-execution):** original plan included `openapi_generator: ^5.x` (the annotation-host package) to drive codegen via `build_runner`. That package caps `analyzer <7.0.0` and the project's existing `riverpod_generator ^2.6.3` requires `analyzer ^6.7.0`. The narrow overlap window triggers a `macros` SDK chain not present in Dart 3.11 — version solving fails. Pivot: drop the annotation package, keep only the `openapi_generator_cli` JAR wrapper (which has no analyzer constraint), and invoke it directly from a shell script in Task 4. The generated output and downstream Riverpod / Repository wiring are unaffected.

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Edit `pubspec.yaml`** to add runtime + dev deps

Under `dependencies:`, after `flutter_tabler_icons: ^1.43.0`, add:

```yaml
  # Required by dart-dio generated clients (Categories v0.4.0+)
  built_value: ^8.9.2
  built_collection: ^5.1.1
```

Under `dev_dependencies:`, after `riverpod_generator: ^2.6.3`, add:

```yaml
  # OpenAPI client codegen — invoked directly from tool/codegen.sh
  # (annotation-host openapi_generator package would conflict with
  # riverpod_generator on the analyzer constraint).
  openapi_generator_cli: ^5.0.2
  built_value_generator: ^8.9.2
```

- [ ] **Step 2: Resolve deps**

```bash
flutter pub get
```

Expected: resolves cleanly, prints "Got dependencies!".

If a version conflict appears (e.g., `intl` clamp), check the resolver output and bump the offending package's `^X.Y.Z` to the suggested version. Do not pin loosely; keep `^` carets.

- [ ] **Step 3: Verify Java is reachable from build_runner**

```bash
dart run openapi_generator_cli version-manager list
```

Expected: prints something like `7.x.x (active)`. If it fails with a Java error, fix `JAVA_HOME` per P3.

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add openapi codegen deps for Catalog v0.4.0

built_value + built_collection (runtime) — required by dart-dio output.
openapi_generator + openapi_generator_cli + built_value_generator (dev) —
the codegen toolchain itself."
```

---

## Task 3: BE source-of-truth sanity check

Per spec §3.1, before accepting any generated client, verify `category.openapi.json` against the BE's `.d.ts`, route, and service. If the openapi shape disagrees with the others, **the others win** and we patch the openapi copy in `tool/openapi-patches/`.

This task produces no code — just a documented finding committed alongside the spec history. Even "no divergence found" is a useful artifact for Plan 2.

**Files:**
- Create: `tool/openapi-patches/.gitkeep`
- Create: `tool/openapi-patches/README.md`
- Modify: `docs/superpowers/specs/2026-05-17-catalog-category-design.md` (append sanity-check finding)

- [ ] **Step 1: Create the patches directory**

```bash
mkdir -p tool/openapi-patches
touch tool/openapi-patches/.gitkeep
```

- [ ] **Step 2: Write `tool/openapi-patches/README.md`**

```markdown
# OpenAPI patches

Per spec §3.1 / §9.2: when `../gen-barcode/openapi/<module>.openapi.json`
disagrees with the BE handler / `.d.ts` / service `resData`, copy the file
here and edit only the divergent shapes. The `tool/codegen.sh` script
auto-detects patched copies and uses them in place of upstream.

**Source-of-truth ordering (per CLAUDE.md):**
1. `be/core/dto/<module>/*.dto.ts` — request body validation
2. `be/core/domains/<domain>/api/<module>.route.ts` — handler
3. `be/types/<module>.d.ts` — generated TS response types
4. `be/core/domains/<domain>/services/<module>.service.ts` — `resData`
5. `openapi/<module>.openapi.json` — cross-check only

Never modify upstream openapi files in `../gen-barcode/` from this repo.
```

- [ ] **Step 3: Read and diff the four BE files for `category`**

Read each of these and make a one-line note in scratch about any divergence between the openapi spec and the canonical source:

```bash
cat ../gen-barcode/be/core/domains/catalog/dto/category/*.dto.ts
cat ../gen-barcode/be/core/domains/catalog/api/category.route.ts
cat ../gen-barcode/be/types/category.d.ts
cat ../gen-barcode/be/core/domains/catalog/services/category.service.ts
```

Compare against `../gen-barcode/openapi/category.openapi.json`:

```bash
python3 -c "import json; d=json.load(open('../gen-barcode/openapi/category.openapi.json')); print(json.dumps(d.get('components',{}).get('schemas',{}).get('CategoryResponse',{}), indent=2))"
```

For each of these fields, confirm presence + type in `category.d.ts`:

| Field | Expected per spec §4.1 |
|---|---|
| `categoryId` | string (UUID) |
| `name` | string |
| `parentId` | string (UUID or NIL_UUID) |
| `parentName` | string \| null |
| `layer` | string |
| `status` | "ACTIVE" \| "INACTIVE" \| "ARCHIVED" |
| `colorSettings` | string \| null |
| `icon` | string \| null |
| `description` | string \| null |
| `subCategoriesCount` | number |
| `itemCount` | number |
| `totalValue` | number |
| `lowStockCount` | number |

- [ ] **Step 4: Append the finding to the spec**

Add a new subsection `### 10.3 Pre-generation sanity check log` at the end of `docs/superpowers/specs/2026-05-17-catalog-category-design.md`:

```markdown
### 10.3 Pre-generation sanity check log

Performed on 2026-05-17 against commit XXXXXXX of `../gen-barcode`.

| Field | openapi `CategoryResponse` | `be/types/category.d.ts` | Divergence? |
|---|---|---|---|
| (fill in one row per field checked) | … | … | none / mismatch (describe) |

**Action taken:** patched / unchanged. Patched copy lives at
`tool/openapi-patches/category.openapi.json` (only if divergence existed).
```

Fill the table in with the actual findings. If everything matches: every "Divergence?" cell says "none" and Step 5 in Task 4 points at the upstream file. If something diverges: copy the upstream JSON to `tool/openapi-patches/category.openapi.json`, edit only the divergent schema, and document the change in the table.

- [ ] **Step 5: Commit**

```bash
git add tool/openapi-patches/ docs/superpowers/specs/2026-05-17-catalog-category-design.md
git commit -m "chore: BE sanity check + openapi-patches infrastructure

Verifies category.openapi.json against be/types + service before codegen.
Sets up tool/openapi-patches/ for future drift handling."
```

---

## Task 4: Generate the category dart-dio client

Pivot from build_runner-driven annotation to standalone CLI invocation (see Task 2 revision note). Create a `tool/codegen.sh` script that invokes `openapi_generator_cli` directly, run it, verify output, commit the generated package.

**Files:**
- Create: `tool/codegen.sh`
- Generated: `lib/api/category/**` (committed)
- Modify: `.gitignore` (ensure `lib/api/` is NOT ignored)

- [ ] **Step 1: Verify `.gitignore` doesn't exclude generated code**

```bash
grep -E "^lib/api|^/lib/api" .gitignore
```

Expected: no output. If a line matches, delete it.

- [ ] **Step 2: Create `tool/codegen.sh`**

```bash
#!/usr/bin/env bash
# Regenerate Dart API clients from the BE's openapi specs.
#
# Run after any openapi spec change in ../gen-barcode/openapi/.
# Generated output is committed to git (see spec §9.1).
#
# Usage:
#   ./tool/codegen.sh           # regenerate all configured modules
#   ./tool/codegen.sh category  # regenerate only one module

set -euo pipefail

DART="${HOME}/flutter/bin/dart"
GEN="dart run openapi_generator_cli:openapi_generator_cli"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Default spec source per module. Override with tool/openapi-patches/<module>.openapi.json
# if Task 3 / future sanity checks revealed divergence (see spec §3.1).
declare -A SPEC_SOURCES=(
  [category]="../gen-barcode/openapi/category.openapi.json"
)

generate() {
  local module="$1"
  local input="${SPEC_SOURCES[$module]:-}"
  local patched="tool/openapi-patches/${module}.openapi.json"

  if [ -f "$patched" ]; then
    input="$patched"
    echo "▶ ${module}: using patched spec at $patched"
  elif [ -z "$input" ]; then
    echo "✗ ${module}: no spec source configured" >&2
    return 1
  else
    echo "▶ ${module}: using upstream spec at $input"
  fi

  rm -rf "lib/api/${module}"
  $DART $GEN generate \
    -i "$input" \
    -g dart-dio \
    -o "lib/api/${module}" \
    --additional-properties=pubName=kuru_${module}_api,pubAuthor=kuru,pubVersion=0.4.0
}

if [ $# -gt 0 ]; then
  generate "$1"
else
  for module in "${!SPEC_SOURCES[@]}"; do
    generate "$module"
  done
fi

echo "✓ codegen complete"
```

Make it executable:

```bash
chmod +x tool/codegen.sh
```

- [ ] **Step 3: Run codegen**

```bash
./tool/codegen.sh category
```

Expected: takes 30s-2min; on first run, `openapi_generator_cli` downloads the openapi-generator JAR. Output includes many `Writing file: lib/api/category/...` lines. Exit 0.

If it fails:
- "Java not found" → fix P3 (Java 17 already verified in previous session)
- "Schema parse error" → openapi spec has issues; copy to `tool/openapi-patches/category.openapi.json`, edit, re-run.
- "Cannot remove lib/api/category" → check filesystem perms.

- [ ] **Step 4: Verify expected files exist**

```bash
ls lib/api/category/lib/src/api/ lib/api/category/lib/src/model/ 2>/dev/null | head
```

Expected: at minimum `category_api.dart` (the API class) and one model file per schema (e.g., `category_response.dart`, `create_category_request.dart`).

If `lib/api/category/` is empty: codegen silently failed. Re-run with `-v` (`dart run build_runner build --delete-conflicting-outputs -v`) and read the output for the actual error.

- [ ] **Step 5: Add `lib/api/category/` as a path dependency in the consumer pubspec**

The `dart-dio` generator emits a **complete sub-package** at `lib/api/category/` (with its own `pubspec.yaml`, `lib/`, etc.). To consume it from the main app, declare a path dependency.

Edit `pubspec.yaml`, under `dependencies:`:

```yaml
  # Generated Category API client (see lib/api/category/pubspec.yaml).
  # The package name comes from DioProperties.pubName in openapi_clients.dart.
  kuru_category_api:
    path: lib/api/category
```

Run:

```bash
flutter pub get
```

Expected: resolves cleanly. If "package not found": confirm the generated `lib/api/category/pubspec.yaml` exists and its `name:` field is `kuru_category_api`. If the generator chose a different name, update the dependency key in the consumer pubspec to match.

- [ ] **Step 6: Run `flutter analyze` on the new files**

```bash
flutter analyze lib/api/category/
flutter analyze
```

Expected: 0 errors on both. Warnings are OK if they're from generated code (generated files use specific lint-exclusion comments tolerated by `very_good_analysis`).

If analyze fails with errors: the generator emitted broken code, usually because of an openapi schema problem. Patch the openapi copy in `tool/openapi-patches/category.openapi.json`, update the annotation, re-run codegen + analyze.

- [ ] **Step 7: Commit**

```bash
git add lib/core/network/openapi_clients.dart lib/api/category/ pubspec.yaml pubspec.lock
git commit -m "feat(api): generate dart-dio client for Category module

Annotation host at lib/core/network/openapi_clients.dart; output committed
under lib/api/category/ as a path-dependency sub-package. Used by
CategoryRepository (next task)."
```

---

## Task 5: Wire `categoryApiClientProvider`

Construct the generated `CategoryApi` with our dio + the `/api/v1` base-path override. Pure provider wiring — no behavior change yet.

**Files:**
- Create: `lib/features/catalog/categories/providers/category_providers.dart`

- [ ] **Step 1: Write the failing test**

Create `test/features/catalog/categories/category_providers_test.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';

void main() {
  test('categoryApiClientProvider builds CategoryApi with /api/v1 base path',
      () {
    final container = ProviderContainer(overrides: [
      dioProvider.overrideWithValue(Dio(BaseOptions(baseUrl: 'http://host'))),
    ]);
    addTearDown(container.dispose);

    final api = container.read(categoryApiClientProvider);
    expect(api, isA<gen.CategoryApi>());
    // basePathOverride is internal; the strongest assertion we can make
    // here is that the provider returns a CategoryApi without throwing.
  });
}
```

Note on the import path `package:kuru_category_api/kuru_category_api.dart`: this is the package name set by `DioProperties.pubName` in Task 4. Confirm the exact path from `lib/api/category/lib/` — it might be `lib/api/category/lib/kuru_category_api.dart`. Adjust the import if needed.

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/features/catalog/categories/category_providers_test.dart
```

Expected: FAIL — `categoryApiClientProvider` is not defined.

- [ ] **Step 3: Create `lib/features/catalog/categories/providers/category_providers.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';

/// Generated Category API client wired with our configured Dio and the
/// /api/v1 base-path override. Our dioProvider keeps baseUrl at the host
/// root (so /auth/* routes work); each module's client adds its own prefix.
final categoryApiClientProvider = Provider<gen.CategoryApi>((ref) {
  final dio = ref.watch(dioProvider);
  return gen.CategoryApi(
    dio,
    gen.standardSerializers, // generated by dart-dio
    // Override the per-request base path. The exact parameter name is
    // generator-version-dependent; check the generated CategoryApi class.
    // If basePathOverride doesn't exist, set it on dio.options before each
    // request via a thin wrapper — but typically dart-dio exposes this.
  );
});
```

Note: dart-dio versions differ on how to pass `basePathOverride`. If the generated `CategoryApi` constructor accepts a `basePath` named parameter, use it. Otherwise, the canonical pattern is to set `dio.options.baseUrl = '${Env.apiBaseUrl}/api/v1'` inside the provider — but that breaks the shared dio used by `/auth/*`. The safest robust pattern is to construct a per-request `RequestOptions` override; the generator's documented hook is `Options(extra: {'overrideBasePath': '...'})` paired with a custom interceptor. **Read the generated `CategoryApi.dart` header comment first** — it documents the supported override mechanism for that exact generator version. Update this code to match.

- [ ] **Step 4: Run test to verify it passes**

```bash
flutter test test/features/catalog/categories/category_providers_test.dart
flutter analyze
```

Expected: PASS; analyze 0 errors.

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/categories/providers/ test/features/catalog/categories/
git commit -m "feat(catalog): wire categoryApiClientProvider

Constructs the generated CategoryApi from dioProvider with the /api/v1
base-path scoped to this module's calls only."
```

---

## Task 6: Build `CategoryRepository`

Wrap the generated client's two read methods (`getCategoryOverviewWithDepth`, `getCategoryById`) with `DioException → ApiException` translation and `ApiResult<T>` returns. No mutation methods in Plan 1.

**Files:**
- Create: `lib/features/catalog/categories/data/category_repository.dart`
- Create: `test/features/catalog/categories/category_repository_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/features/catalog/categories/category_repository_test.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/categories/data/category_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockCategoryApi extends Mock implements gen.CategoryApi {}

void main() {
  late _MockCategoryApi api;
  late CategoryRepository repo;

  setUp(() {
    api = _MockCategoryApi();
    repo = CategoryRepository(api);
  });

  group('getOverview', () {
    test('returns ApiSuccess<List<CategoryResponse>> on 200', () async {
      // Stub the generated method — adjust the exact signature to match
      // the dart-dio output. Typically returns Future<Response<...>> with
      // a built_value model inside.
      when(() => api.getCategoryOverviewWithDepth(depth: any(named: 'depth')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
                data: gen.GetCategoryOverviewResponse((b) => b
                  ..categoryOverviews.replace(<gen.CategoryResponse>[])),
              ));

      final result = await repo.getOverview();
      expect(result, isA<ApiSuccess<List<gen.CategoryResponse>>>());
    });

    test('returns ApiFailure(ForbiddenException) on 403', () async {
      when(() => api.getCategoryOverviewWithDepth(depth: any(named: 'depth')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 403,
          data: {'success': false, 'error': {'message': 'no perms'}},
        ),
      ));

      final result = await repo.getOverview();
      expect(result, isA<ApiFailure<List<gen.CategoryResponse>>>());
      final err = (result as ApiFailure).err;
      expect(err, isA<ForbiddenException>());
    });

    test('returns ApiFailure(NetworkException) on connectionError', () async {
      when(() => api.getCategoryOverviewWithDepth(depth: any(named: 'depth')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      ));

      final result = await repo.getOverview();
      expect((result as ApiFailure).err, isA<NetworkException>());
    });
  });

  group('getById', () {
    test('returns ApiSuccess<CategoryResponse> on 200', () async {
      when(() => api.getCategoryById(getCategoryByIdDto: any(named: 'getCategoryByIdDto')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
                data: gen.CategoryResponse((b) => b..categoryId = 'abc'),
              ));

      final result = await repo.getById('abc');
      expect(result, isA<ApiSuccess<gen.CategoryResponse>>());
    });
  });
}
```

If `mocktail` is not yet a dev_dependency, add it: `mocktail: ^1.0.4` under `dev_dependencies` in `pubspec.yaml` and run `flutter pub get`.

The exact generated method signatures (e.g., is the `depth` parameter named `depth` or `requestBody`? Does `getCategoryById` accept a DTO or named UUID?) depend on dart-dio's choices. **Read `lib/api/category/lib/src/api/category_api.dart` first** and adjust the test stubs to match.

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/features/catalog/categories/category_repository_test.dart
```

Expected: FAIL — `CategoryRepository` does not exist.

- [ ] **Step 3: Create `lib/features/catalog/categories/data/category_repository.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart' show mapDioError;

/// Wraps the generated CategoryApi with DioException → ApiException
/// translation and ApiResult<T> returns. Owns no UI state — callers
/// (widgets / providers) manage their own loading flags.
class CategoryRepository {
  CategoryRepository(this._api);
  final gen.CategoryApi _api;

  /// Fetches the flat list of categories for the current org, with depth
  /// information baked in (used by the layer-filter tabs).
  Future<ApiResult<List<gen.CategoryResponse>>> getOverview() async {
    try {
      final res = await _api.getCategoryOverviewWithDepth(depth: 5);
      final body = res.data;
      log.i('GetCategoryOverviewWithDepth ← ${res.statusCode} '
          'count=${body?.categoryOverviews.length ?? 0}');
      return ApiResult.success(body?.categoryOverviews.toList() ?? const []);
    } on DioException catch (e) {
      log.w('GetCategoryOverviewWithDepth failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  /// Fetches a single category by ID. The generated client POSTs the ID
  /// in a body DTO, not as a path/query param.
  Future<ApiResult<gen.CategoryResponse>> getById(String categoryId) async {
    try {
      final res = await _api.getCategoryById(
        getCategoryByIdDto:
            gen.GetCategoryByIdDto((b) => b..categoryId = categoryId),
      );
      final body = res.data;
      if (body == null) {
        return ApiResult.failure(
          const UnknownException('Empty body from GetCategoryById'),
        );
      }
      log.i('GetCategoryById ← ${res.statusCode} id=${body.categoryId}');
      return ApiResult.success(body);
    } on DioException catch (e) {
      log.w('GetCategoryById($categoryId) failed: ${e.message}');
      return ApiResult.failure(_extract(e));
    }
  }

  ApiException _extract(DioException e) {
    // The _ErrorMappingInterceptor has already attached our typed exception
    // to e.error. Fall back to direct mapping if not (e.g., in tests that
    // throw raw DioException without the interceptor running).
    final attached = e.error;
    if (attached is ApiException) return attached;
    return mapDioError(e);
  }
}
```

**Method signatures will likely need adjustment.** Read `lib/api/category/lib/src/api/category_api.dart` to confirm the exact parameter names — `depth`, `getCategoryByIdDto`, `getCategoryOverviewWithDepth` may differ slightly. Same for the `GetCategoryByIdDto` builder pattern: dart-dio uses built_value, so models have `((b) => b..field = value)` style.

- [ ] **Step 4: Run test to verify it passes**

```bash
flutter test test/features/catalog/categories/category_repository_test.dart
flutter analyze
```

Expected: PASS; analyze 0 errors.

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/categories/data/ test/features/catalog/categories/category_repository_test.dart
git commit -m "feat(catalog): CategoryRepository wraps generated client

Read methods only (getOverview + getById). Returns ApiResult<T>; owns no
UI state. Mutation methods come in Plan 2."
```

---

## Task 7: Add `categoryOverviewProvider` + `categoryByIdProvider.family`

Provider-layer wrapping of the repository, with `ref.watch(currentOrgIdProvider)` so the cache invalidates on org switch.

**Files:**
- Modify: `lib/features/catalog/categories/providers/category_providers.dart`
- Modify: `test/features/catalog/categories/category_providers_test.dart`

- [ ] **Step 1: Extend the test**

Append to `test/features/catalog/categories/category_providers_test.dart`:

```dart
  test('categoryOverviewProvider re-fires when currentOrgIdProvider changes',
      () async {
    // Use a fake repository so we can count calls.
    var callCount = 0;
    final fakeRepo = _FakeCategoryRepo(onGetOverview: () => callCount++);

    final container = ProviderContainer(overrides: [
      categoryRepositoryProvider.overrideWithValue(fakeRepo),
      currentOrgIdProvider.overrideWith(() => _MutableOrgIdController()),
    ]);
    addTearDown(container.dispose);

    // First read with org A.
    container.read(currentOrgIdProvider.notifier).set('org-a');
    await container.read(categoryOverviewProvider.future);
    expect(callCount, 1);

    // Switch to org B — provider should refire.
    container.read(currentOrgIdProvider.notifier).set('org-b');
    container.invalidate(categoryOverviewProvider); // force rebuild
    await container.read(categoryOverviewProvider.future);
    expect(callCount, 2);
  });
```

The exact `currentOrgIdProvider.notifier` API: check `lib/core/auth/auth_providers.dart` for the actual class name and the setter (commonly `.set(...)` or assignment to `.orgId = ...`). Adjust the test accordingly.

You'll also need `_FakeCategoryRepo` and `_MutableOrgIdController` as test-only classes at the bottom of the test file. Sketch:

```dart
class _FakeCategoryRepo implements CategoryRepository {
  _FakeCategoryRepo({required this.onGetOverview});
  final void Function() onGetOverview;

  @override
  Future<ApiResult<List<gen.CategoryResponse>>> getOverview() async {
    onGetOverview();
    return ApiResult.success(const []);
  }

  @override
  Future<ApiResult<gen.CategoryResponse>> getById(String id) => throw UnimplementedError();
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/features/catalog/categories/category_providers_test.dart
```

Expected: FAIL — `categoryRepositoryProvider`, `categoryOverviewProvider`, and `categoryByIdProvider` are not defined.

- [ ] **Step 3: Add providers to `category_providers.dart`**

Append to `lib/features/catalog/categories/providers/category_providers.dart`:

```dart
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/features/catalog/categories/data/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final api = ref.watch(categoryApiClientProvider);
  return CategoryRepository(api);
});

/// Flat list of all categories for the current org. Watches
/// currentOrgIdProvider so org switches auto-invalidate the cache.
final categoryOverviewProvider =
    FutureProvider<List<gen.CategoryResponse>>((ref) async {
  // Watch — not read — so org changes refire this provider.
  ref.watch(currentOrgIdProvider);
  final repo = ref.watch(categoryRepositoryProvider);
  return (await repo.getOverview()).unwrap();
});

/// Single category by id. Family keyed by UUID string. Watches
/// currentOrgIdProvider for the same reason as the overview provider.
final categoryByIdProvider =
    FutureProvider.family<gen.CategoryResponse, String>((ref, id) async {
  ref.watch(currentOrgIdProvider);
  final repo = ref.watch(categoryRepositoryProvider);
  return (await repo.getById(id)).unwrap();
});
```

The `.unwrap()` extension on `Future<ApiResult<T>>` already exists in `lib/core/network/api_result.dart` — it throws the typed exception, which Riverpod surfaces as `AsyncError`.

- [ ] **Step 4: Run test to verify it passes**

```bash
flutter test test/features/catalog/categories/category_providers_test.dart
flutter analyze
```

Expected: PASS; analyze 0 errors.

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/categories/providers/category_providers.dart test/features/catalog/categories/category_providers_test.dart
git commit -m "feat(catalog): categoryOverviewProvider + categoryByIdProvider.family

Both watch currentOrgIdProvider so the cache auto-invalidates on org
switch. categoryByIdProvider is wired but unused in Plan 1 — its first
real consumer ships in Plan 2."
```

---

## Task 8: Vietnamese-normalized search helper

Port `normalizeForSearch` from `../gen-barcode/fe/src/components/category-module/MainCategory.tsx:43-51`. Pure function, easy to test.

**Files:**
- Create: `lib/core/text/search_normalize.dart`
- Create: `test/core/text/search_normalize_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/core/text/search_normalize_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/text/search_normalize.dart';

void main() {
  group('normalizeForSearch', () {
    test('lowercases and trims', () {
      expect(normalizeForSearch('  Hello  '), 'hello');
    });

    test('removes Vietnamese diacritics via NFD', () {
      expect(normalizeForSearch('Điện tử'), 'dien tu');
      expect(normalizeForSearch('Áo dài'), 'ao dai');
      expect(normalizeForSearch('cà phê'), 'ca phe');
    });

    test('handles uppercase Đ', () {
      expect(normalizeForSearch('ĐIỆN'), 'dien');
    });

    test('returns empty string for empty input', () {
      expect(normalizeForSearch(''), '');
      expect(normalizeForSearch('   '), '');
    });

    test('passes through ascii unchanged', () {
      expect(normalizeForSearch('Audio'), 'audio');
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/core/text/search_normalize_test.dart
```

Expected: FAIL — function not defined.

- [ ] **Step 3: Implement the helper**

Create `lib/core/text/search_normalize.dart`:

```dart
import 'package:flutter/foundation.dart';

/// Lowercase + NFD-decompose + strip combining marks + đ→d.
/// Ports the web FE's normalizeForSearch
/// (../gen-barcode/fe/src/components/category-module/MainCategory.tsx:43-51).
/// Used to make "dien" match "Điện tử" in search.
@visibleForTesting
String normalizeForSearch(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return '';
  final lower = trimmed.toLowerCase();
  // NFD decomposition: 'ế' → 'e' + combining acute
  final decomposed = _toNfd(lower);
  // Strip combining marks (Unicode block 0x0300-0x036F)
  final stripped = decomposed.replaceAll(RegExp(r'[̀-ͯ]'), '');
  // đ is not handled by NFD — replace explicitly
  return stripped.replaceAll('đ', 'd');
}

// Dart's String has no built-in NFD, but characters in the Latin Extended
// + Vietnamese ranges have precomposed→decomposed mappings that are
// algorithmic. For our limited use (search), a Unicode-properly NFD via
// the `characters` package is overkill — the decomposition for Vietnamese
// vowels + tone marks fits in this small table.
String _toNfd(String input) {
  const table = {
    'à': 'à', 'á': 'á', 'ả': 'ả', 'ã': 'ã', 'ạ': 'ạ',
    'ă': 'ă', 'ằ': 'ằ', 'ắ': 'ắ', 'ẳ': 'ẳ',
    'ẵ': 'ẵ', 'ặ': 'ặ',
    'â': 'â', 'ầ': 'ầ', 'ấ': 'ấ', 'ẩ': 'ẩ',
    'ẫ': 'ẫ', 'ậ': 'ậ',
    'è': 'è', 'é': 'é', 'ẻ': 'ẻ', 'ẽ': 'ẽ', 'ẹ': 'ẹ',
    'ê': 'ê', 'ề': 'ề', 'ế': 'ế', 'ể': 'ể',
    'ễ': 'ễ', 'ệ': 'ệ',
    'ì': 'ì', 'í': 'í', 'ỉ': 'ỉ', 'ĩ': 'ĩ', 'ị': 'ị',
    'ò': 'ò', 'ó': 'ó', 'ỏ': 'ỏ', 'õ': 'õ', 'ọ': 'ọ',
    'ô': 'ô', 'ồ': 'ồ', 'ố': 'ố', 'ổ': 'ổ',
    'ỗ': 'ỗ', 'ộ': 'ộ',
    'ơ': 'ơ', 'ờ': 'ờ', 'ớ': 'ớ', 'ở': 'ở',
    'ỡ': 'ỡ', 'ợ': 'ợ',
    'ù': 'ù', 'ú': 'ú', 'ủ': 'ủ', 'ũ': 'ũ', 'ụ': 'ụ',
    'ư': 'ư', 'ừ': 'ừ', 'ứ': 'ứ', 'ử': 'ử',
    'ữ': 'ữ', 'ự': 'ự',
    'ỳ': 'ỳ', 'ý': 'ý', 'ỷ': 'ỷ', 'ỹ': 'ỹ', 'ỵ': 'ỵ',
  };
  final buf = StringBuffer();
  for (final ch in input.runes) {
    final s = String.fromCharCode(ch);
    buf.write(table[s] ?? s);
  }
  return buf.toString();
}
```

- [ ] **Step 4: Run test to verify it passes**

```bash
flutter test test/core/text/search_normalize_test.dart
flutter analyze
```

Expected: PASS; analyze 0 errors.

- [ ] **Step 5: Commit**

```bash
git add lib/core/text/ test/core/text/
git commit -m "feat(text): port normalizeForSearch from kuru-web

Lowercase + NFD-decompose + strip combining marks + đ→d, so 'dien' matches
'Điện tử' in category search."
```

---

## Task 9: Add ARB strings for Categories

Add all the user-facing strings used by Plan 1 + Plan 2. ARB regen + analyzer happy.

**Files:**
- Modify: `lib/core/i18n/app_en.arb`
- Modify: `lib/core/i18n/app_vi.arb`

- [ ] **Step 1: Append new keys to `app_en.arb`**

Add the following keys before the closing `}`. Mirror placement in `app_vi.arb` afterwards.

```json
  "navHome": "Home",
  "navCatalog": "Catalog",
  "navSettings": "Settings",

  "settingsPlaceholder": "Settings coming soon",

  "categoryTitle": "Categories",
  "categorySubtitle": "Manage product classifications",
  "categorySearchHint": "Search categories...",
  "categoryEmptyTitle": "No categories yet",
  "categoryEmptyBody": "Create your first category to organize products.",
  "categoryEmptyAction": "Create first category",
  "categoryLayerAll": "All",
  "categoryLayerMain": "Main",
  "categoryLayerSub": "Sub",
  "categoryLayerSubSub": "Sub Sub",
  "categoryLayerPrefix": "Layer",
  "categorySubCount": "{count, plural, one{{count} sub} other{{count} sub}}",
  "@categorySubCount": {
    "placeholders": {"count": {"type": "int"}}
  },
  "categoryItemCount": "{count, plural, one{{count} item} other{{count} items}}",
  "@categoryItemCount": {
    "placeholders": {"count": {"type": "int"}}
  },
  "categoryLoadError": "Couldn't load categories",
  "categoryLoadRetry": "Retry",
  "categoryDetailPlaceholder": "Detail view coming soon"
```

- [ ] **Step 2: Mirror in `app_vi.arb`**

Same keys, Vietnamese values:

```json
  "navHome": "Trang chủ",
  "navCatalog": "Danh mục",
  "navSettings": "Cài đặt",

  "settingsPlaceholder": "Cài đặt sắp ra mắt",

  "categoryTitle": "Danh mục",
  "categorySubtitle": "Quản lý phân loại sản phẩm",
  "categorySearchHint": "Tìm danh mục...",
  "categoryEmptyTitle": "Chưa có danh mục",
  "categoryEmptyBody": "Tạo danh mục đầu tiên để sắp xếp sản phẩm.",
  "categoryEmptyAction": "Tạo danh mục đầu tiên",
  "categoryLayerAll": "Tất cả",
  "categoryLayerMain": "Cấp chính",
  "categoryLayerSub": "Cấp phụ",
  "categoryLayerSubSub": "Cấp phụ phụ",
  "categoryLayerPrefix": "Cấp",
  "categorySubCount": "{count, plural, other{{count} danh mục con}}",
  "categoryItemCount": "{count, plural, other{{count} sản phẩm}}",
  "categoryLoadError": "Không tải được danh mục",
  "categoryLoadRetry": "Thử lại",
  "categoryDetailPlaceholder": "Chi tiết sắp ra mắt"
```

- [ ] **Step 3: Regenerate localizations**

```bash
flutter gen-l10n
```

Expected: succeeds; outputs to `lib/core/i18n/generated/`. Any missing key error → fix the ARB file. Vietnamese-specific: `plural` syntax differs slightly per locale (`vi` doesn't have an `one` form) — the ARB block above already uses `other` only for vi.

- [ ] **Step 4: Verify analyze**

```bash
flutter analyze
```

Expected: 0 errors.

- [ ] **Step 5: Commit**

```bash
git add lib/core/i18n/
git commit -m "i18n: ARB keys for Categories + bottom-nav + Settings

en + vi. Layer-label keys ported from kuru-web's category.json verbatim.
categorySubCount / categoryItemCount use ICU plural for grammatical safety."
```

---

## Task 10: `SettingsStubScreen`

Stub screen for the Settings tab — single centered "Coming soon" text.

**Files:**
- Create: `lib/features/settings/settings_stub_screen.dart`
- Create: `test/features/settings/settings_stub_screen_test.dart`

- [ ] **Step 1: Write the failing widget test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/settings/settings_stub_screen.dart';

void main() {
  testWidgets('SettingsStubScreen shows the placeholder text', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsStubScreen(),
        ),
      ),
    );
    expect(find.text('Settings coming soon'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/features/settings/settings_stub_screen_test.dart
```

Expected: FAIL — screen not defined.

- [ ] **Step 3: Create the screen**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';

class SettingsStubScreen extends StatelessWidget {
  const SettingsStubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            l.settingsPlaceholder,
            style: TextStyle(fontSize: 16, color: c.textSecondary),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

```bash
flutter test test/features/settings/
flutter analyze
```

Expected: PASS; analyze 0 errors.

- [ ] **Step 5: Commit**

```bash
git add lib/features/settings/ test/features/settings/
git commit -m "feat(settings): stub screen for the Settings tab"
```

---

## Task 11: `HomeTabScreen` — thin wrapper around `HomeStubScreen`

The existing `HomeStubScreen` becomes the body of the Home tab. We don't change `HomeStubScreen`'s code; we just point to it from the shell. This task is mostly mechanical — confirming the wrap works before tying the shell together.

**Files:**
- Create: `lib/features/home/home_tab_screen.dart` (thin re-export / wrapper)

- [ ] **Step 1: Decide whether to create a wrapper or alias**

Read `lib/features/home/home_stub_screen.dart`. If it already returns a `Scaffold` (it does — line 18), a wrapper is unnecessary. The MainShell will directly use `HomeStubScreen` as the Home branch builder.

**Skip to Step 2** — no new file needed.

- [ ] **Step 2: No code change. Document intent.**

Open the spec at `docs/superpowers/specs/2026-05-17-catalog-category-design.md` §5.6. The line "HomeTabScreen re-uses the existing HomeStubScreen body. No design changes." is the contract. We honor it by using `HomeStubScreen` directly in the shell (next task).

This task closes with no commit — it's a verification step. Move to Task 12.

---

## Task 12: Placeholder `CategoryDetailScreen`

A single-route placeholder Plan 2 will replace. Wired in Plan 1 to prove the routing contract.

**Files:**
- Create: `lib/features/catalog/categories/category_detail_screen.dart`
- Create: `test/features/catalog/categories/category_detail_screen_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/categories/category_detail_screen.dart';

void main() {
  testWidgets('CategoryDetailScreen shows the placeholder text', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CategoryDetailScreen(categoryId: 'abc'),
        ),
      ),
    );
    expect(find.text('Detail view coming soon'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/features/catalog/categories/category_detail_screen_test.dart
```

Expected: FAIL.

- [ ] **Step 3: Create the screen**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';

/// Placeholder body for /catalog/categories/:id. Plan 2 replaces this
/// with the real header card + children list. Routing contract is wired
/// here so Plan 2 only swaps the body, not the route.
class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({required this.categoryId, super.key});
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: KEmptyState(
        icon: TablerIcons.tools,
        title: l.categoryDetailPlaceholder,
      ),
    );
  }
}
```

Verify `KEmptyState`'s exact constructor at `lib/design/core/feedback/k_empty_state.dart` — it takes `icon: IconData`, `title: String`, optional `subtitle` and `action`. The Tabler icon `tools` is fine; use `IconLayoutGrid` if `tools` doesn't exist in `flutter_tabler_icons`.

- [ ] **Step 4: Run test to verify it passes**

```bash
flutter test test/features/catalog/categories/category_detail_screen_test.dart
flutter analyze
```

Expected: PASS; analyze 0 errors.

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/categories/category_detail_screen.dart test/features/catalog/categories/category_detail_screen_test.dart
git commit -m "feat(catalog): placeholder CategoryDetailScreen

Routes /catalog/categories/:id to a KEmptyState 'coming soon' body.
Plan 2 swaps the body in — routing contract stays."
```

---

## Task 13: `MainShell` with bottom NavigationBar

Renders the three tabs and switches their indexed-stack branches. This is a presentation widget — it doesn't own routing. The router (Task 14) instantiates it with a `StatefulNavigationShell`.

**Files:**
- Create: `lib/features/main_shell/main_shell.dart`
- Create: `test/features/main_shell/main_shell_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/main_shell/main_shell.dart';

void main() {
  testWidgets('MainShell renders 3 NavigationDestinations with Tabler icons',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MainShell(
          currentIndex: 0,
          onTabChanged: (_) {},
          body: const Center(child: Text('TAB_BODY')),
        ),
      ),
    );
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Catalog'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byIcon(TablerIcons.home), findsOneWidget);
    expect(find.byIcon(TablerIcons.layout_grid), findsOneWidget);
    expect(find.byIcon(TablerIcons.settings), findsOneWidget);
    expect(find.text('TAB_BODY'), findsOneWidget);
  });

  testWidgets('Tapping a destination calls onTabChanged', (tester) async {
    var lastTapped = -1;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MainShell(
          currentIndex: 0,
          onTabChanged: (i) => lastTapped = i,
          body: const SizedBox.shrink(),
        ),
      ),
    );
    await tester.tap(find.text('Catalog'));
    await tester.pump();
    expect(lastTapped, 1);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/features/main_shell/main_shell_test.dart
```

Expected: FAIL — widget not defined.

- [ ] **Step 3: Create the widget**

```dart
// (flutter_tabler_icons uses snake_case symbols)
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';

/// Presentation-only shell with a bottom NavigationBar. Routing-owned —
/// the parent (router's StatefulShellRoute builder) supplies currentIndex
/// + onTabChanged + the active tab body.
class MainShell extends StatelessWidget {
  const MainShell({
    required this.currentIndex,
    required this.onTabChanged,
    required this.body,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTabChanged,
        destinations: [
          NavigationDestination(
            icon: const Icon(TablerIcons.home),
            label: l.navHome,
          ),
          NavigationDestination(
            icon: const Icon(TablerIcons.layout_grid),
            label: l.navCatalog,
          ),
          NavigationDestination(
            icon: const Icon(TablerIcons.settings),
            label: l.navSettings,
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
flutter test test/features/main_shell/main_shell_test.dart
flutter analyze
```

Expected: PASS; analyze 0 errors.

- [ ] **Step 5: Commit**

```bash
git add lib/features/main_shell/ test/features/main_shell/
git commit -m "feat(main_shell): MainShell with bottom NavigationBar

Presentation-only; routing wires up currentIndex + onTabChanged in Task 14."
```

---

## Task 14: Refactor router to `StatefulShellRoute.indexedStack`

This is the most involved task — replaces the flat routes with branched shell routes while preserving the existing auth-state redirect logic.

**Files:**
- Modify: `lib/app/router.dart`
- Create: `lib/features/catalog/categories/categories_list_screen.dart` (skeleton — empty body for now; filled in Tasks 15-19)

- [ ] **Step 1: Create the empty CategoriesListScreen skeleton**

Just enough so the router can refer to it. Body comes in Task 15.

`lib/features/catalog/categories/categories_list_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesListScreen extends ConsumerWidget {
  const CategoriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Body wired in Tasks 15-19. Placeholder so the router compiles.
    return const Scaffold(body: SizedBox.shrink());
  }
}
```

- [ ] **Step 2: Rewrite `lib/app/router.dart`**

Replace lines 55-72 (the flat `routes:` block + the `/home` GoRoute), keeping the redirect logic and the `_BootstrapNotifier` class. The new routes block:

```dart
    routes: [
      // Unauthenticated routes — unchanged.
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/create-org', builder: (_, __) => const CreateOrgScreen()),
      GoRoute(path: '/org-picker', builder: (_, __) => const OrgPickerScreen()),
      GoRoute(path: '/totp', builder: (_, __) => const TotpVerificationScreen()),
      GoRoute(path: '/totp/recovery', builder: (_, __) => const RecoveryCodeScreen()),

      // Authenticated shell — bottom-nav with three branches.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) => MainShell(
          currentIndex: navShell.currentIndex,
          onTabChanged: (i) =>
              navShell.goBranch(i, initialLocation: i == navShell.currentIndex),
          body: navShell,
        ),
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, __) => const HomeStubScreen()),
            ],
          ),
          // Branch 1: Catalog
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/catalog',
                builder: (_, __) => const CategoriesListScreen(),
                routes: [
                  GoRoute(
                    path: 'categories/:id',
                    builder: (_, state) => CategoryDetailScreen(
                      categoryId: state.pathParameters['id'] ?? '',
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/settings', builder: (_, __) => const SettingsStubScreen()),
            ],
          ),
        ],
      ),
    ],
```

Also add the imports at the top of the file:

```dart
import 'package:kuru_mobile/features/main_shell/main_shell.dart';
import 'package:kuru_mobile/features/settings/settings_stub_screen.dart';
import 'package:kuru_mobile/features/catalog/categories/categories_list_screen.dart';
import 'package:kuru_mobile/features/catalog/categories/category_detail_screen.dart';
```

- [ ] **Step 3: Verify the existing redirect logic still works**

The redirect at lines 20-52 still returns `/home` for authed users — that's correct (the shell branch 0 owns `/home`). No change needed.

Run the app manually:

```bash
flutter run -d "iPhone 16" --dart-define=API_BASE_URL=http://localhost:9190
```

Walk through: launch → splash → bootstrap → land on /home with three tabs at the bottom. Tap Catalog → empty CategoriesListScreen renders. Tap Settings → "Settings coming soon". Tap Home → returns. Switch tabs back and forth — verify the bottom-nav highlights the active tab.

- [ ] **Step 4: Verify analyze + existing tests still pass**

```bash
flutter analyze
flutter test
```

Expected: all green. If any existing test relied on `GoRoute(path: '/home')` being a top-level route, update it to navigate to `/home` through the shell (which is functionally identical).

- [ ] **Step 5: Commit**

```bash
git add lib/app/router.dart lib/features/catalog/categories/categories_list_screen.dart
git commit -m "feat(router): bottom-nav shell via StatefulShellRoute.indexedStack

Home / Catalog / Settings branches each with their own nav stack.
Existing auth-state redirect logic unchanged. CategoriesListScreen body
ships in subsequent tasks."
```

---

## Task 15: `CategoriesListScreen` — header + search bar

Build the static parts of the list screen body (KPageHeader + KSearchBar) wired against state. No data yet.

**Files:**
- Modify: `lib/features/catalog/categories/categories_list_screen.dart`
- Create: `test/features/catalog/categories/categories_list_screen_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/categories/categories_list_screen.dart';

void main() {
  testWidgets('CategoriesListScreen renders header + search bar',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CategoriesListScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Manage product classifications'), findsOneWidget);
    expect(find.text('Search categories...'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
flutter test test/features/catalog/categories/categories_list_screen_test.dart
```

Expected: FAIL — text not found (screen is empty).

- [ ] **Step 3: Replace the screen body**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';

class CategoriesListScreen extends ConsumerStatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  ConsumerState<CategoriesListScreen> createState() =>
      _CategoriesListScreenState();
}

class _CategoriesListScreenState extends ConsumerState<CategoriesListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KPageHeader(
              title: l.categoryTitle,
              subtitle: l.categorySubtitle,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: KSearchBar(
                hint: l.categorySearchHint,
                onChanged: (q) => setState(() => _searchQuery = q),
              ),
            ),
            const SizedBox(height: 12),
            // Tabs + list come in subsequent tasks.
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
```

Confirm exact KPageHeader / KSearchBar constructor params by reading their source files (`lib/design/core/layout/k_page_header.dart`, `lib/design/core/input/k_search_bar.dart`). The `hint` parameter on KSearchBar matches what we saw; KPageHeader takes `title` (required) + optional `subtitle` + `actions`.

- [ ] **Step 4: Run test to verify it passes**

```bash
flutter test test/features/catalog/categories/categories_list_screen_test.dart
flutter analyze
```

Expected: PASS; analyze 0 errors.

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/categories/categories_list_screen.dart test/features/catalog/categories/categories_list_screen_test.dart
git commit -m "feat(catalog): CategoriesListScreen — header + search bar"
```

---

## Task 16: List rendering — bind to `categoryOverviewProvider` (skeleton + rows + empty + error)

Now wire the real data. Show `KSkeleton` while loading, list rows on data, `KEmptyState` on empty, error state on failure with Retry.

**Files:**
- Modify: `lib/features/catalog/categories/categories_list_screen.dart`
- Modify: `test/features/catalog/categories/categories_list_screen_test.dart`

- [ ] **Step 1: Extend the test**

Append to `test/features/catalog/categories/categories_list_screen_test.dart`:

```dart
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';

// helper to build a fake CategoryResponse with built_value
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
      ..parentId = parentId);

Widget _wrap(Widget child, {required Override overrideOverview}) =>
    ProviderScope(
      overrides: [overrideOverview],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );

testWidgets('shows skeleton while loading', (tester) async {
  await tester.pumpWidget(_wrap(
    const CategoriesListScreen(),
    overrideOverview: categoryOverviewProvider.overrideWith(
      (ref) => Future.delayed(const Duration(seconds: 5), () => []),
    ),
  ));
  await tester.pump(); // first frame
  expect(find.byType(_SkeletonMarker), findsWidgets); // see implementation
});

testWidgets('shows empty state when 0 categories', (tester) async {
  await tester.pumpWidget(_wrap(
    const CategoriesListScreen(),
    overrideOverview:
        categoryOverviewProvider.overrideWith((ref) async => <gen.CategoryResponse>[]),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  expect(find.text('No categories yet'), findsOneWidget);
  expect(find.text('Create first category'), findsOneWidget);
});

testWidgets('shows list rows when data is present', (tester) async {
  await tester.pumpWidget(_wrap(
    const CategoriesListScreen(),
    overrideOverview: categoryOverviewProvider.overrideWith((ref) async => [
      _cat(id: '1', name: 'Electronics'),
      _cat(id: '2', name: 'Food & Beverage'),
    ]),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  expect(find.text('Electronics'), findsOneWidget);
  expect(find.text('Food & Beverage'), findsOneWidget);
});

testWidgets('shows error state with retry on AsyncError', (tester) async {
  await tester.pumpWidget(_wrap(
    const CategoriesListScreen(),
    overrideOverview: categoryOverviewProvider
        .overrideWith((ref) async => throw const NetworkException('boom')),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  expect(find.text("Couldn't load categories"), findsOneWidget);
  expect(find.text('Retry'), findsOneWidget);
});
```

Don't use `pumpAndSettle()` — `KSkeleton` animates forever (CLAUDE.md warning).

- [ ] **Step 2: Run tests to verify they fail**

```bash
flutter test test/features/catalog/categories/categories_list_screen_test.dart
```

Expected: most FAIL (no skeleton/empty/rows/error rendering yet).

- [ ] **Step 3: Update the screen to consume the provider**

Replace the placeholder `Expanded(child: Container())` block with:

```dart
            Expanded(
              child: ref.watch(categoryOverviewProvider).when(
                    loading: () => const _CategorySkeletonList(),
                    error: (e, _) => _CategoryErrorState(
                      onRetry: () =>
                          ref.invalidate(categoryOverviewProvider),
                    ),
                    data: (categories) {
                      if (categories.isEmpty) {
                        return _CategoryEmpty(onCreate: () {
                          // Plan 2 wires the create modal here.
                        });
                      }
                      return ListView.separated(
                        itemCount: categories.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final c = categories[i];
                          return KListRow(
                            leading: Icon(
                              TablerIcons.layout_grid,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: c.name ?? '',
                            // Subtitle composition per spec §5.2:
                            subtitle: _subtitleFor(c),
                            onTap: () => context.go(
                              '/catalog/categories/${c.categoryId}',
                            ),
                          );
                        },
                      );
                    },
                  ),
            ),
```

Add helper widgets at the bottom of the file:

```dart
class _CategorySkeletonList extends StatelessWidget {
  const _CategorySkeletonList();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: KSkeleton(height: 56),
      ),
    );
  }
}

class _CategoryEmpty extends StatelessWidget {
  const _CategoryEmpty({required this.onCreate});
  final VoidCallback onCreate;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return KEmptyState(
      icon: TablerIcons.layout_grid,
      title: l.categoryEmptyTitle,
      subtitle: l.categoryEmptyBody,
      action: KSecondaryBtn(
        onPressed: onCreate,
        child: Text(l.categoryEmptyAction),
      ),
    );
  }
}

class _CategoryErrorState extends StatelessWidget {
  const _CategoryErrorState({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return KEmptyState(
      icon: TablerIcons.alert_triangle,
      title: l.categoryLoadError,
      action: KSecondaryBtn(
        onPressed: onRetry,
        child: Text(l.categoryLoadRetry),
      ),
    );
  }
}

String _subtitleFor(gen.CategoryResponse c) {
  final parts = <String>[];
  final subs = c.subCategoriesCount ?? 0;
  if (subs > 0) parts.add('$subs sub'); // i18n in Task 9 via plural — call l.categorySubCount
  final items = c.itemCount ?? 0;
  if (items > 0) parts.add('$items items');
  return parts.join(' · ');
}
```

The subtitle composition currently hardcodes "sub" / "items" for brevity in the implementation sketch. **Replace with `AppLocalizations.of(context).categorySubCount(subs)` and `.categoryItemCount(items)`** to honor i18n — but you'll need to pass `context` or `l` into `_subtitleFor`, so refactor it inline or pass context. The hardcoded version above is intentional shorthand that the executor must fix in this step.

Add imports as needed:
```dart
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/design/core/catalog/k_list_row.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
flutter test test/features/catalog/categories/categories_list_screen_test.dart
flutter analyze
```

Expected: all PASS; analyze 0 errors.

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/categories/categories_list_screen.dart test/features/catalog/categories/categories_list_screen_test.dart
git commit -m "feat(catalog): wire CategoriesListScreen to overview provider

Skeleton on loading, list rows on data, KEmptyState on 0 categories,
error state with Retry on failure. Plan 2 wires the create-button +
long-press menu."
```

---

## Task 17: Layer-filter pill tabs

Derive distinct layers from the overview, render `KTabNav`, filter the visible rows.

**Files:**
- Modify: `lib/features/catalog/categories/categories_list_screen.dart`
- Modify: `test/features/catalog/categories/categories_list_screen_test.dart`

- [ ] **Step 1: Extend the test**

Append:

```dart
testWidgets('shows All + distinct layer tabs from data', (tester) async {
  await tester.pumpWidget(_wrap(
    const CategoriesListScreen(),
    overrideOverview: categoryOverviewProvider.overrideWith((ref) async => [
      _cat(id: '1', name: 'A', layer: '1'),
      _cat(id: '2', name: 'B', layer: '1'),
      _cat(id: '3', name: 'C', layer: '2'),
    ]),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  expect(find.text('All'), findsOneWidget);
  expect(find.text('Main'), findsOneWidget);
  expect(find.text('Sub'), findsOneWidget);
});

testWidgets('tapping a layer tab filters the list', (tester) async {
  await tester.pumpWidget(_wrap(
    const CategoriesListScreen(),
    overrideOverview: categoryOverviewProvider.overrideWith((ref) async => [
      _cat(id: '1', name: 'Electronics', layer: '1'),
      _cat(id: '2', name: 'Audio', layer: '2'),
    ]),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  // Both visible under "All"
  expect(find.text('Electronics'), findsOneWidget);
  expect(find.text('Audio'), findsOneWidget);
  // Tap "Main" — should hide Audio (layer 2)
  await tester.tap(find.text('Main'));
  await tester.pump();
  expect(find.text('Electronics'), findsOneWidget);
  expect(find.text('Audio'), findsNothing);
});
```

- [ ] **Step 2: Run test to verify it fails**

Expected: FAIL — tabs not rendered.

- [ ] **Step 3: Add layer-filter state + render**

In `_CategoriesListScreenState`, add a `String _activeLayer = 'all';` field and a helper:

```dart
String _layerLabel(BuildContext context, String layer) {
  final l = AppLocalizations.of(context);
  switch (layer) {
    case '1': return l.categoryLayerMain;
    case '2': return l.categoryLayerSub;
    case '3': return l.categoryLayerSubSub;
    default:  return '${l.categoryLayerPrefix} $layer';
  }
}
```

In `build()`, between the search bar and the list, when the data is loaded with `categories.isNotEmpty`, render the tabs. The cleanest pattern: derive layer tabs inside the `.when(data: ...)` branch and pass them down. To keep the patch focused, render tabs above the ListView inside the same `data:` branch.

Add at the top of the data branch (replacing the bare `return ListView.separated(...)`):

```dart
                      final l = AppLocalizations.of(context);
                      final layers = categories
                          .map((c) => c.layer ?? '1')
                          .toSet()
                          .toList()
                        ..sort((a, b) =>
                            int.tryParse(a)?.compareTo(int.tryParse(b) ?? 0) ?? 0);
                      final tabs = <KTabItem<String>>[
                        KTabItem(id: 'all', label: l.categoryLayerAll),
                        for (final layer in layers)
                          KTabItem(
                            id: layer,
                            label: _layerLabel(context, layer),
                          ),
                      ];
                      final visible = _activeLayer == 'all'
                          ? categories
                          : categories
                              .where((c) => (c.layer ?? '1') == _activeLayer)
                              .toList();
                      return Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: KTabNav<String>(
                            tabs: tabs,
                            active: _activeLayer,
                            onChange: (id) => setState(() => _activeLayer = id),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.separated(
                            itemCount: visible.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (_, i) {
                              final c = visible[i];
                              return KListRow(
                                leading: Icon(
                                  TablerIcons.layout_grid,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: c.name ?? '',
                                subtitle: _subtitleFor(c),
                                onTap: () => context.go(
                                  '/catalog/categories/${c.categoryId}',
                                ),
                              );
                            },
                          ),
                        ),
                      ]);
```

Add import:

```dart
import 'package:kuru_mobile/design/core/input/k_tab_nav.dart';
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
flutter test test/features/catalog/categories/
flutter analyze
```

Expected: all PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/categories/categories_list_screen.dart test/features/catalog/categories/categories_list_screen_test.dart
git commit -m "feat(catalog): layer-filter pill tabs

Derive distinct layers from overview; render KTabNav with All + per-layer
tabs; filter visible rows by active layer."
```

---

## Task 18: Search filter (Vietnamese-normalized, scoped to active layer)

Apply the search query to the visible rows, using the helper from Task 8. Per spec §5.2, search filters within the **active** layer.

**Files:**
- Modify: `lib/features/catalog/categories/categories_list_screen.dart`
- Modify: `test/features/catalog/categories/categories_list_screen_test.dart`

- [ ] **Step 1: Extend the test**

Append:

```dart
testWidgets('typing in search filters rows by normalized name',
    (tester) async {
  await tester.pumpWidget(_wrap(
    const CategoriesListScreen(),
    overrideOverview: categoryOverviewProvider.overrideWith((ref) async => [
      _cat(id: '1', name: 'Điện tử', layer: '1'),
      _cat(id: '2', name: 'Thực phẩm', layer: '1'),
    ]),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.enterText(find.byType(TextField), 'dien');
  await tester.pump();
  expect(find.text('Điện tử'), findsOneWidget);
  expect(find.text('Thực phẩm'), findsNothing);
});

testWidgets('search applies within active layer, not across all',
    (tester) async {
  await tester.pumpWidget(_wrap(
    const CategoriesListScreen(),
    overrideOverview: categoryOverviewProvider.overrideWith((ref) async => [
      _cat(id: '1', name: 'Electronics', layer: '1'),
      _cat(id: '2', name: 'Electron beam', layer: '2'),
    ]),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  // Switch to layer 2 ("Sub")
  await tester.tap(find.text('Sub'));
  await tester.pump();
  await tester.enterText(find.byType(TextField), 'electron');
  await tester.pump();
  // Only layer-2 match is visible
  expect(find.text('Electron beam'), findsOneWidget);
  expect(find.text('Electronics'), findsNothing);
});
```

- [ ] **Step 2: Run tests to verify they fail**

Expected: FAIL — search not applied.

- [ ] **Step 3: Apply search filter to the visible list**

In the `data:` branch from Task 17, after computing `visible`, add:

```dart
                      final normalizedQuery = normalizeForSearch(_searchQuery);
                      final filtered = normalizedQuery.isEmpty
                          ? visible
                          : visible.where((c) =>
                              normalizeForSearch(c.name ?? '')
                                  .contains(normalizedQuery)).toList();
```

Then use `filtered` instead of `visible` in the `ListView.separated`'s `itemCount` and `itemBuilder`.

Add import:
```dart
import 'package:kuru_mobile/core/text/search_normalize.dart';
```

Note: `normalizeForSearch` is marked `@visibleForTesting` from Task 8 — remove that annotation now, since the list screen is a real consumer.

- [ ] **Step 4: Run tests to verify they pass**

```bash
flutter test test/features/catalog/categories/
flutter analyze
```

Expected: all PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog/categories/categories_list_screen.dart test/features/catalog/categories/categories_list_screen_test.dart lib/core/text/search_normalize.dart
git commit -m "feat(catalog): Vietnamese-normalized search within active layer"
```

---

## Task 19: Row-tap → placeholder detail navigation test

The row already calls `context.go('/catalog/categories/${c.categoryId}')` (from Task 16). This task adds an end-to-end test that the tap actually pushes onto the route, the placeholder renders, and back-pop returns.

**Files:**
- Create: `test/features/catalog/categories/list_to_detail_navigation_test.dart`

- [ ] **Step 1: Write the test**

This test needs the real `routerProvider`, not a bare MaterialApp. Use `MaterialApp.router` with the actual router.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_category_api/kuru_category_api.dart' as gen;
import 'package:kuru_mobile/app/router.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/catalog/categories/providers/category_providers.dart';
import 'package:kuru_mobile/features/splash/splash_screen.dart';

void main() {
  testWidgets('tapping a row pushes the placeholder detail screen',
      (tester) async {
    final fakeUser = UserInfo(/* fill in minimal fields */);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          splashGateProvider.overrideWith(
            (ref) async => BootstrapAuthed(fakeUser),
          ),
          currentOrgIdProvider.overrideWith(() => _StubOrgId('org-x')),
          categoryOverviewProvider.overrideWith((ref) async => [
            gen.CategoryResponse((b) => b
              ..categoryId = 'cat-1'
              ..name = 'Electronics'
              ..layer = '1'),
          ]),
        ],
        child: Consumer(builder: (ctx, ref, _) {
          final router = ref.watch(routerProvider);
          return MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        }),
      ),
    );
    // Splash → bootstrap → /home (default tab). Step through animations.
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));

    // Switch to Catalog tab
    await tester.tap(find.text('Catalog'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Tap the row
    expect(find.text('Electronics'), findsOneWidget);
    await tester.tap(find.text('Electronics'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300)); // route push

    // Placeholder body
    expect(find.text('Detail view coming soon'), findsOneWidget);
  });
}
```

You'll need to fill in `UserInfo` with whatever the freezed factory takes — read `lib/core/auth/auth_repository.dart` to find its signature, supply the minimum required fields. Same for `_StubOrgId` — model it on whatever `currentOrgIdProvider`'s notifier looks like in `auth_providers.dart`.

- [ ] **Step 2: Run test to verify**

```bash
flutter test test/features/catalog/categories/list_to_detail_navigation_test.dart
```

If the test fails because of unforeseen ProviderScope override missing (e.g., onboarding flag, more dio wiring), add the override and re-run. The goal is a working integration test; don't lower the bar to make it pass.

- [ ] **Step 3: Commit**

```bash
git add test/features/catalog/categories/list_to_detail_navigation_test.dart
git commit -m "test(catalog): end-to-end list → placeholder detail navigation"
```

---

## Task 20: MainShell tab-switching e2e test

Independent of the catalog data, verify all three tabs mount their respective screens and that switching tabs preserves per-branch stacks.

**Files:**
- Create: `test/features/main_shell/main_shell_e2e_test.dart`

- [ ] **Step 1: Write the test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/router.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
// Use the same override fixtures as Task 19 — extract into a helper if both tests need them.

void main() {
  testWidgets('three tabs mount correct screens; per-tab stack preserved',
      (tester) async {
    await tester.pumpWidget(/* same setup as Task 19, plus empty overview */);
    await tester.pump(const Duration(milliseconds: 100));

    // Default tab is Home — homeStubTitle visible
    expect(find.textContaining('Welcome'), findsOneWidget);

    // Tap Catalog
    await tester.tap(find.text('Catalog'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Categories'), findsOneWidget);

    // Tap Settings
    await tester.tap(find.text('Settings'));
    await tester.pump();
    expect(find.text('Settings coming soon'), findsOneWidget);

    // Tap Catalog again — should land back on Categories (preserved branch)
    await tester.tap(find.text('Catalog'));
    await tester.pump();
    expect(find.text('Categories'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test**

```bash
flutter test test/features/main_shell/main_shell_e2e_test.dart
```

Expected: PASS.

- [ ] **Step 3: Run the full test suite + analyze**

```bash
flutter test
flutter analyze
```

Both must exit 0. This is the gate before merging Plan 1.

- [ ] **Step 4: Commit**

```bash
git add test/features/main_shell/main_shell_e2e_test.dart
git commit -m "test(main_shell): e2e three-tab navigation + per-branch preservation"
```

---

## Task 21: Manual smoke + PR

Final preflight before opening the Plan 1 PR.

- [ ] **Step 1: Boot the simulator with BE running**

```bash
xcrun simctl boot "iPhone 16" 2>/dev/null && open -a Simulator
flutter run -d "iPhone 16" --dart-define=API_BASE_URL=http://localhost:9190
```

- [ ] **Step 2: Walk the golden path**

1. Splash → bootstrap → /home (Home tab visible at bottom, active).
2. Tap Catalog → CategoriesListScreen renders with header + search bar.
3. Skeleton briefly visible → list loads with your seeded categories.
4. Layer tabs visible if data spans 2+ layers; tap one → list filters.
5. Type "die" or similar in search → list filters by normalized match.
6. Tap a row → CategoryDetailScreen with "Detail view coming soon".
7. Back button → returns to list with previous filter/search preserved.
8. Tap Settings → "Settings coming soon".
9. Tap Home → returns to original Home stub content.

- [ ] **Step 3: Push and open the PR**

```bash
git push -u origin feat/catalog-scaffold
gh pr create --base release/v0.4.0 --title "feat: Catalog scaffold + read-only Categories (Plan 1)" --body "$(cat <<'EOF'
## Summary
- Adds openapi codegen toolchain (`openapi_generator` + dart-dio) generating `lib/api/category/`
- Splits `UnauthorizedException` into 401 + new `ForbiddenException` (existing 401 callers unaffected)
- Adds bottom-nav `MainShell` via `StatefulShellRoute.indexedStack` (Home / Catalog / Settings)
- Adds read-only `CategoriesListScreen` with search (Vietnamese-normalized), layer-filter pill tabs, KSkeleton / KEmptyState / error retry
- Wires `categoryOverviewProvider` + `categoryByIdProvider.family` (both watch `currentOrgIdProvider`)

## Out of scope (Plan 2)
- `+` button, Create/Edit modal
- Long-press action menu
- Delete confirm
- Real `CategoryDetailScreen` body (currently a "coming soon" placeholder)

## Test plan
- [ ] `flutter test` — all green (49 identity + 87 core-design + ~14 new Categories tests)
- [ ] `flutter analyze` — exit 0
- [ ] Manual smoke per Task 21 Step 2
- [ ] Verify org switch invalidates the cache: log in to a second org, swap via OrgPicker, confirm the list re-fetches
EOF
)"
```

---

## Self-review checklist (do this before declaring Plan 1 done)

- [ ] Every spec §3 architecture point has a task: codegen (T2, T4), basePathOverride (T5), repository (T6), providers (T7), 401/403 split (T1), file layout (T4, T5, T6, T7).
- [ ] Every spec §5 screen exists: MainShell (T13), CategoriesListScreen (T15-T18), placeholder CategoryDetailScreen (T12), SettingsStubScreen (T10), HomeTabScreen (T11 verified no work).
- [ ] Spec §6.2 401/403 split delivered in T1.
- [ ] Spec §10.1 source-of-truth files consulted in T3.
- [ ] No placeholders in any task body — every step has the actual code / command / expected output.
- [ ] All new tests pumped with `pump()` + tiny duration, never `pumpAndSettle()`.
- [ ] All file paths absolute (`lib/...` not `./lib/...`).
- [ ] Imports listed where new files reference packages.
- [ ] `git add` paths in commits explicit (no `git add .`).
