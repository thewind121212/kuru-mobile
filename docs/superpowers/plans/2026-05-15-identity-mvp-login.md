# Identity MVP — Login Flow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A user who already has a kuru account (created via the web app) can launch the mobile app, see a Splash screen, land on a designed Login screen, sign in with email + password, and arrive at an authenticated HomeStub screen. Sign-out from HomeStub returns to Login.

**Architecture:** Flutter + Riverpod state, dio HTTP client with SuperTokens (header mode) auth interceptor, go_router with auth-state redirect, custom theme system (4 palettes × light/dark) ported from `design/kuru/project/kuru-theme.js`. Liquid Glass + ambient orbs implemented via `BackdropFilter` + tweened `AnimationController`s.

**Tech Stack:** Flutter 3.41.9, Dart 3.11, `flutter_riverpod`, `dio`, `go_router`, `freezed`, `json_annotation`, `supertokens_flutter`, `flutter_localizations`, `shared_preferences`, `logger`. Dev: `build_runner`, `freezed`, `json_serializable`, `very_good_analysis`.

**Scope deferred to Plan 2** (Identity Full): Register, CreateOrg, OrgPicker, Onboarding, full widget test coverage. The MVP intentionally hard-redirects users with multiple orgs into the *first* org so we don't need an org-picker UI yet.

---

## File Structure

After this plan completes, the project will have:

```
kuru-mobile/
├── pubspec.yaml                                   # MODIFIED: deps added
├── analysis_options.yaml                          # MODIFIED: very_good_analysis
├── assets/
│   └── logo.webp                                  # NEW: copied from kuru web
├── lib/
│   ├── main.dart                                  # REWRITTEN: SuperTokens + ProviderScope
│   ├── app/
│   │   ├── kuru_app.dart                          # NEW: MaterialApp.router root
│   │   ├── router.dart                            # NEW: go_router config + redirect
│   │   └── theme/
│   │       ├── kuru_colors.dart                   # NEW: ThemeExtension w/ all tokens
│   │       ├── kuru_palettes.dart                 # NEW: 4 palette instances
│   │       └── theme_controller.dart              # NEW: Riverpod theme notifier
│   ├── core/
│   │   ├── env/env.dart                           # NEW: dart-define wrapper
│   │   ├── network/
│   │   │   ├── dio_client.dart                    # NEW: dio + interceptors
│   │   │   ├── api_result.dart                    # NEW: sealed ApiResult<T>
│   │   │   └── api_exception.dart                 # NEW: typed errors
│   │   ├── auth/
│   │   │   ├── supertokens_setup.dart             # NEW: SuperTokens.init
│   │   │   ├── auth_repository.dart               # NEW: signIn + getUserInfo + signOut
│   │   │   ├── org_info.dart                      # NEW: freezed OrgInfo
│   │   │   ├── user_info.dart                     # NEW: freezed UserInfo
│   │   │   └── auth_providers.dart                # NEW: bootstrap + currentOrgId
│   │   ├── i18n/
│   │   │   ├── l10n.yaml                          # NEW: gen_l10n config
│   │   │   ├── app_vi.arb                         # NEW: canonical Vietnamese
│   │   │   └── app_en.arb                         # NEW: English mirror
│   │   └── logging/log.dart                       # NEW: logger instance
│   ├── design/
│   │   ├── widgets/
│   │   │   ├── k_glass.dart                       # NEW: BackdropFilter wrapper
│   │   │   ├── k_primary_btn.dart                 # NEW: filled button + shine
│   │   │   └── k_form_field.dart                  # NEW: KGlass-styled input
│   │   └── auth/
│   │       ├── auth_backdrop.dart                 # NEW: 3 ambient orbs
│   │       └── auth_logo.dart                     # NEW: logo + glow + sparkles
│   └── features/
│       ├── splash/splash_screen.dart              # NEW
│       ├── login/login_screen.dart                # NEW
│       └── home/home_stub_screen.dart             # NEW
└── test/
    ├── core/
    │   ├── network/api_result_test.dart           # NEW
    │   └── auth/auth_repository_test.dart         # NEW
    └── app/theme/kuru_colors_test.dart            # NEW
```

Every other Flutter-generated file from `flutter create` stays as-is.

---

## Pre-flight (one-time per environment)

Before starting Task A1, verify Flutter is alive and pick a target device.

```bash
cd /Users/kotomiichinose/Projects/kuru-mobile
flutter --version    # expect: Flutter 3.41.9
git status           # expect: working tree clean on `main`
```

If `flutter` isn't on PATH, run `source ~/.zprofile` or open a fresh terminal.

**Boot the iOS simulator** (every `flutter run -d "iPhone 16"` command below assumes this is alive):

```bash
xcrun simctl boot "iPhone 16" 2>/dev/null || true   # idempotent
open -a Simulator
flutter devices    # iPhone 16 should appear under "Connected devices"
```

**Start the kuru backend** in another terminal (so login can actually round-trip):

```bash
cd /Users/kotomiichinose/Projects/gen-barcode
task fullstack
# wait until you see "BE running on :9190" + FE on :4140
```

If `task fullstack` isn't available, fall back to `cd be && bun --env-file=.env core/index.ts` from `gen-barcode/`.

**Verify the BE responds:**

```bash
curl -i http://localhost:9190/ping
# expect: HTTP/1.1 200, body {"message":"pong"}
```

If any of the above fails, fix it before starting Task A1 — half the bugs in mobile + BE integration come from "I thought the BE was running."

---

## Phase A — Foundation

### Task A1: Add dependencies to pubspec.yaml

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Replace pubspec.yaml dependencies**

Replace the `dependencies:`, `dev_dependencies:`, and `flutter:` sections with:

```yaml
name: kuru_mobile
description: "Kuru — mobile companion app for the kuru retail platform."
publish_to: 'none'
version: 0.1.0+1

environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0

  # State + DI
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1

  # Networking
  dio: ^5.7.0

  # Routing
  go_router: ^14.6.2

  # Auth (pinned to current published version 0.6.3 — verify on pub.dev before bumping)
  supertokens_flutter: ^0.6.3

  # Models
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # Storage
  shared_preferences: ^2.3.4

  # Logging
  logger: ^2.5.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  very_good_analysis: ^7.0.0
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.9.0
  riverpod_generator: ^2.6.3

flutter:
  uses-material-design: true
  generate: true     # turns on flutter_localizations codegen
  assets:
    - assets/
```

- [ ] **Step 2: Pull packages**

```bash
flutter pub get
```

Expected: "Resolving dependencies... Got dependencies."

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "feat: add Flutter app dependencies (riverpod, dio, go_router, supertokens, freezed)"
```

---

### Task A2: Switch lint rules to very_good_analysis

**Files:**
- Modify: `analysis_options.yaml`

- [ ] **Step 1: Replace analysis_options.yaml contents**

```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "lib/core/i18n/generated/**"

linter:
  rules:
    public_member_api_docs: false
    sort_pub_dependencies: false
    sort_constructors_first: false
```

- [ ] **Step 2: Verify analyzer runs without crashes**

```bash
flutter analyze
```

Expected: any lints reported are pre-existing (in the default `main.dart` / `widget_test.dart`); no analyzer crashes.

- [ ] **Step 3: Commit**

```bash
git add analysis_options.yaml
git commit -m "chore: adopt very_good_analysis lint ruleset"
```

---

### Task A3: KuruColors ThemeExtension

**Files:**
- Create: `lib/app/theme/kuru_colors.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';

/// All design tokens for one (palette, brightness) combination.
/// Ported from design/kuru/project/kuru-theme.js.
@immutable
class KuruColors extends ThemeExtension<KuruColors> {
  const KuruColors({
    required this.pageBg,
    required this.surface,
    required this.surfaceElev,
    required this.surfaceHover,
    required this.border,
    required this.borderSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textInverse,
    required this.overlay,
    required this.primary,
    required this.primaryHover,
    required this.primarySoft,
    required this.secondary,
    required this.secondarySoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.highlight,
    required this.accent50,
    required this.accent100,
    required this.accent200,
    required this.accent300,
    required this.accent400,
    required this.accent500,
    required this.accent600,
    required this.accent700,
    required this.accent800,
    required this.ambient1,
    required this.ambient2,
    required this.shadowSm,
    required this.shadowMd,
    required this.shadowPop,
    required this.glassTint,
  });

  final Color pageBg;
  final Color surface;
  final Color surfaceElev;
  final Color surfaceHover;
  final Color border;
  final Color borderSoft;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textInverse;
  final Color overlay;
  final Color primary;
  final Color primaryHover;
  final Color primarySoft;
  final Color secondary;
  final Color secondarySoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color highlight;
  final Color accent50;
  final Color accent100;
  final Color accent200;
  final Color accent300;
  final Color accent400;
  final Color accent500;
  final Color accent600;
  final Color accent700;
  final Color accent800;
  final Color ambient1;
  final Color ambient2;
  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadowMd;
  final List<BoxShadow> shadowPop;
  final Color glassTint;

