---
name: mobile-design
description: MANDATORY before any design / styling / new-screen / restyle task in kuru-mobile. Use when implementing UI in kuru-mobile (any work in lib/design/, lib/features/, or test/design/ — new widgets, new screens, modifying existing widgets, restyle requests like "make it match products / settings", adding tests for UI). Covers the design-system split (auth-glass vs content-flat), the canonical screen archetypes (list / detail / form), the pastel-tint colour vocabulary, widget catalogue, analyzer rules that trip subagents, and test patterns specific to this project. Read this BEFORE writing widget code or tests. If the task says "make X look like Y", read the relevant archetype section below and mirror the structure literally.
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

## ⭐ Screen archetypes — reference implementations to mirror

When a task says "build a list / detail / form screen" — or worse, "make X look like Product" — you MUST mirror the corresponding reference file structurally. The Product module is the canonical reference (most recent, most polished). Orders is the second example showing the patterns applied to a different domain.

### Archetype A — List screen (paginated)

**Reference:** `lib/features/catalog/products/products_list_screen.dart` (canonical) and `lib/features/orders/order_list_screen.dart` (applied).

Mandatory structure:

1. `Scaffold(backgroundColor: c.pageBg)` — **no AppBar.**
2. `SafeArea(bottom: false)` → `RefreshIndicator` → `CustomScrollView` w/ `ScrollController`, `cacheExtent: 900`.
3. **Slivers, in order:**
   1. `SliverToBoxAdapter` — title block: 32 px / FontWeight.w800 / letterSpacing -0.8 title on left + small FilledButton.icon ("Tạo …") on right.
   2. `SliverToBoxAdapter` — total-count line, 13 px, `c.textMuted` (`"$total {entity}"` or `"Đang tải…"`).
   3. `SliverToBoxAdapter` — filter bar: search `TextField` (`hintText` + `prefixIcon: TablerIcons.search` size 18, `filled: true`, `fillColor: c.surfaceElev`, 12-radius, `BorderSide.none`, `contentPadding` vertical 13) + 48×48 filter button w/ active-count badge in `c.accent600`.
   4. (Optional) `SliverToBoxAdapter` — pill-tab row for primary axis filter (`accent600` selected, `surfaceElev` idle). NOT `KTabNav` — use raw `Material + InkWell` pills to match products.
   5. `async.when(data, loading, error)` slivers:
      - **loading** → `SliverToBoxAdapter` w/ padding 48 + centered `CircularProgressIndicator`.
      - **error** → `SliverToBoxAdapter` w/ padding 24 + centered `'Không tải được … : $e'`.
      - **empty** → `SliverToBoxAdapter` w/ 48-padding column: 56 px icon in `Color(0xFF94A3B8)`, title 16 px `c.textPrimary`, subtitle 13 px `c.textMuted`, primary `FilledButton` CTA when relevant.
      - **data** → see "List-row container" below.
   6. `const SliverToBoxAdapter(child: SizedBox(height: 96))` — clearance for the floating bottom nav pill.
4. **No FloatingActionButton.** Use the header "Tạo" button instead.
5. **Infinite scroll:** ScrollController listener on the CustomScrollView; when `pos.pixels >= pos.maxScrollExtent - 600`, call `loadMore()` on the list provider's notifier.

**List-row container (grouped surface):** items live inside ONE rounded `surfaceElev` container with hairline `borderSoft` dividers indented past the leading icon. Do NOT use `KListRow` for stacked list rows (it draws its own card, gives a "loose pile" look). Instead:

```dart
SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        for (var i = 0; i < items.length; i++) ...[
          MyRow(item: items[i]),
          if (i < items.length - 1)
            Padding(
              padding: const EdgeInsets.only(left: 66), // = 14 + 40 + 12
              child: Divider(height: 1, thickness: 0.5, color: c.borderSoft),
            ),
        ],
        if (page.hasMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
      ]),
    ),
  ),
)
```

