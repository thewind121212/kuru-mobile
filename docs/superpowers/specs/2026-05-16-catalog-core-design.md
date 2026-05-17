# Catalog v1 — Core Design System

**Status:** Draft, awaiting user review
**Date:** 2026-05-16 (revised 2026-05-16 after code review)
**Scope:** Build the foundation widget set that Catalog v1 (Brand + Category CRUD) — and every subsequent content module — will compose from. Visual fidelity to `../gen-barcode/fe/src/core-design/`, mobile-native interactions where the web pattern does not translate.

This spec covers the **20 reusable widgets** sitting under a new `lib/design/core/` tree. It does **not** cover Brand or Category screen wiring — those live in the Catalog v1 plan that comes next.

**Revision note (2026-05-16):** Following a pre-implementation code review against the actual kuru-web Brand + Category screens, this spec was expanded from 13 → 20 widgets. The original 13 were missing the flat-aesthetic text inputs (CreateBrand/CreateCategory dialogs are unbuildable without them), the row/card primitives (web's response shapes are already locked, so deferring them was creating two design passes), and the KModalSheet / KConfirmDialog APIs were too narrow for the destructive-flow and picker-style use cases the web actually exercises. Details called out inline.

---

## 1. Goals and non-goals

**Goals**

- Deliver a flat, content-screen design system mirroring kuru-web's `core-design/` so Catalog, Settings, and future Home/Overview screens can be built feature-first.
- Match kuru-web visually (color tokens, border radius, padding scale, badge tones, button variants) so a user moving between web and mobile feels at the same product.
- Adapt to mobile-native interactions where the web pattern is hostile on phone: bottom sheets, action sheets, scrollable pill tabs.
- Cover **every primitive that CreateBrandDialog and CreateCategoryDialog compose**, so the Catalog v1 plan can be pure feature wiring.

**Non-goals**

- No changes to the existing auth/onboarding "glass" aesthetic (`lib/design/auth/`, `lib/design/widgets/`). Those stay.
- No Brand/Category screen wiring in this spec — that's the next plan.
- No theme switcher UI (palette/locale pickers) — Settings module owns that.
- No port of web's animation tokens (LottieIcon, Collapse, SlideUp). Future module can pull these as needed.
- No port of web's advanced inputs (CurrencyInput, MoneyInputCompact, DatePicker, RangeCalendar, QtyStepper, BarcodeListInput). Catalog v1 does not need them. POS/Product modules will pull them when they land.
- No nested-tree category view (`KTreeItem`) — needed by Catalog v1.1 (`/categories/:id` drilldown), not the top-level list. See §10.

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
    │   ├── k_text_field.dart         ← NEW (flat counterpart to KFormField)
    │   ├── k_textarea.dart           ← NEW
    │   ├── k_select.dart             ← NEW (button → KActionSheet)
    │   ├── k_secondary_btn.dart
    │   ├── k_danger_btn.dart
    │   ├── k_icon_btn.dart
    │   └── k_tab_nav.dart
    ├── feedback/
    │   ├── k_spinner.dart
    │   ├── k_skeleton.dart
    │   ├── k_empty_state.dart
    │   └── k_badge.dart
    ├── modal/
    │   ├── k_modal_sheet.dart        ← base bottom-sheet wrapper
    │   ├── k_confirm_dialog.dart     ← centered AlertDialog
    │   ├── k_action_sheet.dart       ← bottom action list
    │   ├── k_color_picker.dart
    │   ├── k_icon_picker.dart
    │   ├── color_options.dart        ← 26 colors from web's allColors
    │   └── icon_mapping.dart         ← curated icon name → IconData
    └── catalog/                      ← NEW — promoted from "deferred" (web shapes locked)
        ├── k_list_row.dart
        └── k_category_card.dart
```

---

## 4. Mobile-specific adaptations

Where this spec deviates from web on purpose:

| Web pattern | Mobile pattern in this spec | Why |
|---|---|---|
| Centered modal for create/edit/picker | `showModalBottomSheet` (`KModalSheet`) | Bottom sheets are Material 3 native; keyboard appearing pushes the sheet up cleanly; less reach |
| Centered modal for confirm | `showDialog` with `AlertDialog` (`KConfirmDialog`) | Confirm needs weight, prevents miss-tap; centered is correct here |
| Inline brand rename (click → editable in row) | Tap row → open edit sheet | Inline rename on phone = keyboard hides half the screen; tap-to-sheet is unambiguous |
| 3-dot dropdown menu (`ActionMenu`, portal-positioned) | Bottom action sheet (`KActionSheet`) | Popup menus have tiny touch targets; action sheets are Material 3 idiom |
| ⌘K hint in search bar | Removed | No keyboard shortcuts on mobile |
| `<Select>` dropdown (HTML-flavored) | Tap → bottom `KActionSheet` with options | Native HTML select is ugly on Flutter web/mobile; bottom sheet picker is mobile-native |
| `KSearchBar` clear button (web: small X icon) | `IconButton` with `tooltip: 'Clear'` (48dp tap target) | Material 3 minimum tap target; better a11y semantics than custom gesture |
| Both sheets dismissible only via X / backdrop | `enableDrag: true` (swipe-down dismisses) | iOS users always try the drag-down gesture |
| Tabler icons via `@tabler/icons-react` (~5000) | Tabler via `flutter_tabler_icons: ^1.43.0` (104 likes, mature) — **curated 30 icons only in v1** | Consistency with web. Full-Tabler search-all deferred: the package's symbols aren't enumerable without codegen. See KIconPicker §6.4 for the null-fallback contract |

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
| `bg-secondary-{50/700}` | `secondarySoft` / `secondary` |

Border radius (used as raw doubles, not tokens):
- `rounded-lg` → 8 (tabs, chips, ghost icon button bg)
- `rounded-xl` → 12 (buttons, inputs, search bar, list rows)
- `rounded-2xl` → 16 (cards, modal sheet edge)
- `rounded-full` → `BorderRadius.circular(999)` (badges, avatar circles, color swatches)

---

## 6. Widget catalog

Twenty widgets across five categories. Each section: API signature, visual notes (porting source on web), behavior, tests.

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

Visual: `rounded-xl` (12dp), `surfaceElev` BG, leading `IconSearch` (Tabler) at 18dp, trailing **`IconButton` with `tooltip: 'Clear'`** (48dp tap target, Material 3-compliant) when text non-empty. Focused border `accent500` 1dp + ring 4dp `accent500 @ 10% alpha`. Unfocused border `border` 1dp.

Port: `core-design/input/SeachBar.tsx`. ⌘K hint dropped. Clear button upgraded from gesture-wrapped icon → IconButton for accessibility.

Tests: type → onChanged fires; tap clear (`find.byTooltip('Clear')`) → text cleared + onChanged('') fires; focus toggles border color.

#### `KTextField`

```dart
class KTextField extends StatelessWidget {
  final String label;                  // floating label (matches web's CommonInput floatingLabel=true)
  final TextEditingController controller;
  final String? errorText;             // red border + reserved error slot underneath
  final Widget? leadingIcon;
  final String? placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;              // default false
  final bool enabled;                  // default true
  final int? maxLength;
  final Iterable<String>? autofillHints;
}
```

Visual (mirrors `core-design/input/CommonInput.tsx`): `rounded-xl` (12dp), `surfaceElev` BG, 1dp `border` border, 14dp horizontal padding, 14dp vertical padding (compact field), `textPrimary, 14sp, w500` text, `textMuted` placeholder.

Floating label: when field has focus OR text, label floats to top of field at 10sp, weight 600, `textMuted` color. When empty + unfocused, label sits inline at 14sp matching input style.

Error state (`errorText != null`): border switches to `danger` 1.5dp, label/icon to `danger` tint, 11sp `danger` text appears in a reserved animated slot below (matches existing `KFormField` pattern — see `lib/design/widgets/k_form_field.dart`).

Leading icon: 18dp `textMuted` when normal, `danger` when error, `accent500` when focused (mirrors KSearchBar focus state).

Tests: type → controller updates; `errorText` non-null → red border + error text visible below; `obscureText: true` → text rendered as dots; tap submit on keyboard → `onSubmitted` fires.

#### `KTextarea`

```dart
class KTextarea extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? errorText;
  final String? placeholder;
  final int minLines;                  // default 3
  final int maxLines;                  // default 6
  final int? maxLength;                // shows counter when set
  final bool enabled;
}
```

Visual: same chrome as KTextField but multi-line. `rounded-xl` (12dp), `surfaceElev` BG, 1dp `border` border. Floating label sits at top-left of the field. When `maxLength != null`, counter shows in bottom-right (e.g. `123/500` in `textMuted` 11sp). Same error state behavior as KTextField.

Port: `core-design/input/Textarea.tsx` (used in CreateCategoryDialog for description).

Tests: type → controller updates; respects `minLines` / `maxLines`; counter visible when `maxLength` set; error state.

#### `KSelect<T>`

```dart
class KSelectOption<T> {
  final T value;
  final String label;
  final IconData? icon;
}

