---
name: kuru-flutter-review
description: Use when reviewing Flutter/Dart code in kuru-mobile — including phrases like "review my code", "review this widget", "audit this PR", "check this screen", "code review", "ready to merge?", or before commits and PR creation. Project-tailored checklist for Riverpod + GoRouter + freezed + dio + ARB + the glass/flat design split + the kuru BE error contract.
---

# kuru-mobile Flutter code review

Adapted from the library-agnostic Flutter/Dart code review checklist at `affaan-m/everything-claude-code/skills/flutter-dart-code-review`, with every rule mapped to this project's stack and the conventions documented in `CLAUDE.md`.

## Two-stage workflow

```
[review request] → Stage 1: superpowers:requesting-code-review
                       (figures out scope, dispatches review subagent
                        with verification gates and rigorous standards)
                       ↓
                   Stage 2: layer the kuru-mobile checklist below
                       (glass vs flat, KNotify, x-org-id, BE error
                        contract, analyzer trip-wires, test patterns)
                       ↓
                   Report findings — verbatim error messages, file:line
```

**REQUIRED FIRST STEP:** Invoke `superpowers:requesting-code-review` before applying anything in this file. That skill owns the workflow (scoping the diff, dispatching the subagent, verification before claims). This skill provides the *content* of the review, not the workflow.

**REQUIRED COMPANION:** When implementing fixes that came out of the review, invoke `superpowers:receiving-code-review` — it has the right discipline for not performatively agreeing or blindly applying suggestions.

**Also relevant:** `mobile-design` skill (already in this repo) covers widget/test details. If the review touches `lib/design/` or `lib/features/`, read that skill too.

## When to use this skill

- The user asks for a code review, audit, "is this ready?", or feedback on a diff
- Before creating a PR, before committing a feature
- After implementing a plan from `docs/superpowers/plans/`
- When reviewing someone else's PR against this repo
- When asked to verify a change won't regress identity flow, theme, or l10n

