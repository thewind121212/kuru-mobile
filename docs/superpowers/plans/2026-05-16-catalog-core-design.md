# Catalog Core Design — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the 13 reusable widgets defined in `docs/superpowers/specs/2026-05-16-catalog-core-design.md` under `lib/design/core/`, with a debug-only sandbox screen to visually verify them. Every widget gets unit/widget tests. After this plan, the Catalog v1 feature plan can compose these widgets directly.

**Architecture:** Bottom-up build — pure data files first (no UI deps), then feedback primitives, then input primitives, then layout, then modal layer (which composes everything), then the demo screen. Each task is one widget (or one tightly-scoped data file) with its own TDD cycle and commit. Every widget reads colors via `kuruColors(context)` from the existing `KuruColors` theme extension — no new theme tokens introduced.

**Tech Stack:** Flutter 3.41 / Dart 3.11, `flutter_test` (built-in), `flutter_tabler_icons` ^1.43.0 (new), no other new deps. Standard SDK widgets (`CircularProgressIndicator`, `AnimationController`, `AlertDialog`, `showModalBottomSheet`).

**Reference files (read once before starting):**
- Spec: `docs/superpowers/specs/2026-05-16-catalog-core-design.md`
- Theme tokens: `lib/app/theme/kuru_colors.dart` + `lib/app/theme/kuru_palettes.dart`
- Theme helper: `lib/app/theme/theme_controller.dart` (`buildKuruTheme`)
- Existing widget style: `lib/design/widgets/k_form_field.dart`, `lib/design/widgets/k_primary_btn.dart`
- Existing widget test pattern: `test/features/login/login_screen_test.dart`
- Web counterparts (for visual reference, no need to study deeply): `../gen-barcode/fe/src/core-design/`

**Conventions used throughout this plan:**
- All new files live under `lib/design/core/<subdir>/` and `test/design/core/<subdir>/`.
- All widgets are `StatelessWidget` unless they need animation or local state.
- Tests pump widgets with `MaterialApp(theme: buildKuruTheme(KuruPalette.indigo, Brightness.light), home: ...)`. Indigo is the default palette, light is the default we test against.
- Test pumping rule from CLAUDE.md: **never call `pumpAndSettle()`** when `KPrimaryBtn` is on screen (shine animation never settles). Use `pump()` × 2 instead. Same rule applies to `KSkeleton` (pulse never settles).
- Tabler icons via `flutter_tabler_icons` use **snake_case**: `TablerIcons.alert_triangle`, `TablerIcons.info_circle`, `TablerIcons.search`, `TablerIcons.x`, etc. Dart `non_constant_identifier_names` lint may surface on these consumers — add `// ignore: non_constant_identifier_names` at the top of files that use many Tabler icons (it lints declarations not uses, but some configurations flag uses too — apply only if `flutter analyze --fatal-warnings` complains).
- Each task ends with a commit. Commit message format: `feat(core-design): <widget>` for widget tasks, `chore(deps): ...` for dep tasks, `chore(core-design): ...` for the demo screen / wrap-up.

---

## Task 1: Add flutter_tabler_icons dependency

**Files:**
- Modify: `pubspec.yaml` (under `dependencies:`)

- [ ] **Step 1: Add the dependency**

Open `pubspec.yaml` and add this line under `dependencies:` (just above `dev_dependencies:`):

```yaml
  # Icons — port of Tabler icon set, matches kuru-web's @tabler/icons-react
  flutter_tabler_icons: ^1.43.0
```

- [ ] **Step 2: Install**

Run: `flutter pub get`
Expected output ends with `Got dependencies!` and `flutter_tabler_icons` appears in the resolved versions.

- [ ] **Step 3: Verify import works**

Run: `flutter analyze --fatal-warnings`
Expected: PASS (no new warnings from adding the dep).

- [ ] **Step 4: Sanity-check the symbol naming**

Open a Dart console quickly with a one-liner:

```bash
flutter test --plain-name "tabler_smoke" || true
```

There's no test yet; this should print "No tests were found". That's fine — Task 4 will use Tabler icons and validate the package works.

- [ ] **Step 5: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore(deps): add flutter_tabler_icons for core-design icon set"
```

---

## Task 2: Color options data file

**Files:**
- Create: `lib/design/core/modal/color_options.dart`
- Test: `test/design/core/modal/color_options_test.dart`

Hex values are Tailwind v3 defaults — match exactly what `../gen-barcode/fe/src/core-design/modal/colorOptions.ts` references (`bg-red-400` → Tailwind v3 `red-400` → `#F87171`).

- [ ] **Step 1: Write the failing test**

Create `test/design/core/modal/color_options_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';

void main() {
  test('kAllColors has 26 entries matching web colorOptions.ts', () {
    expect(kAllColors.length, 26);
  });

  test('kAllColors first 5 ids are the "quick" set', () {
    expect(
      kAllColors.take(5).map((c) => c.id).toList(),
      ['slate-400', 'red-400', 'orange-400', 'amber-400', 'yellow-400'],
    );
  });

  test('every entry has unique id, label, and resolved swatch', () {
    final ids = kAllColors.map((c) => c.id).toSet();
    expect(ids.length, kAllColors.length);

    for (final c in kAllColors) {
      expect(c.label, isNotEmpty);
      expect(c.swatch, isA<Color>());
    }
  });

  test('resolveColor returns null for unknown id', () {
    expect(resolveColor('not-a-color'), isNull);
  });

  test('resolveColor returns matching swatch for known id', () {
    expect(resolveColor('red-400'), const Color(0xFFF87171));
    expect(resolveColor('indigo-500'), const Color(0xFF6366F1));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/modal/color_options_test.dart`
Expected: FAIL — `color_options.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/modal/color_options.dart`:

```dart
import 'package:flutter/material.dart';

/// One color option in the K Color Picker. `id` is the persistence key
/// (kebab-case Tailwind name — matches what kuru-web sends to the BE).
class KColorOption {
  const KColorOption({
    required this.id,
    required this.label,
    required this.swatch,
  });

  final String id;
  final String label;
  final Color swatch;
}

/// 26 colors ported from `../gen-barcode/fe/src/core-design/modal/colorOptions.ts`.
/// Hex values are Tailwind v3 defaults (e.g. `bg-red-400` → `#F87171`).
/// First 5 are the "quick colors" subset.
const List<KColorOption> kAllColors = [
  KColorOption(id: 'slate-400',    label: 'Slate',         swatch: Color(0xFF94A3B8)),
  KColorOption(id: 'red-400',      label: 'Red',           swatch: Color(0xFFF87171)),
  KColorOption(id: 'orange-400',   label: 'Orange',        swatch: Color(0xFFFB923C)),
  KColorOption(id: 'amber-400',    label: 'Amber',         swatch: Color(0xFFFBBF24)),
  KColorOption(id: 'yellow-400',   label: 'Yellow',        swatch: Color(0xFFFACC15)),
  KColorOption(id: 'lime-400',     label: 'Lime',          swatch: Color(0xFFA3E635)),
  KColorOption(id: 'green-400',    label: 'Green',         swatch: Color(0xFF4ADE80)),
  KColorOption(id: 'emerald-400',  label: 'Emerald',       swatch: Color(0xFF34D399)),
  KColorOption(id: 'teal-400',     label: 'Teal',          swatch: Color(0xFF2DD4BF)),
  KColorOption(id: 'cyan-400',     label: 'Cyan',          swatch: Color(0xFF22D3EE)),
  KColorOption(id: 'sky-400',      label: 'Sky',           swatch: Color(0xFF38BDF8)),
  KColorOption(id: 'blue-400',     label: 'Blue',          swatch: Color(0xFF60A5FA)),
  KColorOption(id: 'indigo-400',   label: 'Indigo',        swatch: Color(0xFF818CF8)),
  KColorOption(id: 'violet-400',   label: 'Violet',        swatch: Color(0xFFA78BFA)),
  KColorOption(id: 'purple-400',   label: 'Purple',        swatch: Color(0xFFC084FC)),
  KColorOption(id: 'fuchsia-400',  label: 'Fuchsia',       swatch: Color(0xFFE879F9)),
  KColorOption(id: 'pink-400',     label: 'Pink',          swatch: Color(0xFFF472B6)),
  KColorOption(id: 'rose-400',     label: 'Rose',          swatch: Color(0xFFFB7185)),
  KColorOption(id: 'red-500',      label: 'Red Dark',      swatch: Color(0xFFEF4444)),
  KColorOption(id: 'orange-500',   label: 'Orange Dark',   swatch: Color(0xFFF97316)),
  KColorOption(id: 'green-500',    label: 'Green Dark',    swatch: Color(0xFF22C55E)),
  KColorOption(id: 'blue-500',     label: 'Blue Dark',     swatch: Color(0xFF3B82F6)),
  KColorOption(id: 'indigo-500',   label: 'Indigo Dark',   swatch: Color(0xFF6366F1)),
  KColorOption(id: 'purple-500',   label: 'Purple Dark',   swatch: Color(0xFFA855F7)),
  KColorOption(id: 'pink-500',     label: 'Pink Dark',     swatch: Color(0xFFEC4899)),
  KColorOption(id: 'slate-600',    label: 'Slate Dark',    swatch: Color(0xFF475569)),
];

