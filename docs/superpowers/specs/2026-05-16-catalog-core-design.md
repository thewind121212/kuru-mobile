# Catalog v1 — Core Design System

**Status:** Draft, awaiting user review
**Date:** 2026-05-16
**Scope:** Build the foundation widget set that Catalog v1 (Brand + Category CRUD) — and every subsequent content module — will compose from. Visual fidelity to `../gen-barcode/fe/src/core-design/`, mobile-native interactions where the web pattern does not translate.

This spec covers the **13 reusable widgets** sitting under a new `lib/design/core/` tree. It does **not** cover Brand or Category screen wiring — those live in the Catalog v1 plan that comes next.

---

## 1. Goals and non-goals

**Goals**

- Deliver a flat, content-screen design system mirroring kuru-web's `core-design/` so Catalog, Settings, and future Home/Overview screens can be built feature-first.
- Match kuru-web visually (color tokens, border radius, padding scale, badge tones, button variants) so a user moving between web and mobile feels at the same product.
- Adapt to mobile-native interactions where the web pattern is hostile on phone: bottom sheets, action sheets, scrollable pill tabs.

**Non-goals**

- No changes to the existing auth/onboarding "glass" aesthetic (`lib/design/auth/`, `lib/design/widgets/`). Those stay.
- No Brand/Category screen wiring in this spec — that's the next plan.
- No theme switcher UI (palette/locale pickers) — Settings module owns that.
- No port of web's animation tokens (LottieIcon, Collapse, SlideUp). Future module can pull these as needed.
- No port of web's advanced inputs (CurrencyInput, MoneyInputCompact, DatePicker, RangeCalendar, QtyStepper, BarcodeListInput). Catalog v1 does not need them. POS/Product modules will pull them when they land.

---

## 2. Aesthetic direction

| Surface | Aesthetic | Rationale |
|---|---|---|
| Auth, onboarding, login, register, TOTP, create-org, org-picker | **Glass** (existing — `KGlass`, `KPrimaryBtn` shine, gradient backdrop) | Already shipped, looks portfolio-grade |
| Catalog, Settings, Home Overview, future CRUD/list screens | **Flat** (new — white card + thin border + soft shadow on press, mirrors kuru-web dashboard) | A 50-row brand list with frosted-glass per row is visually exhausting; flat is the right idiom for table/list/CRUD work |

This split mirrors what kuru-web does: `Auth.tsx` is fancy, dashboard screens are utilitarian.

---

## 3. Folder layout

```
lib/design/
├── auth/                          ← existing, untouched (glass)
├── widgets/                       ← existing, untouched (glass primitives)
└── core/                          ← NEW — flat content-screen system
    ├── layout/
    │   └── k_page_header.dart
    ├── input/
    │   ├── k_search_bar.dart
    │   ├── k_secondary_btn.dart
    │   ├── k_danger_btn.dart
    │   ├── k_icon_btn.dart
    │   └── k_tab_nav.dart
    ├── feedback/
    │   ├── k_spinner.dart
    │   ├── k_skeleton.dart
    │   ├── k_empty_state.dart
    │   └── k_badge.dart
    └── modal/
        ├── k_modal_sheet.dart       ← base bottom-sheet wrapper
        ├── k_confirm_dialog.dart    ← centered AlertDialog
        ├── k_action_sheet.dart      ← bottom action list
        ├── k_color_picker.dart
        ├── k_icon_picker.dart
        ├── color_options.dart       ← 26 colors from web's allColors
        └── icon_mapping.dart        ← curated icon name → IconData
```

`lib/design/core/catalog/` (KListRow, KCategoryCard) is reserved here but **not built in this spec** — built by the Catalog v1 plan once the response shape is concrete.

---

## 4. Mobile-specific adaptations

Three places where this spec deviates from web on purpose:

| Web pattern | Mobile pattern in this spec | Why |
|---|---|---|
| Centered modal for create/edit/picker | `showModalBottomSheet` (`KModalSheet`) | Bottom sheets are Material 3 native; keyboard appearing pushes the sheet up cleanly; less reach |
| Centered modal for confirm | `showDialog` with `AlertDialog` (`KConfirmDialog`) | Confirm needs weight, prevents miss-tap; centered is correct here |
| Inline brand rename (click → editable in row) | Tap row → open edit sheet | Inline rename on phone = keyboard hides half the screen; tap-to-sheet is unambiguous |
| 3-dot dropdown menu (`ActionMenu`, portal-positioned) | Bottom action sheet (`KActionSheet`) | Popup menus have tiny touch targets; action sheets are Material 3 idiom |
| ⌘K hint in search bar | Removed | No keyboard shortcuts on mobile |
| Tabler icons via `@tabler/icons-react` (~5000) | Tabler via `flutter_tabler_icons: ^1.43.0` (most-liked Flutter port, 104 likes on pub.dev) | Consistency with web; pub.dev has multiple Tabler packages, this one is mature. `flutter_tabler_icons` v1.43 covers the curated retail icons (bookmark, layout-grid, package, tag, store, etc.) — verify when implementing |