class KSelect<T> extends StatelessWidget {
  final String label;                       // floating label
  final T? value;
  final List<KSelectOption<T>> options;
  final ValueChanged<T> onChanged;
  final String? errorText;
  final String? placeholder;                // shown when value is null
  final bool enabled;
}
```

Visual: same chrome as KTextField (looks like a text input). Trailing chevron icon (`TablerIcons.chevron_down`) 18dp `textMuted` indicates it's a picker, not a free-text field.

Behavior: tap → opens `KActionSheet` with the options. Selected option's label fills the field display. If `value` is null, shows `placeholder` (or empty) in `textMuted`.

Port: `core-design/input/Select.tsx` (used in CreateCategoryDialog ×2 — parent category, status). Mobile-native: HTML-style `<select>` is awful; tap-to-sheet is the idiomatic phone pattern.

Tests: shows placeholder when `value == null`; shows selected label when value set; tap → action sheet opens with all options; choosing an option fires `onChanged`.

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
  final double size;               // default 48 (Material 3 min tap target)
  // ghost background (transparent → surfaceHover on press)
}
```

Visual (mirrors `core-design/input/CommonButton.tsx`):
- `rounded-xl` (12dp), gap 8dp icon→label.
- Secondary: 1dp `border` border, `surfaceElev` BG, `textPrimary` text. Hover → `surfaceHover` BG.
- Danger: 1dp `danger @ 30% alpha` border, `surfaceElev` BG, `danger` text. Hover → `dangerSoft` BG.
- Loading: replace icon with `KSpinner` 16dp; disable taps.
- `active:scale-95` → wrap with `AnimatedScale` on pressed.
- Size scale: sm = 28h / 12sp; md = 40h / 14sp; lg = 52h / 14sp.

