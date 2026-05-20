---
name: mobile-design
description: Use when implementing UI in kuru-mobile (any work in lib/design/, lib/features/, or test/design/ — new widgets, new screens, modifying existing widgets, adding tests for UI). Covers the design-system split (auth-glass vs content-flat), widget catalog, analyzer rules that trip subagents, and test patterns specific to this project. Read this BEFORE writing widget code or tests.
---

# Mobile design system — kuru-mobile

This project has a deliberate **two-aesthetic** design system. Knowing which side to use prevents costly rework.

## ⚠️ Read this first when working on content screens

**Canonical UI bible:** `docs/superpowers/specs/2026-05-20-ui-style-guide.md`

Every content-screen UI (Settings, Catalog, Home overview, future product list / POS / etc.) must match the style guide. The Settings module (`lib/features/settings/`) is the reference implementation as of `v0.4.0-settings-biometric`.

Auth/onboarding screens are intentionally different (glass aesthetic) and are out of scope for the bible. Do not retrofit them.

## The split

```
lib/design/
├── auth/                  ← Auth/onboarding chrome (AuthBackdrop, AuthLogo)
├── widgets/               ← GLASS aesthetic — used by auth/onboarding/login/register/
│                            TOTP/create-org/org-picker screens
│                            Files: KGlass, KPrimaryBtn (shine), KFormField, KCheckbox,
│                                   KStepDots, KOtpInput
└── core/                  ← FLAT aesthetic — used by Catalog/Settings/Home/all future
                             content screens
    ├── layout/      → KPageHeader
    ├── input/       → KSearchBar, KTextField, KTextarea, KSelect,
                         KSecondaryBtn, KDangerBtn, KIconBtn, KTabNav
    ├── feedback/    → KSpinner, KSkeleton, KEmptyState, KBadge
    ├── modal/       → KModalSheet (base bottom sheet), KConfirmDialog (centered),
                         KActionSheet (bottom action list), KPopupMenu (native iOS/
                         Android context menu via super_context_menu),
                         KColorPicker, KIconPicker,
                         color_options.dart, icon_mapping.dart
    └── catalog/     → KListRow, KCategoryCard (Catalog-specific compositions)
```

**Decision rule:**
- Building an auth/onboarding/identity-flow screen? → `lib/design/widgets/` (glass).
- Building anything else (Catalog, Settings, Home overview, product list, POS, …)? → `lib/design/core/` (flat).

Do NOT mix glass and flat on the same screen. Don't use `KGlass` inside a Catalog screen; don't use `KSecondaryBtn` on Login.

## Specs and plans (read these for context)

- `docs/superpowers/specs/2026-05-16-catalog-core-design.md` — full spec for the flat design system (20 widgets, mobile adaptations, theme tokens, build order, deferred items).
- `docs/superpowers/plans/2026-05-16-catalog-core-design.md` — implementation plan (25 task TDD cycles).

## Conventions you MUST follow (analyzer trip-wires)

The repo's analyzer is strict — `flutter analyze` exits non-zero on info-level lints, breaking CI per CLAUDE.md. These are the recurring ones that subagents kept hitting:

| Lint | Fix |
|---|---|
| `lines_longer_than_80_chars` | Wrap long lines. Especially common on `const EdgeInsets.symmetric(horizontal: X, vertical: Y)` and aligned constant tables — break them onto multiple lines. |
| `no_leading_underscores_for_local_identifiers` | In test files, use `Widget wrap(Widget child) => MaterialApp(...)`. NEVER `_wrap`. |
| `avoid_redundant_argument_values` | Don't pass default values. `Border.all(color: c.border)` not `Border.all(color: c.border, width: 1)`. `CrossAxisAlignment.center` is the default on Row (drop it) but not on Column (keep it). `KSpinner()` not `KSpinner(size: 16)`. Same for `isScrollControlled: false`. |
| `document_ignores` | Put the explanation comment ABOVE `// ignore_for_file:`, not below. |
| `avoid_catches_without_on_clauses` | `on Object catch (_)` not `catch (_)`. |
| `discarded_futures` | Wrap fire-and-forget Futures in `unawaited(...)` from `dart:async`. Common in tests that call `showK*` without awaiting. |
| `always_put_required_named_parameters_first` | In constructors, list `required` params before `super.key` and before optional ones. |
| `prefer_final_locals` / `prefer_final_fields` | If never reassigned, use `final` (top-level or field) / `final` (local). |
| `unnecessary_null_checks` | Avoid `tooltip!` if analyzer already narrowed it. Hoist into a `final t = tooltip;` if the narrowing doesn't propagate. |
| `prefer_const_constructors` | `const KBadge(...)` where possible. |

**Run `flutter analyze` after every change and verify exit code 0 with `echo $?`.** Don't trust an implementer's "analyzer passed" claim without verifying yourself.

