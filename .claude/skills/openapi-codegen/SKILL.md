---
name: openapi-codegen
description: Use when running tool/codegen.sh, adding a new openapi module to lib/api/, modifying generated dart-dio output, or debugging build errors that mention generated files in lib/api/. Especially when seeing "The language version override has to be the same in the library and its part(s)" during iOS / Android build or `flutter analyze`. Documents the dart-dio + Dart 3 incompatibility and the canonical fix baked into our codegen.sh.
---

# OpenAPI codegen — kuru-mobile

How we turn `../gen-barcode/openapi/*.openapi.json` into Dart clients in `lib/api/<module>/`, and the foot-guns we've already paid for so you don't pay for them again.

## TL;DR

- **Generator:** `openapi_generator_cli` 6.1.0 (Dart wrapper) invoking JAR `openapi-generator-cli-7.9.0`.
- **Template:** `dart-dio` (uses `dio` + `built_value`).
- **Entry point:** `tool/codegen.sh [module]` — never invoke `dart run openapi_generator_cli:main` directly.
- **Generated package shape:** sub-Dart-package at `lib/api/<module>/` with its own `pubspec.yaml`, consumed as a `path:` dependency by the main app.
- **Output is committed** to git (per spec §9.1). Re-generate after any openapi spec change in `../gen-barcode/openapi/`.

## The big foot-gun: language-version override error

```
lib/api/<module>/lib/src/model/foo.dart:9:6: Error:
  The language version override has to be the same in the library and its part(s).
```

You'll hit this on `flutter run` (iOS / Android), not on `flutter analyze` or unit tests — the CFE used by the build pipeline is stricter than the analyzer.

### Root cause (upstream bug — openapi-generator)

The dart-dio template hardcodes `environment: sdk: '>=2.14.0 <3.0.0'` (or `>=2.15.0 <4.0.0` in newer versions) in the **generated sub-package**'s `pubspec.yaml`. Our host app has `sdk: ^3.11.0`. The package-boundary language-version mismatch makes the CFE reject the `part 'X.g.dart';` directives at compile time even when both library and part files inherit the same effective version from the package config — there's something about the prior generation context that the CFE remembers.