**Row layout:** 14h/12v padding · 40×40 pastel-tinted icon container (10-radius) · 12 gap · ellipsized Expanded title-block (entity number 15 px w800 / secondary text 13 px w600 / muted meta 12 px w500) · 8 gap · right column (primary metric 15 px w800 + 4 gap + status pill 10 px w800).

DO NOT put status labels inline next to the title — they overflow horizontally on long titles. The icon's tint already encodes status by colour. Use a small right-side pill for the secondary status (e.g. payment) instead.

### Archetype B — Detail screen

**Reference:** `lib/features/catalog/products/product_detail_screen.dart` (canonical) and `lib/features/orders/order_detail_screen.dart` (applied).

Mandatory structure:

1. `Scaffold(backgroundColor: c.pageBg)`.
2. `AppBar(backgroundColor: c.pageBg, elevation: 0, scrolledUnderElevation: 0, centerTitle: true)` w/ title in 17 px w700 `c.textPrimary` showing the entity identifier (or fallback title while loading).
3. AppBar `actions: [IconButton(icon: dots_vertical)]` → opens `showKActionSheet<String>` w/ relevant `KActionItem`s (use `danger: true` for destructive ones, never raw `PopupMenuButton`).
4. Body = `SingleChildScrollView(padding: const EdgeInsets.only(top: 12, bottom: 96))` → `Column` of:
   1. **Hero block** — 16-h-padding `_Hero` widget. Either an 18-radius image card (for products) OR an 18-radius `surfaceElev` container w/ status badges row → 32 px w800 metric → 13 px w600 `c.textMuted` meta line (for orders/non-image entities).
   2. **`KSettingsSection`** groups (from `lib/design/core/layout/k_settings_section.dart`) — one section per logical area. Header is sentence-case Vietnamese ("Thông tin chính", "Phân loại", "Tổng kết", "Thanh toán (N)" w/ count). Children = `KSettingsRow` instances with pastel-tinted icon tiles.
5. Bottom action: pinned `FilledButton` in `bottomNavigationBar: SafeArea(child: Padding(child: FilledButton(...)))` — only when there's a single primary action available at the current state.
6. Loading state: centered `KSpinner` (or `CircularProgressIndicator`). Error state: centered icon + 15 px w700 message (use `receipt_off`, `package_off`, etc. — not a generic empty state widget).

### Archetype C — Form / create screen

**Reference:** `lib/features/catalog/products/product_form_screen.dart` (canonical) and `lib/features/orders/order_create_screen.dart` (applied).

Mandatory structure:

1. `Scaffold(backgroundColor: c.pageBg)`.
2. `AppBar(backgroundColor: c.pageBg, elevation: 0, scrolledUnderElevation: 0)` w/ title 18 px w800 `c.textPrimary` ("Tạo X" / "Sửa X").
3. Body = `SafeArea(child: Column(children: [Expanded(child: ListView(...)), _CreateFooter(...)]))`.
4. `ListView` uses `keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag`, `padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + bottomInset)` where `bottomInset = MediaQuery.viewInsetsOf(context).bottom`.
5. Inside the ListView: stack of **`_CreateSection`** cards separated by `SizedBox(height: 18)`. Each section: `DecoratedBox(color: c.surfaceElev, border: Border.all(color: c.borderSoft), borderRadius: 18)` containing a 14-padding column with a 14 px w800 title + accent-tinted leading icon + optional "Bắt buộc" red badge, then the field stack. Reference: `lib/features/catalog/products/product_form_screen.dart:1521` (and the local copy in `lib/features/orders/order_create_screen.dart`). The widget is currently private to each form; copy-paste it locally until it's worth extracting.
6. Field widgets:
   - Single-line text → `KTextField` (`label`, `controller`, `placeholder`, `maxLength`, `keyboardType`, `errorText`).
   - Multi-line → `KTextarea`.
   - Currency → `KCurrencyField` (returns `int?`, opens a bottom-sheet picker).
   - Picker triggers (category/brand/unit) → `_PickerTriggerRow` (label + value + chevron, taps to show `KActionSheet` or other picker).
   - Segmented selection (≤4 options) → custom row of accent-toggled chips (see `_DiscountTypeChips` in `order_create_screen.dart`). Do NOT use Material `DropdownButtonFormField` — too noisy.