## Test conventions

- Test file lives at `test/design/core/<subdir>/k_<widget>_test.dart` mirroring `lib/design/core/...`.
- Pump pattern (single-palette default):
  ```dart
  Widget wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),  // or Center(child: child) for tightly sized widgets
      );
  ```
- **NEVER call `pumpAndSettle()` when a continuous animation is in the frame** (KSpinner / KSkeleton / KPrimaryBtn shine). Use `pump()` + `pump(Duration(milliseconds: N))` to step through microtasks instead. This is critical for testing KModalSheet / KConfirmDialog flows where a brief spinner state appears during the awaited `onConfirm`.
- For modal flows, capture a BuildContext from an inner Builder, then call `showK*` from that captured context. Wrap fire-and-forget calls in `unawaited(...)`.
- Don't write goldens — too fragile at this stage. Visual review happens on the demo screen.

## Theme

All flat widgets read colors from `kuruColors(context)` (see `lib/app/theme/kuru_colors.dart`). Available fields: `accent50/100/200/600/700/800`, `surfaceElev/surfaceHover`, `border/borderSoft`, `textPrimary/Secondary/Muted`, `danger/dangerSoft`, `success/successSoft`, `warning/warningSoft`, `secondary/secondarySoft`, `pageBg`, `textInverse`.

Border radius literals: 8 (tabs/chips), 12 (buttons/inputs/list rows), 16 (cards/sheet edges), 999 (badges/circles).

## Mobile-specific adaptations from kuru-web

When porting a widget from `../gen-barcode/fe/src/core-design/`:

- Web centered modal (`showDialog`-style sheet) → mobile bottom sheet (`KModalSheet`).
- Web 3-dot dropdown (`ActionMenu`) → either `KActionSheet` (bottom sheet action list, mobile-native) or `KPopupMenu` (native iOS/Android context menu, long-press). Caller picks per use-case.
- Web inline-edit (`BrandRow` clickable inline name) → mobile tap-row-opens-edit-sheet (use `KListRow` + `KModalSheet`).
- Web `<select>` → mobile `KSelect` (looks like text input, opens `KActionSheet` on tap).
- Web ⌘K hint → drop entirely on mobile.
- Web tabler icons via `@tabler/icons-react` → `flutter_tabler_icons` v1.43+ (snake_case: `TablerIcons.alert_triangle`, not camelCase).

## Modal API quick reference

| Helper | When |
|---|---|
| `showKModalSheet<T>(...)` | Create/edit forms, pickers. Has `disableConfirm`, `showCancel`, `loadingBody`, `enableDrag` params. |
| `showKConfirmDialog(...)` | Yes/no confirmations (delete, sign-out). Pass `onConfirm: () async {...}` and the dialog stays open with a spinner during the await. |
| `showKActionSheet<T>(...)` | List of 2–5 actions on a single item (Edit / Duplicate / Delete). Items can be `enabled: false` for permission gating. |
| `KPopupMenu<T>(...)` | Same actions, but native iOS/Android context menu on long-press. Use when web has a 3-dot menu and you want platform-native feel. |
| `showKColorPicker(...)` | 26-color swatch grid. |
| `showKIconPicker(...)` | Curated icon grid with search. Returns kebab-case name. Caller MUST fallback to `TablerIcons.layout_grid` when `resolveIconName(name) == null` (e.g. web saved an icon outside the mobile curated set). |

## Demo / sandbox screen

`lib/features/demo/core_design_demo_screen.dart` shows every widget rendered with sample data.

**How to reach it:** double-tap the kuru logo on the Login screen (debug-only — `kDebugMode` guard). Long-press is taken by onboarding replay.

**Production safety:** the gesture is wrapped in `if (kDebugMode ? ... : null)`. `kDebugMode` is a compile-time constant — in release builds, the branch becomes dead code and the Dart tree-shaker eliminates the import + the entire `CoreDesignDemoScreen` class. The screen does not ship in production.

When verifying release behavior:
```bash
flutter build ios --release --analyze-size
# or
flutter build apk --release --analyze-size
```
Inspect the resulting size report — `core_design_demo_screen.dart` should NOT appear in the bundle. If it does, the tree-shaking failed and we need to add a stub-on-release pattern.

## Pubspec deps used by the flat design system

- `flutter_tabler_icons: ^1.43.0` — Tabler icon set
- `super_context_menu: ^0.9.1` — native context menus (requires iOS 13+ deployment target — already set in `ios/Podfile`)

After adding ANY plugin with native code (Rust/Obj-C/Kotlin), you must:
```bash
flutter clean && flutter pub get && cd ios && pod install && cd .. && flutter run
```
Hot-reload and hot-restart don't pick up new native plugins.