References:
- [openapi-generator/issues/16117](https://github.com/OpenAPITools/openapi-generator/issues/16117) — fix-via-PR claim, still hits in practice
- [openapi-generator/issues/14863](https://github.com/OpenAPITools/openapi-generator/issues/14863) — root-cause discussion, status: open

### The fix (already baked into `tool/codegen.sh`)

Two parts. `tool/codegen.sh` does both automatically — you should not have to run them by hand:

**(a) Sed-bump the generated sub-package's SDK lower bound to match the host (Dart 3.11):**

```bash
sed -i.bak "s|sdk: '>=2.15.0 <4.0.0'|sdk: '>=3.11.0 <4.0.0'|" "lib/api/${module}/pubspec.yaml"
rm -f "lib/api/${module}/pubspec.yaml.bak"
```

This eliminates the package-boundary version difference entirely.

**(b) Run `pub get` + `build_runner build` inside the sub-package _after_ the sed-bump:**

```bash
(cd "lib/api/${module}" && $DART pub get --no-example && $DART run build_runner build)
```

Order matters: bump SDK → `pub get` (refreshes the sub-package's `.dart_tool/package_config.json` with the new 3.11 languageVersion) → `build_runner build` (emits `.g.dart` files in the 3.11 language context).

### If the fix isn't holding (recovery procedure)

If you bumped the constraint but still see the error:

1. **Stale `.g.dart` files** — the most common cause. Files generated under the OLD SDK constraint carry a stale language-version association that survives the bump. Fix:
   ```bash
   (cd lib/api/<module> && rm -f lib/src/model/*.g.dart lib/src/*.g.dart)
   (cd lib/api/<module> && ~/flutter/bin/dart pub get --no-example && ~/flutter/bin/dart run build_runner build)
   ```

2. **Stale `.dart_tool/package_config.json`** in the sub-package — caches the old languageVersion. `pub get` inside the sub-package refreshes it.

3. **Nuclear option** — wipe and regenerate from scratch:
   ```bash
   ./tool/codegen.sh <module>   # codegen.sh wipes lib/api/<module>/ before regenerating
   ```

After any of the above, run `flutter clean && flutter pub get && cd ios && pod install && cd ..` before `flutter run` — the iOS build cache poisons easily.

### Never try to fix this by adding `// @dart=X.Y` to generated files

It looks tempting (the error mentions "override") but:
- Generated files get clobbered on every regen
- Manual overrides break for tomorrow's reviewer
- The SDK-bump fix is the canonical upstream-blessed workaround

## Source-of-truth ordering (per CLAUDE.md)

The openapi specs in `../gen-barcode/openapi/*.openapi.json` are unreliable. They're proto-generated and drift from the handler. Before accepting any generated client into the codebase, verify against:

1. `../gen-barcode/be/core/dto/<module>/*.dto.ts` — request body validation (Zod)
2. `../gen-barcode/be/core/domains/<domain>/api/<module>.route.ts` — actual handler
3. `../gen-barcode/be/types/<module>.d.ts` — generated TS response types
4. `../gen-barcode/be/core/domains/<domain>/services/<module>.service.ts` — `resData`

If the generated Dart model disagrees with the `.d.ts` or service, patch a copy of `<module>.openapi.json` in `tool/openapi-patches/<module>.openapi.json` — `codegen.sh` auto-detects and uses the patched copy. Do **not** modify files in `../gen-barcode/openapi/` from this repo.

The category module already has surgical patches (see `tool/openapi-patches/category.openapi.json` and spec §10.3 — the sanity-check log). Use that as your template for future patch-format.

## Adding a new module (Brand, Product, …)

1. Verify the openapi spec exists at `../gen-barcode/openapi/<module>.openapi.json`.
2. Run the BE source-of-truth check (read the 4 BE files above, diff against the openapi). Patch if needed.
3. Add the module to `tool/codegen.sh`'s `spec_for()` case statement AND to the `ALL_MODULES` string:
   ```bash
   spec_for() {
     case "$module" in
       category) echo "../gen-barcode/openapi/category.openapi.json" ;;
       brand)    echo "../gen-barcode/openapi/brand.openapi.json" ;;   # ← new
       *) echo "" ;;
     esac
   }

   ALL_MODULES="category brand"   # ← new
   ```
4. Run `./tool/codegen.sh brand`.
5. Add the path dependency to `pubspec.yaml`:
   ```yaml
   dependencies:
     kuru_brand_api:
       path: lib/api/brand
   ```
6. `flutter pub get`.
7. Commit the generated `lib/api/brand/` directory.

## Why we don't use the annotation-based `openapi_generator` package

The pub.dev `openapi_generator` package (the `@Openapi`-annotation host that wraps `openapi_generator_cli` via `build_runner`) caps `analyzer <7.0.0`. Our `riverpod_generator ^2.6.3` requires `analyzer ^6.7.0`. The narrow overlap window triggers a `macros` SDK chain not present in Dart 3.11 — version solving fails.

The script-based approach (`tool/codegen.sh` invoking the CLI directly) bypasses that constraint entirely. If you ever re-evaluate, the pivot is documented in `docs/superpowers/plans/2026-05-17-catalog-scaffold.md` (Task 2 revision note + Task 4 architecture).

## Analyzer exclusion

Generated code lives at `lib/api/**` and is excluded in `analysis_options.yaml`:

```yaml
analyzer:
  exclude:
    - lib/api/**
```

Don't remove this. The generator emits style choices `very_good_analysis` would flag (file-level lint ignores, unused-element warnings, etc.). If you find yourself running `flutter analyze` on `lib/api/` directly, you're holding it wrong — the exclusion is intentional.

## Smoke check after regen

After any codegen run:

```bash
flutter pub get             # in repo root, picks up the path-dep refresh
# (use mcp__plugin_vgv-ai-flutter-plugin_dart__pub if hook blocks)

# Quick analyzer pass on consumer code (NOT lib/api/**):
flutter analyze             # should exit 0

# Full test pass:
# (use mcp__plugin_vgv-ai-flutter-plugin_very-good-cli__test in this project,
#  not raw `flutter test` which is hook-blocked)

# Build smoke (the part that historically caught the language-version bug):
flutter run -d "iPhone 16" --dart-define=API_BASE_URL=http://localhost:9190
```

If the build fails with the language-version error AGAIN despite the SDK bump being in place, jump straight to the "recovery procedure" above — don't try to bandage the symptom.

## Hooks that get in the way

This project has a VGV plugin hook (`block-cli-workarounds.sh`) that intercepts `flutter test` / `dart test` and routes them through `very_good_cli`. The hook does NOT block:
- `flutter pub get`
- `flutter run`
- `dart run openapi_generator_cli:main` (codegen.sh's invocation)
- `dart run build_runner build`

So `tool/codegen.sh` runs unhindered. The MCP equivalents (`mcp__plugin_vgv-ai-flutter-plugin_dart__pub`, `mcp__plugin_vgv-ai-flutter-plugin_very-good-cli__test`) are the preferred substitutes for the blocked commands.

## What to put in a commit message after regen

When the generated `lib/api/<module>/` content changes (you re-ran codegen for any reason), the commit should explicitly say so:

```
chore(api): regenerate <module> client from <SHA-or-date>

[Reason: <openapi spec changed | model field added | bug fix in BE | …>]
```

Don't hide a regen inside a feature commit — it bloats the diff and obscures intent.

---

**Sources:**
- `tool/codegen.sh` (the canonical script)
- `tool/openapi-patches/README.md` (patch workflow)
- `docs/superpowers/specs/2026-05-17-catalog-category-design.md` (§3.1 codegen, §10.3 sanity-check log)
- `docs/superpowers/plans/2026-05-17-catalog-scaffold.md` (Task 2 + Task 4 pivot history)
- [openapi-generator issue #16117](https://github.com/OpenAPITools/openapi-generator/issues/16117)
- [openapi-generator issue #14863](https://github.com/OpenAPITools/openapi-generator/issues/14863)
- `CLAUDE.md` (project conventions, source-of-truth ordering)
