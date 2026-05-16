# Identity Full — Onboarding · Register · CreateOrg · OrgPicker

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Complete the identity flow described in `docs/superpowers/specs/2026-05-15-identity-v1-design.md`. After this plan, a brand-new user can open the app, walk through a 3-step onboarding carousel, register a new account, create their first store, and a user with 2+ orgs can pick which one to enter. The MVP login path remains intact for returning users.

**Architecture:** Builds on the MVP foundation tagged `v0.1.0-identity-mvp`. We add four new screens, two new AuthRepository methods (`signUp`, `createStore`/`createStorage`), one `SharedPreferences`-backed flag (`hasSeenOnboarding`), and update the go_router redirect to handle three new branches (first-launch onboarding, zero-orgs CreateOrg, multi-orgs OrgPicker).

**Tech Stack:** Same as MVP — Flutter 3.41.9, Riverpod, dio, go_router, freezed, supertokens_flutter, gen_l10n. No new packages.

**Builds on:** Plan 1 (commits `cf7f5f3..81e1217`, tag `v0.1.0-identity-mvp`).

---

## File Structure

After this plan completes the project adds:

```
lib/
├── core/
│   ├── auth/
│   │   ├── auth_repository.dart           # MODIFIED: + signUp, createStore, createStorage
│   │   ├── auth_providers.dart            # MODIFIED: + onboardingSeenProvider, redirect helpers
│   │   └── onboarding_seen_provider.dart  # NEW: SharedPreferences-backed bool
│   └── i18n/
│       ├── app_vi.arb                     # MODIFIED: + onboarding/register/createorg/orgpicker strings
│       └── app_en.arb                     # MODIFIED: + en mirrors
├── app/
│   └── router.dart                        # MODIFIED: + onboarding, register, create-org, org-picker routes + branches
├── design/
│   └── widgets/
│       ├── k_step_dots.dart               # NEW: progress dots indicator
│       ├── k_checkbox.dart                # NEW: small filled checkbox (used in Login.remember + Register.terms)
│       └── k_ghost_btn.dart               # NEW: outline button (CreateOrg invite-link style — though we drop the link)
└── features/
    ├── onboarding/
    │   ├── onboarding_screen.dart         # NEW: PageView carousel
    │   ├── onboarding_step_data.dart      # NEW: title/body strings per step
    │   └── illustrations/
    │       ├── scan_illustration.dart     # NEW: barcode-scan phone (step 1)
    │       ├── inventory_illustration.dart # NEW: stacked boxes with in/out arrows (step 2)
    │       └── chart_illustration.dart    # NEW: rising bar chart (step 3)
    ├── register/
    │   ├── register_screen.dart           # NEW
    │   └── password_strength.dart         # NEW: strength logic + 4-bar meter
    ├── create_org/
    │   ├── create_org_screen.dart         # NEW
    │   └── store_illustration.dart        # NEW: animated storefront + stacking boxes
    └── org_picker/
        ├── org_picker_screen.dart         # NEW
        └── org_card.dart                  # NEW
test/
├── core/auth/auth_repository_test.dart    # MODIFIED: + signUp/createStore happy + error tests
├── features/onboarding/onboarding_screen_test.dart  # NEW: smoke + "skip → /login" interaction
├── features/register/
│   ├── password_strength_test.dart        # NEW: 4-bar logic unit tests
│   └── register_screen_test.dart          # NEW: smoke
├── features/create_org/create_org_screen_test.dart  # NEW: smoke
└── features/org_picker/org_picker_screen_test.dart  # NEW: smoke
```

---

## Pre-flight

Before Task E1, confirm:

```bash
cd /Users/kotomiichinose/Projects/kuru-mobile
git status               # working tree CLEAN on main
git log --oneline | head -3   # most recent should be 81e1217 test: smoke tests...
flutter test             # 14/14 pass
flutter analyze          # 0 errors (info lints OK)
```

If any of the above fails, **fix it** before starting — Plan 2 assumes the MVP is in a working state.

---

## Phase E — Onboarding

### Task E1: `hasSeenOnboarding` SharedPreferences provider

**Files:**
- Create: `lib/core/auth/onboarding_seen_provider.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/main.dart' show sharedPrefsProvider;

const _kHasSeenOnboardingKey = 'kuru.has_seen_onboarding.v1';

/// Persisted "user has finished/skipped onboarding once" flag.
/// Read by router redirect; set to true when the user taps "Bắt đầu" on
/// the last onboarding step or "Bỏ qua" at any step.
class OnboardingSeenController extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.read(sharedPrefsProvider);
    return prefs.getBool(_kHasSeenOnboardingKey) ?? false;
  }

  Future<void> markSeen() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool(_kHasSeenOnboardingKey, true);
    state = true;
  }

  /// Test-only — clears persisted flag.
  Future<void> reset() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.remove(_kHasSeenOnboardingKey);
    state = false;
  }
}

final onboardingSeenProvider =
    NotifierProvider<OnboardingSeenController, bool>(
  OnboardingSeenController.new,
);
```

- [ ] **Step 2: Verify analyze**

```bash
export PATH="$HOME/flutter/bin:$PATH"
flutter analyze lib/core/auth/onboarding_seen_provider.dart
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/core/auth/onboarding_seen_provider.dart
git commit -m "$(cat <<'EOF'
feat(auth): persisted hasSeenOnboarding flag (SharedPreferences-backed)

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task E2: i18n strings for the new screens

**Files:**
- Modify: `lib/core/i18n/app_vi.arb`
- Modify: `lib/core/i18n/app_en.arb`

- [ ] **Step 1: Append these keys to `app_vi.arb` (before the closing `}`)**

```jsonc
,
  "onboardingSkip": "Bỏ qua",
  "onboardingNext": "Tiếp theo",
  "onboardingStart": "Bắt đầu",
  "onboardingStep1Title": "Bán hàng nhanh hơn, chỉ với một lần quét.",
  "onboardingStep1Body": "Quét mã vạch để thêm sản phẩm vào giỏ, tính tiền và in hóa đơn — chỉ trong vài giây.",
  "onboardingStep2Title": "Quản lý tồn kho theo thời gian thực.",
  "onboardingStep2Body": "Mỗi giao dịch cập nhật tồn kho tức thì. Cảnh báo khi sắp hết hàng.",
  "onboardingStep3Title": "Hiểu cửa hàng của bạn qua từng con số.",
  "onboardingStep3Body": "Báo cáo doanh thu, đơn hàng, khách hàng tự động hoá.",

  "registerTitle": "Tạo tài khoản",
  "registerSubtitle": "Bắt đầu với kuru chỉ trong 30 giây.",
  "fieldFullName": "Họ và tên",
  "registerStrengthLabel": "Độ mạnh",
  "registerStrengthWeak": "Yếu",
  "registerStrengthFair": "Khá",
  "registerStrengthGood": "Tốt",
  "registerStrengthStrong": "Mạnh",
  "registerStrengthCharsCount": "{current}/{min} ký tự",
  "@registerStrengthCharsCount": {
    "placeholders": {
      "current": {"type": "int"},
      "min": {"type": "int"}
    }
  },
  "registerTerms": "Tôi đồng ý với {tos} và {privacy}.",
  "@registerTerms": {
    "placeholders": {
      "tos": {"type": "String"},
      "privacy": {"type": "String"}
    }
  },
  "registerTermsTos": "Điều khoản dịch vụ",
  "registerTermsPrivacy": "Chính sách bảo mật",
  "registerCta": "Tạo tài khoản",
  "registerFooterHasAccount": "Đã có tài khoản?",
  "registerFooterLogin": "Đăng nhập",
  "registerErrorEmailExists": "Email đã được sử dụng.",
  "registerErrorWeakPassword": "Mật khẩu chưa đủ mạnh.",

  "createOrgTitle": "Tạo cửa hàng của bạn",
  "createOrgSubtitle": "Tạo tổ chức và chi nhánh đầu tiên. Bạn có thể thêm chi nhánh khác sau.",
  "createOrgBusinessName": "Tên doanh nghiệp",
  "createOrgBranchName": "Tên chi nhánh đầu tiên",
  "createOrgBranchPlaceholder": "Mặc định: cùng tên doanh nghiệp",
  "createOrgCta": "Tạo cửa hàng",
  "createOrgErrorNameRequired": "Vui lòng nhập tên doanh nghiệp.",
  "createOrgErrorServer": "Không tạo được cửa hàng. Thử lại sau.",

  "orgPickerTitle": "Chọn tổ chức",
  "orgPickerSubtitle": "Bạn là thành viên của {count} tổ chức",
  "@orgPickerSubtitle": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },
  "orgPickerCreateNew": "Tạo tổ chức mới",
  "orgPickerNote": "Mỗi tổ chức là một không gian dữ liệu riêng biệt. Bạn có thể chuyển đổi bất kỳ lúc nào trong Cài đặt."