Note: `KPrimaryBtn` (existing, glass-aesthetic with shine animation) stays. For content screens, prefer `KSecondaryBtn`. Primary CTAs on content screens can reuse `KPrimaryBtn` (shine is subtle enough) until a future flat `KPrimaryFlatBtn` is needed.

`KIconBtn` default size **48dp** (was 40dp pre-review) — Material 3 minimum tap target. A smaller visible icon (20dp) inside a 48dp tap zone is fine; ship the 48dp default.

Tests: each variant — tap → onPressed fires; loading=true → onPressed suppressed; disabled (onPressed=null) → onPressed not called.

#### `KTabNav<T>`

```dart
class KTabItem<T> {
  final T id;
  final String label;
  final IconData? icon;
}

enum KTabSize { sm, md }
enum KTabVariant { labels, iconOnly }  // labels = web's default; iconOnly = view-mode toggle (grid/list)

class KTabNav<T> extends StatelessWidget {
  final List<KTabItem<T>> tabs;
  final T active;
  final ValueChanged<T> onChange;
  final KTabSize size;             // default md
  final KTabVariant variant;       // default labels
}
```

Visual: container `rounded-lg` (8dp), `surfaceHover` BG, 4dp internal padding. Each tab `rounded-md` (6dp) pill, 8dp gap. Active: `accent50` BG, `accent600` text/icon, shadow-sm. Inactive: transparent, `textSecondary`.