  @override
  KuruColors copyWith({Color? pageBg}) {
    // Plan 1 doesn't need a real copyWith; palettes are baked constants.
    return this;
  }

  @override
  KuruColors lerp(ThemeExtension<KuruColors>? other, double t) {
    if (other is! KuruColors) return this;
    // Material transitions; we don't tween cross-palette in v1 (no live switcher).
    return t < 0.5 ? this : other;
  }
}

/// Convenience accessor: `kuruColors(context).primary`.
KuruColors kuruColors(BuildContext context) =>
    Theme.of(context).extension<KuruColors>()!;
```

- [ ] **Step 2: Verify it compiles**

```bash
flutter analyze lib/app/theme/kuru_colors.dart
```

Expected: no errors. Lint warnings about unused parameters in `copyWith` are OK.

- [ ] **Step 3: Commit**

```bash
git add lib/app/theme/kuru_colors.dart
git commit -m "feat(theme): add KuruColors ThemeExtension with all design tokens"
```

---

### Task A4: Palette definitions (4 palettes)

**Files:**
- Create: `lib/app/theme/kuru_palettes.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// All 4 palettes ported from design/kuru/project/kuru-theme.js.
/// indigoDark is synthesized — kuru-theme.js only defines `indigo` light.
class KuruPalettes {
  static const purpleLight = KuruColors(
    pageBg: Color(0xFFF5F0FA),
    surface: Color(0xFFFAF7FC),
    surfaceElev: Color(0xFFFFFFFF),
    surfaceHover: Color(0xFFEDE4F5),
    border: Color(0xFFD0C0E0),
    borderSoft: Color(0xFFE5DBED),
    textPrimary: Color(0xFF1A1028),
    textSecondary: Color(0xFF554466),
    textMuted: Color(0xFF887799),
    textInverse: Color(0xFFFFFFFF),
    overlay: Color(0x4D08080C),
    primary: Color(0xFF9C27B0),
    primaryHover: Color(0xFF8520A0),
    primarySoft: Color(0x1A9C27B0),
    secondary: Color(0xFF5E35B1),
    secondarySoft: Color(0x1F5E35B1),
    success: Color(0xFF0D9488),
    successSoft: Color(0x1F0D9488),
    warning: Color(0xFFD07000),
    warningSoft: Color(0x1FD07000),
    danger: Color(0xFFC62828),
    dangerSoft: Color(0x1AC62828),
    highlight: Color(0xFFC8A600),
    accent50: Color(0xFFF8EAFB),
    accent100: Color(0xFFF1D7F7),
    accent200: Color(0xFFE8C0F3),
    accent300: Color(0xFFD99AEA),
    accent400: Color(0xFFC96DE0),
    accent500: Color(0xFFB845CB),
    accent600: Color(0xFF9C27B0),
    accent700: Color(0xFF8520A0),
    accent800: Color(0xFF68197E),
    ambient1: Color(0x299C27B0),
    ambient2: Color(0x245E35B1),
    shadowSm: [
      BoxShadow(
        color: Color(0x0F5E35B1),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color(0x335E35B1),
        blurRadius: 22,
        offset: Offset(0, 8),
        spreadRadius: -14,
      ),
    ],
    shadowMd: [
      BoxShadow(
        color: Color(0x2E5E35B1),
        blurRadius: 14,
        offset: Offset(0, 4),
        spreadRadius: -6,
      ),
      BoxShadow(
        color: Color(0x475E35B1),
        blurRadius: 40,
        offset: Offset(0, 16),
        spreadRadius: -22,
      ),
    ],
    shadowPop: [
      BoxShadow(
        color: Color(0x665E35B1),
        blurRadius: 50,
        offset: Offset(0, 22),
        spreadRadius: -22,
      ),
    ],
    glassTint: Color(0x8CFFFFFF),
  );

  static const purpleDark = KuruColors(
    pageBg: Color(0xFF08080C),
    surface: Color(0xFF111118),
    surfaceElev: Color(0xFF1A1A24),
    surfaceHover: Color(0xFF242432),
    border: Color(0xFF2E2E42),
    borderSoft: Color(0xFF232334),
    textPrimary: Color(0xFFE8E0F0),
    textSecondary: Color(0xFFB8AED0),
    textMuted: Color(0xFF7A7090),
    textInverse: Color(0xFF08080C),
    overlay: Color(0xA608080C),
    primary: Color(0xFFE040FB),
    primaryHover: Color(0xFFC830E0),
    primarySoft: Color(0x24E040FB),
    secondary: Color(0xFF7C4DFF),
    secondarySoft: Color(0x297C4DFF),
    success: Color(0xFF2DD4BF),
    successSoft: Color(0x242DD4BF),
    warning: Color(0xFFFF9100),
    warningSoft: Color(0x29FF9100),
    danger: Color(0xFFFF5470),
    dangerSoft: Color(0x29FF5470),
    highlight: Color(0xFFFFEA00),
    accent50: Color(0xFF310925),
    accent100: Color(0xFF6B176F),
    accent200: Color(0xFF9F23B5),
    accent300: Color(0xFFC830E0),
    accent400: Color(0xFFE040FB),
    accent500: Color(0xFFE65AFC),
    accent600: Color(0xFFEA6DFF),
    accent700: Color(0xFFE59BFF),
    accent800: Color(0xFFE9C0FD),
    ambient1: Color(0x2EE040FB),
    ambient2: Color(0x297C4DFF),
    shadowSm: [
      BoxShadow(color: Color(0x66000000), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(
        color: Color(0x4DE040FB),
        blurRadius: 28,
        offset: Offset(0, 10),
        spreadRadius: -18,
      ),
    ],
    shadowMd: [
      BoxShadow(
        color: Color(0x80000000),
        blurRadius: 18,
        offset: Offset(0, 6),
        spreadRadius: -10,
      ),
      BoxShadow(
        color: Color(0x66E040FB),
        blurRadius: 52,
        offset: Offset(0, 22),
        spreadRadius: -28,
      ),
    ],
    shadowPop: [
      BoxShadow(
        color: Color(0x8CE040FB),
        blurRadius: 60,
        offset: Offset(0, 26),
        spreadRadius: -22,
      ),
    ],
    glassTint: Color(0x611A1A24),
  );

  static const indigoLight = KuruColors(
    pageBg: Color(0xFFF3F6FF),
    surface: Color(0xFFF8FBFF),
    surfaceElev: Color(0xFFFFFFFF),
    surfaceHover: Color(0xFFE8EFFF),
    border: Color(0xFFC8D4F4),
    borderSoft: Color(0xFFDFE6F8),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF3F4D67),
    textMuted: Color(0xFF71809C),
    textInverse: Color(0xFFFFFFFF),
    overlay: Color(0x4D0F172A),
    primary: Color(0xFF4F46E5),
    primaryHover: Color(0xFF4338CA),
    primarySoft: Color(0x1A4F46E5),
    secondary: Color(0xFF2563EB),
    secondarySoft: Color(0x1F2563EB),
    success: Color(0xFF0D9488),
    successSoft: Color(0x1F0D9488),
    warning: Color(0xFFB45309),
    warningSoft: Color(0x1FB45309),
    danger: Color(0xFFB91C1C),
    dangerSoft: Color(0x1AB91C1C),
    highlight: Color(0xFFCA8A04),
    accent50: Color(0xFFEEF2FF),
    accent100: Color(0xFFE0E7FF),
    accent200: Color(0xFFC7D2FE),
    accent300: Color(0xFFA5B4FC),
    accent400: Color(0xFF818CF8),
    accent500: Color(0xFF6366F1),
    accent600: Color(0xFF4F46E5),
    accent700: Color(0xFF4338CA),
    accent800: Color(0xFF3730A3),
    ambient1: Color(0x264F46E5),
    ambient2: Color(0x212563EB),
    shadowSm: [
      BoxShadow(
        color: Color(0x0F2563EB),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color(0x382563EB),
        blurRadius: 22,
        offset: Offset(0, 8),
        spreadRadius: -14,
      ),
    ],
    shadowMd: [
      BoxShadow(
        color: Color(0x2E2563EB),
        blurRadius: 14,
        offset: Offset(0, 4),
        spreadRadius: -6,
      ),
      BoxShadow(
        color: Color(0x4D2563EB),
        blurRadius: 40,
        offset: Offset(0, 16),
        spreadRadius: -22,
      ),
    ],
    shadowPop: [
      BoxShadow(
        color: Color(0x6B2563EB),
        blurRadius: 50,
        offset: Offset(0, 22),
        spreadRadius: -22,
      ),
    ],
    glassTint: Color(0x8CFFFFFF),
  );