```

- [ ] **Step 2: Mirror to `app_en.arb` — append (before the closing `}`)**

```jsonc
,
  "onboardingSkip": "Skip",
  "onboardingNext": "Next",
  "onboardingStart": "Get started",
  "onboardingStep1Title": "Sell faster — one scan at a time.",
  "onboardingStep1Body": "Scan a barcode to add a product, cash out, and print a receipt — in seconds.",
  "onboardingStep2Title": "Inventory updates in real time.",
  "onboardingStep2Body": "Every sale moves stock instantly. We warn you when items are running low.",
  "onboardingStep3Title": "Understand your store through its numbers.",
  "onboardingStep3Body": "Revenue, orders, and customer trends — automated reports, better decisions.",

  "registerTitle": "Create an account",
  "registerSubtitle": "Start with kuru in 30 seconds.",
  "fieldFullName": "Full name",
  "registerStrengthLabel": "Strength",
  "registerStrengthWeak": "Weak",
  "registerStrengthFair": "Fair",
  "registerStrengthGood": "Good",
  "registerStrengthStrong": "Strong",
  "registerStrengthCharsCount": "{current}/{min} chars",
  "@registerStrengthCharsCount": {
    "placeholders": {
      "current": {"type": "int"},
      "min": {"type": "int"}
    }
  },
  "registerTerms": "I agree to the {tos} and {privacy}.",
  "@registerTerms": {
    "placeholders": {
      "tos": {"type": "String"},
      "privacy": {"type": "String"}
    }
  },
  "registerTermsTos": "Terms of Service",
  "registerTermsPrivacy": "Privacy Policy",
  "registerCta": "Create account",
  "registerFooterHasAccount": "Already have an account?",
  "registerFooterLogin": "Log in",
  "registerErrorEmailExists": "That email is already in use.",
  "registerErrorWeakPassword": "Password isn't strong enough.",

  "createOrgTitle": "Create your store",
  "createOrgSubtitle": "Set up your organization and first branch. You can add more branches later.",
  "createOrgBusinessName": "Business name",
  "createOrgBranchName": "First branch name",
  "createOrgBranchPlaceholder": "Default: same as business name",
  "createOrgCta": "Create store",
  "createOrgErrorNameRequired": "Please enter a business name.",
  "createOrgErrorServer": "Couldn't create the store. Try again later.",

  "orgPickerTitle": "Choose an organization",
  "orgPickerSubtitle": "You belong to {count} organizations",
  "@orgPickerSubtitle": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },
  "orgPickerCreateNew": "Create new organization",
  "orgPickerNote": "Each organization is an isolated data space. You can switch any time from Settings."
```

- [ ] **Step 3: Regenerate localizations**

```bash
export PATH="$HOME/flutter/bin:$PATH"
flutter gen-l10n
```

Expected: writes updated `lib/core/i18n/generated/app_localizations*.dart`. No errors.

- [ ] **Step 4: Commit (both ARB files + the regenerated dart files)**

```bash
git add lib/core/i18n/
git commit -m "$(cat <<'EOF'
feat(i18n): add onboarding/register/createorg/orgpicker strings

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task E3: KStepDots widget

**Files:**
- Create: `lib/design/widgets/k_step_dots.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Compact step indicator — current step is a wide pill, others are 6×6 dots.
/// Animates the width transition on change.
class KStepDots extends StatelessWidget {
  const KStepDots({
    required this.count,
    required this.current,
    super.key,
  });

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: 6,
          width: active ? 24 : 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: active
                ? c.primary
                : Color.alphaBlend(
                    c.textMuted.withValues(alpha: 0.26),
                    Colors.transparent,
                  ),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}
```

- [ ] **Step 2: Verify analyze**