`KTabVariant.iconOnly`: hides label, shows only the icon (each tab requires `icon != null`). Used for the **grid/list view-mode toggle** on the Category screen (web: `MainCategory.tsx:346-371`).

Behavior: **horizontal scrollable** (`SingleChildScrollView(scrollDirection: Axis.horizontal)`) — Category screen has 6 tabs (All + Layer 1..5) which doesn't fit a phone width. Web has both flex and grid modes; mobile uses scroll-only for simplicity.

Port: `core-design/input/TabNav.tsx` + the inline grid/list toggle pattern from MainCategory.

Tests: smoke render with 3 tabs; tap inactive tab → onChange fires with that id; scrollable when 6 tabs don't fit; `iconOnly` variant renders icons without text.

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

Helper constructors: `KSkeleton.circle(double diameter)`.

Tests: smoke render; `KSkeleton.circle(40)` smoke; verify `AnimationController` is disposed.

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

Web has no shared empty-state component (web uses an ad-hoc `bg-gray-50 rounded-xl border-2 border-dashed` box per screen). This is a deliberate mobile upgrade — single shared widget, more substantial empty state because mobile screens are smaller and the empty state takes more visual weight.

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
  - success: `successSoft` BG, `success` text, `success @ 30%` ring
  - warning: `warningSoft` BG, `warning` text, `warning @ 30%` ring
  - danger: `dangerSoft` BG, `danger` text, `danger @ 30%` ring
  - accent: `accent50` BG, `accent700` text, `accent200` ring
- Size: sm = 8h / 2v pad / 11sp text; md = 10h / 4v pad / 12sp text.

Two use-cases for `tone: danger + leadingIcon: TablerIcons.alert_triangle`:
- Inline list-row "Low stock" warning (web `MainCategoryList.tsx:88`).
- Generic status callouts.

Tests: smoke render each tone; renders leading icon when provided.

### 6.4 Modal layer

#### `KModalSheet` (base bottom sheet wrapper)

```dart
enum KConfirmTone { primary, danger }

Future<T?> showKModalSheet<T>({
  required BuildContext context,
  required String title,
  String? subtitle,
  required WidgetBuilder builder,
  String? confirmLabel,                   // null = hide entire footer
  String cancelLabel = 'Cancel',
  Future<bool> Function()? onConfirm,     // return true to close
  KConfirmTone confirmTone = KConfirmTone.primary,
  bool isDismissible = true,
  bool enableDrag = true,                 // iOS swipe-down dismiss
  // ── added after code review ──
  bool disableConfirm = false,            // confirm button shows but is disabled (form invalid)
  bool showCancel = true,                 // pickers can hide cancel ("Done" only)
  Widget? loadingBody,                    // shown in place of builder() while initial data fetches
});
```