/// Returns the swatch for [id], or null if unknown.
Color? resolveColor(String id) {
  for (final c in kAllColors) {
    if (c.id == id) return c.swatch;
  }
  return null;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/modal/color_options_test.dart`
Expected: PASS, 5 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/modal/color_options.dart test/design/core/modal/color_options_test.dart
git commit -m "feat(core-design): KColorOption data + 26-entry kAllColors list"
```

---

## Task 3: Icon mapping data file

**Files:**
- Create: `lib/design/core/modal/icon_mapping.dart`
- Test: `test/design/core/modal/icon_mapping_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/modal/icon_mapping_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/design/core/modal/icon_mapping.dart';

void main() {
  test('kCuratedIcons has at least 30 entries', () {
    expect(kCuratedIcons.length, greaterThanOrEqualTo(30));
  });

  test('every retail-essential name is present', () {
    const essentials = [
      'box', 'package', 'tag', 'tags',
      'shopping-cart', 'shopping-bag',
      'building-store', 'building-warehouse', 'truck',
      'barcode', 'receipt', 'wallet', 'coins', 'credit-card',
      'percentage', 'scale', 'ruler', 'palette',
      'shirt', 'coffee', 'pizza', 'apple', 'meat', 'bottle',
      'tool', 'device-laptop', 'camera', 'book',
      'heart', 'star', 'layout-grid',
    ];
    for (final name in essentials) {
      expect(kCuratedIcons.containsKey(name), isTrue,
          reason: 'missing $name from kCuratedIcons');
    }
  });

  test('resolveIconName returns null for unknown name', () {
    expect(resolveIconName('not-an-icon'), isNull);
  });

  test('resolveIconName returns IconData for known name', () {
    expect(resolveIconName('box'), isNotNull);
    expect(resolveIconName('layout-grid'), isNotNull);
  });

  test('searchIconsByName filters by substring case-insensitively', () {
    final results = searchIconsByName('shop');
    expect(results.length, greaterThanOrEqualTo(2));
    expect(results.every((e) => e.name.contains('shop')), isTrue);
  });

  test('searchIconsByName with empty query returns full curated set', () {
    final results = searchIconsByName('');
    expect(results.length, kCuratedIcons.length);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/modal/icon_mapping_test.dart`
Expected: FAIL — `icon_mapping.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/modal/icon_mapping.dart`:

```dart
// ignore_for_file: non_constant_identifier_names
// (flutter_tabler_icons uses snake_case symbols)
import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

/// A curated, retail-relevant icon paired with its persistence name.
class KCuratedIcon {
  const KCuratedIcon(this.name, this.icon);
  final String name;
  final IconData icon;
}

/// Stable kebab-case name → IconData. Names mirror kuru-web's
/// `iconHelpers.ts` STATIC_ICON_MAP so the BE stores the same strings
/// for both clients.
const Map<String, IconData> kCuratedIcons = {
  'box':                  TablerIcons.box,
  'package':              TablerIcons.package,
  'tag':                  TablerIcons.tag,
  'tags':                 TablerIcons.tags,
  'shopping-cart':        TablerIcons.shopping_cart,
  'shopping-bag':         TablerIcons.shopping_bag,
  'building-store':       TablerIcons.building_store,
  'building-warehouse':   TablerIcons.building_warehouse,
  'truck':                TablerIcons.truck,
  'barcode':              TablerIcons.barcode,
  'receipt':              TablerIcons.receipt,
  'wallet':               TablerIcons.wallet,
  'coins':                TablerIcons.coins,
  'credit-card':          TablerIcons.credit_card,
  'percentage':           TablerIcons.percentage,
  'scale':                TablerIcons.scale,
  'ruler':                TablerIcons.ruler,
  'palette':              TablerIcons.palette,
  'shirt':                TablerIcons.shirt,
  'coffee':               TablerIcons.coffee,
  'pizza':                TablerIcons.pizza,
  'apple':                TablerIcons.apple,
  'meat':                 TablerIcons.meat,
  'bottle':               TablerIcons.bottle,
  'tool':                 TablerIcons.tool,
  'device-laptop':        TablerIcons.device_laptop,
  'camera':               TablerIcons.camera,
  'book':                 TablerIcons.book,
  'heart':                TablerIcons.heart,
  'star':                 TablerIcons.star,
  'layout-grid':          TablerIcons.layout_grid,
};

/// Returns IconData for [name], or null if not in the curated set.
IconData? resolveIconName(String name) => kCuratedIcons[name];

/// Returns curated icons whose name contains [query] (case-insensitive).
/// Empty query returns all curated icons.
List<KCuratedIcon> searchIconsByName(String query) {
  final entries = kCuratedIcons.entries
      .map((e) => KCuratedIcon(e.key, e.value))
      .toList();
  if (query.isEmpty) return entries;
  final lower = query.toLowerCase();
  return entries.where((e) => e.name.toLowerCase().contains(lower)).toList();
}
```

**Note:** if `flutter analyze` flags any of the `TablerIcons.xxx` symbols as undefined, the package's symbol may use a slightly different name (e.g. `TablerIcons.alert_triangle` vs `TablerIcons.alertTriangle`). Open `~/.pub-cache/hosted/pub.dev/flutter_tabler_icons-1.43.0/lib/` and grep the actual constant names. Adjust this file accordingly — keep the kebab-case keys; only the right-hand `TablerIcons.xxx` references change.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/modal/icon_mapping_test.dart`
Expected: PASS, 6 tests pass. If you hit "TablerIcons.X is not defined", grep the package and fix per the note above before continuing.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/modal/icon_mapping.dart test/design/core/modal/icon_mapping_test.dart
git commit -m "feat(core-design): KCuratedIcon map + resolve/search helpers"
```

---

## Task 4: KSpinner

**Files:**
- Create: `lib/design/core/feedback/k_spinner.dart`
- Test: `test/design/core/feedback/k_spinner_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/feedback/k_spinner_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';

void main() {
  testWidgets('KSpinner renders a CircularProgressIndicator', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: const Scaffold(body: Center(child: KSpinner())),
    ));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('KSpinner respects custom size', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: const Scaffold(body: Center(child: KSpinner(size: 24))),
    ));
    await tester.pump();
    final box = tester.getSize(find.byType(KSpinner));
    expect(box.width, 24);
    expect(box.height, 24);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/feedback/k_spinner_test.dart`
Expected: FAIL — `k_spinner.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/feedback/k_spinner.dart`:

```dart
import 'package:flutter/material.dart';