7. Footer = **`_CreateFooter`** — `Container` w/ `c.surfaceElev` background + top hairline border, 16/12/16/16 padding, 50 px-tall `FilledButton.icon` (or two-button row for save-draft + primary). Spinner replaces icon while submitting; `disabledBackgroundColor: c.accent600.withValues(alpha: 0.38)`; 14-radius shape.

### Archetype quick-pick table

| Task phrasing | Mirror file |
|---|---|
| "list / overview / index screen" | `products_list_screen.dart` |
| "detail screen" | `product_detail_screen.dart` |
| "create / edit / form screen" | `product_form_screen.dart` |
| "Make X look like Product" | All three of the above. |
| "Make X look like Settings" | `lib/features/settings/settings_screen.dart` |

## ⭐ Pastel icon-tint vocabulary

Pastel (bg) / vivid (fg) pairs used everywhere icons need a tinted square. Always declare them as `const Color(0xFFXXXXXX)` literals — they're outside the theme palette on purpose so the visual stays stable across light/dark/purple/indigo (semantic colour). Reuse the same set product / order detail uses:

| Token | bg | fg | Use |
|---|---|---|---|
| Purple | `0xFFF1ECFB` | `0xFF8B5CF6` | Category / channel / variants / card-payment |
| Blue | `0xFFE7F1FB` | `0xFF3B82F6` | Brand / created-at / bank-transfer / inventory |
| Green | `0xFFE6F7F0` | `0xFF10B981` | Sell-price / completed / paid / cash / money |
| Slate | `0xFFEFF1F4` | `0xFF64748B` | Neutral / unit / draft / "other" |
| Amber | `0xFFFEF6E5` | `0xFFD97706` | Export-price / pending / partial / discount |
| Red | `0xFFFCE7E7` | `0xFFDC2626` | Cancelled / unpaid / destructive empty state |

Status mapping for order entries (mirror this for any similar status-bearing entity):

- `draft` → slate
- `pending` → amber
- `completed` → green
- `cancelled` → red
- `paid` → green / `partial` → amber / `unpaid` → red

## ⭐ Format conventions

- **Money:** `NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0)`. Use lower-case `đ`, not `₫` — matches `product_detail_screen.dart`'s `_vnd`.
- **Date (long):** `DateFormat('dd/MM/yyyy HH:mm').format(dt.toLocal())` — header / detail surfaces.
- **Date (short):** `DateFormat('dd/MM HH:mm').format(dt.toLocal())` — list-row meta.
- **Date (calendar only):** `DateFormat('dd/MM/yyyy')` — picker triggers, lot tables.
- **Plural counts:** use the existing ARB-generated method when one exists (`l.orderItemsCount(n)`). Vietnamese is no-plural so the function returns the same string for any count — that's fine.
- **Border radius:** 8 (tabs/chips), 12 (buttons/inputs/picker triggers), 18 (cards/sheets/sections — NOT 16; the 18 radius is canonical in this project), 999 (badges/pills).
- **Typography scale on detail screens:** 32 px w800 (hero metric) · 22 px w700 (product hero name) · 17 px w700 (app-bar title) · 15 px w700/w800 (row title / value) · 14 px w800 (section header inside `_CreateSection`) · 13 px w500/w600/w700 (subtitle / muted meta) · 12 px w600 (caption / variant) · 11 px w800 (badge label) · 10 px w800 (badge label "Bắt buộc").
- **`Card` widget is BANNED on content screens.** Use the rounded `surfaceElev` containers above. Material `Card` introduces a shadow that fights the flat aesthetic.

## ⭐ Pre-flight checklist before writing any UI code

1. Open the matching archetype reference file (see table above). Skim its build method.
2. Open `lib/app/theme/kuru_colors.dart`. Verify the colour tokens you intend to use exist.
3. Confirm the widget you intend to use isn't auth/glass by checking it lives under `lib/design/core/` (not `lib/design/widgets/`).
4. After every edit run `flutter analyze`. Exit 0 or the change is not done.

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