---

## 5. Theme tokens

**No new tokens.** `KuruColors` (in `lib/app/theme/kuru_colors.dart`) already has accent50–accent800, plus surface/border/text/danger/success/warning roles. Every widget in this spec consumes via `kuruColors(context).accent600` etc.

Mapping reference for porters reading the web Tailwind source:

| Web class | KuruColors field |
|---|---|
| `text-slate-900` / `text-white` (dark) | `textPrimary` |
| `text-slate-500` / `text-slate-400` (dark) | `textSecondary` |
| `text-slate-400` (icons, hints) | `textMuted` |
| `border-gray-200` / `border-slate-800` (dark) | `border` |
| `border-gray-100` / `border-slate-900` (dark, soft) | `borderSoft` |
| `bg-white` / `bg-slate-900` (dark) | `surfaceElev` |
| `bg-gray-50` / `bg-slate-800` (dark) — chip BG, soft fills | `surfaceHover` |
| `bg-accent-{600/700}` | `accent600` / `accent700` |
| `bg-red-{50/600}` | `dangerSoft` / `danger` |

Border radius (used as raw doubles, not tokens):
- `rounded-lg` → 8 (tabs, chips, ghost icon button bg)
- `rounded-xl` → 12 (buttons, inputs, search bar)
- `rounded-2xl` → 16 (cards, modal sheet edge)
- `rounded-full` → `BorderRadius.circular(999)` (badges, avatar circles, color swatches)

---

## 6. Widget catalog

Thirteen widgets across four categories. Each section: API signature, visual notes (porting source on web), behavior, tests.

### 6.1 Layout

#### `KPageHeader`

```dart
class KPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;   // trailing button row
}
```

