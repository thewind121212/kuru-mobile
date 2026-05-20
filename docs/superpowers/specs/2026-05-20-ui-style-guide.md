# Kuru-mobile UI Style Guide — content screens

**Status:** Canonical reference as of 2026-05-20. Settings module is the reference implementation. Every content-screen UI must match this guide.

**Reference image:** the Structured app's settings screen (`/Users/kotomiichinose/Downloads/Ảnh màn hình 2026-05-20 lúc 08.45.57.png`) — soft pastel iOS-native feel, generous whitespace, no harsh borders. The kuru Settings module ports that aesthetic into the indigo brand palette.

**Out of scope:** Auth, onboarding, login, register, TOTP, create-org, org-picker. Those screens use the glass aesthetic and are intentionally different. Do NOT apply this guide to them.

---

## 1. Aesthetic principles

1. **iOS-native feel.** Mobile-first. Large title at the top, scroll-away. No persistent app-bar title.
2. **Generous breathing room.** 24h horizontal page padding, 18+vp between sections, 12vp row padding inside cards.
3. **Soft pastel accents.** Icon tints are desaturated (10-15% alpha against white). No 100%-saturation primaries on row icons.
4. **No harsh borders.** Group cards use fill + radius, NOT a 1px outline. Rely on the very-light page background to make cards float.
5. **Hairline dividers only.** Row separators inside a group card are 0.5px, indented to align past the leading icon.
6. **Lowercase, sentence-case headers.** "Bảo mật", not "BẢO MẬT". Headers sit OUTSIDE the group card in muted gray.
7. **Strong title typography.** Large iOS-style 32sp / 800w / -0.8 letter-spacing for the screen title.

---

## 2. Token reference

### 2.1 Typography

| Use | Size | Weight | Letter-spacing | Color |
|---|---|---|---|---|
| Screen title (iOS large) | 32 | 800 | -0.8 | `c.textPrimary` |
| Section header (above card) | 13 | 500 | 0 | `c.textMuted` |
| List row label | 15 | 500 | 0 | `c.textPrimary` |
| List row subtitle / trailing helper | 14 | 400 | 0 | `c.textMuted` |
| Hero name | 17 | 700 | -0.2 | white |
| Hero secondary line | 13 | 400 | 0 | `white@85` |
| Body | 14 | 400 | 0 | `c.textPrimary` |
| Badge / chip | 12 | 500 | 0 | varies |

### 2.2 Radius

- 10 — leading icon square (slightly rounded)
- 12 — inputs, buttons
- 18 — group cards, hero card
- 20 — hero card (when isolated)
- 999 — pill badges, switches, circle avatars

Do not invent new radii. Always pick from this set.

### 2.3 Spacing

- Page horizontal padding: 24 around title, 16 around group cards (cards inset slightly from the title)
- Between sections: 18-22vp
- Between header label and group card: 10vp
- Row internal padding: `EdgeInsets.symmetric(horizontal: 14, vertical: 12)`
- Hero internal padding: 18 all sides
- Leading icon → label gap: 14

### 2.4 Icon tint palette (use these exact values)

Pull from this palette — do NOT use saturated primaries on row icons:

```dart
const _indigoTint  = (bg: Color(0xFFEEF0FF), fg: Color(0xFF6366F1));
const _amberTint   = (bg: Color(0xFFFEF6E5), fg: Color(0xFFD97706));
const _emeraldTint = (bg: Color(0xFFE6F7F0), fg: Color(0xFF10B981));
const _violetTint  = (bg: Color(0xFFF1ECFB), fg: Color(0xFF8B5CF6));
const _tealTint    = (bg: Color(0xFFE6F4F5), fg: Color(0xFF14B8A6));
const _blueTint    = (bg: Color(0xFFE7F1FB), fg: Color(0xFF3B82F6));
const _roseTint    = (bg: Color(0xFFFBE9EC), fg: Color(0xFFE11D48));
const _slateTint   = (bg: Color(0xFFEFF1F4), fg: Color(0xFF64748B));
```

Pick semantic associations:
- **Indigo** — primary actions, keys, identity
- **Amber** — security warnings, 2FA, important
- **Emerald** — biometric, success, enabled state
- **Violet** — geography, organization, location
- **Teal** — appearance, theme
- **Blue** — language, network, sync
- **Rose** — destructive, sign-out, delete
- **Slate** — neutral / informational

---

## 3. Component patterns

### 3.1 Screen template

**Two patterns — pick by stack depth:**

- **Tab-root screen** (Settings home, Catalog launcher, Brands list, Categories list, Home overview) — use the inline 32sp/800w title at the top of the body, **no AppBar** (or AppBar with no title; only used for status-bar padding). Adopts the iOS "Large Title" idiom.
- **Pushed detail screen** (Profile, Security, Store, Appearance, Category detail, any other screen reached by `context.push`) — use a Material AppBar with `centerTitle: true`, `backgroundColor: c.pageBg`, `elevation: 0`, `scrolledUnderElevation: 0`, and `title: Text(name, style: 17/700, color: c.textPrimary)`. **Do not render an inline 32sp title in the body.**