  /// Synthesized from midnight's structure with the indigo accent ramp.
  static const indigoDark = KuruColors(
    pageBg: Color(0xFF080814),
    surface: Color(0xFF11111F),
    surfaceElev: Color(0xFF1A1A2E),
    surfaceHover: Color(0xFF22223A),
    border: Color(0xFF2A2D4A),
    borderSoft: Color(0xFF20223A),
    textPrimary: Color(0xFFE0E4FF),
    textSecondary: Color(0xFFAEB3D9),
    textMuted: Color(0xFF7A809E),
    textInverse: Color(0xFF080814),
    overlay: Color(0xA608080C),
    primary: Color(0xFF818CF8),
    primaryHover: Color(0xFF6366F1),
    primarySoft: Color(0x24818CF8),
    secondary: Color(0xFF60A5FA),
    secondarySoft: Color(0x2960A5FA),
    success: Color(0xFF2DD4BF),
    successSoft: Color(0x242DD4BF),
    warning: Color(0xFFFB923C),
    warningSoft: Color(0x29FB923C),
    danger: Color(0xFFFF5470),
    dangerSoft: Color(0x29FF5470),
    highlight: Color(0xFFFACC15),
    accent50: Color(0xFF1E1B4B),
    accent100: Color(0xFF312E81),
    accent200: Color(0xFF3730A3),
    accent300: Color(0xFF4338CA),
    accent400: Color(0xFF4F46E5),
    accent500: Color(0xFF6366F1),
    accent600: Color(0xFF818CF8),
    accent700: Color(0xFFA5B4FC),
    accent800: Color(0xFFC7D2FE),
    ambient1: Color(0x2E818CF8),
    ambient2: Color(0x2960A5FA),
    shadowSm: [
      BoxShadow(color: Color(0x66000000), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(
        color: Color(0x4D818CF8),
        blurRadius: 28,
        offset: Offset(0, 10),
        spreadRadius: -18,
      ),
    ],
    shadowMd: [
      BoxShadow(
        color: Color(0x80000000),
        blurRadius: 18,
        offset: Offset(0, 6),
        spreadRadius: -10,
      ),
      BoxShadow(
        color: Color(0x66818CF8),
        blurRadius: 52,
        offset: Offset(0, 22),
        spreadRadius: -28,
      ),
    ],
    shadowPop: [
      BoxShadow(
        color: Color(0x8C818CF8),
        blurRadius: 60,
        offset: Offset(0, 26),
        spreadRadius: -22,
      ),
    ],
    glassTint: Color(0x611A1A2E),
  );
}

/// User-selectable palette family. Brightness is decided by the platform.
enum KuruPalette { purple, indigo }

extension KuruPaletteX on KuruPalette {
  KuruColors resolve(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (this) {
      KuruPalette.purple =>
        dark ? KuruPalettes.purpleDark : KuruPalettes.purpleLight,
      KuruPalette.indigo =>
        dark ? KuruPalettes.indigoDark : KuruPalettes.indigoLight,
    };
  }
}
```

- [ ] **Step 2: Write a test that verifies the palette resolves correctly**

Create `test/app/theme/kuru_colors_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';

void main() {
  test('purple light resolves to purple light colors', () {
    final colors = KuruPalette.purple.resolve(Brightness.light);
    expect(colors.primary, const Color(0xFF9C27B0));
    expect(colors.pageBg, const Color(0xFFF5F0FA));
  });

  test('purple dark uses midnight tokens', () {
    final colors = KuruPalette.purple.resolve(Brightness.dark);
    expect(colors.primary, const Color(0xFFE040FB));
    expect(colors.pageBg, const Color(0xFF08080C));
  });

  test('indigo light uses indigo tokens', () {
    final colors = KuruPalette.indigo.resolve(Brightness.light);
    expect(colors.primary, const Color(0xFF4F46E5));
  });

  test('indigo dark synthesizes from midnight structure', () {
    final colors = KuruPalette.indigo.resolve(Brightness.dark);
    expect(colors.primary, const Color(0xFF818CF8));
    expect(colors.pageBg, const Color(0xFF080814));
  });
}
```

- [ ] **Step 3: Run the tests**

```bash
flutter test test/app/theme/kuru_colors_test.dart
```

Expected: 4 tests pass.

- [ ] **Step 4: Commit**

```bash
git add lib/app/theme/kuru_palettes.dart test/app/theme/kuru_colors_test.dart
git commit -m "feat(theme): port 4 palettes (purple/indigo × light/dark) from design tokens"
```

---

### Task A5: Theme controller (Riverpod)

**Files:**
- Create: `lib/app/theme/theme_controller.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';

/// Holds the currently selected palette. v1 hard-codes purple; the picker
/// UI lands in a future Settings spec.
class ThemeController extends Notifier<KuruPalette> {
  @override
  KuruPalette build() => KuruPalette.purple;

  void setPalette(KuruPalette p) => state = p;
}

final themeControllerProvider =
    NotifierProvider<ThemeController, KuruPalette>(ThemeController.new);

/// Build a Material `ThemeData` for the given palette + brightness.
ThemeData buildKuruTheme(KuruPalette palette, Brightness brightness) {
  final c = palette.resolve(brightness);
  final scheme = ColorScheme.fromSeed(
    seedColor: c.primary,
    brightness: brightness,
    primary: c.primary,
    onPrimary: c.textInverse,
    surface: c.surface,
    onSurface: c.textPrimary,
    error: c.danger,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.pageBg,
    extensions: [c],
    fontFamily: '.SF Pro Text',
    textTheme: ThemeData.from(colorScheme: scheme).textTheme.apply(
          bodyColor: c.textPrimary,
          displayColor: c.textPrimary,
        ),
  );
}
```

- [ ] **Step 2: Verify it analyzes clean**

```bash
flutter analyze lib/app/theme/theme_controller.dart
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/app/theme/theme_controller.dart
git commit -m "feat(theme): add ThemeController Riverpod notifier + buildKuruTheme"
```

---

### Task A6: Add logo asset

**Files:**
- Create: `assets/logo.webp` (copied from kuru web)

- [ ] **Step 1: Copy the logo file**

```bash
cp /Users/kotomiichinose/Projects/gen-barcode/fe/public/logo.webp \
   /Users/kotomiichinose/Projects/kuru-mobile/assets/logo.webp
```

- [ ] **Step 2: Verify the file exists and is non-empty**

```bash
ls -la /Users/kotomiichinose/Projects/kuru-mobile/assets/logo.webp
```

Expected: a >0 byte `.webp` file.

- [ ] **Step 3: Commit**

```bash
git add assets/logo.webp
git commit -m "chore: bundle kuru logo asset (from gen-barcode web)"
```

---

### Task A7: i18n setup with initial ARB files

**Files:**
- Create: `l10n.yaml` (**project root** — Flutter's gen-l10n tool only auto-discovers this file at the root, not under `lib/`)
- Create: `lib/core/i18n/app_vi.arb`
- Create: `lib/core/i18n/app_en.arb`

- [ ] **Step 1: Write `l10n.yaml` at the project root**

Path: `/Users/kotomiichinose/Projects/kuru-mobile/l10n.yaml`

```yaml
arb-dir: lib/core/i18n
template-arb-file: app_vi.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
synthetic-package: false
output-dir: lib/core/i18n/generated
```

- [ ] **Step 2: Write `app_vi.arb` (canonical)**

```json
{
  "@@locale": "vi",
  "appTitle": "Kuru",
  "splashTagline": "Đang kết nối...",

  "loginTitle": "Chào mừng trở lại",
  "loginSubtitle": "Đăng nhập kuru để tiếp tục quản lý cửa hàng.",
  "fieldEmail": "Email",
  "fieldPassword": "Mật khẩu",
  "loginRemember": "Ghi nhớ đăng nhập",
  "loginCta": "Đăng nhập",
  "loginFooterNoAccount": "Chưa có tài khoản?",
  "loginFooterRegister": "Đăng ký",
  "loginErrorBadCredentials": "Email hoặc mật khẩu không chính xác.",
  "loginErrorNetwork": "Không có kết nối mạng. Thử lại.",
  "loginErrorGeneric": "Đã có lỗi xảy ra. Thử lại sau.",

  "homeStubTitle": "Đã đăng nhập",
  "homeStubBody": "Chào {email}, bạn đang ở cửa hàng {orgName}.",
  "@homeStubBody": {
    "placeholders": {
      "email": {"type": "String"},
      "orgName": {"type": "String"}
    }
  },
  "homeStubLogout": "Đăng xuất"
}
```

- [ ] **Step 3: Write `app_en.arb` (mirroring kuru web's style)**

```json
{
  "@@locale": "en",
  "appTitle": "Kuru",
  "splashTagline": "Connecting...",

  "loginTitle": "Welcome back",
  "loginSubtitle": "Log in to kuru to keep managing your store.",
  "fieldEmail": "Email",
  "fieldPassword": "Password",
  "loginRemember": "Remember me",
  "loginCta": "Log in",
  "loginFooterNoAccount": "No account yet?",
  "loginFooterRegister": "Sign up",
  "loginErrorBadCredentials": "Email password combination is incorrect.",
  "loginErrorNetwork": "No internet connection. Try again.",
  "loginErrorGeneric": "Oops! Something went wrong.",

  "homeStubTitle": "You're logged in",
  "homeStubBody": "Hi {email}, you're working in {orgName}.",
  "homeStubLogout": "Log out"
}
```

- [ ] **Step 4: Generate the AppLocalizations class**

```bash
flutter gen-l10n
```

Expected: writes `lib/core/i18n/generated/app_localizations.dart` (plus `_vi.dart`, `_en.dart`).

- [ ] **Step 5: Commit**

```bash
git add lib/core/i18n/
git commit -m "feat(i18n): bootstrap vi + en ARB files and gen_l10n config"
```

---

### Task A8: Bootstrap main.dart + kuru_app.dart (placeholder router)

**Files:**
- Modify: `lib/main.dart` (overwrite the default counter app)
- Create: `lib/app/kuru_app.dart`

- [ ] **Step 1: Rewrite `lib/main.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/kuru_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: KuruApp()));
}
```

> Real SuperTokens.init + SharedPreferences override go in Task B5. We're keeping `main` minimal so the foundation compiles before the network layer exists.

- [ ] **Step 2: Write `lib/app/kuru_app.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';