Visual (mirrors `core-design/modal/ModalBase.tsx`):
- Sheet rounds at top 24dp (`rounded-3xl` top corners).
- Header: 16dp padding, title `textPrimary, 18sp, w700`, subtitle below 12sp `textMuted`, drag-handle indicator (4×40 `surfaceHover` pill) above header. Trailing `IconButton` with `tooltip: 'Close'` (`TablerIcons.x`, 48dp tap target).
- Body: scrollable, padding 16dp horizontal, 16dp vertical. If `loadingBody != null`, render that instead of `builder()` (used for edit sheets while fetching the row by id).
- Footer (only if `confirmLabel != null`): 16dp padding, 1dp `borderSoft` top, row with Cancel (`KSecondaryBtn` `size: md, fullWidth: false`) — hidden when `showCancel: false` — and Confirm (primary/danger by tone) right-aligned. Confirm shows `KSpinner` during `onConfirm`. Confirm disabled (50% opacity, no tap) when `disableConfirm: true`.
- `isScrollControlled: true` to handle keyboard.

Why the API breadth: web's ModalBase exposes `disableConfirm`, `hideFooter`, `showCancelButton`, `isLoadingComponent` + `loadingComponent`. Catalog v1 actually uses all of them:
- `disableConfirm` — CreateBrandDialog's Save button is disabled until form is valid (Yup error state).
- `showCancel: false` — KColorPicker and KIconPicker sheets show only "Done", no Cancel.
- `loadingBody` — Edit-brand flow fetches the brand by id; sheet shows a spinner where the form would be.
- `enableDrag: true` — iOS users drag down to dismiss.

This is the only modal API content screens use for create/edit flows.

Tests: opens, tap close → returns null; tap confirm with `onConfirm` returning true → resolves; `onConfirm` returning false keeps sheet open; `disableConfirm: true` → tap confirm does nothing; `showCancel: false` → no Cancel button rendered; `loadingBody` non-null → builder() output not in tree.

#### `KConfirmDialog`

```dart
enum KConfirmDialogTone { destructive, info }

Future<bool?> showKConfirmDialog({
  required BuildContext context,
  required String title,
  String? subtitle,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  KConfirmDialogTone tone = KConfirmDialogTone.destructive,
  // ── added after code review ──
  Future<void> Function()? onConfirm,    // if set, dialog stays open + spins until future resolves
});
```

(Renamed enum from `KConfirmTone` → `KConfirmDialogTone` to avoid collision with `KConfirmTone` declared in KModalSheet — two different concepts: sheet's tone is "what color is the confirm button (primary/danger)", dialog's tone is "what's the icon + button color theme (destructive/info)".)

Visual (mirrors `core-design/modal/ConfirmModal.tsx`):
- Centered `AlertDialog` via `showDialog`, max-width 320dp.
- 56dp circle icon at top center: destructive = `dangerSoft` BG, `danger` `IconAlertTriangle` 24dp; info = `accent50` BG, `accent600` `IconInfoCircle`.
- Title 18sp w700 centered, subtitle 14sp `textMuted` centered.
- Buttons: Cancel (`KSecondaryBtn size: md`) + Confirm. Confirm color: destructive = `danger` BG white text, info = `accent600` BG white text.

Behavior:
- Without `onConfirm`: tap Confirm → resolves `true` and closes; tap Cancel → resolves `null` and closes. (Caller handles the async delete itself.)
- With `onConfirm`: tap Confirm → confirm button shows `KSpinner`, dialog stays open + barrier-non-dismissible until the future resolves. On success, dialog closes and resolves `true`. On exception, dialog closes and resolves `null` (caller surfaces error toast). This matches web's `ConfirmModal isLoading={isDeleting}` pattern.

Tests: tap Confirm → returns true; tap Cancel / outside → returns null; destructive vs info tone changes icon; `onConfirm` provided → confirm button shows spinner during await; `onConfirm` throws → dialog closes with null.

#### `KActionSheet`

```dart
class KActionItem<T> {
  final T id;
  final String label;
  final IconData? icon;
  final bool danger;             // default false
  final bool enabled;            // default true — disabled items render at 40% opacity, untap­pable
}

Future<T?> showKActionSheet<T>({
  required BuildContext context,
  required List<KActionItem<T>> actions,
  String? title,                  // optional sheet title
  bool enableDrag = true,
});
```