```bash
flutter analyze lib/design/widgets/k_step_dots.dart
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/design/widgets/k_step_dots.dart
git commit -m "$(cat <<'EOF'
feat(design): KStepDots indicator widget

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task E4: Three onboarding illustrations

The design ships a complex composite illustration for step 1 (phone scanning a barcode + floating product card + check badge + cart). Steps 2 and 3 we author. For each: a self-contained widget that fits in a 360×320 area. Animations are optional and can be added in a polish pass — for v1 we ship static layouts that read clearly. They live under `lib/features/onboarding/illustrations/`.

**Files:**
- Create: `lib/features/onboarding/illustrations/scan_illustration.dart`
- Create: `lib/features/onboarding/illustrations/inventory_illustration.dart`
- Create: `lib/features/onboarding/illustrations/chart_illustration.dart`

- [ ] **Step 1: Write `scan_illustration.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Step 1 illustration — a phone showing a barcode-scan viewfinder with a
/// floating "product detected" card and a success check. Static layout
/// (no animation in v1; the scan-beam keyframe lives in design/kuru-theme.js
/// and can be ported later).
class ScanIllustration extends StatelessWidget {
  const ScanIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SizedBox(
      width: 360,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft concentric pulse rings (static)
          for (var i = 0; i < 3; i++)
            Container(
              width: 240 + i * 20.0,
              height: 240 + i * 20.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: c.primary.withValues(alpha: 0.18 - i * 0.05),
                  width: 2,
                ),
              ),
            ),

          // Phone body (center)
          Container(
            width: 152,
            height: 220,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: c.textPrimary,
              boxShadow: c.shadowPop,
              border: Border.all(color: c.surfaceElev, width: 5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [c.primary, c.secondary],
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 80,
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        18,
                        (i) => Expanded(
                          flex: ((i * 7 + 3) % 3) + 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.5),
                            child: Container(
                              color: Colors.white.withValues(alpha: 0.92),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Floating product card (top-left)
          Positioned(
            top: 12,
            left: 20,
            child: Container(
              width: 124,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: c.surfaceElev,
                boxShadow: c.shadowMd,
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFE53935), Color(0xFFD84315)],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'CC',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Coca-Cola',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: c.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '12.000₫',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: c.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Success badge (top-right)
          Positioned(
            top: 20,
            right: 16,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: c.success,
                boxShadow: [
                  BoxShadow(
                    color: c.success.withValues(alpha: 0.40),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.check, size: 26, color: Colors.white),
            ),
          ),

          // Cart pill (bottom-right)
          Positioned(
            bottom: 14,
            right: 28,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: c.surfaceElev,
                boxShadow: c.shadowMd,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 22, color: c.primary),
                  const SizedBox(width: 6),
                  Text(
                    '+1',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
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

- [ ] **Step 2: Write `inventory_illustration.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Step 2 illustration — stacked warehouse boxes with arrows showing in/out
/// flow. Static.
class InventoryIllustration extends StatelessWidget {
  const InventoryIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SizedBox(
      width: 360,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Floor shadow
          Positioned(
            bottom: 40,
            child: Container(
              width: 240,
              height: 8,
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),

          // Box stack (center, 3 boxes)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final hue in const [200, 280, 30])
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  width: 96,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        HSLColor.fromAHSL(1, hue.toDouble(), 0.6, 0.55)
                            .toColor(),
                        HSLColor.fromAHSL(
                          1,
                          (hue + 30).toDouble() % 360,
                          0.65,
                          0.45,
                        ).toColor(),
                      ],
                    ),
                    boxShadow: c.shadowSm,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
            ],
          ),

          // "In" arrow (left, pointing right toward stack)
          Positioned(
            left: 40,
            top: 130,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: c.surfaceElev,
                    boxShadow: c.shadowSm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward, size: 16, color: c.success),
                      const SizedBox(width: 4),
                      Text(
                        '+24',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: c.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // "Out" arrow (right, pointing away from stack)
          Positioned(
            right: 40,
            bottom: 130,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: c.surfaceElev,
                boxShadow: c.shadowSm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '-3',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: c.warning,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: c.warning),
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

- [ ] **Step 3: Write `chart_illustration.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Step 3 illustration — a rising bar chart with a trend pill. Static.
class ChartIllustration extends StatelessWidget {
  const ChartIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    // bar heights as fractions of the chart area (rising trend)
    const heights = <double>[0.32, 0.45, 0.40, 0.62, 0.75, 0.88];
    return SizedBox(
      width: 360,
      height: 320,
      child: Center(
        child: Container(
          width: 280,
          height: 220,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
          decoration: BoxDecoration(
            color: c.surfaceElev,
            borderRadius: BorderRadius.circular(20),
            boxShadow: c.shadowMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Doanh thu tuần',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: c.textMuted,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: c.successSoft,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.trending_up, size: 12, color: c.success),
                        const SizedBox(width: 3),
                        Text(
                          '+24%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: c.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final h in heights) ...[
                      Expanded(
                        child: FractionallySizedBox(
                          heightFactor: h,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [c.primary, c.secondary],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ],
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

- [ ] **Step 4: Verify all three analyze**

```bash
flutter analyze lib/features/onboarding/illustrations/
```

Expected: no errors. Info-level lints (line length, etc.) acceptable if non-trivial to wrap.

- [ ] **Step 5: Commit**

```bash
git add lib/features/onboarding/illustrations/
git commit -m "$(cat <<'EOF'
feat(onboarding): three step illustrations (scan, inventory, chart)

Static layouts using KuruColors tokens. Animations (scan-beam, box-bounce)
can be ported from design/kuru-theme.js in a later polish pass.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task E5: OnboardingScreen with PageView carousel

**Files:**
- Create: `lib/features/onboarding/onboarding_step_data.dart`
- Create: `lib/features/onboarding/onboarding_screen.dart`

- [ ] **Step 1: Write `onboarding_step_data.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/onboarding/illustrations/chart_illustration.dart';
import 'package:kuru_mobile/features/onboarding/illustrations/inventory_illustration.dart';
import 'package:kuru_mobile/features/onboarding/illustrations/scan_illustration.dart';

class OnboardingStep {
  const OnboardingStep({
    required this.title,
    required this.body,
    required this.illustration,
  });

  final String title;
  final String body;
  final Widget illustration;
}

List<OnboardingStep> buildOnboardingSteps(AppLocalizations l) => [
      OnboardingStep(
        title: l.onboardingStep1Title,
        body: l.onboardingStep1Body,
        illustration: const ScanIllustration(),
      ),
      OnboardingStep(
        title: l.onboardingStep2Title,
        body: l.onboardingStep2Body,
        illustration: const InventoryIllustration(),
      ),
      OnboardingStep(
        title: l.onboardingStep3Title,
        body: l.onboardingStep3Body,
        illustration: const ChartIllustration(),
      ),
    ];
```

- [ ] **Step 2: Write `onboarding_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/onboarding_seen_provider.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';
import 'package:kuru_mobile/design/widgets/k_step_dots.dart';
import 'package:kuru_mobile/features/onboarding/onboarding_step_data.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageCtl = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageCtl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingSeenProvider.notifier).markSeen();
    if (!mounted) return;
    context.go('/login');
  }

  void _next(int total) {
    if (_index >= total - 1) {
      _finish();
    } else {
      _pageCtl.nextPage(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final steps = buildOnboardingSteps(l);
    final isLast = _index == steps.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top row: step count + Skip
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_index + 1} ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: c.textMuted,
                    ),
                    children: <TextSpan>[],
                  ).asRichWithFaded(steps.length, c.textMuted),
                  TextButton(
                    onPressed: _finish,
                    style: TextButton.styleFrom(
                      foregroundColor: c.textMuted,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(l.onboardingSkip),
                  ),
                ],
              ),
            ),

            // PageView (illustration + title + body)
            Expanded(
              child: PageView.builder(
                controller: _pageCtl,
                itemCount: steps.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final step = steps[i];
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      step.illustration,
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.6,
                                color: c.textPrimary,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              step.body,
                              style: TextStyle(
                                fontSize: 14,
                                color: c.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Bottom: dots + CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
              child: Column(
                children: [
                  KStepDots(count: steps.length, current: _index),
                  const SizedBox(height: 18),
                  KPrimaryBtn(
                    fullWidth: true,
                    icon: Icon(isLast ? Icons.arrow_forward : Icons.chevron_right),
                    onPressed: () => _next(steps.length),
                    child: Text(isLast ? l.onboardingStart : l.onboardingNext),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Text {
  /// Tiny helper to render the "N / total" indicator with the total grayed out.
  Widget asRichWithFaded(int total, Color faded) {
    return Builder(
      builder: (context) {
        final base = (style ?? const TextStyle()).copyWith(
          color: (style?.color) ?? Colors.black,
        );
        return RichText(
          text: TextSpan(
            style: base,
            children: [
              TextSpan(text: data ?? ''),
              TextSpan(
                text: '/ $total',
                style: base.copyWith(color: faded.withValues(alpha: 0.6)),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 3: Verify analyze**

```bash
flutter analyze lib/features/onboarding/
```

Expected: 0 errors. Address any warnings.

- [ ] **Step 4: Commit**

```bash
git add lib/features/onboarding/onboarding_screen.dart \
        lib/features/onboarding/onboarding_step_data.dart
git commit -m "$(cat <<'EOF'
feat(onboarding): 3-step PageView carousel with Skip / Next / Start

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task E6: Wire OnboardingScreen into the router

**Files:**
- Modify: `lib/app/router.dart`

- [ ] **Step 1: Edit `router.dart`**

Three changes:

1. Add an import: `import 'package:kuru_mobile/core/auth/onboarding_seen_provider.dart';` and `import 'package:kuru_mobile/features/onboarding/onboarding_screen.dart';`.

2. In `redirect`, read `onboardingSeenProvider`. The new branching logic:

```dart
redirect: (context, state) {
  final boot = ref.read(appBootstrapProvider);
  final seenOnboarding = ref.read(onboardingSeenProvider);
  final loc = state.matchedLocation;
  return boot.when(
    loading: () => loc == '/splash' ? null : '/splash',
    error: (_, __) => loc == '/login' ? null : '/login',
    data: (result) {
      if (result is BootstrapUnauthed) {
        if (!seenOnboarding) {
          return loc == '/onboarding' ? null : '/onboarding';
        }
        return loc == '/login' ? null : '/login';
      }
      // BootstrapAuthed
      return loc == '/home' ? null : '/home';
    },
  );
},
```

3. Add `GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),` to `routes`.

- [ ] **Step 2: Update `_BootstrapNotifier` to also listen for onboarding flag changes**

In `_BootstrapNotifier`'s constructor, after the existing `_sub = ref.listen(...)`, add:

```dart
_onboardingSub = ref.listen(onboardingSeenProvider, (_, __) => notifyListeners());
```

Add a field `late final ProviderSubscription<bool> _onboardingSub;` and close it in `dispose`:

```dart
@override
void dispose() {
  _sub.close();
  _onboardingSub.close();
  super.dispose();
}
```

- [ ] **Step 3: Verify analyze and tests still pass**

```bash
flutter analyze lib/app/router.dart
flutter test
```

Expected: 0 errors. All 14 existing tests still pass.

- [ ] **Step 4: Commit**

```bash
git add lib/app/router.dart
git commit -m "$(cat <<'EOF'
feat(router): wire /onboarding route with hasSeenOnboarding gate

First-launch unauthenticated users now land on /onboarding; subsequent
launches and users who tapped Skip/Start go to /login.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Phase F — Register

### Task F1: Password strength logic + meter (TDD)

**Files:**
- Create: `lib/features/register/password_strength.dart`
- Create: `test/features/register/password_strength_test.dart`

- [ ] **Step 1: Write the failing tests first**

```dart
// test/features/register/password_strength_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/features/register/password_strength.dart';

void main() {
  group('passwordStrength', () {
    test('empty → 0 bars', () {
      expect(passwordStrength('').bars, 0);
    });

    test('len >= 8 → at least 1 bar', () {
      expect(passwordStrength('aaaaaaaa').bars, greaterThanOrEqualTo(1));
    });

    test('upper + digit → at least 2 bars', () {
      expect(passwordStrength('Aaaaaaa1').bars, greaterThanOrEqualTo(2));
    });

    test('upper + digit + symbol → at least 3 bars', () {
      expect(passwordStrength('Aaaaaaa1!').bars, greaterThanOrEqualTo(3));
    });

    test('len >= 12 + symbol + digit + upper → 4 bars', () {
      expect(passwordStrength('Aaaaaaaa1!ab').bars, 4);
    });

    test('label matches bar count', () {
      expect(passwordStrength('').label, PwLabel.weak);
      expect(passwordStrength('aaaaaaaa').label, PwLabel.weak);
      expect(passwordStrength('Aaaaaaaa1').label, PwLabel.fair);
      expect(passwordStrength('Aaaaaaa1!').label, PwLabel.good);
      expect(passwordStrength('Aaaaaaaa1!ab').label, PwLabel.strong);
    });
  });
}
```

- [ ] **Step 2: Run and confirm failure**

```bash
export PATH="$HOME/flutter/bin:$PATH"
flutter test test/features/register/password_strength_test.dart
```

Expected: compile error / "PwLabel undefined", "passwordStrength undefined" etc.

- [ ] **Step 3: Write the implementation**

```dart
// lib/features/register/password_strength.dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';

enum PwLabel { weak, fair, good, strong }

class PwStrength {
  const PwStrength({required this.bars, required this.label});
  final int bars; // 0–4
  final PwLabel label;
}

PwStrength passwordStrength(String pw) {
  if (pw.isEmpty) return const PwStrength(bars: 0, label: PwLabel.weak);
  var bars = 0;
  if (pw.length >= 8) bars++;
  final hasUpper = pw.contains(RegExp('[A-Z]'));
  final hasDigit = pw.contains(RegExp('[0-9]'));
  final hasSymbol = pw.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=/\\\[\]~`]'));
  if (hasUpper && hasDigit) bars++;
  if (hasSymbol) bars++;
  if (pw.length >= 12) bars++;
  final label = switch (bars) {
    <= 1 => PwLabel.weak,
    2 => PwLabel.fair,
    3 => PwLabel.good,
    _ => PwLabel.strong,
  };
  return PwStrength(bars: bars, label: label);
}

/// Visual 4-bar meter + label + char count.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({
    required this.password,
    super.key,
    this.minChars = 8,
  });

  final String password;
  final int minChars;

  String _labelText(PwLabel l, AppLocalizations loc) => switch (l) {
        PwLabel.weak => loc.registerStrengthWeak,
        PwLabel.fair => loc.registerStrengthFair,
        PwLabel.good => loc.registerStrengthGood,
        PwLabel.strong => loc.registerStrengthStrong,
      };

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final s = passwordStrength(password);
    final barColor = switch (s.label) {
      PwLabel.weak => c.danger,
      PwLabel.fair => c.warning,
      PwLabel.good => c.success,
      PwLabel.strong => c.success,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(4, (i) {
              final on = i < s.bars;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  height: 4,
                  decoration: BoxDecoration(
                    color: on ? barColor : c.borderSoft,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${l.registerStrengthLabel}: ${_labelText(s.label, l)}',
                style: TextStyle(fontSize: 11, color: c.textMuted),
              ),
              Text(
                l.registerStrengthCharsCount(password.length, minChars),
                style: TextStyle(fontSize: 11, color: c.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Re-run tests**

```bash
flutter test test/features/register/password_strength_test.dart
```

Expected: 6 tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/features/register/password_strength.dart \
        test/features/register/password_strength_test.dart
git commit -m "$(cat <<'EOF'
feat(register): password strength logic + 4-bar meter (TDD)

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task F2: AuthRepository.signUp + createStore + createStorage

**Files:**
- Modify: `lib/core/auth/auth_repository.dart`
- Modify: `test/core/auth/auth_repository_test.dart`

- [ ] **Step 1: Add the three methods to `AuthRepository`**

Append (after `signOut()`):

```dart
/// SuperTokens emailpassword sign-up.
Future<ApiResult<void>> signUp({
  required String fullName,
  required String email,
  required String password,
}) async {
  try {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/signup',
      data: {
        'formFields': [
          {'id': 'email', 'value': email},
          {'id': 'password', 'value': password},
          // SuperTokens accepts arbitrary extra form fields; the BE schema
          // for sign-up passes them through as user metadata.
          {'id': 'name', 'value': fullName},
        ],
      },
    );
    final status = res.data?['status'] as String? ?? 'UNKNOWN';
    if (status == 'OK') return ApiResult.success(null);
    if (status == 'FIELD_ERROR') {
      return ApiResult.failure(BadRequestException(status, code: 'FIELD_ERROR'));
    }
    if (status == 'EMAIL_ALREADY_EXISTS_ERROR') {
      return ApiResult.failure(
        BadRequestException(status, code: 'EMAIL_EXISTS'),
      );
    }
    return ApiResult.failure(BadRequestException(status));
  } on DioException catch (e) {
    return ApiResult.failure(_extract(e));
  }
}

/// Create a Store (the multi-tenant root entity). Returns the new store id.
Future<ApiResult<String>> createStore({required String name}) async {
  try {
    final res = await _dio.post<Map<String, dynamic>>(
      '/api/v1/store/CreateStore',
      data: {'name': name},
    );
    final data = res.data?['data'] as Map<String, dynamic>?;
    final id = data?['storeId'] as String?;
    if (id == null) {
      return ApiResult.failure(
        ServerException('Missing storeId', statusCode: 200),
      );
    }
    return ApiResult.success(id);
  } on DioException catch (e) {
    return ApiResult.failure(_extract(e));
  }
}

/// Create a Storage row (kuru's "branch") inside a store. Best-effort —
/// failure is non-fatal; caller may continue with just the store.
Future<ApiResult<String>> createStorage({required String name}) async {
  try {
    final res = await _dio.post<Map<String, dynamic>>(
      '/api/v1/storage/CreateStore',
      data: {'name': name},
    );
    final data = res.data?['data'] as Map<String, dynamic>?;
    final id = data?['storageId'] as String? ?? data?['id'] as String?;
    if (id == null) {
      return ApiResult.failure(
        ServerException('Missing storageId', statusCode: 200),
      );
    }
    return ApiResult.success(id);
  } on DioException catch (e) {
    return ApiResult.failure(_extract(e));
  }
}
```

- [ ] **Step 2: Append tests to `auth_repository_test.dart`**

Add inside `void main()`:

```dart
  group('AuthRepository.signUp', () {
    test('returns success on OK', () async {
      final dio = _dioWith({'status': 'OK'});
      final r = await AuthRepository(dio).signUp(
        fullName: 'A',
        email: 'a@b.com',
        password: 'pw',
      );
      expect(r, isA<ApiSuccess<void>>());
    });

    test('returns BadRequest on EMAIL_ALREADY_EXISTS_ERROR', () async {
      final dio = _dioWith({'status': 'EMAIL_ALREADY_EXISTS_ERROR'});
      final r = await AuthRepository(dio).signUp(
        fullName: 'A',
        email: 'a@b.com',
        password: 'pw',
      );
      expect(r, isA<ApiFailure<void>>());
      final err = (r as ApiFailure).err as BadRequestException;
      expect(err.code, 'EMAIL_EXISTS');
    });
  });

  group('AuthRepository.createStore', () {
    test('returns the storeId on success', () async {
      final dio = _dioWith({
        'data': {'storeId': 'store-123'},
      });
      final r = await AuthRepository(dio).createStore(name: 'Shop');
      expect(r, isA<ApiSuccess<String>>());
      expect((r as ApiSuccess<String>).data, 'store-123');
    });

    test('returns ServerException when storeId missing', () async {
      final dio = _dioWith({'data': <String, dynamic>{}});
      final r = await AuthRepository(dio).createStore(name: 'Shop');
      expect(r, isA<ApiFailure<String>>());
      expect((r as ApiFailure).err, isA<ServerException>());
    });
  });
```

- [ ] **Step 3: Run all auth tests**

```bash
flutter test test/core/auth/auth_repository_test.dart
```

Expected: 6 tests pass (2 from MVP + 4 new).

- [ ] **Step 4: Commit**

```bash
git add lib/core/auth/auth_repository.dart test/core/auth/auth_repository_test.dart
git commit -m "$(cat <<'EOF'
feat(auth): AuthRepository.signUp + createStore + createStorage

Plus unit tests for signUp happy / EMAIL_ALREADY_EXISTS and createStore
happy / missing-id.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task F3: KCheckbox widget

**Files:**
- Create: `lib/design/widgets/k_checkbox.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Small filled checkbox that matches the design's "purple filled" look.
/// Used for Login.remember and Register.terms.
class KCheckbox extends StatelessWidget {
  const KCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.size = 18,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return InkResponse(
      onTap: () => onChanged(!value),
      radius: size,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? c.primary : Colors.transparent,
          border: Border.all(
            color: value ? c.primary : c.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: value
            ? Icon(Icons.check, size: size * 0.7, color: c.textInverse)
            : null,
      ),
    );
  }
}
```

- [ ] **Step 2: Verify analyze**

```bash
flutter analyze lib/design/widgets/k_checkbox.dart
```

Expected: clean.

- [ ] **Step 3: Commit**

```bash
git add lib/design/widgets/k_checkbox.dart
git commit -m "$(cat <<'EOF'
feat(design): KCheckbox — filled checkbox matching design tokens

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task F4: RegisterScreen

**Files:**
- Create: `lib/features/register/register_screen.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_exception.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/auth/auth_backdrop.dart';
import 'package:kuru_mobile/design/auth/auth_logo.dart';
import 'package:kuru_mobile/design/widgets/k_checkbox.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';
import 'package:kuru_mobile/features/register/password_strength.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _termsAccepted = false;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    if (_name.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _password.text.isEmpty) {
      setState(() => _errorMessage = l.loginErrorBadCredentials);
      return;
    }
    final pw = passwordStrength(_password.text);
    if (pw.bars < 2) {
      setState(() => _errorMessage = l.registerErrorWeakPassword);
      return;
    }
    if (!_termsAccepted) return; // CTA disabled by terms checkbox

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    final repo = ref.read(authRepositoryProvider);
    final r = await repo.signUp(
      fullName: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    );
    if (!mounted) return;
    switch (r) {
      case ApiSuccess<void>():
        // Re-run bootstrap; router will route us to /create-org (zero orgs)
        ref.invalidate(appBootstrapProvider);
      case ApiFailure<void>(:final err):
        setState(() {
          _submitting = false;
          _errorMessage = switch (err) {
            BadRequestException(code: 'EMAIL_EXISTS') =>
              l.registerErrorEmailExists,
            NetworkException() => l.loginErrorNetwork,
            _ => l.loginErrorGeneric,
          };
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final canSubmit = _termsAccepted && !_submitting;

    return Scaffold(
      body: Stack(
        children: [
          const AuthBackdrop(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      const AuthLogo(small: true),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l.registerTitle,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.55,
                                color: c.textPrimary,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l.registerSubtitle,
                              style: TextStyle(fontSize: 12, color: c.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  KFormField(
                    label: l.fieldFullName,
                    controller: _name,
                    icon: const Icon(Icons.person_outline),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
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
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 8),
                  PasswordStrengthMeter(password: _password.text),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KCheckbox(
                        value: _termsAccepted,
                        onChanged: (v) => setState(() => _termsAccepted = v),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: c.textSecondary,
                                height: 1.45,
                              ),
                              children: [
                                TextSpan(text: '${_termsPrefix(l)} '),
                                TextSpan(
                                  text: l.registerTermsTos,
                                  style: TextStyle(
                                    color: c.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(text: ' ${_termsConjunction(l)} '),
                                TextSpan(
                                  text: l.registerTermsPrivacy,
                                  style: TextStyle(
                                    color: c.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: c.dangerSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(fontSize: 13, color: c.danger),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  KPrimaryBtn(
                    fullWidth: true,
                    icon: const Icon(Icons.arrow_outward),
                    onPressed: canSubmit ? _submit : null,
                    child: Text(l.registerCta),
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${l.registerFooterHasAccount} ',
                          style: TextStyle(fontSize: 13, color: c.textMuted),
                        ),
                        Text(
                          l.registerFooterLogin,
                          style: TextStyle(
                            fontSize: 13,
                            color: c.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _termsPrefix(AppLocalizations l) {
    // Split the "I agree to {tos} and {privacy}." string into a prefix.
    // For en/vi the part before {tos} is everything up to the first
    // placeholder. We compute it once at build time.
    final tpl = l.registerTerms('__TOS__', '__PRIV__');
    final idx = tpl.indexOf('__TOS__');
    return idx > 0 ? tpl.substring(0, idx).trimRight() : '';
  }

  String _termsConjunction(AppLocalizations l) {
    final tpl = l.registerTerms('__TOS__', '__PRIV__');
    final start = tpl.indexOf('__TOS__') + '__TOS__'.length;
    final end = tpl.indexOf('__PRIV__');
    return tpl.substring(start, end).trim();
  }
}
```

- [ ] **Step 2: Update `LoginScreen` so its footer navigates to /register**

In `lib/features/login/login_screen.dart`, find the footer Row (the "Chưa có tài khoản? Đăng ký" text). Wrap the "Đăng ký" link in a `GestureDetector` with `onTap: () => context.go('/register')`. Add `import 'package:go_router/go_router.dart';` at the top.

- [ ] **Step 3: Add /register to the router**

In `lib/app/router.dart`, add to `routes`:

```dart
GoRoute(
  path: '/register',
  builder: (_, __) => const RegisterScreen(),
),
```

And add an import: `import 'package:kuru_mobile/features/register/register_screen.dart';`. `/register` is unauthenticated, so it should be reachable from `/login`. Update the redirect's `BootstrapUnauthed` branch to allow `/register` to stay:

```dart
if (result is BootstrapUnauthed) {
  if (!seenOnboarding) {
    return loc == '/onboarding' ? null : '/onboarding';
  }
  const publicRoutes = {'/login', '/register'};
  return publicRoutes.contains(loc) ? null : '/login';
}
```

- [ ] **Step 4: Verify analyze + tests**

```bash
flutter analyze
flutter test
```

Expected: 0 errors, all tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/features/register/register_screen.dart \
        lib/features/login/login_screen.dart \
        lib/app/router.dart
git commit -m "$(cat <<'EOF'
feat(register): RegisterScreen + login footer nav + router wiring

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Phase G — Create Org

### Task G1: Animated StoreIllustration widget

**Files:**
- Create: `lib/features/create_org/store_illustration.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';

/// Storefront with cascading boxes that bounce in on first mount.
/// Direct adaptation of the design's ScreenCreateOrg illustration.
class StoreIllustration extends StatefulWidget {
  const StoreIllustration({super.key});

  @override
  State<StoreIllustration> createState() => _StoreIllustrationState();
}

class _StoreIllustrationState extends State<StoreIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    return SizedBox(
      width: 240,
      height: 180,
      child: AnimatedBuilder(
        animation: _ctl,
        builder: (context, _) {
          return Stack(
            children: [
              // floor
              Positioned(
                bottom: 6,
                left: 20,
                right: 20,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: c.primarySoft,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              // storefront
              Positioned(
                bottom: 12,
                left: 65,
                child: Container(
                  width: 110,
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: c.surfaceElev,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: c.shadowMd,
                    border: Border.all(color: c.borderSoft),
                  ),
                  child: Column(
                    children: [
                      // sign
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color.alphaBlend(
                            c.primary.withValues(alpha: 0.25),
                            Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            for (final on in const [true, true, true, false])
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color:
                                      on ? c.primarySoft : c.secondarySoft,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // awning (over storefront)
              Positioned(
                bottom: 102,
                left: 57,
                child: Container(
                  width: 126,
                  height: 18,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [c.primary, c.secondary],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),

              // 5 stacking boxes, each with a delayed bounce
              for (final cfg in const [
                _BoxCfg(x: 14, y: 100, delay: 0.0, hue: 280, small: false),
                _BoxCfg(x: 178, y: 90, delay: 0.10, hue: 220, small: false),
                _BoxCfg(x: 32, y: 60, delay: 0.20, hue: 340, small: true),
                _BoxCfg(x: 168, y: 40, delay: 0.30, hue: 30, small: true),
                _BoxCfg(x: 100, y: 10, delay: 0.40, hue: 200, small: true),
              ])
                _AnimatedBox(cfg: cfg, t: _ctl.value, c: c),
            ],
          );
        },
      ),
    );
  }
}

class _BoxCfg {
  const _BoxCfg({
    required this.x,
    required this.y,
    required this.delay,
    required this.hue,
    required this.small,
  });
  final double x;
  final double y;
  final double delay;
  final int hue;
  final bool small;
}

class _AnimatedBox extends StatelessWidget {
  const _AnimatedBox({required this.cfg, required this.t, required this.c});
  final _BoxCfg cfg;
  final double t;
  final KuruColors c;

  @override
  Widget build(BuildContext context) {
    final local = ((t - cfg.delay) / (1 - cfg.delay)).clamp(0.0, 1.0);
    final eased = Curves.easeOutBack.transform(local);
    final size = cfg.small ? 28.0 : 38.0;
    return Positioned(
      left: cfg.x,
      top: cfg.y - (1 - eased) * 30,
      child: Opacity(
        opacity: local,
        child: Transform.rotate(
          angle: (1 - eased) * 0.12,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  HSLColor.fromAHSL(1, cfg.hue.toDouble(), 0.6, 0.6).toColor(),
                  HSLColor.fromAHSL(
                    1,
                    (cfg.hue + 30) % 360,
                    0.65,
                    0.5,
                  ).toColor(),
                ],
              ),
              boxShadow: c.shadowSm,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.inventory_2_outlined,
              size: cfg.small ? 16 : 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify**

```bash
flutter analyze lib/features/create_org/store_illustration.dart
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/create_org/store_illustration.dart
git commit -m "$(cat <<'EOF'
feat(create_org): animated storefront with cascading boxes

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task G2: CreateOrgScreen + post-auth router branch

**Files:**
- Create: `lib/features/create_org/create_org_screen.dart`
- Modify: `lib/app/router.dart`

- [ ] **Step 1: Write `create_org_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/auth_repository.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/core/network/api_result.dart';
import 'package:kuru_mobile/design/auth/auth_backdrop.dart';
import 'package:kuru_mobile/design/widgets/k_form_field.dart';
import 'package:kuru_mobile/design/widgets/k_primary_btn.dart';
import 'package:kuru_mobile/design/widgets/k_step_dots.dart';
import 'package:kuru_mobile/features/create_org/store_illustration.dart';

class CreateOrgScreen extends ConsumerStatefulWidget {
  const CreateOrgScreen({super.key});

  @override
  ConsumerState<CreateOrgScreen> createState() => _CreateOrgScreenState();
}

class _CreateOrgScreenState extends ConsumerState<CreateOrgScreen> {
  final _businessName = TextEditingController();
  final _branchName = TextEditingController();
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _businessName.dispose();
    _branchName.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final name = _businessName.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = l.createOrgErrorNameRequired);
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    final repo = ref.read(authRepositoryProvider);
    final storeResult = await repo.createStore(name: name);
    if (!mounted) return;
    switch (storeResult) {
      case ApiSuccess<String>():
        // Optional: create the first branch / storage with the supplied name.
        // Failure here is non-fatal — store creation is what unblocks Home.
        final branch = _branchName.text.trim();
        if (branch.isNotEmpty) {
          await repo.createStorage(name: branch);
        }
        // Bootstrap will now find an org → routes to /home
        ref.invalidate(appBootstrapProvider);
      case ApiFailure<String>():
        setState(() {
          _submitting = false;
          _errorMessage = l.createOrgErrorServer;
        });
    }
  }

  Future<void> _logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
    ref.read(currentOrgIdProvider.notifier).clear();
    ref.invalidate(appBootstrapProvider);
  }

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final bootstrap = ref.watch(appBootstrapProvider);
    final email = bootstrap.maybeWhen(
      data: (s) => s is BootstrapAuthed ? s.user.email ?? '' : '',
      orElse: () => '',
    );

    return Scaffold(
      body: Stack(
        children: [
          const AuthBackdrop(),
          SafeArea(
            child: Column(
              children: [
                // Custom auth chrome: tiny header with email + logout
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios_new, size: 18),
                      const Spacer(),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: c.textMuted,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _logout,
                        icon: Icon(Icons.logout, color: c.danger, size: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const StoreIllustration(),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      Text(
                        l.createOrgTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: c.textPrimary,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l.createOrgSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: c.textMuted,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      KFormField(
                        label: l.createOrgBusinessName,
                        controller: _businessName,
                        icon: const Icon(Icons.business_outlined),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      KFormField(
                        label: l.createOrgBranchName,
                        controller: _branchName,
                        icon: const Icon(Icons.warehouse_outlined),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: c.dangerSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(fontSize: 13, color: c.danger),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
                  child: Column(
                    children: [
                      KPrimaryBtn(
                        fullWidth: true,
                        icon: const Icon(Icons.arrow_outward),
                        onPressed: _submitting ? null : _submit,
                        child: Text(l.createOrgCta),
                      ),
                      const SizedBox(height: 14),
                      const KStepDots(count: 3, current: 1),
                    ],
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

- [ ] **Step 2: Update `router.dart`**

Add import:

```dart
import 'package:kuru_mobile/features/create_org/create_org_screen.dart';
```

Add route:

```dart
GoRoute(
  path: '/create-org',
  builder: (_, __) => const CreateOrgScreen(),
),
```

Replace the `BootstrapAuthed` branch of the redirect with:

```dart
final user = (result as BootstrapAuthed).user;
if (user.orgInfos.isEmpty) {
  return loc == '/create-org' ? null : '/create-org';
}
// (OrgPicker handled in Task H — for now, all multi-org users go to /home)
return loc == '/home' ? null : '/home';
```

- [ ] **Step 3: Verify analyze + tests**

```bash
flutter analyze
flutter test
```

Expected: 0 errors, all tests pass.

- [ ] **Step 4: Commit**

```bash
git add lib/features/create_org/create_org_screen.dart lib/app/router.dart
git commit -m "$(cat <<'EOF'
feat(create_org): CreateOrgScreen + zero-orgs router branch

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Phase H — Org Picker

### Task H1: OrgCard widget

**Files:**
- Create: `lib/features/org_picker/org_card.dart`

- [ ] **Step 1: Write the file**

```dart
import 'package:flutter/material.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';

class OrgCard extends StatelessWidget {
  const OrgCard({
    required this.org,
    required this.active,
    required this.onTap,
    super.key,
  });

  final OrgInfo org;
  final bool active;
  final VoidCallback onTap;

  // Derive a stable hue from the org name hash for the avatar tint.
  int get _hue => (org.name.hashCode & 0xFFFF) % 360;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final initials = org.name
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0])
        .join()
        .toUpperCase();
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.surfaceElev,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? c.primary : c.borderSoft,
            width: active ? 2 : 1,
          ),
          boxShadow: active ? c.shadowMd : c.shadowSm,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HSLColor.fromAHSL(1, _hue.toDouble(), 0.6, 0.55).toColor(),
                    HSLColor.fromAHSL(
                      1,
                      (_hue + 30) % 360,
                      0.7,
                      0.45,
                    ).toColor(),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    org.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                      letterSpacing: -0.14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _RolePill(role: org.role, active: active),
                ],
              ),
            ),
            if (active)
              Icon(Icons.check, size: 20, color: c.primary),
          ],
        ),
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  const _RolePill({required this.role, required this.active});
  final String role;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final c = kuruColors(context);
    final bg = active ? c.primarySoft : c.borderSoft;
    final fg = active ? c.primary : c.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify analyze**

```bash
flutter analyze lib/features/org_picker/org_card.dart
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/org_picker/org_card.dart
git commit -m "$(cat <<'EOF'
feat(org_picker): OrgCard widget with hue-derived avatar

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task H2: OrgPickerScreen + router branch

**Files:**
- Create: `lib/features/org_picker/org_picker_screen.dart`
- Modify: `lib/app/router.dart`

- [ ] **Step 1: Write `org_picker_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuru_mobile/app/theme/kuru_colors.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/org_picker/org_card.dart';

class OrgPickerScreen extends ConsumerWidget {
  const OrgPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = kuruColors(context);
    final l = AppLocalizations.of(context);
    final bootstrap = ref.watch(appBootstrapProvider);
    final currentOrgId = ref.watch(currentOrgIdProvider);

    return bootstrap.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (state) {
        if (state is! BootstrapAuthed) {
          return const Scaffold(body: Center(child: Text('No session')));
        }
        final orgs = state.user.orgInfos;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.orgPickerTitle,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: c.textPrimary,
                    letterSpacing: -0.55,
                  ),
                ),
                Text(
                  l.orgPickerSubtitle(orgs.length),
                  style: TextStyle(fontSize: 12, color: c.textMuted),
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
              children: [
                for (final org in orgs) ...[
                  OrgCard(
                    org: org,
                    active: org.id == currentOrgId,
                    onTap: () {
                      ref.read(currentOrgIdProvider.notifier).orgId = org.id;
                      context.go('/home');
                    },
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => context.go('/create-org'),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: c.border,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 18, color: c.primary),
                        const SizedBox(width: 6),
                        Text(
                          l.orgPickerCreateNew,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: c.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: c.primarySoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.shield_outlined, size: 20, color: c.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l.orgPickerNote,
                          style: TextStyle(
                            fontSize: 12,
                            color: c.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 2: Update router** — replace the `BootstrapAuthed` branch (introduced in Task G2) with:

```dart
final user = (result as BootstrapAuthed).user;
if (user.orgInfos.isEmpty) {
  return loc == '/create-org' ? null : '/create-org';
}
if (user.orgInfos.length > 1 &&
    ref.read(currentOrgIdProvider) == null) {
  return loc == '/org-picker' ? null : '/org-picker';
}
return loc == '/home' ? null : '/home';
```

Add the route:

```dart
GoRoute(
  path: '/org-picker',
  builder: (_, __) => const OrgPickerScreen(),
),
```

And import `package:kuru_mobile/features/org_picker/org_picker_screen.dart`.

Also: add `_orgIdSub` to `_BootstrapNotifier`:

```dart
_orgIdSub = ref.listen(currentOrgIdProvider, (_, __) => notifyListeners());
```

(With field + close-in-dispose like the other subs.)

- [ ] **Step 3: Verify analyze + tests**

```bash
flutter analyze
flutter test
```

- [ ] **Step 4: Commit**

```bash
git add lib/features/org_picker/org_picker_screen.dart lib/app/router.dart
git commit -m "$(cat <<'EOF'
feat(org_picker): OrgPickerScreen + 2+ orgs router branch

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

## Phase I — Polish + Smoke Tests

### Task I1: Smoke tests for the 4 new screens

**Files:**
- Create: `test/features/onboarding/onboarding_screen_test.dart`
- Create: `test/features/register/register_screen_test.dart`
- Create: `test/features/create_org/create_org_screen_test.dart`
- Create: `test/features/org_picker/org_picker_screen_test.dart`

- [ ] **Step 1: Write `onboarding_screen_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/onboarding/onboarding_screen.dart';

void main() {
  testWidgets('OnboardingScreen renders step 1 + Skip', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.purple, Brightness.light),
          home: const OnboardingScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Bỏ qua'), findsOneWidget);
    expect(find.text('Bán hàng nhanh hơn, chỉ với một lần quét.'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Write `register_screen_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/register/register_screen.dart';

void main() {
  testWidgets('RegisterScreen renders name + email + password fields',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.purple, Brightness.light),
          home: const RegisterScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Tạo tài khoản'), findsAtLeastNWidgets(1));
    expect(find.text('Họ và tên'), findsOneWidget);
  });
}
```

- [ ] **Step 3: Write `create_org_screen_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/create_org/create_org_screen.dart';

void main() {
  testWidgets('CreateOrgScreen renders title + business name field',
      (tester) async {
    const user = UserInfo(email: 'a@b.com');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider
              .overrideWith((ref) async => const BootstrapAuthed(user)),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.purple, Brightness.light),
          home: const CreateOrgScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('Tạo cửa hàng của bạn'), findsOneWidget);
    expect(find.text('Tên doanh nghiệp'), findsOneWidget);
  });
}
```

- [ ] **Step 4: Write `org_picker_screen_test.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuru_mobile/app/theme/kuru_palettes.dart';
import 'package:kuru_mobile/app/theme/theme_controller.dart';
import 'package:kuru_mobile/core/auth/auth_providers.dart';
import 'package:kuru_mobile/core/auth/org_info.dart';
import 'package:kuru_mobile/core/auth/user_info.dart';
import 'package:kuru_mobile/core/i18n/generated/app_localizations.dart';
import 'package:kuru_mobile/features/org_picker/org_picker_screen.dart';

void main() {
  testWidgets('OrgPickerScreen lists user orgs', (tester) async {
    const user = UserInfo(
      email: 'a@b.com',
      orgInfos: <OrgInfo>[
        OrgInfo(id: 'o1', name: 'Shop One', role: 'Owner'),
        OrgInfo(id: 'o2', name: 'Shop Two', role: 'Manager'),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapProvider
              .overrideWith((ref) async => const BootstrapAuthed(user)),
        ],
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildKuruTheme(KuruPalette.purple, Brightness.light),
          home: const OrgPickerScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('Shop One'), findsOneWidget);
    expect(find.text('Shop Two'), findsOneWidget);
    expect(find.text('Tạo tổ chức mới'), findsOneWidget);
  });
}
```

- [ ] **Step 5: Run the full suite**

```bash
flutter test
```

Expected: 14 prior + 4 new screen tests + 6 password-strength + 4 new auth-repo = 28 minimum, all green.

- [ ] **Step 6: Commit**

```bash
git add test/features/onboarding test/features/register test/features/create_org test/features/org_picker
git commit -m "$(cat <<'EOF'
test: smoke tests for Onboarding, Register, CreateOrg, OrgPicker

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
EOF
)"
```

---

### Task I2: Final verify + tag

- [ ] **Step 1: Run final checks**

```bash
export PATH="$HOME/flutter/bin:$PATH"
flutter analyze         # 0 errors; info lints OK
flutter test            # all tests green
flutter build ios --simulator   # confirms iOS link still works
```

- [ ] **Step 2: Tag the release**

```bash
git tag -a v0.2.0-identity-full -m "Identity Full — onboarding + register + create-org + org-picker"
git tag --list
```

- [ ] **Step 3: Confirm log**

```bash
git log --oneline | head -25
```

Expected: ~22 new commits stacked on top of `81e1217`.

---

## Self-Review Notes

**Spec coverage check** (compares against `docs/superpowers/specs/2026-05-15-identity-v1-design.md`):

- §6.2 Onboarding (3 steps) — E1 (flag) + E2 (i18n) + E3 (dots) + E4 (illustrations) + E5 (screen) + E6 (router).
- §6.4 Register — F1 (strength) + F2 (signUp) + F3 (checkbox) + F4 (screen + router).
- §6.5 CreateOrg — G1 (illustration) + G2 (screen + zero-orgs branch) — invite-code link intentionally dropped per spec §6.5.
- §6.6 OrgPicker — H1 (card) + H2 (screen + 2+-orgs branch).
- §9 BE dependencies — signUp wired with `EMAIL_ALREADY_EXISTS` handling. createStore returns `storeId` per `store.openapi.json` (verified during plan write). createStorage best-effort.

**Type/name consistency:** `appBootstrapProvider`, `currentOrgIdProvider`, `BootstrapAuthed`, `BootstrapUnauthed`, `OnboardingSeenController`, `passwordStrength()`, `PwLabel` are all used consistently across tasks.

**Known frictions to expect during execution:**

1. `currentOrgIdProvider.notifier` uses an `orgId` setter (not `set()`) — this was the deviation from Plan 1 Task B8. Use `.orgId = ...` and `.clear()`.
2. `ApiResult.success(null)` is **not** const-callable (factories aren't const) — write `ApiResult.success(null)` without `const`. Same for `.failure(...)`.
3. Default Flutter lint `lines_longer_than_80_chars` may force wrapping in deeply nested widget trees — let the implementer wrap as needed; reviewers should accept cosmetic wraps.
4. Widget tests that include `KPrimaryBtn` cannot use `pumpAndSettle()` because the shine animation never settles — use `pump()` × 2 or 3 instead.