Visual: 56dp fixed-height container at top of scaffold body (mobile pages typically don't have a separate web-style header bar — this sits inside the body), `surfaceElev` background, 1dp `border` bottom, padding 16dp horizontal. Title `textPrimary, 18sp, w700`. Subtitle `textMuted, 12sp, w500`. Actions row right-aligned, 12dp gap.

Port: `core-design/layout/PageHeader.tsx`. Web's `h-16` (64px) reduced to 56dp for mobile.

Tests: smoke render with + without subtitle, smoke render with 2 trailing actions.

### 6.2 Input

#### `KSearchBar`

```dart
class KSearchBar extends StatefulWidget {
  final String? hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
}
```

Visual: `rounded-xl` (12dp), `surfaceElev` BG, leading `IconSearch` (Tabler) at 18dp, trailing `IconX` clear button when text non-empty. Focused border `accent500` 1dp + ring 4dp `accent500 @ 10% alpha`. Unfocused border `border` 1dp.

Port: `core-design/input/SeachBar.tsx`. ⌘K hint dropped.

Tests: type → onChanged fires; tap X → text cleared + onChanged('') fires; focus toggles border color.

#### Button variants — `KSecondaryBtn`, `KDangerBtn`, `KIconBtn`

```dart
enum KBtnSize { sm, md, lg }

class KSecondaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final Widget? icon;
  final KBtnSize size;             // default lg
  final bool fullWidth;            // default true
}

class KDangerBtn { /* same shape */ }

class KIconBtn extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;               // default 40
  // ghost background (transparent → surfaceHover on press)
}
```

Visual (mirrors `core-design/input/CommonButton.tsx`):
- `rounded-xl` (12dp), gap 8dp icon→label.
- Secondary: 1dp `border` border, `surfaceElev` BG, `textPrimary` text. Hover → `surfaceHover` BG.
- Danger: 1dp `danger` border (alpha-blended), `surfaceElev` BG, `danger` text. Hover → `dangerSoft` BG.
- Loading: replace icon with spinning Tabler `IconLoader2` 16dp; disable taps.
- `active:scale-95` → wrap with `AnimatedScale` on pressed.
- Size scale: sm = 28h / 12sp / 14sp spinner; md = 40h / 14sp / 16sp spinner; lg = 52h / 18sp / 20sp spinner.

Note: `KPrimaryBtn` (existing, glass-aesthetic with shine animation) stays. For content screens, prefer `KSecondaryBtn` or a future flat `KPrimaryFlatBtn` if needed (not built in this spec — `KSecondaryBtn` covers the immediate need; primary CTAs on content screens can reuse `KPrimaryBtn` for now since the shine is subtle).

Tests: each variant — tap → onPressed fires; loading=true → onPressed suppressed; disabled (onPressed=null) → onPressed not called.

#### `KTabNav<T>`

```dart
class KTabItem<T> {
  final T id;
  final String label;
  final IconData? icon;
}

enum KTabSize { sm, md }

class KTabNav<T> extends StatelessWidget {
  final List<KTabItem<T>> tabs;
  final T active;
  final ValueChanged<T> onChange;
  final KTabSize size;             // default md
}
```

Visual: container `rounded-lg` (8dp), `surfaceHover` BG, 4dp internal padding. Each tab `rounded-md` (6dp) pill, 8dp gap. Active: `accent50` BG, `accent600` text/icon, shadow-sm. Inactive: transparent, `textSecondary`.

Behavior: **horizontal scrollable** (`SingleChildScrollView(scrollDirection: Axis.horizontal)`) — Category screen has 6 tabs (All + Layer 1..5) which doesn't fit a phone width. Web has both flex and grid modes; mobile uses scroll-only for simplicity.

Port: `core-design/input/TabNav.tsx`.

Tests: smoke render with 3 tabs; tap inactive tab → onChange fires with that id; ensure scrollable when 6 tabs don't fit (golden or layout test).

### 6.3 Feedback

#### `KSpinner`

```dart
class KSpinner extends StatelessWidget {
  final double size;       // default 16
  final Color? color;      // default = inherited DefaultTextStyle color
}
```

Wraps `CircularProgressIndicator` with `strokeWidth: 2` and currentColor. Web's hand-rolled SVG → Flutter's built-in is fine.

Tests: smoke render at default + size=24.

#### `KSkeleton`

```dart
class KSkeleton extends StatefulWidget {
  final double? width;
  final double? height;    // default 16
  final double radius;     // default 8
}
```

Animated pulse: `AnimationController(duration: 1.2s, repeat: reverse)` driving opacity 0.5 → 1.0 of a `surfaceHover` box. No external shimmer dep.

Helper constructors: `KSkeleton.circle(double diameter)`, `KSkeleton.text({double width})` (16dp tall, 8dp radius).

Tests: smoke render — verify `AnimationController` is disposed; `KSkeleton.circle(40)` smoke.

#### `KEmptyState`

```dart
class KEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;   // typically a KSecondaryBtn or KPrimaryBtn
}
```

Visual: centered column, 32dp gap. Icon 64dp in a 96dp `accent50` circle. Title `textPrimary, 16sp, w600`. Subtitle `textMuted, 14sp`, center-aligned, max-width 280dp. Action below with 24dp top margin.

Web has no direct equivalent (web uses ad-hoc empty UIs per screen). This is a mobile-specific consolidation.

Tests: smoke render with + without action; renders subtitle when provided.

#### `KBadge`

```dart
enum KBadgeTone { neutral, info, success, warning, danger, accent }
enum KBadgeSize { sm, md }

class KBadge extends StatelessWidget {
  final String label;
  final KBadgeTone tone;   // default neutral
  final KBadgeSize size;   // default sm
  final IconData? leadingIcon;
}
```

Visual (mirrors `core-design/badge/Badge.tsx`):
- `rounded-full`, 1dp ring-inset.
- Tone → background + text + ring color (6 combinations) from `KuruColors`:
  - neutral: `surfaceHover` BG, `textSecondary` text, `border` ring
  - info: `secondarySoft` BG, `secondary` text, `secondary @ 30%` ring
  - success: `successSoft` BG, `success` text
  - warning: `warningSoft` BG, `warning` text
  - danger: `dangerSoft` BG, `danger` text
  - accent: `accent50` BG, `accent700` text, `accent200` ring
- Size: sm = 4h pad / 11sp text, md = 6h pad / 12sp text.

Tests: smoke render each tone; renders leading icon when provided.

### 6.4 Modal layer

#### `KModalSheet` (base bottom sheet wrapper)

```dart
Future<T?> showKModalSheet<T>({
  required BuildContext context,
  required String title,
  String? subtitle,
  required WidgetBuilder builder,
  String? confirmLabel,                   // null = hide footer entirely
  String cancelLabel = 'Cancel',
  Future<bool> Function()? onConfirm,     // return true to close
  KConfirmTone confirmTone = KConfirmTone.primary,
  bool isDismissible = true,
});
```

Visual (mirrors `core-design/modal/ModalBase.tsx`):
- Sheet rounds at top 24dp (`rounded-3xl` top corners).
- Header: 16dp padding, title `textPrimary, 18sp, w700`, subtitle below 12sp `textMuted`, drag-handle indicator (4×40 `surfaceHover` pill) above header. Trailing `IconX` close.
- Body: scrollable, padding 16dp horizontal.
- Footer (only if `confirmLabel != null`): 16dp padding, 1dp `borderSoft` top, row with Cancel (`KSecondaryBtn` shrink-wrap) and Confirm (primary/danger by tone) right-aligned. Loading state during `onConfirm` shows spinner inside confirm button.
- `isScrollControlled: true` to handle keyboard.

This is the only modal API content screens use for create/edit flows.

Tests: opens, tap close → returns null; tap confirm with `onConfirm` returning true → resolves; `onConfirm` returning false keeps sheet open (e.g., validation failed); keyboard insertion pushes sheet up (manual UI test note, not unit).

#### `KConfirmDialog`

```dart
enum KConfirmTone { destructive, info }

Future<bool?> showKConfirmDialog({
  required BuildContext context,
  required String title,
  String? subtitle,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  KConfirmTone tone = KConfirmTone.destructive,
});
```

Visual (mirrors `core-design/modal/ConfirmModal.tsx`):
- Centered `AlertDialog` via `showDialog`, max-width 320dp.
- 56dp circle icon at top center: destructive = `dangerSoft` BG, `danger` `IconAlertTriangle` 24dp; info = `accent50` BG, `accent600` `IconInfoCircle`.
- Title 18sp w700 centered, subtitle 14sp `textMuted` centered.
- Buttons: Cancel (ghost text button) + Confirm. Confirm color: destructive = `danger` BG white text, info = `accent600` BG white text.

Returns `true` if confirmed, `null` if cancelled.

Tests: tap confirm → returns true; tap cancel / outside → returns null; destructive vs info tone changes icon + button color.

#### `KActionSheet`

```dart
class KActionItem<T> {
  final T id;
  final String label;
  final IconData? icon;
  final bool danger;             // default false
}

Future<T?> showKActionSheet<T>({
  required BuildContext context,
  required List<KActionItem<T>> actions,
  String? title,                  // optional sheet title
});
```

Visual: bottom sheet (uses `KModalSheet` without footer underneath), list of action rows. Each row: 52dp tall, leading icon 20dp (24dp container), label 16sp `textPrimary` (or `danger` if `danger == true`). Tap row → returns that id and closes.

Replaces web's `ActionMenu` (3-dot dropdown).

Tests: tap action → returns its id; tap outside → returns null.

#### `KColorPicker`

```dart
Future<String?> showKColorPicker({
  required BuildContext context,
  required String selected,        // color id e.g. 'red-400'
});
```

- Opens via `KModalSheet` titled "Pick color".
- Content: grid `crossAxisCount: 6`, 12dp gap, 40dp diameter circles. Selected has 4dp ring (color-matched) + scale 1.1 + `IconCheck` (Tabler) 18dp white centered.
- 26 colors from `color_options.dart`, ported from `core-design/modal/colorOptions.ts`:

```dart
// lib/design/core/modal/color_options.dart
class KColorOption {
  final String id;          // e.g. 'red-400' — matches web for round-trip
  final String label;
  final Color swatch;       // resolved Color
}

const List<KColorOption> kAllColors = [
  KColorOption(id: 'slate-400',  label: 'Slate',  swatch: Color(0xFF94A3B8)),
  KColorOption(id: 'red-400',    label: 'Red',    swatch: Color(0xFFF87171)),
  // ... 26 entries, hex values from Tailwind v3 default palette
];
```

The `id` is the persistence key (sent to BE). The swatch is resolved Color via Tailwind v3 defaults — written as literal hex so we don't pull a Tailwind palette package.

Returns the picked id, or null if dismissed.

Tests: smoke render shows 26 circles; tap → returns that id; selected id shows ring + check.

#### `KIconPicker`

```dart
Future<String?> showKIconPicker({
  required BuildContext context,
  required String selected,        // icon name e.g. 'box'
});
```

- Opens via `KModalSheet` titled "Pick icon".
- Header has inline `KSearchBar` (above the grid, not below). Empty search → show **curated retail set** (~30 icons: box, package, tag, tags, shopping-cart, shopping-bag, building-store, building-warehouse, truck, barcode, receipt, wallet, coins, credit-card, percentage, scale, ruler, palette, shirt, coffee, pizza, apple, meat, bottle, tool, device-laptop, camera, book, heart, star, layout-grid). With search query → substring-filter the same curated map (case-insensitive on name). **Full-Tabler search-all is deferred** — `flutter_tabler_icons` doesn't expose an enumerable registry; the curated map is the picker's universe in v1. If a Catalog v2 needs broader icons, we extend the curated map (cheap).
- Grid `crossAxisCount: 6`, square icon buttons 56dp, 12dp gap. Selected has `accent600` BG + white icon. Unselected has `surfaceHover` BG, `textPrimary` icon.
- Icon name (kebab-case string) is the persistence key.

`icon_mapping.dart` lookup:

```dart
// Maps stable kebab-case names → Tabler IconData
// Why keep names instead of IconData? Because BE stores names as strings.
const Map<String, IconData> kCuratedIcons = {
  'box':              TablerIcons.box,
  'package':          TablerIcons.package,
  'tag':              TablerIcons.tag,
  // ... ~30 entries
};

IconData? resolveIconName(String name) => kCuratedIcons[name];
// Search filters the same map by name substring — no global registry needed.
```

Returns the picked name, or null.

Tests: smoke render shows curated grid; typing in search filters; tap → returns name; selected name shows accent BG.

---

## 7. Dependencies

Add to `pubspec.yaml`:

```yaml
flutter_tabler_icons: ^1.43.0
```

No other new dependencies. `CircularProgressIndicator`, `AnimationController`, `AlertDialog`, `showModalBottomSheet` are all Flutter SDK.

---

## 8. Testing strategy

- **Unit + smoke widget tests for every widget** — one test file per widget, mirroring existing test pattern (`test/design/...`).
- **No goldens** — too fragile for this stage. Visual review happens manually via a sandbox screen (see below).
- **Demo / sandbox screen** — add `lib/features/demo/core_design_demo_screen.dart` (debug-only, reachable via long-press kuru logo on Login — same gesture currently used for onboarding replay), showing every widget rendered with sample data. This is the manual visual-review surface for the user and any future contributor. Route guarded by `kDebugMode`.
- **Existing widget tests** (KPrimaryBtn shine, KFormField error, etc.) untouched. New tests follow the same conventions: `pump()` × 2 instead of `pumpAndSettle()` when a widget animates (KSkeleton).

---

## 9. Implementation order

Logical build order for the plan that follows this spec:

1. `color_options.dart` + `icon_mapping.dart` (pure data, no UI dependency)
2. `KSpinner`, `KSkeleton`, `KBadge`, `KEmptyState` (feedback primitives, no other deps)
3. `KSearchBar`, `KSecondaryBtn`, `KDangerBtn`, `KIconBtn`, `KTabNav` (input primitives)
4. `KPageHeader` (composes nothing complex)
5. `KModalSheet` (composes spinner + buttons)
6. `KConfirmDialog`, `KActionSheet`, `KColorPicker`, `KIconPicker` (compose modal sheet + primitives above)
7. Demo screen (verifies everything in one place)

This bottom-up order means each widget can be merged + reviewed in isolation, and the demo screen is the natural end-of-plan verification.

---

## 10. Out of scope (deferred)

- `KListRow` (single-line list item with leading icon + title + trailing) and `KCategoryCard` (grid card with stat boxes) — built in the Catalog v1 plan when their concrete data shape is locked.
- Theme switching UI (palette picker, locale picker) — Settings module.
- Animation tokens (Collapse, SlideUp, LottieIcon) — pulled when a screen needs them.
- Advanced inputs (currency, date, range, qty, barcode list) — POS/Product modules.
- Image picker / avatar upload — added when first profile-edit screen needs it.

---

## 11. Open questions

None at write time. All defaults pulled from `../gen-barcode/fe/src/core-design/`; all mobile-specific adaptations were confirmed during brainstorming on 2026-05-16.