class KuruApp extends ConsumerWidget {
  const KuruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(themeControllerProvider);
    return MaterialApp(
      title: 'Kuru',
      debugShowCheckedModeBanner: false,
      theme: buildKuruTheme(palette, Brightness.light),
      darkTheme: buildKuruTheme(palette, Brightness.dark),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: const _BootPlaceholder(),
    );
  }
}

class _BootPlaceholder extends StatelessWidget {
  const _BootPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('kuru — foundation OK')),
    );
  }
}
```

- [ ] **Step 3: Run the app to confirm it boots**

```bash
flutter run -d "iPhone 16"
```

Expected: simulator shows the text "kuru — foundation OK" on the purple page background. Hit `q` to quit.

- [ ] **Step 4: Commit**

```bash
git add lib/main.dart lib/app/kuru_app.dart
git commit -m "feat: bootstrap KuruApp shell with theme + localizations wired"
```

---

### Task A9: Allow cleartext HTTP to localhost (iOS ATS + Android NSC)

Both platforms block plaintext HTTP by default. The kuru BE dev server runs on **plain HTTP** at `localhost:9190`, so we whitelist exactly that host. Skipping this is the single most common reason mobile apps "silently fail" their first network call.

**Files:**
- Modify: `ios/Runner/Info.plist`
- Create: `android/app/src/main/res/xml/network_security_config.xml`
- Modify: `android/app/src/main/AndroidManifest.xml`

- [ ] **Step 1: Add `NSAppTransportSecurity` to `ios/Runner/Info.plist`**

Open `ios/Runner/Info.plist` and add the following just before the closing `</dict>`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsLocalNetworking</key>
  <true/>
  <key>NSExceptionDomains</key>
  <dict>
    <key>localhost</key>
    <dict>
      <key>NSExceptionAllowsInsecureHTTPLoads</key>
      <true/>
    </dict>
    <key>10.0.2.2</key>
    <dict>
      <key>NSExceptionAllowsInsecureHTTPLoads</key>
      <true/>
    </dict>
  </dict>
</dict>
```

- [ ] **Step 2: Create `android/app/src/main/res/xml/network_security_config.xml`**

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
  <domain-config cleartextTrafficPermitted="true">
    <domain includeSubdomains="true">localhost</domain>
    <domain includeSubdomains="true">10.0.2.2</domain>
  </domain-config>
</network-security-config>
```

- [ ] **Step 3: Wire it into `android/app/src/main/AndroidManifest.xml`**

Find the `<application>` tag and add `android:networkSecurityConfig="@xml/network_security_config"` as an attribute:

```xml
<application
    android:label="kuru_mobile"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher"
    android:networkSecurityConfig="@xml/network_security_config">
    <!-- existing children unchanged -->
```

- [ ] **Step 4: Commit**

```bash
git add ios/Runner/Info.plist \
        android/app/src/main/res/xml/network_security_config.xml \
        android/app/src/main/AndroidManifest.xml
git commit -m "chore(platform): allow cleartext HTTP to localhost/10.0.2.2 for dev"
```

---

## Phase B — Networking + Auth

### Task B1: Environment config

**Files:**
- Create: `lib/core/env/env.dart`

- [ ] **Step 1: Write the file**

```dart
/// Compile-time configuration injected via `--dart-define`.
class Env {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:9190', // android emu default
  );

  /// True when running on iOS simulator — use localhost instead of 10.0.2.2.
  /// Caller sets this via dart-define if needed: `--dart-define=API_BASE_URL=http://localhost:9190`.
  static bool get hasOverride =>
      const String.fromEnvironment('API_BASE_URL').isNotEmpty;
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/core/env/env.dart
git commit -m "feat(env): API_BASE_URL via --dart-define"
```

---

### Task B2: ApiException type

**Files:**
- Create: `lib/core/network/api_exception.dart`

- [ ] **Step 1: Write the file**

```dart
sealed class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends ApiException {
  const NetworkException(super.message);
}

class TimeoutException extends ApiException {
  const TimeoutException(super.message);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message);
}

class BadRequestException extends ApiException {
  const BadRequestException(super.message, {this.code});
  final String? code;
}

class ServerException extends ApiException {
  const ServerException(super.message, {required this.statusCode});
  final int statusCode;
}

class UnknownException extends ApiException {
  const UnknownException(super.message);
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/core/network/api_exception.dart
git commit -m "feat(network): typed ApiException hierarchy"
```

---

### Task B3: ApiResult with TDD

**Files:**
- Create: `lib/core/network/api_result.dart`
- Create: `test/core/network/api_result_test.dart`

- [ ] **Step 1: Write the failing test first**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';

void main() {
  group('ApiResult', () {
    test('Success.data returns the value', () {
      final r = ApiResult<int>.success(42);
      expect(r is ApiSuccess<int>, isTrue);
      expect((r as ApiSuccess<int>).data, 42);
    });

    test('Failure.err returns the exception', () {
      const e = NetworkException('down');
      final r = ApiResult<int>.failure(e);
      expect((r as ApiFailure<int>).err, e);
    });

    test('unwrap returns the value on success', () async {
      final v = await Future.value(ApiResult<int>.success(7)).unwrap();
      expect(v, 7);
    });

    test('unwrap throws on failure', () async {
      const e = NetworkException('down');
      expect(
        () async => Future.value(ApiResult<int>.failure(e)).unwrap(),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
```

- [ ] **Step 2: Run the test and verify it fails**

```bash
flutter test test/core/network/api_result_test.dart
```

Expected: compile errors (`ApiResult`, `ApiSuccess`, `ApiFailure`, `unwrap` are not defined).

- [ ] **Step 3: Write `lib/core/network/api_result.dart`**

```dart
import 'package:kuru_mobile/core/network/api_exception.dart';

sealed class ApiResult<T> {
  const ApiResult();
  factory ApiResult.success(T data) = ApiSuccess<T>;
  factory ApiResult.failure(ApiException err) = ApiFailure<T>;
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);
  final T data;
}

final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.err);
  final ApiException err;
}

extension ApiResultX<T> on Future<ApiResult<T>> {
  /// Returns the value on success, throws the typed exception on failure.
  /// Use inside Riverpod async notifiers where throwing routes to AsyncError.
  Future<T> unwrap() async {
    final r = await this;
    return switch (r) {
      ApiSuccess<T>(:final data) => data,
      ApiFailure<T>(:final err) => throw err,
    };
  }
}
```

- [ ] **Step 4: Re-run the tests**

```bash
flutter test test/core/network/api_result_test.dart
```

Expected: 4 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/core/network/api_result.dart test/core/network/api_result_test.dart
git commit -m "feat(network): sealed ApiResult<T> with unwrap extension (TDD)"
```

---

### Task B4: Dio client + interceptors

**Files:**
- Create: `lib/core/logging/log.dart`
- Create: `lib/core/network/dio_client.dart`

- [ ] **Step 1: Write `lib/core/logging/log.dart`**

```dart
import 'package:logger/logger.dart';

final log = Logger(
  printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: false),
);
```

- [ ] **Step 2: Write `lib/core/network/dio_client.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:kuru_mobile/core/logging/log.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';

/// Provides a configured dio instance. baseUrl is the kuru host root —
/// this dio is used for both SuperTokens auth routes (`/auth/*` at root) and
/// the REST API routes (`/api/v1/*`); each caller includes its own prefix.
/// The SuperTokens interceptor is wired separately by Task B5.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl, // root, e.g. http://localhost:9190
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );

  // Task B5 wires SuperTokens to this dio.
  // Org-id / logging / error-mapping below.

  dio.interceptors.add(_OrgIdInterceptor(ref));
  dio.interceptors.add(_LoggingInterceptor());
  dio.interceptors.add(_ErrorMappingInterceptor());

  return dio;
});