Visual: bottom sheet (uses `KModalSheet` chrome without footer underneath), list of action rows. Each row: 52dp tall, leading icon 20dp, label 16sp `textPrimary` (or `danger` if `danger == true`). Tap row → returns that id and closes. Disabled rows: 40% opacity, no tap response.

The `enabled: false` flag is the lightweight mobile equivalent of web's `<PermissionGate>` — a Catalog v1 feature can compute permission per action and pass `enabled: hasPermission` rather than the action sheet having to know about auth. See §10 for the broader `KPermissionGate` deferral note.

Replaces web's `ActionMenu` (3-dot dropdown).

Tests: tap enabled action → returns its id; tap disabled action → no return; tap outside / drag down → returns null.

#### `KColorPicker`

```dart
Future<String?> showKColorPicker({
  required BuildContext context,
  required String selected,        // color id e.g. 'red-400'
});
```

- Opens via `KModalSheet` titled "Pick color" (with `showCancel: false`, `confirmLabel: 'Done'`).
- Header strip in body: 14sp `textMuted` "Selected: <label>" where `<label>` is the swatch's `KColorOption.label` (e.g. "Selected: Red"). Updates as the user taps swatches.
- Content: grid `crossAxisCount: 6`, 12dp gap, 40dp diameter circles. Selected has 4dp **ring with 2dp gap** between swatch and ring (using a 48dp outer transparent container with `Border.all(width: 4, color: swatch)` around a 40dp inner swatch box) + scale 1.1 + `IconCheck` (Tabler) 18dp white centered.
- 26 colors from `color_options.dart`, ported from `core-design/modal/colorOptions.ts`.

```dart
// lib/design/core/modal/color_options.dart
class KColorOption {
  final String id;          // e.g. 'red-400' — matches web for round-trip
  final String label;
  final Color swatch;       // resolved Color
}

const List<KColorOption> kAllColors = [
  KColorOption(id: 'slate-400', label: 'Slate', swatch: Color(0xFF94A3B8)),
  KColorOption(id: 'red-400',   label: 'Red',   swatch: Color(0xFFF87171)),
  // ... 26 entries, hex values from Tailwind v3 default palette
];
```

The `id` is the persistence key (sent to BE). The swatch is resolved Color via Tailwind v3 defaults — written as literal hex so we don't pull a Tailwind palette package.

Returns the picked id, or null if dismissed.

Tests: smoke render shows 26 circles; tap → returns that id; selected id shows ring + check; "Selected: <label>" updates on tap before user taps Done.

#### `KIconPicker`

```dart
Future<String?> showKIconPicker({
  required BuildContext context,
  required String selected,        // icon name e.g. 'box'
});
```

- Opens via `KModalSheet` titled "Pick icon" (with `showCancel: false`, `confirmLabel: 'Done'`).
- Header has inline `KSearchBar` (above the grid). Empty search → show **curated retail set** (~30 icons: box, package, tag, tags, shopping-cart, shopping-bag, building-store, building-warehouse, truck, barcode, receipt, wallet, coins, credit-card, percentage, scale, ruler, palette, shirt, coffee, pizza, apple, meat, bottle, tool, device-laptop, camera, book, heart, star, layout-grid). With search query → substring-filter the same curated map (case-insensitive on name).
- Grid `crossAxisCount: 6`, square icon buttons 56dp, 12dp gap. Selected has `accent600` BG + white icon. Unselected has `surfaceHover` BG, `textPrimary` icon.
- Icon name (kebab-case string) is the persistence key.