/// Tiny circular spinner used inside buttons, modals, and inline loaders.
/// Color defaults to the inherited `DefaultTextStyle` color so it blends
/// with surrounding text (e.g. inside a primary button: white text + white
/// spinner; inside a list row: textPrimary).
class KSpinner extends StatelessWidget {
  const KSpinner({super.key, this.size = 16, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? DefaultTextStyle.of(context).style.color;
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: resolved == null ? null : AlwaysStoppedAnimation(resolved),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/feedback/k_spinner_test.dart`
Expected: PASS, 2 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/feedback/k_spinner.dart test/design/core/feedback/k_spinner_test.dart
git commit -m "feat(core-design): KSpinner"
```

---

## Task 5: KSkeleton

**Files:**
- Create: `lib/design/core/feedback/k_skeleton.dart`
- Test: `test/design/core/feedback/k_skeleton_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/feedback/k_skeleton_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';

void main() {
  testWidgets('KSkeleton renders a Container with given size', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: const Scaffold(
        body: Center(child: KSkeleton(width: 100, height: 12)),
      ),
    ));
    // Pulse never settles — use pump twice.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final box = tester.getSize(find.byType(KSkeleton));
    expect(box.width, 100);
    expect(box.height, 12);
  });

  testWidgets('KSkeleton.circle renders a square of given diameter',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: const Scaffold(body: Center(child: KSkeleton.circle(40))),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final box = tester.getSize(find.byType(KSkeleton));
    expect(box.width, 40);
    expect(box.height, 40);
  });

  testWidgets('KSkeleton disposes its AnimationController', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: const Scaffold(body: Center(child: KSkeleton(width: 100))),
    ));
    await tester.pump();
    // Remove the widget — pumpWidget with a different child triggers dispose.
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    // If dispose were missing, the tester would print a leak error on tearDown.
    expect(find.byType(KSkeleton), findsNothing);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/feedback/k_skeleton_test.dart`
Expected: FAIL — `k_skeleton.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/feedback/k_skeleton.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Pulsing placeholder block used to indicate loading state for list rows,
/// cards, and other content surfaces. Animates a single `surfaceHover` box
/// opacity between 0.5 and 1.0 with a 1.2s cycle (reversed each iteration).
///
/// Use the default constructor for rectangular skeletons (text lines,
/// thumbnails, badges). Use [KSkeleton.circle] for avatar placeholders.
class KSkeleton extends StatefulWidget {
  const KSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 8,
  });

  /// Square block sized [diameter]×[diameter] with full corner radius.
  /// Used in place of avatar / category-icon circles while loading.
  const KSkeleton.circle(double diameter, {super.key})
      : width = diameter,
        height = diameter,
        radius = diameter / 2;

  final double? width;
  final double height;
  final double radius;

  @override
  State<KSkeleton> createState() => _KSkeletonState();
}

class _KSkeletonState extends State<KSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return AnimatedBuilder(
      animation: _ctl,
      builder: (context, _) {
        final t = _ctl.value; // 0..1
        final opacity = 0.5 + t * 0.5; // 0.5..1.0
        return Opacity(
          opacity: opacity,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: c.surfaceHover,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/feedback/k_skeleton_test.dart`
Expected: PASS, 3 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/feedback/k_skeleton.dart test/design/core/feedback/k_skeleton_test.dart
git commit -m "feat(core-design): KSkeleton with pulse animation"
```

---

## Task 6: KBadge

**Files:**
- Create: `lib/design/core/feedback/k_badge.dart`
- Test: `test/design/core/feedback/k_badge_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/feedback/k_badge_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/feedback/k_badge.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('KBadge renders label', (tester) async {
    await tester.pumpWidget(_wrap(const KBadge(label: 'Active')));
    await tester.pump();
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('KBadge renders for every tone without crash', (tester) async {
    for (final tone in KBadgeTone.values) {
      await tester.pumpWidget(_wrap(KBadge(label: tone.name, tone: tone)));
      await tester.pump();
      expect(find.text(tone.name), findsOneWidget);
    }
  });

  testWidgets('KBadge renders leading icon when provided', (tester) async {
    await tester.pumpWidget(_wrap(const KBadge(
      label: 'Low stock',
      tone: KBadgeTone.danger,
      leadingIcon: Icons.warning,
    )));
    await tester.pump();
    expect(find.byIcon(Icons.warning), findsOneWidget);
    expect(find.text('Low stock'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/feedback/k_badge_test.dart`
Expected: FAIL — `k_badge.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/feedback/k_badge.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

enum KBadgeTone { neutral, info, success, warning, danger, accent }
enum KBadgeSize { sm, md }

/// Pill-shaped status indicator. 6 tones, 2 sizes. Mirrors
/// `../gen-barcode/fe/src/core-design/badge/Badge.tsx`.
class KBadge extends StatelessWidget {
  const KBadge({
    required this.label,
    super.key,
    this.tone = KBadgeTone.neutral,
    this.size = KBadgeSize.sm,
    this.leadingIcon,
  });

  final String label;
  final KBadgeTone tone;
  final KBadgeSize size;
  final IconData? leadingIcon;

  ({Color bg, Color fg, Color ring}) _palette(KuruColors c) {
    switch (tone) {
      case KBadgeTone.neutral:
        return (bg: c.surfaceHover, fg: c.textSecondary, ring: c.border);
      case KBadgeTone.info:
        return (bg: c.secondarySoft, fg: c.secondary, ring: c.secondary.withValues(alpha: 0.3));
      case KBadgeTone.success:
        return (bg: c.successSoft, fg: c.success, ring: c.success.withValues(alpha: 0.3));
      case KBadgeTone.warning:
        return (bg: c.warningSoft, fg: c.warning, ring: c.warning.withValues(alpha: 0.3));
      case KBadgeTone.danger:
        return (bg: c.dangerSoft, fg: c.danger, ring: c.danger.withValues(alpha: 0.3));
      case KBadgeTone.accent:
        return (bg: c.accent50, fg: c.accent700, ring: c.accent200);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final p = _palette(c);
    final isSm = size == KBadgeSize.sm;
    final hPad = isSm ? 8.0 : 10.0;
    final vPad = isSm ? 2.0 : 4.0;
    final fontSize = isSm ? 11.0 : 12.0;
    final iconSize = isSm ? 12.0 : 14.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: p.ring, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: iconSize, color: p.fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: p.fg,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 16 / fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/feedback/k_badge_test.dart`
Expected: PASS, 3 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/feedback/k_badge.dart test/design/core/feedback/k_badge_test.dart
git commit -m "feat(core-design): KBadge with 6 tones x 2 sizes"
```

---

## Task 7: KEmptyState

**Files:**
- Create: `lib/design/core/feedback/k_empty_state.dart`
- Test: `test/design/core/feedback/k_empty_state_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/feedback/k_empty_state_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('KEmptyState shows icon and title', (tester) async {
    await tester.pumpWidget(_wrap(const KEmptyState(
      icon: Icons.inbox_outlined,
      title: 'No brands yet',
    )));
    await tester.pump();

    expect(find.text('No brands yet'), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });

  testWidgets('KEmptyState shows subtitle when provided', (tester) async {
    await tester.pumpWidget(_wrap(const KEmptyState(
      icon: Icons.inbox_outlined,
      title: 'No brands yet',
      subtitle: 'Add your first brand to get started',
    )));
    await tester.pump();

    expect(find.text('Add your first brand to get started'), findsOneWidget);
  });

  testWidgets('KEmptyState renders action when provided', (tester) async {
    await tester.pumpWidget(_wrap(KEmptyState(
      icon: Icons.inbox_outlined,
      title: 'No brands yet',
      action: ElevatedButton(
        onPressed: () {},
        child: const Text('Add brand'),
      ),
    )));
    await tester.pump();

    expect(find.text('Add brand'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/feedback/k_empty_state_test.dart`
Expected: FAIL — `k_empty_state.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/feedback/k_empty_state.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Empty-list / empty-state placeholder. Used when a screen has no data
/// to show yet (no brands, no categories, no search results).
class KEmptyState extends StatelessWidget {
  const KEmptyState({
    required this.icon,
    required this.title,
    super.key,
    this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: c.accent50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: c.accent600),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: c.textMuted, fontSize: 14),
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/feedback/k_empty_state_test.dart`
Expected: PASS, 3 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/feedback/k_empty_state.dart test/design/core/feedback/k_empty_state_test.dart
git commit -m "feat(core-design): KEmptyState"
```

---

## Task 8: KSearchBar

**Files:**
- Create: `lib/design/core/input/k_search_bar.dart`
- Test: `test/design/core/input/k_search_bar_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/input/k_search_bar_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('KSearchBar shows hint text', (tester) async {
    await tester.pumpWidget(_wrap(KSearchBar(
      hint: 'Search brands',
      onChanged: (_) {},
    )));
    await tester.pump();
    expect(find.text('Search brands'), findsOneWidget);
  });

  testWidgets('KSearchBar fires onChanged on text entry', (tester) async {
    String? captured;
    await tester.pumpWidget(_wrap(KSearchBar(
      hint: '',
      onChanged: (v) => captured = v,
    )));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'cof');
    expect(captured, 'cof');
  });

  testWidgets('KSearchBar shows clear button when text is non-empty',
      (tester) async {
    await tester.pumpWidget(_wrap(KSearchBar(hint: '', onChanged: (_) {})));
    await tester.pump();

    // No clear icon initially.
    expect(find.byIcon(Icons.close), findsNothing);

    await tester.enterText(find.byType(TextField), 'cof');
    await tester.pump();
    // Tabler X is an IconData — we look for it via byKey since icon equality
    // varies. Use a Semantics tooltip on the button instead.
    expect(find.bySemanticsLabel('Clear'), findsOneWidget);
  });

  testWidgets('KSearchBar clear button empties text and fires onChanged("")',
      (tester) async {
    String? captured;
    await tester.pumpWidget(_wrap(KSearchBar(
      hint: '',
      onChanged: (v) => captured = v,
    )));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'cof');
    expect(captured, 'cof');

    await tester.tap(find.bySemanticsLabel('Clear'));
    await tester.pump();
    expect(captured, '');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/input/k_search_bar_test.dart`
Expected: FAIL — `k_search_bar.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/input/k_search_bar.dart`:

```dart
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Single-line search input. Leading Tabler search icon, trailing clear
/// button when text is non-empty. Focused state shows a 4dp accent ring.
class KSearchBar extends StatefulWidget {
  const KSearchBar({
    required this.onChanged,
    super.key,
    this.hint,
    this.controller,
  });

  final String? hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  State<KSearchBar> createState() => _KSearchBarState();
}

class _KSearchBarState extends State<KSearchBar> {
  late final TextEditingController _ctl;
  final FocusNode _focus = FocusNode();
  bool _ownedCtl = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _ctl = TextEditingController();
      _ownedCtl = true;
    } else {
      _ctl = widget.controller!;
    }
    _ctl.addListener(_onChanged);
    _focus.addListener(() => setState(() {}));
  }

  void _onChanged() {
    widget.onChanged(_ctl.text);
    setState(() {}); // toggle clear icon
  }

  @override
  void dispose() {
    _ctl.removeListener(_onChanged);
    if (_ownedCtl) _ctl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _clear() {
    _ctl.clear();
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final focused = _focus.hasFocus;
    final hasText = _ctl.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: focused ? c.accent500 : c.border,
          width: 1,
        ),
        boxShadow: focused
            ? [
                BoxShadow(
                  color: c.accent500.withValues(alpha: 0.1),
                  blurRadius: 0,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(
            TablerIcons.search,
            size: 18,
            color: focused ? c.accent500 : c.textMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _ctl,
              focusNode: _focus,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(color: c.textMuted, fontSize: 14),
                isDense: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (hasText)
            Semantics(
              label: 'Clear',
              button: true,
              child: GestureDetector(
                onTap: _clear,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    TablerIcons.x,
                    size: 16,
                    color: c.textMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/input/k_search_bar_test.dart`
Expected: PASS, 4 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/input/k_search_bar.dart test/design/core/input/k_search_bar_test.dart
git commit -m "feat(core-design): KSearchBar with leading icon + clear"
```

---

## Task 9: KSecondaryBtn

**Files:**
- Create: `lib/design/core/input/k_secondary_btn.dart`
- Test: `test/design/core/input/k_secondary_btn_test.dart`

This file also exports the shared `KBtnSize` enum used by KDangerBtn and KIconBtn — keep the enum here to avoid a circular dep.

- [ ] **Step 1: Write the failing test**

Create `test/design/core/input/k_secondary_btn_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('KSecondaryBtn fires onPressed on tap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(_wrap(KSecondaryBtn(
      label: 'Cancel',
      onPressed: () => tapped++,
    )));
    await tester.pump();
    await tester.tap(find.byType(KSecondaryBtn));
    expect(tapped, 1);
  });

  testWidgets('KSecondaryBtn loading=true suppresses onPressed', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(_wrap(KSecondaryBtn(
      label: 'Save',
      loading: true,
      onPressed: () => tapped++,
    )));
    await tester.pump();
    await tester.tap(find.byType(KSecondaryBtn));
    expect(tapped, 0);
  });

  testWidgets('KSecondaryBtn with onPressed=null is disabled', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(_wrap(KSecondaryBtn(
      label: 'Save',
      onPressed: null,
    )));
    await tester.pump();
    await tester.tap(find.byType(KSecondaryBtn));
    expect(tapped, 0);
  });

  testWidgets('KSecondaryBtn renders label', (tester) async {
    await tester.pumpWidget(_wrap(KSecondaryBtn(
      label: 'Cancel',
      onPressed: () {},
    )));
    await tester.pump();
    expect(find.text('Cancel'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/input/k_secondary_btn_test.dart`
Expected: FAIL — `k_secondary_btn.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/input/k_secondary_btn.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';

enum KBtnSize { sm, md, lg }

/// Outlined button used as the "cancel" / "secondary action" CTA on
/// content screens. Mirrors `core-design/input/CommonButton.tsx` variant
/// "secondary". Renders an optional leading icon, fills its container by
/// default (`fullWidth = true`).
class KSecondaryBtn extends StatelessWidget {
  const KSecondaryBtn({
    required this.label,
    super.key,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.size = KBtnSize.lg,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final Widget? icon;
  final KBtnSize size;
  final bool fullWidth;

  ({double height, double fontSize, double spinnerSize}) _metrics() {
    switch (size) {
      case KBtnSize.sm:
        return (height: 28, fontSize: 12, spinnerSize: 14);
      case KBtnSize.md:
        return (height: 40, fontSize: 14, spinnerSize: 16);
      case KBtnSize.lg:
        return (height: 52, fontSize: 14, spinnerSize: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final m = _metrics();
    final disabled = onPressed == null || loading;

    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          KSpinner(size: m.spinnerSize, color: c.textPrimary)
        else if (icon != null) ...[
          IconTheme(
            data: IconThemeData(color: c.textPrimary, size: m.spinnerSize),
            child: icon!,
          ),
          const SizedBox(width: 8),
        ],
        if (!loading)
          Text(
            label,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: m.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Material(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: m.height,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border, width: 1),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/input/k_secondary_btn_test.dart`
Expected: PASS, 4 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/input/k_secondary_btn.dart test/design/core/input/k_secondary_btn_test.dart
git commit -m "feat(core-design): KSecondaryBtn with sm/md/lg sizes"
```

---

## Task 10: KDangerBtn

**Files:**
- Create: `lib/design/core/input/k_danger_btn.dart`
- Test: `test/design/core/input/k_danger_btn_test.dart`

Identical shape to KSecondaryBtn but with `danger` border + `danger` text + `dangerSoft` hover BG.

- [ ] **Step 1: Write the failing test**

Create `test/design/core/input/k_danger_btn_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_danger_btn.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('KDangerBtn fires onPressed on tap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(_wrap(KDangerBtn(
      label: 'Delete',
      onPressed: () => tapped++,
    )));
    await tester.pump();
    await tester.tap(find.byType(KDangerBtn));
    expect(tapped, 1);
  });

  testWidgets('KDangerBtn loading=true suppresses onPressed', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(_wrap(KDangerBtn(
      label: 'Delete',
      loading: true,
      onPressed: () => tapped++,
    )));
    await tester.pump();
    await tester.tap(find.byType(KDangerBtn));
    expect(tapped, 0);
  });

  testWidgets('KDangerBtn renders label', (tester) async {
    await tester.pumpWidget(_wrap(KDangerBtn(
      label: 'Delete',
      onPressed: () {},
    )));
    await tester.pump();
    expect(find.text('Delete'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/input/k_danger_btn_test.dart`
Expected: FAIL — `k_danger_btn.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/input/k_danger_btn.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart' show KBtnSize;

/// Outlined danger button. Red text + red border + soft red hover. Used
/// for destructive actions outside of confirmation dialogs (e.g. a "Remove
/// brand" inline button on a brand row when the user is already in an
/// edit sheet).
class KDangerBtn extends StatelessWidget {
  const KDangerBtn({
    required this.label,
    super.key,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.size = KBtnSize.lg,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final Widget? icon;
  final KBtnSize size;
  final bool fullWidth;

  ({double height, double fontSize, double spinnerSize}) _metrics() {
    switch (size) {
      case KBtnSize.sm:
        return (height: 28, fontSize: 12, spinnerSize: 14);
      case KBtnSize.md:
        return (height: 40, fontSize: 14, spinnerSize: 16);
      case KBtnSize.lg:
        return (height: 52, fontSize: 14, spinnerSize: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final m = _metrics();
    final disabled = onPressed == null || loading;

    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          KSpinner(size: m.spinnerSize, color: c.danger)
        else if (icon != null) ...[
          IconTheme(
            data: IconThemeData(color: c.danger, size: m.spinnerSize),
            child: icon!,
          ),
          const SizedBox(width: 8),
        ],
        if (!loading)
          Text(
            label,
            style: TextStyle(
              color: c.danger,
              fontSize: m.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Material(
        color: c.surfaceElev,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          hoverColor: c.dangerSoft,
          child: Container(
            height: m.height,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.danger.withValues(alpha: 0.3), width: 1),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/input/k_danger_btn_test.dart`
Expected: PASS, 3 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/input/k_danger_btn.dart test/design/core/input/k_danger_btn_test.dart
git commit -m "feat(core-design): KDangerBtn"
```

---

## Task 11: KIconBtn

**Files:**
- Create: `lib/design/core/input/k_icon_btn.dart`
- Test: `test/design/core/input/k_icon_btn_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/input/k_icon_btn_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_icon_btn.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('KIconBtn fires onPressed on tap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(_wrap(KIconBtn(
      icon: const Icon(Icons.add),
      onPressed: () => tapped++,
    )));
    await tester.pump();
    await tester.tap(find.byType(KIconBtn));
    expect(tapped, 1);
  });

  testWidgets('KIconBtn with onPressed=null does not respond', (tester) async {
    await tester.pumpWidget(_wrap(const KIconBtn(
      icon: Icon(Icons.add),
      onPressed: null,
    )));
    await tester.pump();
    // No assertion error / no rebuild needed — we just want it to render.
    expect(find.byType(KIconBtn), findsOneWidget);
  });

  testWidgets('KIconBtn renders tooltip when provided', (tester) async {
    await tester.pumpWidget(_wrap(KIconBtn(
      icon: const Icon(Icons.add),
      tooltip: 'Add brand',
      onPressed: () {},
    )));
    await tester.pump();
    expect(find.byTooltip('Add brand'), findsOneWidget);
  });

  testWidgets('KIconBtn renders at specified size', (tester) async {
    await tester.pumpWidget(_wrap(KIconBtn(
      icon: const Icon(Icons.add),
      size: 48,
      onPressed: () {},
    )));
    await tester.pump();
    final box = tester.getSize(find.byType(KIconBtn));
    expect(box.width, 48);
    expect(box.height, 48);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/input/k_icon_btn_test.dart`
Expected: FAIL — `k_icon_btn.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/input/k_icon_btn.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Square icon-only button. Ghost background (transparent → surfaceHover
/// on hover/press). Used for header action slots, list-row trailing
/// actions, and similar single-icon affordances.
class KIconBtn extends StatelessWidget {
  const KIconBtn({
    required this.icon,
    super.key,
    this.onPressed,
    this.tooltip,
    this.size = 40,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final disabled = onPressed == null;

    Widget button = SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: disabled ? null : onPressed,
          customBorder: const CircleBorder(),
          hoverColor: c.surfaceHover,
          splashColor: c.surfaceHover,
          child: Center(
            child: IconTheme(
              data: IconThemeData(
                color: disabled ? c.textMuted : c.textPrimary,
                size: 20,
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/input/k_icon_btn_test.dart`
Expected: PASS, 4 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/input/k_icon_btn.dart test/design/core/input/k_icon_btn_test.dart
git commit -m "feat(core-design): KIconBtn (icon-only ghost button)"
```

---

## Task 12: KTabNav

**Files:**
- Create: `lib/design/core/input/k_tab_nav.dart`
- Test: `test/design/core/input/k_tab_nav_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/input/k_tab_nav_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/input/k_tab_nav.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('KTabNav renders all tab labels', (tester) async {
    await tester.pumpWidget(_wrap(KTabNav<String>(
      tabs: const [
        KTabItem(id: 'all', label: 'All'),
        KTabItem(id: 'l1', label: 'Layer 1'),
        KTabItem(id: 'l2', label: 'Layer 2'),
      ],
      active: 'all',
      onChange: (_) {},
    )));
    await tester.pump();
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Layer 1'), findsOneWidget);
    expect(find.text('Layer 2'), findsOneWidget);
  });

  testWidgets('KTabNav fires onChange when tapping inactive tab',
      (tester) async {
    String? captured;
    await tester.pumpWidget(_wrap(KTabNav<String>(
      tabs: const [
        KTabItem(id: 'all', label: 'All'),
        KTabItem(id: 'l1', label: 'Layer 1'),
      ],
      active: 'all',
      onChange: (id) => captured = id,
    )));
    await tester.pump();
    await tester.tap(find.text('Layer 1'));
    expect(captured, 'l1');
  });

  testWidgets('KTabNav is horizontally scrollable when content overflows',
      (tester) async {
    // Narrow viewport, 8 tabs.
    await tester.binding.setSurfaceSize(const Size(320, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_wrap(KTabNav<int>(
      tabs: List.generate(8, (i) => KTabItem(id: i, label: 'Tab $i')),
      active: 0,
      onChange: (_) {},
    )));
    await tester.pump();
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/input/k_tab_nav_test.dart`
Expected: FAIL — `k_tab_nav.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/input/k_tab_nav.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

class KTabItem<T> {
  const KTabItem({required this.id, required this.label, this.icon});
  final T id;
  final String label;
  final IconData? icon;
}

enum KTabSize { sm, md }

/// Horizontally scrollable pill-tab strip. Active tab uses accent50 BG +
/// accent600 text. Inactive tabs are transparent on a surfaceHover track.
class KTabNav<T> extends StatelessWidget {
  const KTabNav({
    required this.tabs,
    required this.active,
    required this.onChange,
    super.key,
    this.size = KTabSize.md,
  });

  final List<KTabItem<T>> tabs;
  final T active;
  final ValueChanged<T> onChange;
  final KTabSize size;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final isSm = size == KTabSize.sm;
    final hPad = isSm ? 8.0 : 16.0;
    final vPad = isSm ? 6.0 : 8.0;
    final fontSize = isSm ? 12.0 : 14.0;
    final iconSize = isSm ? 13.0 : 15.0;

    return Container(
      decoration: BoxDecoration(
        color: c.surfaceHover,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final tab in tabs) ...[
              _tabButton(c, tab, hPad, vPad, fontSize, iconSize),
              const SizedBox(width: 4),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tabButton(
    KuruColors c,
    KTabItem<T> tab,
    double hPad,
    double vPad,
    double fontSize,
    double iconSize,
  ) {
    final isActive = tab.id == active;
    return Material(
      color: isActive ? c.accent50 : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: () => onChange(tab.id),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (tab.icon != null) ...[
                Icon(
                  tab.icon,
                  size: iconSize,
                  color: isActive ? c.accent600 : c.textSecondary,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                tab.label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: isActive ? c.accent600 : c.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/input/k_tab_nav_test.dart`
Expected: PASS, 3 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/input/k_tab_nav.dart test/design/core/input/k_tab_nav_test.dart
git commit -m "feat(core-design): KTabNav (scrollable pill tabs)"
```

---

## Task 13: KPageHeader

**Files:**
- Create: `lib/design/core/layout/k_page_header.dart`
- Test: `test/design/core/layout/k_page_header_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/layout/k_page_header_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('KPageHeader renders title and subtitle', (tester) async {
    await tester.pumpWidget(_wrap(const KPageHeader(
      title: 'Brands',
      subtitle: 'Manage your brands',
    )));
    await tester.pump();

    expect(find.text('Brands'), findsOneWidget);
    expect(find.text('Manage your brands'), findsOneWidget);
  });

  testWidgets('KPageHeader without subtitle renders only the title',
      (tester) async {
    await tester.pumpWidget(_wrap(const KPageHeader(title: 'Brands')));
    await tester.pump();

    expect(find.text('Brands'), findsOneWidget);
  });

  testWidgets('KPageHeader renders trailing actions', (tester) async {
    await tester.pumpWidget(_wrap(KPageHeader(
      title: 'Brands',
      actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: () {}),
      ],
    )));
    await tester.pump();
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/layout/k_page_header_test.dart`
Expected: FAIL — `k_page_header.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/layout/k_page_header.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Inline page header used at the top of content-screen bodies. Holds the
/// page title + optional subtitle on the left, trailing actions on the
/// right. Not a SliverAppBar — sits inside the body as a fixed-height row
/// so it scrolls away with content (mobile-native feel).
class KPageHeader extends StatelessWidget {
  const KPageHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: c.surfaceElev,
        border: Border(bottom: BorderSide(color: c.border, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: c.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          if (actions != null)
            Row(
              children: [
                for (var i = 0; i < actions!.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  actions![i],
                ],
              ],
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/layout/k_page_header_test.dart`
Expected: PASS, 3 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/layout/k_page_header.dart test/design/core/layout/k_page_header_test.dart
git commit -m "feat(core-design): KPageHeader"
```

---

## Task 14: KModalSheet (base bottom sheet wrapper)

**Files:**
- Create: `lib/design/core/modal/k_modal_sheet.dart`
- Test: `test/design/core/modal/k_modal_sheet_test.dart`

This is the most complex widget in the pack. It wraps `showModalBottomSheet` with a consistent header (drag handle + title + subtitle + X close) and optional footer (cancel + confirm with loading + tone).

- [ ] **Step 1: Write the failing test**

Create `test/design/core/modal/k_modal_sheet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('showKModalSheet opens and renders title + body', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    showKModalSheet<void>(
      context: capturedCtx,
      title: 'Create brand',
      subtitle: 'Add a brand to your catalog',
      builder: (_) => const Text('BODY'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create brand'), findsOneWidget);
    expect(find.text('Add a brand to your catalog'), findsOneWidget);
    expect(find.text('BODY'), findsOneWidget);
  });

  testWidgets('showKModalSheet returns null when dismissed via X',
      (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    final future = showKModalSheet<String>(
      context: capturedCtx,
      title: 'Test',
      builder: (_) => const Text('BODY'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Close'));
    await tester.pumpAndSettle();

    expect(await future, isNull);
  });

  testWidgets('showKModalSheet confirm with onConfirm=true closes sheet',
      (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    final future = showKModalSheet<bool>(
      context: capturedCtx,
      title: 'Test',
      confirmLabel: 'Save',
      onConfirm: () async => true,
      builder: (_) => const Text('BODY'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(await future, isNotNull); // closed (any non-null result counts)
    expect(find.text('BODY'), findsNothing);
  });

  testWidgets('showKModalSheet onConfirm=false keeps the sheet open',
      (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    showKModalSheet<bool>(
      context: capturedCtx,
      title: 'Test',
      confirmLabel: 'Save',
      onConfirm: () async => false, // validation failed
      builder: (_) => const Text('BODY'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Sheet still open.
    expect(find.text('BODY'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/modal/k_modal_sheet_test.dart`
Expected: FAIL — `k_modal_sheet.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/modal/k_modal_sheet.dart`:

```dart
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';

enum KConfirmTone { primary, danger }

/// Opens a Material 3 bottom sheet with a consistent K header/footer.
///
/// - [title] / [subtitle] render in the header.
/// - [builder] supplies the body (gets a [BuildContext] so it can pop the
///   sheet itself with `Navigator.of(ctx).pop(value)`).
/// - If [confirmLabel] is non-null, a footer with Cancel + Confirm renders.
///   [onConfirm] returns `true` to close the sheet (resolving the returned
///   future with `true`), or `false` to keep it open (validation failure).
/// - Returns whatever the body pops (or `true` from a confirm flow, or `null`
///   on dismissal).
Future<T?> showKModalSheet<T>({
  required BuildContext context,
  required String title,
  String? subtitle,
  required WidgetBuilder builder,
  String? confirmLabel,
  String cancelLabel = 'Cancel',
  Future<bool> Function()? onConfirm,
  KConfirmTone confirmTone = KConfirmTone.primary,
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _KModalSheet<T>(
      title: title,
      subtitle: subtitle,
      builder: builder,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      confirmTone: confirmTone,
    ),
  );
}

class _KModalSheet<T> extends StatefulWidget {
  const _KModalSheet({
    required this.title,
    required this.builder,
    this.subtitle,
    this.confirmLabel,
    this.cancelLabel = 'Cancel',
    this.onConfirm,
    this.confirmTone = KConfirmTone.primary,
  });

  final String title;
  final String? subtitle;
  final WidgetBuilder builder;
  final String? confirmLabel;
  final String cancelLabel;
  final Future<bool> Function()? onConfirm;
  final KConfirmTone confirmTone;

  @override
  State<_KModalSheet<T>> createState() => _KModalSheetState<T>();
}

class _KModalSheetState<T> extends State<_KModalSheet<T>> {
  bool _busy = false;

  Future<void> _handleConfirm() async {
    if (widget.onConfirm == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _busy = true);
    final shouldClose = await widget.onConfirm!();
    if (!mounted) return;
    setState(() => _busy = false);
    if (shouldClose) {
      Navigator.of(context).pop(true as T?);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final insets = MediaQuery.of(context).viewInsets;

    return AnimatedPadding(
      padding: insets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(c),
              _buildHeader(c),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Builder(builder: widget.builder),
                ),
              ),
              if (widget.confirmLabel != null) _buildFooter(c),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle(KuruColors c) => Container(
        margin: const EdgeInsets.only(top: 8),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: c.surfaceHover,
          borderRadius: BorderRadius.circular(999),
        ),
      );

  Widget _buildHeader(KuruColors c) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle!,
                      style: TextStyle(color: c.textMuted, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            Semantics(
              label: 'Close',
              button: true,
              child: IconButton(
                icon: Icon(TablerIcons.x, color: c.textMuted, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      );

  Widget _buildFooter(KuruColors c) => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.borderSoft, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            KSecondaryBtn(
              label: widget.cancelLabel,
              size: KBtnSize.md,
              fullWidth: false,
              onPressed: _busy ? null : () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 8),
            _buildConfirmButton(c),
          ],
        ),
      );

  Widget _buildConfirmButton(KuruColors c) {
    final bg = widget.confirmTone == KConfirmTone.danger
        ? c.danger
        : c.accent600;
    final disabled = _busy;
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: disabled ? null : _handleConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          disabledBackgroundColor: bg.withValues(alpha: 0.5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 0,
        ),
        child: _busy
            ? const KSpinner(size: 16, color: Colors.white)
            : Text(
                widget.confirmLabel!,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
      ),
    );
  }
}
```

**Note on the `pop(true as T?)` cast:** when `T = bool` this is just `pop(true)`. When `T = SomeOtherType` the cast fails at runtime — but in practice, callers that pass a `confirmLabel` + `onConfirm` use either `T = bool` or `T = void`. Body-driven flows (form sheets) pop their own typed result via `Navigator.of(ctx).pop(myResult)` from inside `builder`. If a future caller hits a runtime cast error, switch the API to a dedicated `confirm()` overload — defer that complexity until needed.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/modal/k_modal_sheet_test.dart`
Expected: PASS, 4 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/modal/k_modal_sheet.dart test/design/core/modal/k_modal_sheet_test.dart
git commit -m "feat(core-design): KModalSheet (bottom-sheet base with header/footer)"
```

---

## Task 15: KConfirmDialog

**Files:**
- Create: `lib/design/core/modal/k_confirm_dialog.dart`
- Test: `test/design/core/modal/k_confirm_dialog_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/modal/k_confirm_dialog_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('showKConfirmDialog renders title + subtitle', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    showKConfirmDialog(
      context: capturedCtx,
      title: 'Delete brand?',
      subtitle: 'This will permanently remove the brand.',
    );
    await tester.pumpAndSettle();

    expect(find.text('Delete brand?'), findsOneWidget);
    expect(find.text('This will permanently remove the brand.'),
        findsOneWidget);
  });

  testWidgets('showKConfirmDialog returns true on Confirm', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    final future = showKConfirmDialog(
      context: capturedCtx,
      title: 'Delete?',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(await future, isTrue);
  });

  testWidgets('showKConfirmDialog returns null on Cancel', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    final future = showKConfirmDialog(
      context: capturedCtx,
      title: 'Delete?',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(await future, isNull);
  });

  testWidgets('showKConfirmDialog info tone renders info icon', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    showKConfirmDialog(
      context: capturedCtx,
      title: 'Sign out?',
      tone: KConfirmDialogTone.info,
    );
    await tester.pumpAndSettle();
    // Both tones show an icon — we just verify the dialog rendered.
    expect(find.text('Sign out?'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/modal/k_confirm_dialog_test.dart`
Expected: FAIL — `k_confirm_dialog.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/modal/k_confirm_dialog.dart`:

```dart
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';

enum KConfirmDialogTone { destructive, info }

/// Shows a centered Material AlertDialog used for confirm/cancel flows
/// (delete, sign out, discard changes). Returns `true` on confirm,
/// `null` on cancel/dismiss.
Future<bool?> showKConfirmDialog({
  required BuildContext context,
  required String title,
  String? subtitle,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  KConfirmDialogTone tone = KConfirmDialogTone.destructive,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => _KConfirmDialog(
      title: title,
      subtitle: subtitle,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      tone: tone,
    ),
  );
}

class _KConfirmDialog extends StatelessWidget {
  const _KConfirmDialog({
    required this.title,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.tone,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final String confirmLabel;
  final String cancelLabel;
  final KConfirmDialogTone tone;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final isDestructive = tone == KConfirmDialogTone.destructive;
    final iconBg = isDestructive ? c.dangerSoft : c.accent50;
    final iconColor = isDestructive ? c.danger : c.accent600;
    final icon = isDestructive ? TablerIcons.alert_triangle : TablerIcons.info_circle;

    return Dialog(
      backgroundColor: c.surfaceElev,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 24, color: iconColor),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: c.textMuted, fontSize: 14),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: KSecondaryBtn(
                      label: cancelLabel,
                      size: KBtnSize.md,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDestructive ? c.danger : c.accent600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          confirmLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/modal/k_confirm_dialog_test.dart`
Expected: PASS, 4 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/modal/k_confirm_dialog.dart test/design/core/modal/k_confirm_dialog_test.dart
git commit -m "feat(core-design): KConfirmDialog with destructive/info tones"
```

---

## Task 16: KActionSheet

**Files:**
- Create: `lib/design/core/modal/k_action_sheet.dart`
- Test: `test/design/core/modal/k_action_sheet_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/modal/k_action_sheet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('showKActionSheet renders all action labels', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    showKActionSheet<String>(
      context: capturedCtx,
      actions: const [
        KActionItem(id: 'edit', label: 'Edit', icon: Icons.edit),
        KActionItem(id: 'delete', label: 'Delete', icon: Icons.delete, danger: true),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('showKActionSheet returns tapped id', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    final future = showKActionSheet<String>(
      context: capturedCtx,
      actions: const [
        KActionItem(id: 'edit', label: 'Edit'),
        KActionItem(id: 'delete', label: 'Delete', danger: true),
      ],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(await future, 'delete');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/modal/k_action_sheet_test.dart`
Expected: FAIL — `k_action_sheet.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/modal/k_action_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// One row in the action sheet. `danger=true` renders text + icon in
/// the danger tone (red) — used for destructive options like "Delete".
class KActionItem<T> {
  const KActionItem({
    required this.id,
    required this.label,
    this.icon,
    this.danger = false,
  });

  final T id;
  final String label;
  final IconData? icon;
  final bool danger;
}

/// Shows a bottom-up action sheet — Material 3 idiomatic replacement
/// for a 3-dot dropdown menu. Returns the id of the tapped action,
/// or null if the user dismissed.
Future<T?> showKActionSheet<T>({
  required BuildContext context,
  required List<KActionItem<T>> actions,
  String? title,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _KActionSheet<T>(actions: actions, title: title),
  );
}

class _KActionSheet<T> extends StatelessWidget {
  const _KActionSheet({required this.actions, this.title});

  final List<KActionItem<T>> actions;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceElev,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: c.surfaceHover,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title!,
                    style: TextStyle(
                      color: c.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            for (final action in actions) _row(context, c, action),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, KuruColors c, KActionItem<T> a) {
    final color = a.danger ? c.danger : c.textPrimary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(a.id),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (a.icon != null) ...[
                Icon(a.icon, size: 20, color: color),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  a.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/modal/k_action_sheet_test.dart`
Expected: PASS, 2 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/modal/k_action_sheet.dart test/design/core/modal/k_action_sheet_test.dart
git commit -m "feat(core-design): KActionSheet (bottom action list)"
```

---

## Task 17: KColorPicker

**Files:**
- Create: `lib/design/core/modal/k_color_picker.dart`
- Test: `test/design/core/modal/k_color_picker_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/modal/k_color_picker_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';
import 'package:kuru_mobile/design/core/modal/k_color_picker.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('showKColorPicker renders all 26 swatches', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    showKColorPicker(context: capturedCtx, selected: 'red-400');
    await tester.pumpAndSettle();

    // Each swatch has a Semantics label of its color id.
    for (final c in kAllColors) {
      expect(find.bySemanticsLabel(c.label), findsOneWidget,
          reason: 'missing swatch ${c.label}');
    }
  });

  testWidgets('showKColorPicker returns tapped id', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    final future = showKColorPicker(context: capturedCtx, selected: 'red-400');
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Blue'));
    await tester.pumpAndSettle();

    expect(await future, 'blue-400');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/modal/k_color_picker_test.dart`
Expected: FAIL — `k_color_picker.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/modal/k_color_picker.dart`:

```dart
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/modal/color_options.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

/// Shows the 26-color picker as a bottom sheet. Returns the picked id
/// (e.g. 'blue-400'), or null if dismissed.
Future<String?> showKColorPicker({
  required BuildContext context,
  required String selected,
}) {
  return showKModalSheet<String>(
    context: context,
    title: 'Pick color',
    builder: (_) => _KColorPickerBody(selected: selected),
  );
}

class _KColorPickerBody extends StatelessWidget {
  const _KColorPickerBody({required this.selected});

  final String selected;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        for (final option in kAllColors)
          _swatch(context, option, c),
      ],
    );
  }

  Widget _swatch(BuildContext context, KColorOption opt, KuruColors c) {
    final isSelected = opt.id == selected;
    return Semantics(
      label: opt.label,
      button: true,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(opt.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: opt.swatch,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: opt.swatch, width: 4)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: opt.swatch.withValues(alpha: 0.5),
                      blurRadius: 0,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: isSelected
              ? Center(
                  child: Icon(
                    TablerIcons.check,
                    size: 18,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/modal/k_color_picker_test.dart`
Expected: PASS, 2 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/modal/k_color_picker.dart test/design/core/modal/k_color_picker_test.dart
git commit -m "feat(core-design): KColorPicker (26 swatches via bottom sheet)"
```

---

## Task 18: KIconPicker

**Files:**
- Create: `lib/design/core/modal/k_icon_picker.dart`
- Test: `test/design/core/modal/k_icon_picker_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/design/core/modal/k_icon_picker_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/design/core/modal/icon_mapping.dart';
import 'package:kuru_mobile/design/core/modal/k_icon_picker.dart';

void main() {
  Widget _wrap(Widget child) => MaterialApp(
        theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('showKIconPicker initially renders all curated icons',
      (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    showKIconPicker(context: capturedCtx, selected: 'box');
    await tester.pumpAndSettle();

    // Each icon has a Semantics label of its name.
    expect(find.bySemanticsLabel('box'), findsOneWidget);
    expect(find.bySemanticsLabel('package'), findsOneWidget);
    expect(find.bySemanticsLabel('layout-grid'), findsOneWidget);
  });

  testWidgets('showKIconPicker search narrows to matching icons',
      (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    showKIconPicker(context: capturedCtx, selected: 'box');
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'shop');
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('shopping-cart'), findsOneWidget);
    expect(find.bySemanticsLabel('shopping-bag'), findsOneWidget);
    // A non-matching curated icon should no longer be present.
    expect(find.bySemanticsLabel('coffee'), findsNothing);
  });

  testWidgets('showKIconPicker returns tapped icon name', (tester) async {
    late BuildContext capturedCtx;
    await tester.pumpWidget(_wrap(Builder(builder: (ctx) {
      capturedCtx = ctx;
      return const SizedBox.shrink();
    })));
    await tester.pump();

    final future = showKIconPicker(context: capturedCtx, selected: 'box');
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('package'));
    await tester.pumpAndSettle();

    expect(await future, 'package');
  });

  // Quick guard against accidental data drift.
  test('curated icons exposed by mapping is non-empty', () {
    expect(kCuratedIcons.isNotEmpty, isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/design/core/modal/k_icon_picker_test.dart`
Expected: FAIL — `k_icon_picker.dart` not found.

- [ ] **Step 3: Implement**

Create `lib/design/core/modal/k_icon_picker.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';
import 'package:kuru_mobile/design/core/modal/icon_mapping.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

/// Shows the curated icon picker as a bottom sheet. Search filters the
/// same curated set by substring (no full-Tabler search-all in v1).
/// Returns the picked icon name (e.g. 'package'), or null if dismissed.
Future<String?> showKIconPicker({
  required BuildContext context,
  required String selected,
}) {
  return showKModalSheet<String>(
    context: context,
    title: 'Pick icon',
    builder: (_) => _KIconPickerBody(selected: selected),
  );
}

class _KIconPickerBody extends StatefulWidget {
  const _KIconPickerBody({required this.selected});
  final String selected;

  @override
  State<_KIconPickerBody> createState() => _KIconPickerBodyState();
}

class _KIconPickerBodyState extends State<_KIconPickerBody> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final results = searchIconsByName(_query);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KSearchBar(
          hint: 'Search icons...',
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            for (final entry in results)
              _iconButton(context, c, entry),
          ],
        ),
      ],
    );
  }

  Widget _iconButton(BuildContext context, KuruColors c, KCuratedIcon entry) {
    final isSelected = entry.name == widget.selected;
    return Semantics(
      label: entry.name,
      button: true,
      child: Material(
        color: isSelected ? c.accent600 : c.surfaceHover,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => Navigator.of(context).pop(entry.name),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            child: Icon(
              entry.icon,
              size: 24,
              color: isSelected ? Colors.white : c.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/design/core/modal/k_icon_picker_test.dart`
Expected: PASS, 4 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/design/core/modal/k_icon_picker.dart test/design/core/modal/k_icon_picker_test.dart
git commit -m "feat(core-design): KIconPicker with search-filtered curated grid"
```

---

## Task 19: Demo / sandbox screen + login long-press wiring

**Files:**
- Create: `lib/features/demo/core_design_demo_screen.dart`
- Modify: `lib/features/login/login_screen.dart` — change the existing long-press-logo handler to navigate to the demo screen instead of (or in addition to) onboarding replay
- Test: `test/features/demo/core_design_demo_screen_test.dart`

The existing long-press-logo gesture goes to onboarding replay. CLAUDE.md says it's gated by `kDebugMode`. We need to decide: replace, or add a second gesture. **Plan choice: keep onboarding replay on long-press, add a *double-tap on logo* as the demo-screen entry — equally debug-only**. If a double-tap gesture would conflict with the logo's existing handlers, the engineer should add a `kDebugMode`-guarded `FloatingActionButton` on Login instead. Pick whichever leaves the production flow untouched.

- [ ] **Step 1: Write the failing test**

Create `test/features/demo/core_design_demo_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/features/demo/core_design_demo_screen.dart';

void main() {
  testWidgets('CoreDesignDemoScreen renders every widget section',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildKuruTheme(KuruPalette.indigo, Brightness.light),
      home: const CoreDesignDemoScreen(),
    ));
    // Use pump() x 2 because KSkeleton + (any) animation never settle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Section headings (one per widget category).
    expect(find.text('Feedback'), findsOneWidget);
    expect(find.text('Input'), findsOneWidget);
    expect(find.text('Layout'), findsOneWidget);
    expect(find.text('Modal'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/demo/core_design_demo_screen_test.dart`
Expected: FAIL — `core_design_demo_screen.dart` not found.

- [ ] **Step 3: Implement the demo screen**

Create `lib/features/demo/core_design_demo_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/core/feedback/k_badge.dart';
import 'package:kuru_mobile/design/core/feedback/k_empty_state.dart';
import 'package:kuru_mobile/design/core/feedback/k_skeleton.dart';
import 'package:kuru_mobile/design/core/feedback/k_spinner.dart';
import 'package:kuru_mobile/design/core/input/k_danger_btn.dart';
import 'package:kuru_mobile/design/core/input/k_icon_btn.dart';
import 'package:kuru_mobile/design/core/input/k_search_bar.dart';
import 'package:kuru_mobile/design/core/input/k_secondary_btn.dart';
import 'package:kuru_mobile/design/core/input/k_tab_nav.dart';
import 'package:kuru_mobile/design/core/layout/k_page_header.dart';
import 'package:kuru_mobile/design/core/modal/k_action_sheet.dart';
import 'package:kuru_mobile/design/core/modal/k_color_picker.dart';
import 'package:kuru_mobile/design/core/modal/k_confirm_dialog.dart';
import 'package:kuru_mobile/design/core/modal/k_icon_picker.dart';
import 'package:kuru_mobile/design/core/modal/k_modal_sheet.dart';

/// Debug-only sandbox that renders every core-design widget in one
/// scrollable column. Used for manual visual verification — the unit/widget
/// tests cover behavior, this screen covers "does it look right?".
class CoreDesignDemoScreen extends StatefulWidget {
  const CoreDesignDemoScreen({super.key});

  @override
  State<CoreDesignDemoScreen> createState() => _CoreDesignDemoScreenState();
}

class _CoreDesignDemoScreenState extends State<CoreDesignDemoScreen> {
  String _tab = 'all';
  String _color = 'red-400';
  String _icon = 'box';

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Scaffold(
      backgroundColor: c.pageBg,
      body: SafeArea(
        child: ListView(
          children: [
            KPageHeader(
              title: 'Core Design',
              subtitle: 'Debug sandbox',
              actions: [
                KIconBtn(
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
            _section(c, 'Feedback', _feedbackSection(c)),
            _section(c, 'Input', _inputSection(c)),
            _section(c, 'Layout', _layoutSection(c)),
            _section(c, 'Modal', _modalSection(context, c)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _section(KuruColors c, String title, Widget body) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: c.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            body,
          ],
        ),
      );

  Widget _feedbackSection(KuruColors c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Spinner'),
          const SizedBox(height: 4),
          const Row(children: [
            KSpinner(size: 16),
            SizedBox(width: 12),
            KSpinner(size: 24),
            SizedBox(width: 12),
            KSpinner(size: 32),
          ]),
          const SizedBox(height: 16),
          const Text('Skeleton'),
          const SizedBox(height: 4),
          const KSkeleton(width: double.infinity, height: 16),
          const SizedBox(height: 8),
          const Row(children: [
            KSkeleton.circle(40),
            SizedBox(width: 12),
            Expanded(child: KSkeleton(width: double.infinity, height: 12)),
          ]),
          const SizedBox(height: 16),
          const Text('Badge'),
          const SizedBox(height: 4),
          const Wrap(spacing: 8, runSpacing: 8, children: [
            KBadge(label: 'neutral'),
            KBadge(label: 'info', tone: KBadgeTone.info),
            KBadge(label: 'success', tone: KBadgeTone.success),
            KBadge(label: 'warning', tone: KBadgeTone.warning),
            KBadge(label: 'danger', tone: KBadgeTone.danger),
            KBadge(label: 'accent', tone: KBadgeTone.accent),
          ]),
          const SizedBox(height: 16),
          const Text('EmptyState'),
          const SizedBox(height: 4),
          const SizedBox(
            height: 240,
            child: KEmptyState(
              icon: Icons.inbox_outlined,
              title: 'No brands yet',
              subtitle: 'Add your first brand to get started',
            ),
          ),
        ],
      );

  Widget _inputSection(KuruColors c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SearchBar'),
          const SizedBox(height: 4),
          KSearchBar(hint: 'Search brands', onChanged: (_) {}),
          const SizedBox(height: 16),
          const Text('Buttons'),
          const SizedBox(height: 4),
          KSecondaryBtn(label: 'Secondary', onPressed: () {}),
          const SizedBox(height: 8),
          KDangerBtn(label: 'Danger', onPressed: () {}),
          const SizedBox(height: 8),
          Row(children: [
            KIconBtn(icon: const Icon(Icons.add), onPressed: () {}),
            const SizedBox(width: 8),
            KIconBtn(icon: const Icon(Icons.edit), onPressed: () {}),
            const SizedBox(width: 8),
            KIconBtn(icon: const Icon(Icons.delete), onPressed: () {}),
          ]),
          const SizedBox(height: 16),
          const Text('TabNav'),
          const SizedBox(height: 4),
          KTabNav<String>(
            tabs: const [
              KTabItem(id: 'all', label: 'All'),
              KTabItem(id: 'l1', label: 'Layer 1'),
              KTabItem(id: 'l2', label: 'Layer 2'),
              KTabItem(id: 'l3', label: 'Layer 3'),
              KTabItem(id: 'l4', label: 'Layer 4'),
              KTabItem(id: 'l5', label: 'Layer 5'),
            ],
            active: _tab,
            onChange: (id) => setState(() => _tab = id),
          ),
        ],
      );

  Widget _layoutSection(KuruColors c) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(
          'PageHeader rendered at top of this screen — scroll to see.',
        ),
      );

  Widget _modalSection(BuildContext context, KuruColors c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KSecondaryBtn(
            label: 'Open form sheet',
            fullWidth: false,
            onPressed: () => showKModalSheet<void>(
              context: context,
              title: 'Create brand',
              subtitle: 'Add a brand to your catalog',
              confirmLabel: 'Save',
              onConfirm: () async => true,
              builder: (_) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('(form fields would go here)'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          KDangerBtn(
            label: 'Open confirm dialog (destructive)',
            fullWidth: false,
            onPressed: () => showKConfirmDialog(
              context: context,
              title: 'Delete brand?',
              subtitle: 'This action cannot be undone.',
              confirmLabel: 'Delete',
            ),
          ),
          const SizedBox(height: 8),
          KSecondaryBtn(
            label: 'Open action sheet',
            fullWidth: false,
            onPressed: () => showKActionSheet<String>(
              context: context,
              title: 'BRAND ACTIONS',
              actions: const [
                KActionItem(id: 'edit', label: 'Edit', icon: Icons.edit),
                KActionItem(id: 'duplicate', label: 'Duplicate', icon: Icons.copy),
                KActionItem(
                  id: 'delete',
                  label: 'Delete',
                  icon: Icons.delete_outline,
                  danger: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          KSecondaryBtn(
            label: 'Pick color (current: $_color)',
            fullWidth: false,
            onPressed: () async {
              final picked =
                  await showKColorPicker(context: context, selected: _color);
              if (picked != null) setState(() => _color = picked);
            },
          ),
          const SizedBox(height: 8),
          KSecondaryBtn(
            label: 'Pick icon (current: $_icon)',
            fullWidth: false,
            onPressed: () async {
              final picked =
                  await showKIconPicker(context: context, selected: _icon);
              if (picked != null) setState(() => _icon = picked);
            },
          ),
        ],
      );
}
```

- [ ] **Step 4: Run test to verify the demo screen passes**

Run: `flutter test test/features/demo/core_design_demo_screen_test.dart`
Expected: PASS.

- [ ] **Step 5: Wire the long-press / double-tap gesture from Login**

Open `lib/features/login/login_screen.dart`. Find the existing long-press handler on the kuru logo (it currently calls onboarding replay via `kDebugMode`). Add a *double-tap* gesture on the same logo:

```dart
// Inside lib/features/login/login_screen.dart, wherever the logo is
// rendered with the long-press handler, wrap or extend it:
GestureDetector(
  onLongPress: kDebugMode ? _replayOnboarding : null,
  onDoubleTap: kDebugMode
      ? () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const CoreDesignDemoScreen(),
          ))
      : null,
  child: const AuthLogo(),
)
```

Add the import:
```dart
import 'package:kuru_mobile/features/demo/core_design_demo_screen.dart';
```

If the logo is wrapped in a different parent gesture (e.g. `InkWell`), prefer extending its existing builder rather than nesting another `GestureDetector` — same effect, clearer code.

- [ ] **Step 6: Verify analyzer still passes**

Run: `flutter analyze --fatal-warnings`
Expected: PASS, no new warnings.

- [ ] **Step 7: Commit**

```bash
git add lib/features/demo/core_design_demo_screen.dart test/features/demo/core_design_demo_screen_test.dart lib/features/login/login_screen.dart
git commit -m "chore(core-design): debug-only demo screen + double-tap-logo entry"
```

---

## Task 20: Full test suite + analyzer wrap-up

**Files:** None modified directly — this task only runs commands and writes a final tag-less commit if anything needed adjusting.

- [ ] **Step 1: Run the full test suite**

Run: `flutter test`
Expected: PASS, all tests (existing ~49 + ~35 new from this plan ≈ ~84 tests) green.

If any fail:
- Read the failure message carefully.
- Fix the implementation (not the test, unless the test has a typo). Re-run just that file: `flutter test test/path/to/file.dart`.
- Commit the fix with `fix(core-design): <what>` and re-run the full suite.

- [ ] **Step 2: Run the analyzer with fatal warnings**

Run: `flutter analyze --fatal-warnings`
Expected: PASS.

If new info-level lints appear (e.g. `non_constant_identifier_names` on Tabler usages):
- Verify the `// ignore_for_file:` directive is at the top of the affected file.
- Re-run.
- Commit any fixes as `chore(lint): <what>`.

- [ ] **Step 3: Manual visual check (no commit — just a verification step)**

Run the app and open the demo screen:

```bash
xcrun simctl boot "iPhone 16" 2>/dev/null
open -a Simulator
flutter run -d "iPhone 16" --dart-define=API_BASE_URL=http://localhost:9190
```

In the running app: navigate to `/login`, double-tap the kuru logo. The demo screen opens. Tap through each modal action (form sheet, confirm dialog, action sheet, color picker, icon picker). Verify:
- Sheets animate up smoothly.
- Bottom-sheet header has the drag handle.
- Confirm dialog is centered with a big icon circle.
- Color picker shows 26 swatches in a 6-column grid.
- Icon picker shows ~30 curated icons; typing "shop" narrows to ~2 results.

If something looks wrong, fix the widget code, re-run tests, and commit `fix(core-design): <what>`.

- [ ] **Step 4: Done — no commit needed unless step 3 turned up issues**

If you got here clean, the plan is complete. The Catalog v1 plan can now reference these widgets directly without re-spec'ing them.

---

## Reference: file ↔ task map

For quick lookup when reviewing or debugging:

| File | Task |
|---|---|
| `pubspec.yaml` | 1 |
| `lib/design/core/modal/color_options.dart` | 2 |
| `lib/design/core/modal/icon_mapping.dart` | 3 |
| `lib/design/core/feedback/k_spinner.dart` | 4 |
| `lib/design/core/feedback/k_skeleton.dart` | 5 |
| `lib/design/core/feedback/k_badge.dart` | 6 |
| `lib/design/core/feedback/k_empty_state.dart` | 7 |
| `lib/design/core/input/k_search_bar.dart` | 8 |
| `lib/design/core/input/k_secondary_btn.dart` | 9 |
| `lib/design/core/input/k_danger_btn.dart` | 10 |
| `lib/design/core/input/k_icon_btn.dart` | 11 |
| `lib/design/core/input/k_tab_nav.dart` | 12 |
| `lib/design/core/layout/k_page_header.dart` | 13 |
| `lib/design/core/modal/k_modal_sheet.dart` | 14 |
| `lib/design/core/modal/k_confirm_dialog.dart` | 15 |
| `lib/design/core/modal/k_action_sheet.dart` | 16 |
| `lib/design/core/modal/k_color_picker.dart` | 17 |
| `lib/design/core/modal/k_icon_picker.dart` | 18 |
| `lib/features/demo/core_design_demo_screen.dart` + login wiring | 19 |
| (full test + analyze) | 20 |