/// Reads currentOrgIdProvider lazily and stamps `x-org-id` on every request
/// once an org is selected.
class _OrgIdInterceptor extends Interceptor {
  _OrgIdInterceptor(this._ref);
  final Ref _ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // currentOrgIdProvider is defined in Task B8.
    final orgId = _ref.read(_currentOrgIdValueProvider);
    if (orgId != null) options.headers['x-org-id'] = orgId;
    handler.next(options);
  }
}

/// Placeholder for the current org id while `auth_providers.dart` doesn't
/// exist yet (Task B8 swaps this for a direct read of `currentOrgIdProvider`).
/// Don't remove this in Task B4 — keeping it now means the dio client compiles
/// before the auth-providers file is written.
final _currentOrgIdValueProvider = Provider<String?>((_) => null);

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.d('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler h) {
    log.d('← ${response.statusCode} ${response.requestOptions.uri}');
    h.next(response);
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    log.w('× ${e.response?.statusCode ?? '???'} ${e.requestOptions.uri}: '
        '${e.message}');
    handler.next(e);
  }
}

class _ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    final mapped = mapDioError(e);
    handler.reject(
      DioException(
        requestOptions: e.requestOptions,
        error: mapped,
        response: e.response,
        type: e.type,
      ),
    );
  }
}

/// Converts a DioException into our typed ApiException. Exposed for unit tests.
ApiException mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutException('Request timed out');
    case DioExceptionType.connectionError:
      return const NetworkException('No network connection');
    case DioExceptionType.cancel:
      return const UnknownException('Request cancelled');
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode ?? 0;
      final msg = _extractMessage(e.response?.data) ?? 'HTTP $status';
      if (status == 401 || status == 403) {
        return UnauthorizedException(msg);
      }
      if (status >= 400 && status < 500) {
        return BadRequestException(msg, code: _extractCode(e.response?.data));
      }
      return ServerException(msg, statusCode: status);
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return UnknownException(e.message ?? 'Unknown error');
  }
}

String? _extractMessage(dynamic data) {
  if (data is Map && data['error'] is Map) {
    return data['error']['message']?.toString();
  }
  return null;
}

String? _extractCode(dynamic data) {
  if (data is Map && data['error'] is Map) {
    return data['error']['code']?.toString();
  }
  return null;
}
```

- [ ] **Step 3: Verify it compiles**

```bash
flutter analyze lib/core/network lib/core/logging
```

Expected: no errors.

- [ ] **Step 4: Commit**

```bash
git add lib/core/logging/log.dart lib/core/network/dio_client.dart
git commit -m "feat(network): dio client with org-id, logging, and error-mapping interceptors"
```

---

### Task B5: SuperTokens setup + wire into dio + main.dart update

**Files:**
- Create: `lib/core/auth/supertokens_setup.dart`
- Modify: `lib/core/network/dio_client.dart` (wire interceptor)
- Modify: `lib/main.dart`

- [ ] **Step 1: Write `supertokens_setup.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:kuru_mobile/core/env/env.dart';
import 'package:supertokens_flutter/dio.dart'; // exports `addSupertokensInterceptor` extension
import 'package:supertokens_flutter/supertokens.dart';

/// One-time SuperTokens init. Synchronous despite the surrounding async main().
/// `apiBasePath: '/auth'` matches where kuru BE mounts the SuperTokens
/// middleware (see `gen-barcode/be/core/app.ts:102` — `app.use(middleware())`
/// before the `/api/v1` mount). Header-mode token transfer is the SDK default
/// for native clients (no cookies).
void initSuperTokens() {
  SuperTokens.init(
    apiDomain: Env.apiBaseUrl,
    apiBasePath: '/auth',
  );
}

/// Attach SuperTokens' dio interceptor. Call this on the dio singleton AT
/// CONSTRUCTION TIME and BEFORE any other interceptors so token attachment
/// + refresh-on-401 wraps every subsequent request.
void wireSuperTokensToDio(Dio dio) {
  dio.addSupertokensInterceptor();
}
```

> **Why no custom extension:** the `supertokens_flutter/dio.dart` import above already exposes `addSupertokensInterceptor()` as an extension on `Dio`. We just call it.

- [ ] **Step 2: Update `lib/core/network/dio_client.dart` to wire SuperTokens FIRST**

Inside `dioProvider`, immediately after constructing `dio` (and BEFORE adding the org-id / logging / error interceptors), call:

```dart
import 'package:kuru_mobile/core/auth/supertokens_setup.dart';
// ...
final dio = Dio(BaseOptions(/* ... */));

wireSuperTokensToDio(dio); // MUST be first — token attach + refresh wraps the rest

dio.interceptors.add(_OrgIdInterceptor(ref));
dio.interceptors.add(_LoggingInterceptor());
dio.interceptors.add(_ErrorMappingInterceptor());

return dio;
```

- [ ] **Step 3: Update `lib/main.dart` (sync init, no `await`)**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/kuru_app.dart';
import 'package:kuru_mobile/core/auth/supertokens_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError('overridden in main()');
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initSuperTokens(); // SYNC — SuperTokens.init returns void
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: const KuruApp(),
    ),
  );
}
```

- [ ] **Step 4: Sanity check with curl that the SuperTokens endpoint actually exists at the path we think**

In a separate terminal (with the kuru BE running on `localhost:9190`):

```bash
curl -i -X POST http://localhost:9190/auth/signin \
  -H 'Content-Type: application/json' \
  -d '{"formFields":[{"id":"email","value":"x@x"},{"id":"password","value":"x"}]}'
```

Expected: a `200` (with `{"status":"WRONG_CREDENTIALS_ERROR",...}` body) or a `400` validation response — both prove the endpoint is reachable at that path. If you get `404`, the BE's `apiBasePath` is different; update `apiBasePath` in Step 1 accordingly before proceeding.

- [ ] **Step 5: Run the app**

```bash
flutter run -d "iPhone 16" --dart-define=API_BASE_URL=http://localhost:9190
```

Expected: app boots to "kuru — foundation OK"; no SuperTokens-related crashes. (No network call is made yet.) Press `q` to quit.

- [ ] **Step 6: Commit**

```bash
git add lib/core/auth/supertokens_setup.dart lib/core/network/dio_client.dart lib/main.dart
git commit -m "feat(auth): SuperTokens init + dio interceptor wiring (real, not stub)"
```

---

### Task B6: UserInfo + OrgInfo freezed models

**Files:**
- Create: `lib/core/auth/org_info.dart`
- Create: `lib/core/auth/user_info.dart`

- [ ] **Step 1: Write `org_info.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'org_info.freezed.dart';
part 'org_info.g.dart';

@freezed
class OrgInfo with _$OrgInfo {
  const factory OrgInfo({
    required String id,
    required String name,
    required String role,
  }) = _OrgInfo;

  factory OrgInfo.fromJson(Map<String, dynamic> json) =>
      _$OrgInfoFromJson(json);
}
```

- [ ] **Step 2: Write `user_info.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    String? email,
    String? name,
    @Default(<OrgInfo>[]) List<OrgInfo> orgInfos,
    @Default(<OrgInfo>[]) List<OrgInfo> disabledOrgInfos,
    String? avatarStyle,
    String? avatarSeed,
    String? avatarUrl,
    @Default(false) bool totpEnabled,
    @Default(0) int pendingInviteCount,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}
```

- [ ] **Step 3: Run codegen**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: writes `org_info.freezed.dart`, `org_info.g.dart`, `user_info.freezed.dart`, `user_info.g.dart`.

- [ ] **Step 4: Commit**

```bash
git add lib/core/auth/org_info.dart lib/core/auth/user_info.dart \
        lib/core/auth/*.freezed.dart lib/core/auth/*.g.dart
git commit -m "feat(auth): freezed UserInfo + OrgInfo models"
```

---

### Task B7: AuthRepository (signIn + getUserInfo + signOut)

**Files:**
- Create: `lib/core/auth/auth_repository.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:supertokens_flutter/supertokens.dart';

class AuthRepository {
  AuthRepository(this._dio);
  final Dio _dio;

  /// SuperTokens EmailPassword sign-in. Path is `/auth/signin` at the host
  /// root — kuru BE mounts the SuperTokens middleware before `/api/v1`.
  Future<ApiResult<void>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/signin',
        data: {
          'formFields': [
            {'id': 'email', 'value': email},
            {'id': 'password', 'value': password},
          ],
        },
      );
      final status = res.data?['status'] as String? ?? 'UNKNOWN';
      if (status == 'OK') return const ApiResult.success(null);
      if (status == 'WRONG_CREDENTIALS_ERROR') {
        return const ApiResult.failure(
          UnauthorizedException('WRONG_CREDENTIALS'),
        );
      }
      return ApiResult.failure(BadRequestException(status));
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e));
    }
  }

  /// REST API endpoint — note the `/api/v1` prefix. The dio baseUrl is the
  /// host root, so every REST call writes the full path here.
  Future<ApiResult<UserInfo>> getUserInfo() async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/v1/profile/GetUserInfo',
        data: <String, dynamic>{},
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        return const ApiResult.failure(
          ServerException('Empty body', statusCode: 200),
        );
      }
      return ApiResult.success(UserInfo.fromJson(data));
    } on DioException catch (e) {
      return ApiResult.failure(_extract(e));
    }
  }

  Future<void> signOut() async {
    await SuperTokens.signOut();
  }

  ApiException _extract(DioException e) {
    final mapped = e.error;
    return mapped is ApiException
        ? mapped
        : const UnknownException('Unexpected error');
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.read(dioProvider)),
);
```