**Null-resolution fallback contract (important):** `resolveIconName(String)` returns `null` for any name not in the curated map. **Every consumer must handle null with a fallback** — typically `TablerIcons.layout_grid`. The two places this matters in Catalog v1:
- `KListRow` / `KCategoryCard` rendering a category icon: if BE stores `'unknown-icon'` (because user picked it on web from the broader Tabler set), mobile renders `TablerIcons.layout_grid` instead of crashing. Web has the same fallback (`MainCategoryList.tsx:46`, `MainCategoryCard.tsx:46`).
- `KIconPicker` opening with `selected: 'unknown-icon'`: the picker shows no selection ring (since the icon isn't in the grid), but the grid renders normally.

Why curated-only in v1: `flutter_tabler_icons` exposes ~5000 icons as `static const IconData` declarations, with no enumerable registry. To support full-Tabler search would require a codegen pass (read the package's `lib/*.dart` files, regex-extract const names, generate a `Map<String, IconData>`). That's a follow-up task (`Catalog v1.1` or earlier if someone needs it). For v1, web users picking an uncurated icon will see the fallback on mobile — explicit trade-off, not a bug.

```dart
// Maps stable kebab-case names → Tabler IconData
const Map<String, IconData> kCuratedIcons = {
  'box':              TablerIcons.box,
  'package':          TablerIcons.package,
  'tag':              TablerIcons.tag,
  // ... 30 entries
};

IconData? resolveIconName(String name) => kCuratedIcons[name];
// Consumers fall back to TablerIcons.layout_grid when null.
```

Returns the picked name, or null if dismissed.

Tests: smoke render shows curated grid; typing "shop" filters to 2 results; tap → returns name; selected name shows accent BG; selected name not in curated map → no ring (no crash).

### 6.5 Catalog (promoted from "deferred")

The response shapes for `BrandOverviewItem` and `CategoryResponse` are stable on web — building these primitives in this spec means the Catalog v1 plan is pure screen wiring rather than two design passes.

#### `KListRow`

```dart
class KListRow extends StatelessWidget {
  final Widget leading;              // 40dp container — typically a colored circle with category icon
  final String title;
  final String? subtitle;
  final Widget? trailing;            // typically KIconBtn for 3-dot menu, or a small KSecondaryBtn pill
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
}
```

Visual: row container `rounded-xl` (12dp), `surfaceElev` BG, 1dp `border`, 12dp padding, 16dp horizontal gap between leading/title/trailing. Title `textPrimary, 14sp, w600`. Subtitle `textMuted, 12sp`. Hover/press → `accent300 / accent500` border (mirrors web's `MainBrand.tsx:80` brand row hover).

Used for: brand list row (icon + name + 3-dot menu), category list row in list-view mode, and any future "single-line item with leading icon + action" pattern.

Tests: tap → onTap fires; long-press → onLongPress fires; renders trailing when provided.

#### `KCategoryCard`

```dart
class KCategoryCardStat {
  final String label;     // e.g. "Items"
  final String value;     // e.g. "15"
}

class KCategoryCard extends StatelessWidget {
  final IconData icon;                 // resolved via resolveIconName + fallback
  final Color iconBg;                  // resolved via resolveColor + fallback
  final String name;
  final List<KCategoryCardStat> stats;       // typically 2 stat boxes (items + value)
  final Widget? lowStockBadge;         // typically a KBadge with tone: danger
  final Widget? trailingAction;        // typically a small "Filter products" KSecondaryBtn-style pill
  final Widget? menu;                  // typically a KIconBtn for 3-dot menu
  final VoidCallback? onTap;
}
```

Visual (mirrors `core-design/card/main-category-card/MainCategoryCard.tsx`):
- Card `rounded-xl` (12dp), `surfaceElev` BG, 1dp `border`, 12dp padding.
- Top row: 32dp circle icon container (`iconBg` background, white icon, 2dp ring-offset on white/dark BG) + name + menu right-aligned.
- Middle: 2-column grid of stat boxes (`surfaceHover` BG, 8dp pad, label 12sp `textMuted` + value 14sp `textPrimary, w500`).
- Bottom row: lowStockBadge left-aligned + trailingAction right-aligned.

Used for: category grid view. Brand grid view is not on the web roadmap; if it lands later, this card structure ports over.

Tests: smoke render with 2 stats + low-stock badge + menu; tap → onTap fires; renders without optional pieces (no badge, no trailing action).

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
- **Demo / sandbox screen** — add `lib/features/demo/core_design_demo_screen.dart` (debug-only, reachable via double-tap kuru logo on Login — long-press is already taken by onboarding replay), showing every widget rendered with sample data. Route guarded by `kDebugMode`.
- **Pumping rule:** never call `pumpAndSettle()` when a widget with continuous animation is in the frame (KSpinner, KSkeleton — both run forever). Use `pump()` then `pump(Duration(milliseconds: N))` to step microtasks. This is critical for KModalSheet / KConfirmDialog `onConfirm` tests where a brief spinner state lives during the awaited future.
- **Existing widget tests** (KPrimaryBtn shine, KFormField error, etc.) untouched.

---

## 9. Implementation order

Logical build order for the plan that follows this spec:

1. **Setup:** Add `flutter_tabler_icons` to pubspec.
2. **Data files:** `color_options.dart`, `icon_mapping.dart` (no UI deps).
3. **Feedback primitives:** KSpinner, KSkeleton, KBadge, KEmptyState (leaf widgets).
4. **Input primitives:** KSearchBar, KSecondaryBtn, KDangerBtn, KIconBtn, KTabNav, KTextField, KTextarea (no modal deps).
5. **Layout:** KPageHeader.
6. **Modal layer:** KModalSheet (composes spinner + KSecondaryBtn).
7. **Modal layer 2:** KActionSheet (composes KModalSheet chrome).
8. **KSelect** (composes KActionSheet — must come after KActionSheet).
9. **Modal layer 3:** KConfirmDialog, KColorPicker, KIconPicker (compose modal sheet + primitives above).
10. **Catalog primitives:** KListRow, KCategoryCard (compose KBadge + KIconBtn).
11. **Demo screen** — verifies everything in one place.

This bottom-up order means each widget can be merged + reviewed in isolation, and the demo screen is the natural end-of-plan verification.

---

## 10. Out of scope (deferred to future modules)

- **`KPermissionGate`** — web wraps Create/Edit/Delete actions in `<PermissionGate>`. Mobile equivalent: Catalog v1 feature code computes permission per action (via Riverpod provider) and passes `enabled: hasPermission` to `KActionItem` / hides `KPageHeader.actions` items. A first-class `KPermissionGate` wrapper widget may emerge once Settings + Catalog both have permission gating; defer until the second feature needs it.
- **`KTreeItem`** — nested category drilldown at `/categories/:rootCategoryId` is Catalog v1.1, not v1. Web uses `CategoryTree` with auto-open paths, animated chevron, depth indent, max-layer enforcement. Will need a tree primitive; expect a new widget spec when v1.1 lands.
- **`KCollapsibleGuide`** — web's 4-step "category guide" hint with dismiss-and-remember. Pure decoration; defer to Catalog v1.1 or a "first-run hints" follow-up plan.
- **Full-Tabler icon search** — see §6.4 KIconPicker. Either a codegen pass or a manually-curated extension of `kCuratedIcons`. Defer until first user complains about a missing icon.
- Theme switching UI (palette picker, locale picker) — Settings module.
- Animation tokens (Collapse, SlideUp, LottieIcon) — pulled when a screen needs them.
- Advanced inputs (currency, date, range, qty, barcode list) — POS/Product modules.
- Image picker / avatar upload — added when first profile-edit screen needs it.

---

## 11. Open questions

None at write time. All defaults pulled from `../gen-barcode/fe/src/core-design/` and the Brand/Category screens. All mobile-specific adaptations and API extensions were confirmed during brainstorming + post-review revision on 2026-05-16.