Rationale: matches iOS HIG. Root = large landmark title (orients user inside a tab). Pushed child = compact centered title (back arrow on the left does most of the orienting).

#### Tab-root template

```dart
return Scaffold(
  backgroundColor: c.pageBg,
  body: SafeArea(
    child: ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, 18),
          child: Text(
            'Screen title',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
        ),
        // ... KSettingsSection / KSettingsHero / etc.
      ],
    ),
  ),
);
```

#### Pushed detail template

Every pushed content screen follows this skeleton:

```dart
return Scaffold(
  backgroundColor: c.pageBg,
  appBar: AppBar(
    backgroundColor: c.pageBg,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    leading: const BackButton(),
    title: Text(
      'Screen title',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: c.textPrimary,
      ),
    ),
  ),
  body: SafeArea(
    top: false,                   // AppBar already handles top inset
    child: ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 32),
      children: [
        // ... KSettingsSection / sub-content. NO inline 32sp title here.
      ],
    ),
  ),
);
```

### 3.2 Section card (`KSettingsSection`)

Already in the design system. Renders:

- A header label outside the card (sentence-case, gray, 13/500).
- A `Container` with `borderRadius: 18`, `color: c.surfaceElev`, NO border.
- Children separated by 0.5-thickness `Divider`s indented 64px from the left (past the icon).

Pass `header: ''` for the destructive sign-out group at the bottom — section skips the label but keeps the card.

### 3.3 List row (`KSettingsRow`)

Reuse — do NOT roll your own row in screens. Props: `leadingIcon`, `iconBackground`, `iconColor`, `label`, `trailingText?`, `trailingBadge?`, `labelColor?`, `showChevron`, `onTap`.

If you need a trailing widget more complex than a string (toggle, badge, custom), use `trailingBadge`. Toggles use `KSwitchRow` instead.

### 3.4 Hero card (`KSettingsHero`)

Used at the top of the Settings home screen. Soft-alpha indigo gradient (`primary@88` → `primary@66`), white avatar tile (translucent fill), 20-radius, white text, chip for org/role.

If you need a hero for a different screen (e.g. Profile, account upgrade prompt), build a new variant in `lib/design/core/layout/` rather than overloading `KSettingsHero`. Keep the same visual treatment (soft gradient, generous padding, rounded chip for tags).

### 3.5 Modal sheets (`KModalSheet`)

Already canonical. Bottom sheet, 24-radius top corners, kuru handle bar, optional title + footer with Cancel + Confirm. The body builder gets a context that can pop with a typed result. Do NOT use Material `AlertDialog` for create/edit flows on mobile.

For the body content:
- Keep it scrollable — assume the keyboard will eat space.
- Use `KFormField` for inputs (mirrors the auth glass field but inside a flat card).
- Use a `FilledButton` for the body-local Confirm if you don't want the footer slot.

### 3.6 Toasts (`KNotify`)

- **Success / info / warning** — top-right toastification toast, auto-dismiss 4s.
- **Network error** — bottom SnackBar with a retry action (`onRetry:` required).
- **Field-level error** — `KFormField.errorText`, NOT a toast.

Toast color tokens (in `KNotify._toast`): `success`, `warning`, `danger`, `primary`, all read from `kuruColors`. Do not pass custom colors at the call site.

Field-level errors are visually distinct: red text under the field, no banner shift. Anything that's a server validation result the user can correct (wrong password, invalid email, taken name, too-long field) belongs in `KFormField.errorText`, not a toast.

### 3.7 Catalog list row (`KListRow`)

Used by Catalog screens (brands, categories, products) — NOT by Settings. KListRow is more generic: leading widget, title, optional subtitle, optional trailing widget, tap + long-press. Visual treatment should match the new aesthetic:

- 18-radius container, `c.surfaceElev` fill, no outer border.
- Inset (16h margin) just like KSettingsSection.
- Title 15/500, subtitle 13/400, both on the same column with 2-vp gap.
- Leading widget: 40-44 square, rounded 10, soft tinted bg (from the icon palette above when it's an icon; or the actual category color when rendering a category).
- Trailing: keep the 3-dot button compact, no border.

When refactoring KListRow consumers, replace any hand-rolled wrapping `Container(decoration: BoxDecoration(border: Border.all(...)))` — they are no longer needed.

### 3.8 Category-specific patterns

Categories show a nested tree. The nesting indicator should be:

- A thin left rail (1px) in `c.borderSoft`, indented 16px per level.
- Level-2 rows: indent the leading icon column by 16; do NOT shrink the icon.
- Use the category's saved color as the icon background tint (lighten by mixing with white at ~85% alpha), and the saved color at full saturation for the icon glyph.
- Trailing badge for child-count: 12sp pill in `c.borderSoft` background.

Do NOT use box-shadows, chevrons-as-tree-bullets, or accordion-style row collapses for nesting — that's web-modal IA, not mobile-native.

### 3.9 Buttons

- Primary action: `KPrimaryBtn(fullWidth: true, child: ...)`. The button is gradient indigo with a subtle shine; child is plain `Text` styled white/700.
- Secondary action: `KSecondaryBtn`. Outline-only, indigo border, indigo label.
- Danger action: `KDangerBtn` (filled red) for destructive within forms; for row-level destructive use a `KSettingsRow` with `labelColor: rose`.

Don't use Flutter's stock `ElevatedButton` or `OutlinedButton` for primary CTAs — they don't match the gradient + shine treatment. The exception is body buttons inside sheets, where `FilledButton` is fine if it's already inside a `KModalSheet` body.

### 3.10 Form fields (`KFormField`)

Already canonical. Same widget across auth + content screens. No `onChanged` callback — wire a `TextEditingController` listener in `initState` to clear errors as the user types. Errors render in an animated reserved slot, no layout jank.

---

## 4. Do / Don't matrix

| Do | Don't |
|---|---|
| Use `c.pageBg` as scaffold background everywhere | Use a stark white surface that has no contrast against cards |
| Render the screen title as an inline 32sp bold heading inside the body's `ListView` | Render the title in the AppBar (use AppBar only for the back button + status-bar spacing) |
| Use 0.5-thickness `Divider`s indented 64px inside a group card | Use full-width 1px borders/dividers; they look like a heavy form |
| Use the icon palette in §2.4 verbatim | Pick arbitrary saturated colors per call site |
| Drop the section header to `''` to hide it while keeping the group card | Hand-roll a separate "destructive group" widget |
| Match toast tone to severity (success / info / warning / networkError) | Use a single "generic" toast for everything |
| Lift inline-edit forms into `KModalSheet` bodies | Push to a full-screen route for a single-field change |
| Use `KFormField` everywhere a TextEditingController feeds an input | Use Material `TextField` or `TextFormField` directly on a content screen |
| Read every color from `kuruColors(context)` | Hardcode hex unless it's the §2.4 icon palette |

---

## 5. Files this guide governs

```
lib/design/core/catalog/k_settings_row.dart       ← canonical row
lib/design/core/catalog/k_avatar.dart             ← unchanged
lib/design/core/catalog/k_list_row.dart           ← review against §3.7
lib/design/core/catalog/k_category_card.dart      ← review against §3.8
lib/design/core/layout/k_page_header.dart         ← use only when an inline title isn't enough
lib/design/core/layout/k_settings_hero.dart       ← canonical hero
lib/design/core/layout/k_settings_section.dart    ← canonical group card
lib/design/core/input/k_switch_row.dart           ← canonical toggle row
lib/design/core/modal/*.dart                      ← canonical sheets
lib/design/core/feedback/*.dart                   ← canonical loading / empty states
lib/core/feedback/k_notify.dart                   ← canonical toast wrapper
lib/features/settings/                            ← reference implementation
```

Anything in `lib/features/catalog/` or future content modules must be refactored to use these widgets the way Settings uses them.

---

## 6. Migration checklist (existing content screens)

When you touch a content screen during normal work:

1. Swap any hand-rolled `Container(decoration: BoxDecoration(border: ...))` row to `KSettingsRow` or `KListRow`.
2. Hoist screen titles out of the `AppBar` and into an inline 32sp `Text` at the top of the body.
3. Replace UPPERCASE section labels with sentence-case Vietnamese (`'Bảo mật'`, `'Chung'`, `'Tính năng'`, …).
4. Drop outer 1px borders on group cards. Use radius + `surfaceElev` only.
5. Repaint row leading icons using §2.4 tints. Match the semantic table.
6. Convert any centered `AlertDialog` to `KModalSheet` (or `KConfirmDialog` for yes/no).
7. Verify the page renders well on iPhone 15 Pro Max (390pt wide) — that's the reference device.

When you create a brand new content screen, follow §3.1 verbatim.

---

## 7. Reference implementation pointer

The Settings module on branch `feat/settings-and-biometric` (tag `v0.4.0-settings-biometric`) is the canonical implementation. When in doubt, copy the pattern from:

- `lib/features/settings/settings_home_screen.dart`
- `lib/features/settings/security_screen.dart`
- `lib/features/settings/appearance_screen.dart`

For sheets, copy from:

- `lib/features/settings/sheets/change_password_sheet.dart`
- `lib/features/settings/sheets/avatar_picker_sheet.dart`

For toasts, the call sites in `security_screen.dart` (warning + success), `store_screen.dart` (success + networkError), and `profile_screen.dart` (networkError) cover the full pattern.

---

## 8. Out-of-scope reminders

- **Auth glass surfaces (Login, Register, TOTP, CreateOrg, OrgPicker, Onboarding)** — already match the brand. Do not touch unless explicitly asked.
- **Splash screen** — visual chrome only, not relevant here.
- **HomeStubScreen** — placeholder until the real Overview lands. Refactor it when you build the real Home; until then, leave alone.