- [ ] **Step 2: Verify it analyzes clean**

```bash
flutter analyze lib/core/auth
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/core/auth/auth_repository.dart
git commit -m "feat(auth): AuthRepository.signIn + getUserInfo + signOut"
```

---

### Task B8: Auth providers + bootstrap

**Files:**
- Create: `lib/core/auth/auth_providers.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/core/network/dio_client.dart';
import 'package:supertokens_flutter/supertokens.dart';

/// Currently-selected org id. Null until bootstrap completes successfully.
class CurrentOrgIdController extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? id) => state = id;
  void clear() => state = null;
}

final currentOrgIdProvider =
    NotifierProvider<CurrentOrgIdController, String?>(
  CurrentOrgIdController.new,
);

/// Bridge to the dio client: every interceptor read reads the *current*
/// value (Riverpod handles this automatically because the dio provider
/// has access to `ref`).
final _orgIdBridgeProvider = Provider<String?>((ref) {
  return ref.watch(currentOrgIdProvider);
});

/// One-shot bootstrap: does the user have a valid session? If so, fetch
/// their orgs and pick the first one.
final appBootstrapProvider = FutureProvider<BootstrapResult>((ref) async {
  // wire the bridge first so the dio interceptor reads live state
  ref.read(_orgIdBridgeProvider);

  final hasSession = await SuperTokens.doesSessionExist();
  if (!hasSession) return const BootstrapUnauthed();

  final repo = ref.read(authRepositoryProvider);
  final result = await repo.getUserInfo();
  return switch (result) {
    ApiSuccess<UserInfo>(:final data) => () {
        // Auto-pick first org for MVP; OrgPicker comes in Plan 2.
        // Defer the state mutation to a microtask so we don't mutate another
        // provider's state during this provider's build (Riverpod logs a
        // warning otherwise and edge cases can loop).
        if (data.orgInfos.isNotEmpty) {
          Future.microtask(() {
            ref.read(currentOrgIdProvider.notifier).set(data.orgInfos.first.id);
          });
        }
        return BootstrapAuthed(data);
      }(),
      ApiFailure<UserInfo>() => const BootstrapUnauthed(),
  };
});

sealed class BootstrapResult {
  const BootstrapResult();
}

class BootstrapUnauthed extends BootstrapResult {
  const BootstrapUnauthed();
}

class BootstrapAuthed extends BootstrapResult {
  const BootstrapAuthed(this.user);
  final UserInfo user;
}
```

- [ ] **Step 2: Wire the dio interceptor's bridge — modify `dio_client.dart`**

Replace the `_OrgIdInterceptor` class and `_currentOrgIdValueProvider` line:

```dart
class _OrgIdInterceptor extends Interceptor {
  _OrgIdInterceptor(this._ref);
  final Ref _ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Read the live current-org value. The provider is defined in
    // auth_providers.dart; we import it lazily via the ref.
    final orgId = _ref.read(currentOrgIdProvider);
    if (orgId != null) options.headers['x-org-id'] = orgId;
    handler.next(options);
  }
}
```

And at the top of `dio_client.dart` add:

```dart
import 'package:kuru_mobile/core/auth/auth_providers.dart';
```

Remove the now-unused `_currentOrgIdValueProvider` and `currentOrgIdValueProvider` lines.

- [ ] **Step 3: Verify everything compiles**

```bash
flutter analyze lib/core
```

Expected: no errors.

- [ ] **Step 4: Commit**

```bash
git add lib/core/auth/auth_providers.dart lib/core/network/dio_client.dart
git commit -m "feat(auth): bootstrap provider + currentOrgId + wire dio interceptor"
```

---

## Phase C — Splash + Login + HomeStub

### Task C1: KGlass widget

**Files:**
- Create: `lib/design/widgets/k_glass.dart`

- [ ] **Step 1: Write the file**

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Liquid Glass surface — semi-transparent + heavy blur + saturation.
/// Direct port of the .k-glass CSS rule from kuru-theme.js.
class KGlass extends StatelessWidget {
  const KGlass({
    required this.child,
    super.key,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.padding = EdgeInsets.zero,
    this.solid = false,
    this.blur = 22,
  });

  final Widget child;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final bool solid;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final tint = solid
        ? Color.alphaBlend(
            c.surfaceElev.withValues(alpha: 0.82),
            Colors.transparent,
          )
        : c.glassTint;
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tint,
            borderRadius: borderRadius,
            border: Border.all(
              color: c.textPrimary.withValues(alpha: 0.12),
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/design/widgets/k_glass.dart
git commit -m "feat(design): KGlass widget — Liquid Glass surface"
```

---

### Task C2: KPrimaryBtn with shine animation

**Files:**
- Create: `lib/design/widgets/k_primary_btn.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

enum KBtnTone { primary, success, danger }

class KPrimaryBtn extends StatefulWidget {
  const KPrimaryBtn({
    required this.child,
    super.key,
    this.icon,
    this.onPressed,
    this.fullWidth = false,
    this.tone = KBtnTone.primary,
    this.shine = true,
  });

  final Widget child;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final KBtnTone tone;
  final bool shine;

  @override
  State<KPrimaryBtn> createState() => _KPrimaryBtnState();
}

class _KPrimaryBtnState extends State<KPrimaryBtn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    if (widget.shine && widget.onPressed != null) _ctl.repeat();
  }