**Do NOT use this skill for:**
- Generic Flutter questions unrelated to this codebase (use the upstream skill instead)
- Pure design feedback on visuals (that's a human call, not a checklist)

## Pre-review gates (run these FIRST, fail fast)

```bash
flutter analyze        # MUST exit 0 — info-level lints fail CI
flutter test           # MUST be all green
```

If either fails, stop the review and report the failure. Do not proceed to checklist items — the diff isn't ready for review.

Per `CLAUDE.md`: `--fatal-warnings` is redundant; plain `flutter analyze` already exits non-zero on info lints.

## Section 1 — Project structure (kuru-mobile-specific)

- [ ] New code goes under the correct top-level dir:
  - `lib/app/` — app shell (router, theme). **Don't add business logic here.**
  - `lib/core/<topic>/` — cross-cutting: auth, env, feedback, i18n, logging, network, validators
  - `lib/design/auth/` — auth chrome (AuthBackdrop, AuthLogo)
  - `lib/design/widgets/` — GLASS aesthetic widgets
  - `lib/design/core/<group>/` — FLAT aesthetic widgets (`layout/`, `input/`, `feedback/`, `modal/`, `catalog/`)
  - `lib/features/<feature>/` — one folder per screen group
- [ ] No business logic in `lib/design/` widgets — they take props/callbacks only
- [ ] No HTTP / dio calls outside `lib/core/network/` and `lib/core/auth/AuthRepository`
- [ ] No widget code imports from `lib/core/` should reach into another feature's internals
- [ ] `pubspec.yaml` changes — does the comment explain *why* a non-pub.dev ref is used? (See the supertokens_flutter git ref reason already there.)

## Section 2 — Dart language (project lint set is strict)

The full upstream Dart pitfall list applies. These are the ones that recur here and the analyzer **will** catch (info-level → CI fail):

| Pitfall | This project's fix |
|---|---|
| `print()` in production | Use `log` from `lib/core/logging/` (single `package:logger` instance) |
| `dynamic` / missing types | Strict mode is on — analyzer flags this; don't silence |
| `catch (e)` without `on` | `on Object catch (_)` or specific exception; never bare `catch` |
| Catching `Error` subtypes | Don't — they signal bugs |
| Fire-and-forget `Future` | `unawaited(...)` from `dart:async` (recurring in tests calling `showK*`) |
| `var` where `final` works | `prefer_final_locals` / `prefer_final_fields` — analyzer enforces |
| Relative imports | Always `package:kuru_mobile/...` |
| Mutable collections in public APIs | Return `List.unmodifiable(...)` or use freezed |
| `late` overuse | Prefer nullable + null-check, or constructor init |
| Single-use DTO classes | Use Dart 3 records `(String, int)` |
| String concat in loop | `StringBuffer` |

Project-specific analyzer trip-wires (from `mobile-design` skill — repeated here as reviewer reference):

- `lines_longer_than_80_chars` — wrap long `const EdgeInsets.symmetric(...)` lines
- `no_leading_underscores_for_local_identifiers` — in tests, `Widget wrap(...)`, never `_wrap`
- `avoid_redundant_argument_values` — drop default values (`width: 1` on `Border.all`, `CrossAxisAlignment.center` on Row but NOT on Column)
- `document_ignores` — comment goes **above** `// ignore_for_file:`
- `always_put_required_named_parameters_first` — required params before `super.key`
- `prefer_const_constructors` — use `const` wherever possible

## Section 3 — Widgets and design system

### Glass vs flat (CRITICAL — flag any mixing)

- [ ] Auth / onboarding / identity-flow screen? → uses `lib/design/widgets/` (KGlass, KPrimaryBtn, KFormField, KCheckbox, KStepDots, KOtpInput)
- [ ] Catalog / Settings / Home / any content screen? → uses `lib/design/core/` (KSearchBar, KTextField, KSecondaryBtn, KIconBtn, KSpinner, KSkeleton, KEmptyState, KBadge, KListRow, KCategoryCard, KPageHeader, K*Sheet, K*Dialog, etc.)
- [ ] Same screen does NOT mix glass and flat
- [ ] New widget — does it belong in `lib/design/` (reusable) or `lib/features/<x>/widgets/` (one-off)?

### Theme tokens (no hardcoded colors / sizes)

- [ ] Colors via `Theme.of(context).extension<KuruColors>()!` — never `Color(0xff...)` or `Colors.red` in widget code
- [ ] Text styles via `Theme.of(context).textTheme.*` — never inline `TextStyle(fontSize: 14)`
- [ ] Both dark + light + purple + indigo verified (4 palettes, default = indigo)
- [ ] Spacing constants used consistently — flag magic numbers

### Const / keys / rebuild discipline

- [ ] `const` constructors used wherever fields are final
- [ ] `ValueKey` on items in `ListView.builder` for reorder/animation safety
- [ ] No `UniqueKey()` in `build()`
- [ ] `setState()` localized — not at the screen root for a leaf widget
- [ ] No async work, no I/O, no `.listen()` in `build()`

### Build complexity

- [ ] Single widget `build()` ≤ ~100 lines
- [ ] Private `_buildX()` methods that return `Widget` → extract to a real widget class (enables `const` + element reuse)
- [ ] `StatelessWidget` over `StatefulWidget` when no mutable state

## Section 4 — State management (Riverpod)

This project uses `flutter_riverpod` + `riverpod_annotation` exclusively.

- [ ] Business logic lives in a `Notifier` / `AsyncNotifier` / provider — never in the widget
- [ ] Providers depend on providers via `ref.watch` / `ref.read` — that's the Riverpod idiom and is fine (flag only circular or absurdly long chains)
- [ ] No singletons or `static` mutable state — everything through `ProviderScope`
- [ ] Immutable state via freezed (`@freezed`) + `copyWith` — never field mutation
- [ ] `ApiResult<T>` sealed class used for async outcomes — NOT `bool isLoading + bool hasError`
- [ ] Every `ref.watch` is the narrowest provider that satisfies the consumer — use `.select(...)` if only one field matters
- [ ] `ref.listen` for side effects (toasts, navigation) — never put navigation in a provider body
- [ ] `BuildContext` is **NOT** stored in providers, services, or static fields
- [ ] After `await`, code that uses `context` checks `context.mounted` (Flutter 3.7+)

### Bootstrap + org-id synchronization (project-specific, recurring bug source)

- [ ] After CreateStore / OrgPicker selection: `currentOrgIdProvider` is set **synchronously** before `ref.invalidate(appBootstrapProvider)` — otherwise the next request races and goes out without `x-org-id`
- [ ] `appBootstrapProvider` is invalidated (not refreshed) after sign-out / org switch
- [ ] Sealed `BootstrapResult` variants exhaustively handled in the router redirect

## Section 5 — Network / dio / BE contract (kuru-mobile-specific, common burns)

### Request shape

- [ ] All new authed endpoints carry `x-org-id` via the dio interceptor — don't add it manually
- [ ] dio `baseUrl` = host root; each call writes its own prefix (`/auth/...` vs `/api/v1/...`)
- [ ] `--dart-define=API_BASE_URL=...` is honored — no hardcoded `http://localhost:9190`

### Response parsing

- [ ] Every parser handles **both** HTTP 200 and HTTP 201 (CreateStore returns 201 — `openapi/store.openapi.json` lies, the handler in `be/core/api/store/store.routes.ts` is truth)
- [ ] The wire shape is the universal kuru BE shape:
  - Success: `{ "success": true, "data": {...}, "timestamp": "..." }`
  - Error: `{ "success": false, "error": { "message": "...", "code": "..." }, "timestamp": "..." }`
- [ ] When in doubt about a field name (e.g. CreateStore returns `orgId`, NOT `storeId`), the order of truth is:
  1. `../gen-barcode/be/core/dto/<module>/<thing>.dto.ts` (Zod rules)
  2. `../gen-barcode/be/core/api/<module>/<module>.routes.ts` (the handler)
  3. `../gen-barcode/be/types/<module>.d.ts` (generated TS response type)
  4. `../gen-barcode/be/core/services/<module>.service.ts` (resData)
  5. **THEN** maybe `openapi/<module>.openapi.json` — never trust this alone

### Error handling

- [ ] 4xx → `error.message` is user-readable; surface **verbatim** via `KFormField.errorText` (field-level) or `KNotify.networkError` (network/retriable)
- [ ] 5xx → never surface raw `error.message`; show localized fallback ("Đã có lỗi xảy ra")
- [ ] 400 = validation/business error — handle as field error
- [ ] 401 → force `signOut()` + `ref.invalidate(appBootstrapProvider)` → router routes to /login
- [ ] 429 with `code: "RATE_LIMITED"` → `KNotify.warning` with back-off message
- [ ] HTTP 500 with body containing `"Session does not exist"` → treat same as 401 (BE bug — mitigation lives in `AuthRepository._interpretMfaError`; replicate the pattern for any new MFA-adjacent endpoint)
- [ ] VerifyTotpCode / UseRecoveryCode return HTTP **400** for wrong codes (not `200 + verified:false`) — mirror `_interpretMfaError`'s treatment

## Section 6 — UX patterns (use the project's wrappers)

| Need | Use |
|---|---|
| Field validation error (wrong password, taken email) | `KFormField.errorText: '...'` — red border + reserved animated slot, no layout shift |
| Network down / 5xx | `KNotify.networkError(context, msg, onRetry: _submit)` — bottom SnackBar with retry |
| Success after save / sign-out | `KNotify.success(context, msg)` — top-right auto-dismissing toast |
| Info / sync status | `KNotify.info(context, msg)` |
| Rate-limited warning | `KNotify.warning(context, msg)` |
| 401 mid-flow | toast → `signOut()` + invalidate bootstrap |

- [ ] Toasts are **never** used for errors users need to read (they auto-dismiss)
- [ ] Modal helpers picked correctly: `showKModalSheet` for forms, `showKConfirmDialog` for delete/sign-out, `showKActionSheet` for action lists, `KPopupMenu` (super_context_menu) for long-press menus
- [ ] `showKIconPicker` consumers fallback to `TablerIcons.layout_grid` when `resolveIconName(name) == null`

## Section 7 — i18n (vi canonical, en mirror)

- [ ] No hardcoded user-visible strings in widgets — every string goes through `AppLocalizations.of(context)`
- [ ] `l10n.yaml` lives at project root (NOT under `lib/`)
- [ ] Both `lib/core/i18n/app_vi.arb` and `app_en.arb` have the key
- [ ] `vi` translation is the **canonical** copy (project is Vietnam-first); `en` is the mirror
- [ ] ICU plurals / placeholders typed properly in ARB
- [ ] Date / number / currency formatting goes through `intl` — not manual `.toString()`
- [ ] No string concat for localized templates — use parameterized messages

## Section 8 — Routing (GoRouter with auth redirect)

- [ ] New routes added to `lib/app/router.dart`
- [ ] Redirect logic for the route accounts for each `BootstrapResult` variant
- [ ] Route paths are constants (the file already does this — flag magic strings)
- [ ] Auth-gated screens are unreachable from `BootstrapAnon` / `BootstrapNeedsTotp` / `BootstrapNoOrg`
- [ ] Deep links validated and sanitized before navigation
- [ ] No imperative `Navigator.push` mixed with GoRouter — use `context.go` / `context.push`

## Section 9 — Performance

- [ ] No sorting / filtering / mapping of large collections inside `build()`
- [ ] `ListView.builder` / `GridView.builder` for dynamic lists — concrete `ListView(children: [...])` only for tiny static lists
- [ ] `const` widgets stop rebuild propagation through subtrees
- [ ] `RepaintBoundary` around complex independently-painting subtrees
- [ ] Image assets given `cacheWidth` / `cacheHeight` at display size
- [ ] `MediaQuery.sizeOf(context)` (specific) instead of `MediaQuery.of(context).size` (full subscription)

## Section 10 — Tests

- [ ] New widget → has a widget test in `test/design/` or `test/features/`
- [ ] New state notifier → has a unit test
- [ ] Identity-flow change → has at least one bootstrap-state test using the `appBootstrapProvider.overrideWith(...)` pattern
- [ ] Tests using `KPrimaryBtn`, `KSpinner`, `KSkeleton` **do not** call `pumpAndSettle()` — animations never settle. Use `pump()` + `pump(Duration(milliseconds: 50))` to step through microtasks
- [ ] Tests for `KModalSheet` / `KConfirmDialog` confirm flows use the same `pump` step pattern during the awaited `onConfirm`
- [ ] No `_wrap` helper — use `Widget wrap(Widget child) => MaterialApp(...)` (no leading underscore)
- [ ] `unawaited(showK*(...))` for fire-and-forget modal calls in tests
- [ ] After the change: `flutter test` passes and total ≥ 136 tests (don't accidentally delete coverage)

## Section 11 — Debug-only features (safety)

- [ ] Debug entry points (long-press logo to replay onboarding, double-tap logo to open `CoreDesignDemoScreen`) are wrapped in `kDebugMode`
- [ ] `kDebugMode` is a compile-time `const bool` so tree-shaker drops the import in release
- [ ] If adding a debug-only screen: confirm `flutter build ios --release --analyze-size` does NOT include the file in the size report

## Section 12 — Native plugins

If `pubspec.yaml` adds a plugin with native code (Rust, Swift, Kotlin, .a/.framework):

- [ ] Reviewer confirms the implementer ran:
  ```bash
  flutter clean && flutter pub get && cd ios && pod install && cd .. && flutter run
  ```
- [ ] Hot-reload / hot-restart does NOT register new native plugins — flag any reviewer claim of "works on hot reload"
- [ ] Minimum iOS version in `ios/Podfile` covers the plugin's requirement (super_context_menu needs iOS 13+ — already set)
- [ ] `ios/Podfile.lock` change reviewed for unexpected upgrades

## Section 13 — Security

- [ ] No secrets / API keys in Dart source — use `--dart-define` (already pattern for `API_BASE_URL`)
- [ ] No new files in `.env` style storage committed
- [ ] Session tokens stored only via `supertokens_flutter` header-mode session (NOT manual `SharedPreferences`)
- [ ] User input that flows into deep links is validated
- [ ] HTTPS-only in production builds (localhost OK for dev `API_BASE_URL`)
- [ ] No sensitive data in `log.d(...)` / `log.i(...)` (tokens, passwords, full PII)

## Section 14 — Accessibility

- [ ] Tappable targets ≥ 48×48 logical pixels
- [ ] `Semantics` label on icons that have no visible text
- [ ] Contrast ≥ 4.5:1 verified in both dark and light, both palettes
- [ ] No no-op `onPressed` callbacks — either it does something, or the button is disabled
- [ ] Text scales with system font size (no fixed `Text(..., textScaler: TextScaler.noScaling)`)
- [ ] Focus order matches visual reading order

## Section 15 — Dependencies

- [ ] New `pubspec.yaml` dependency justified — pub points / popularity / last publish date checked
- [ ] Version uses `^` caret unless a comment explains a pin (like supertokens_flutter's git ref)
- [ ] No new `dependency_overrides` without an issue link / comment
- [ ] License compatible with project (see `vgv-ai-flutter-plugin:license-compliance` skill if unsure)
- [ ] `flutter pub outdated` not regressed in a way that adds known-vulnerable versions

---

## Quick-reference: "is this PR ready?" checklist

Run in order; first failure stops the chain.

1. `flutter analyze` exits 0 ✅
2. `flutter test` all green, count ≥ baseline ✅
3. New widget/screen in correct dir + correct aesthetic (glass vs flat) ✅
4. Theme tokens used (no hardcoded colors / sizes) ✅
5. State immutable + freezed + sealed async states ✅
6. Network: x-org-id auto-attached, handles 200/201, BE error contract respected ✅
7. UX errors via KFormField or KNotify (not raw toast) ✅
8. New strings in BOTH `app_vi.arb` and `app_en.arb` (vi canonical) ✅
9. Router redirect handles every `BootstrapResult` variant ✅
10. Tests added (no `pumpAndSettle` for animated widgets) ✅
11. No `kDebugMode` features leaked into release path ✅
12. If new native plugin: `pod install` + cold restart documented ✅

## Report format

After running the review, report findings like this:

```
Stage 1 (workflow): [what superpowers:requesting-code-review did — scope, subagent dispatch]
Stage 2 (kuru-mobile checklist):

BLOCKERS (must fix before merge):
- lib/features/foo/foo_screen.dart:42 — hardcoded Color(0xff7c3aed); use KuruColors.accent
- lib/core/network/foo_repository.dart:88 — parses only HTTP 200, will fail on 201

WARNINGS (recommend fixing):
- test/features/foo/foo_screen_test.dart:30 — uses pumpAndSettle() on a KPrimaryBtn child

NITS (optional):
- lib/features/foo/foo_state.dart:12 — could use Dart 3 record instead of single-use DTO

PASSED:
- analyzer 0 issues, 136 tests green
- no glass/flat mixing
- arb files in sync
```

Be specific: file path + line + the exact rule that's violated. Don't generalize. Don't downgrade blockers to warnings to avoid friction — `superpowers:receiving-code-review` is the user's defense against blind agreement; let them disagree if they want.

---

## Sources

- Adapted from [affaan-m/everything-claude-code — flutter-dart-code-review](https://github.com/affaan-m/everything-claude-code/blob/main/skills/flutter-dart-code-review/SKILL.md) (library-agnostic upstream)
- This project's `CLAUDE.md` (stack, contract, conventions)
- This project's `.claude/skills/mobile-design/SKILL.md` (widget catalog + analyzer trip-wires + test patterns)
- `superpowers:requesting-code-review` (workflow)
- `superpowers:receiving-code-review` (when applying fixes)
- `superpowers:verification-before-completion` (before claiming the review is done)