  @override
  void didUpdateWidget(KPrimaryBtn old) {
    super.didUpdateWidget(old);
    final shouldShine = widget.shine && widget.onPressed != null;
    if (shouldShine && !_ctl.isAnimating) {
      _ctl.repeat();
    } else if (!shouldShine && _ctl.isAnimating) {
      _ctl.stop();
    }
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  Color _bg(KuruColors c) => switch (widget.tone) {
        KBtnTone.primary => c.primary,
        KBtnTone.success => c.success,
        KBtnTone.danger => c.danger,
      };

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final btn = Material(
      color: _bg(c),
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: c.textInverse, size: 18),
                  child: widget.icon!,
                ),
                const SizedBox(width: 8),
              ],
              DefaultTextStyle.merge(
                style: TextStyle(
                  color: c.textInverse,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: -0.14,
                ),
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );

    final sized = widget.fullWidth ? SizedBox(width: double.infinity, child: btn) : btn;

    if (!widget.shine) return sized;
    return Stack(
      children: [
        sized,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AnimatedBuilder(
                animation: _ctl,
                builder: (context, _) {
                  final pos = -1.2 + _ctl.value * 3.4;
                  return ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment(pos - 0.4, 0),
                      end: Alignment(pos + 0.4, 0),
                      colors: const [
                        Colors.transparent,
                        Color(0x59FFFFFF),
                        Colors.transparent,
                      ],
                    ).createShader(bounds),
                    blendMode: BlendMode.srcATop,
                    child: const SizedBox.expand(),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/design/widgets/k_primary_btn.dart
git commit -m "feat(design): KPrimaryBtn with shine sweep animation"
```

---

### Task C3: KFormField (KGlass-styled input)

**Files:**
- Create: `lib/design/widgets/k_form_field.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/design/widgets/k_glass.dart';

class KFormField extends StatelessWidget {
  const KFormField({
    required this.label,
    required this.controller,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final Widget? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return KGlass(
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(color: c.textMuted, size: 18),
              child: icon!,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: c.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                TextField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  autofillHints: autofillHints,
                  textInputAction: textInputAction,
                  onSubmitted: onSubmitted,
                  style: TextStyle(
                    fontSize: 14,
                    color: c.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/design/widgets/k_form_field.dart
git commit -m "feat(design): KFormField — KGlass-wrapped labelled input"
```

---

### Task C4: AuthBackdrop (animated orbs)

**Files:**
- Create: `lib/design/auth/auth_backdrop.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Three drifting ambient gradient orbs. Direct port of `AuthBackdrop`
/// in design/kuru/project/kuru-screens-1.jsx.
class AuthBackdrop extends StatefulWidget {
  const AuthBackdrop({super.key});

  @override
  State<AuthBackdrop> createState() => _AuthBackdropState();
}

class _AuthBackdropState extends State<AuthBackdrop>
    with TickerProviderStateMixin {
  late final AnimationController _orbA;
  late final AnimationController _orbB;

  @override
  void initState() {
    super.initState();
    _orbA = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    _orbB = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _orbA.dispose();
    _orbB.dispose();
    super.dispose();
  }

  Offset _orbAOffset(double t) {
    if (t < 0.33) {
      final p = t / 0.33;
      return Offset(40 * p, 60 * p);
    } else if (t < 0.66) {
      final p = (t - 0.33) / 0.33;
      return Offset(40 - 70 * p, 60 - 30 * p);
    } else {
      final p = (t - 0.66) / 0.34;
      return Offset(-30 + 30 * p, 30 - 30 * p);
    }
  }

  Offset _orbBOffset(double t) {
    if (t < 0.40) {
      final p = t / 0.40;
      return Offset(-50 * p, -40 * p);
    } else if (t < 0.75) {
      final p = (t - 0.40) / 0.35;
      return Offset(-50 + 70 * p, -40 - 20 * p);
    } else {
      final p = (t - 0.75) / 0.25;
      return Offset(20 - 20 * p, -60 + 60 * p);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return IgnorePointer(
      child: ClipRect(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _orbA,
              builder: (context, _) {
                final off = _orbAOffset(_orbA.value);
                return Positioned(
                  top: -90 + off.dy,
                  left: -60 + off.dx,
                  child: _Orb(color: c.primary, size: 280, opacity: 0.32),
                );
              },
            ),
            AnimatedBuilder(
              animation: _orbB,
              builder: (context, _) {
                final off = _orbBOffset(_orbB.value);
                return Positioned(
                  top: MediaQuery.sizeOf(context).height * 0.40 + off.dy,
                  right: -80 + off.dx,
                  child: _Orb(color: c.secondary, size: 240, opacity: 0.30),
                );
              },
            ),
            AnimatedBuilder(
              animation: _orbA,
              builder: (context, _) {
                final off = _orbAOffset((_orbA.value + 0.28) % 1.0);
                return Positioned(
                  bottom: -100 + off.dy,
                  left: MediaQuery.sizeOf(context).width * 0.18 + off.dx,
                  child: _Orb(color: c.accent500, size: 220, opacity: 0.22),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.color, required this.size, required this.opacity});
  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              Colors.transparent,
            ],
            stops: const [0, 0.65],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/design/auth/auth_backdrop.dart
git commit -m "feat(design): AuthBackdrop with 3 drifting ambient orbs"
```

---

### Task C5: AuthLogo (glow + sparkles)

**Files:**
- Create: `lib/design/auth/auth_logo.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

class AuthLogo extends StatefulWidget {
  const AuthLogo({super.key, this.small = false});
  final bool small;

  @override
  State<AuthLogo> createState() => _AuthLogoState();
}

class _AuthLogoState extends State<AuthLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glow;

  @override
  void initState() {
    super.initState();
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final size = widget.small ? 56.0 : 68.0;
    final radius = widget.small ? 16.0 : 20.0;
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, _) {
        final t = _glow.value;
        return SizedBox(
          width: size + 28,
          height: size + 28,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: [
                    BoxShadow(
                      color: c.ambient1,
                      blurRadius: 24 + 8 * t,
                      offset: Offset(0, 8 + 6 * t),
                    ),
                    if (t < 0.5)
                      BoxShadow(
                        color: c.ambient2.withValues(alpha: 1 - t * 2),
                        spreadRadius: 14 * t,
                        blurRadius: 1,
                      ),
                  ],
                  border: Border.all(
                    color: c.textPrimary.withValues(alpha: 0.14),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/logo.webp', fit: BoxFit.cover),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.auto_awesome,
                  size: 14,
                  color: c.accent500.withValues(alpha: 0.6 + 0.4 * t),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Icon(
                  Icons.auto_awesome,
                  size: 10,
                  color: c.secondary.withValues(alpha: 0.4 + 0.6 * (1 - t)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/design/auth/auth_logo.dart
git commit -m "feat(design): AuthLogo with glow + sparkles"
```

---

### Task C6: SplashScreen

**Files:**
- Create: `lib/features/splash/splash_screen.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/auth/auth_backdrop.dart';
import 'package:kuru_mobile/design/auth/auth_logo.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly trigger bootstrap; the router redirect reads its state.
    ref.watch(appBootstrapProvider);
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const AuthBackdrop(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AuthLogo(),
                const SizedBox(height: 28),
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: c.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l.splashTagline,
                  style: TextStyle(fontSize: 13, color: c.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/splash/splash_screen.dart
git commit -m "feat(splash): SplashScreen triggers bootstrap + shows loading"
```

---

### Task C7: LoginScreen UI (no wiring yet)

**Files:**
- Create: `lib/features/login/login_screen.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/auth/auth_backdrop.dart';
import 'package:kuru_mobile/design/auth/auth_logo.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = true;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // wired in Task C8
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const AuthBackdrop(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AuthLogo(),
                            const SizedBox(height: 18),
                            Text(
                              l.loginTitle,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.9,
                                color: c.textPrimary,
                                height: 1.05,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l.loginSubtitle,
                              style: TextStyle(fontSize: 14, color: c.textMuted),
                            ),
                            const SizedBox(height: 28),
                            KFormField(
                              label: l.fieldEmail,
                              controller: _email,
                              icon: const Icon(Icons.mail_outline),
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 12),
                            KFormField(
                              label: l.fieldPassword,
                              controller: _password,
                              icon: const Icon(Icons.lock_outline),
                              obscureText: true,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _submit(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Checkbox(
                                  value: _remember,
                                  onChanged: (v) =>
                                      setState(() => _remember = v ?? true),
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  l.loginRemember,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: c.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: c.dangerSoft,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: c.danger,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            KPrimaryBtn(
                              fullWidth: true,
                              icon: const Icon(Icons.arrow_outward),
                              onPressed: _submitting ? null : _submit,
                              child: Text(l.loginCta),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${l.loginFooterNoAccount} ',
                        style: TextStyle(fontSize: 13, color: c.textMuted),
                      ),
                      Text(
                        l.loginFooterRegister,
                        style: TextStyle(
                          fontSize: 13,
                          color: c.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/login/login_screen.dart
git commit -m "feat(login): LoginScreen UI (form + AuthBackdrop + AuthLogo)"
```

---

### Task C8: Wire LoginScreen to AuthRepository

**Files:**
- Modify: `lib/features/login/login_screen.dart`

- [ ] **Step 1: Replace `_submit()` with the real implementation**

Replace the placeholder `_submit` method body with:

```dart
Future<void> _submit() async {
  final l = AppLocalizations.of(context);
  final email = _email.text.trim();
  final password = _password.text;
  if (email.isEmpty || password.isEmpty) {
    setState(() => _errorMessage = l.loginErrorBadCredentials);
    return;
  }
  setState(() {
    _submitting = true;
    _errorMessage = null;
  });
  final repo = ref.read(authRepositoryProvider);
  final result = await repo.signIn(email: email, password: password);
  if (!mounted) return;
  switch (result) {
    case ApiSuccess<void>():
      // Re-run bootstrap so router redirects us to home.
      ref.invalidate(appBootstrapProvider);
    case ApiFailure<void>(:final err):
      setState(() {
        _submitting = false;
        _errorMessage = switch (err) {
          UnauthorizedException() => l.loginErrorBadCredentials,
          NetworkException() => l.loginErrorNetwork,
          _ => l.loginErrorGeneric,
        };
      });
  }
}
```

- [ ] **Step 2: Add the imports at the top of `login_screen.dart`**

```dart
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
```

- [ ] **Step 3: Verify analyzer is clean**

```bash
flutter analyze lib/features/login
```

Expected: no errors.

- [ ] **Step 4: Commit**

```bash
git add lib/features/login/login_screen.dart
git commit -m "feat(login): wire form submission to AuthRepository.signIn"
```

---

### Task C9: HomeStubScreen

**Files:**
- Create: `lib/features/home/home_stub_screen.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';

class HomeStubScreen extends ConsumerWidget {
  const HomeStubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final bootstrap = ref.watch(appBootstrapProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: bootstrap.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (state) => state is BootstrapAuthed
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 64, color: c.success),
                      const SizedBox(height: 16),
                      Text(
                        l.homeStubTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l.homeStubBody(
                          state.user.email ?? '?',
                          state.user.orgInfos.isNotEmpty
                              ? state.user.orgInfos.first.name
                              : '(no org)',
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: c.textSecondary),
                      ),
                      const SizedBox(height: 32),
                      KPrimaryBtn(
                        tone: KBtnTone.danger,
                        onPressed: () async {
                          final repo = ref.read(authRepositoryProvider);
                          await repo.signOut();
                          ref.read(currentOrgIdProvider.notifier).clear();
                          ref.invalidate(appBootstrapProvider);
                        },
                        child: Text(l.homeStubLogout),
                      ),
                    ],
                  )
                : const Center(child: Text('No session')),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/home/home_stub_screen.dart
git commit -m "feat(home): HomeStubScreen with greeting + logout"
```

---

### Task C10: Router + redirect + end-to-end run

**Files:**
- Create: `lib/app/router.dart`
- Modify: `lib/app/kuru_app.dart`

- [ ] **Step 1: Write `lib/app/router.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/features/home/home_stub_screen.dart';
import 'package:kuru_mobile/features/login/login_screen.dart';
import 'package:kuru_mobile/features/splash/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final boot = ref.read(appBootstrapProvider);
      final loc = state.matchedLocation;
      return boot.when(
        loading: () => loc == '/splash' ? null : '/splash',
        error: (_, __) => loc == '/login' ? null : '/login',
        data: (result) {
          if (result is BootstrapUnauthed) {
            return loc == '/login' ? null : '/login';
          }
          return loc == '/home' ? null : '/home';
        },
      );
    },
    // Re-evaluate redirect whenever bootstrap state changes.
    refreshListenable: _BootstrapNotifier(ref),
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeStubScreen()),
    ],
  );
});

class _BootstrapNotifier extends ChangeNotifier {
  _BootstrapNotifier(this._ref) {
    _sub = _ref.listen(appBootstrapProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
  late final ProviderSubscription<AsyncValue<BootstrapResult>> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
```

- [ ] **Step 2: Update `lib/app/kuru_app.dart` to use the router**

Replace the body with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/router.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';

class KuruApp extends ConsumerWidget {
  const KuruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = ref.watch(themeControllerProvider);
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Kuru',
      debugShowCheckedModeBanner: false,
      theme: buildKuruTheme(palette, Brightness.light),
      darkTheme: buildKuruTheme(palette, Brightness.dark),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      routerConfig: router,
    );
  }
}
```

- [ ] **Step 3: Run the app end-to-end**

Before this step, start the kuru backend (in another terminal):

```bash
cd /Users/kotomiichinose/Projects/gen-barcode
task fullstack
```

Then run the mobile app:

```bash
cd /Users/kotomiichinose/Projects/kuru-mobile
flutter run -d "iPhone 16" --dart-define=API_BASE_URL=http://localhost:9190
```

Expected behaviour:
1. Splash screen appears with orbs + logo + spinner.
2. After ~0.5–2 s (bootstrap completes), redirected to Login screen (no session yet).
3. Type an email + password that exist in the kuru DB. Tap "Đăng nhập".
4. Bootstrap re-runs; you land on HomeStub showing "Đã đăng nhập" + your email + first org name.
5. Tap "Đăng xuất". You return to Login.

If any step fails, debug with `flutter logs` (the dio + logger interceptors print every request).

- [ ] **Step 4: Commit**

```bash
git add lib/app/router.dart lib/app/kuru_app.dart
git commit -m "feat(router): go_router with auth-state redirect; end-to-end login works"
```

---

### Task C11: AuthRepository unit tests with MockDio

**Files:**
- Create: `test/core/auth/auth_repository_test.dart`

- [ ] **Step 1: Write the tests**

```dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';

class _FakeAdapter extends HttpClientAdapter {
  _FakeAdapter(this._response);
  final ResponseBody _response;
  @override
  void close({bool force = false}) {}
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? body,
    Future<void>? cancelFuture,
  ) async {
    return _response;
  }
}

Dio _dioWith(Map<String, dynamic> json, {int status = 200}) {
  final dio = Dio();
  dio.httpClientAdapter = _FakeAdapter(
    ResponseBody.fromString(
      jsonEncode(json),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    ),
  );
  return dio;
}

void main() {
  group('AuthRepository.signIn', () {
    test('returns success on OK status', () async {
      final dio = _dioWith({'status': 'OK'});
      final repo = AuthRepository(dio);
      final r = await repo.signIn(email: 'a@b.com', password: 'pw');
      expect(r, isA<ApiSuccess<void>>());
    });

    test('returns Unauthorized on WRONG_CREDENTIALS_ERROR', () async {
      final dio = _dioWith({'status': 'WRONG_CREDENTIALS_ERROR'});
      final repo = AuthRepository(dio);
      final r = await repo.signIn(email: 'a@b.com', password: 'wrong');
      expect(r, isA<ApiFailure<void>>());
      expect((r as ApiFailure).err, isA<UnauthorizedException>());
    });
  });
}
```

- [ ] **Step 2: Run the tests**

```bash
flutter test test/core/auth/auth_repository_test.dart
```

Expected: 2 tests pass.

- [ ] **Step 3: Commit**

```bash
git add test/core/auth/auth_repository_test.dart
git commit -m "test(auth): AuthRepository.signIn happy-path + wrong-credentials"
```

---

## Phase D — Smoke Test + Demo

### Task D1: Smoke test for the three screens

**Files:**
- Create: `test/features/splash/splash_screen_test.dart`
- Create: `test/features/login/login_screen_test.dart`
- Create: `test/features/home/home_stub_screen_test.dart`

- [ ] **Step 1: Write `splash_screen_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/splash/splash_screen.dart';

void main() {
  testWidgets('SplashScreen renders logo + spinner', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SplashScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

- [ ] **Step 2: Write `login_screen_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/login/login_screen.dart';

void main() {
  testWidgets('LoginScreen renders email + password fields', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          locale: Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LoginScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Chào mừng trở lại'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsAtLeastNWidgets(1));
  });
}
```

- [ ] **Step 3: Write `home_stub_screen_test.dart`**

The HomeStub watches `appBootstrapProvider`, which calls `SuperTokens.doesSessionExist()`. SuperTokens isn't initialized in the test environment — so we **must** override `appBootstrapProvider` with a fake authed state, otherwise the test throws.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/home/home_stub_screen.dart';

void main() {
  testWidgets('HomeStubScreen renders authenticated state', (tester) async {
    const user = UserInfo(
      email: 'test@x.com',
      orgInfos: [OrgInfo(id: 'o1', name: 'Test Org', role: 'Chủ sở hữu')],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider
              .overrideWith((ref) async => const BootstrapAuthed(user)),
        ],
        child: const MaterialApp(
          locale: Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeStubScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Đã đăng nhập'), findsOneWidget);
  });
}
```

> **Note:** because `UserInfo` and `OrgInfo` are freezed, they have `const` factory constructors. The `const` literal above works because all the field values are themselves `const`.

- [ ] **Step 4: Run all tests**

```bash
flutter test
```

Expected: all tests pass (4 theme + 4 ApiResult + 2 AuthRepository + 3 smoke = 13).

- [ ] **Step 5: Commit**

```bash
git add test/features/
git commit -m "test: smoke tests for Splash, Login, HomeStub screens"
```

---

### Task D2: Final analyze + demo recording

- [ ] **Step 1: Make sure analyzer is clean**

```bash
flutter analyze
```

Expected: 0 issues (or only acknowledged ones in generated files).

- [ ] **Step 2: Run the full test suite**

```bash
flutter test
```

Expected: all green.

- [ ] **Step 3: Final E2E manual demo**

```bash
flutter run -d "iPhone 16" --dart-define=API_BASE_URL=http://localhost:9190
```

Manually verify the flow described in Task C10 Step 3 still works.

- [ ] **Step 4: Tag the commit**

```bash
git tag -a v0.1.0-identity-mvp -m "Identity MVP — login flow works end-to-end"
```

- [ ] **Step 5: Confirm in the terminal**

```bash
git log --oneline | head -30
git tag --list
```

Expected: a tidy log of ~26 commits ending in the new tag.

---

## Self-Review Notes

Spec coverage check (spec sections → plan tasks):
- §1 Goals — covered by Tasks A1–D2 (whole plan)
- §3 Navigation Flow — partial: `/splash`, `/login`, `/home` branches covered (C10). The orgs-list / register branches deferred to Plan 2.
- §4 Tech Stack — A1 + B4 + B5 + B7 + theme tasks.
- §5 Theme System — A3 + A4 + A5.
- §6.1 Splash — C6.
- §6.3 Login — C7 + C8.
- §6.7 HomeStub — C9.
- §7 Auth Flow — B7 + B8 + C10.
- §8 i18n — A7.
- §9 Backend Dependencies — handled by tasks B5 (SuperTokens header mode) and B7 (AuthRepository methods).
- §10 Testing — B3 (ApiResult), C11 (AuthRepository), D1 (smoke tests), Task A4 step 2 (palette golden).

Spec sections NOT covered (deferred to Plan 2): §6.2 Onboarding, §6.4 Register, §6.5 CreateOrg, §6.6 OrgPicker.

Type / name consistency: `BootstrapResult` is sealed with `BootstrapUnauthed` + `BootstrapAuthed` everywhere. `currentOrgIdProvider` is the single source of truth (defined in `auth_providers.dart`, read by `dio_client.dart`).

No "TBD"s, no "add appropriate error handling", no "similar to Task N" — every step has full code or full commands.
